using System.Reflection;
using Npgsql;
using OpenTelemetry;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Serilog;
using Serilog.Events;
using Serilog.Formatting.Compact;

namespace Stowise.Api.Observability;

public static class ObservabilitySetup
{
    public const string ServiceName = "stowise-api";

    /// <summary>Variável padrão do OpenTelemetry. Sem ela, nada é exportado por OTLP.</summary>
    public const string OtlpEndpointKey = "OTEL_EXPORTER_OTLP_ENDPOINT";

    private const string DevelopmentTemplate =
        "[{Timestamp:HH:mm:ss} {Level:u3}] {SourceContext}: {Message:lj} {TraceId}{NewLine}{Exception}";

    public static WebApplicationBuilder AddObservability(this WebApplicationBuilder builder)
    {
        ArgumentNullException.ThrowIfNull(builder);

        // Serilog escreve no console e repassa os eventos ao provider do OpenTelemetry (writeToProviders).
        builder.Services.AddSerilog(
            (services, logger) =>
            {
                logger.ReadFrom.Configuration(builder.Configuration)
                    .ReadFrom.Services(services)
                    .Enrich.FromLogContext()
                    .Enrich.WithProperty("Application", ServiceName);

                if (builder.Environment.IsDevelopment())
                {
                    logger.WriteTo.Console(outputTemplate: DevelopmentTemplate, formatProvider: null);
                }
                else
                {
                    // JSON compacto, com @tr (trace id) e @sp (span id) para correlacionar com os traces.
                    logger.WriteTo.Console(new RenderedCompactJsonFormatter());
                }
            },
            writeToProviders: true);

        var otel = builder.Services.AddOpenTelemetry()
            .ConfigureResource(resource => resource.AddService(ServiceName, serviceVersion: ServiceVersion))
            .WithTracing(tracing => tracing
                .AddAspNetCoreInstrumentation(options => options.Filter = http => !IsHealthCheck(http.Request.Path))
                .AddHttpClientInstrumentation()
                .AddNpgsql())
            .WithMetrics(metrics => metrics
                .AddAspNetCoreInstrumentation()
                .AddHttpClientInstrumentation()
                .AddRuntimeInstrumentation())
            .WithLogging();

        if (!string.IsNullOrWhiteSpace(builder.Configuration[OtlpEndpointKey]))
        {
            otel.UseOtlpExporter();
        }

        return builder;
    }

    /// <summary>Um log por requisição. Health checks só aparecem em nível Verbose.</summary>
    public static IApplicationBuilder UseStowiseRequestLogging(this IApplicationBuilder app) =>
        app.UseSerilogRequestLogging(options =>
        {
            options.GetLevel = (http, _, exception) => exception is not null || http.Response.StatusCode >= 500
                ? LogEventLevel.Error
                : IsHealthCheck(http.Request.Path) ? LogEventLevel.Verbose : LogEventLevel.Information;

            options.EnrichDiagnosticContext = (diagnostics, http) =>
            {
                var usuarioId = http.User.FindFirst("sub")?.Value;
                if (usuarioId is not null)
                {
                    diagnostics.Set("UsuarioId", usuarioId);
                }
            };
        });

    private static string ServiceVersion { get; } =
        typeof(ObservabilitySetup).Assembly.GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion
        ?? "0.0.0";

    private static bool IsHealthCheck(PathString path) => path.StartsWithSegments("/health", StringComparison.OrdinalIgnoreCase);
}
