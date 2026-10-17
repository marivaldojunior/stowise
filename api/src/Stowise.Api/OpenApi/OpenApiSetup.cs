using System.Text.Json.Serialization;
using Asp.Versioning;
using Microsoft.OpenApi;
using Scalar.AspNetCore;

namespace Stowise.Api.OpenApi;

public static class OpenApiSetup
{
    /// <summary>Versão atual. Cada versão publicada tem o próprio documento (<c>/openapi/v1.json</c>).</summary>
    public static readonly ApiVersion V1 = new(1, 0);

    public static IServiceCollection AddStowiseOpenApi(this IServiceCollection services)
    {
        // Enums como texto no JSON e no contrato OpenAPI (ex.: "Refrigerado", não 1).
        services.ConfigureHttpJsonOptions(options => options.SerializerOptions.Converters.Add(new JsonStringEnumConverter()));

        services.AddApiVersioning(options =>
            {
                options.DefaultApiVersion = V1;
                options.ReportApiVersions = true;
                options.ApiVersionReader = new UrlSegmentApiVersionReader();
            })
            .AddApiExplorer(options =>
            {
                // Grupo "v1": nome do documento OpenAPI de cada versão.
                options.GroupNameFormat = "'v'VVV";
                options.SubstituteApiVersionInUrl = true;
            })
            .AddOpenApi(options =>
            {
                var version = options.Description.ApiVersion.ToString();
                options.Document.AddDocumentTransformer((document, _, _) =>
                {
                    document.Info ??= new OpenApiInfo();
                    document.Info.Title = "Stowise API";
                    document.Info.Version = version;
                    document.Info.Description =
                        "Inventário e armazenagem com IA: a IA sugere e uma pessoa confirma.\n\n"
                        + "Erros seguem o padrão ProblemDetails (RFC 9457) e sempre trazem `traceId`. "
                        + (document.Info.Description ?? string.Empty);
                    return Task.CompletedTask;
                });
                options.Document.AddDocumentTransformer<BearerSecurityTransformer>();
                options.Document.AddOperationTransformer<BearerSecurityTransformer>();
            });

        return services;
    }

    /// <summary>Grupo versionado <c>/api/v{version}</c>. Os módulos mapeiam as rotas relativas a ele.</summary>
    public static RouteGroupBuilder MapApiV1(this IEndpointRouteBuilder app) =>
        app.NewVersionedApi("Stowise")
            .MapGroup("/api/v{version:apiVersion}")
            .HasApiVersion(V1);

    /// <summary>Contrato em <c>/openapi/v1.json</c> e referência interativa em <c>/scalar</c>.</summary>
    public static IEndpointRouteBuilder MapStowiseOpenApi(this IEndpointRouteBuilder app)
    {
        app.MapOpenApi().WithDocumentPerVersion().AllowAnonymous();
        app.MapScalarApiReference(options => options
                .WithTitle("Stowise API")
                .AddPreferredSecuritySchemes(BearerSecurityTransformer.SchemeName))
            .AllowAnonymous();
        return app;
    }
}
