using System.Diagnostics;
using Microsoft.AspNetCore.Diagnostics;

namespace Stowise.Api.Errors;

public static class ProblemDetailsSetup
{
    /// <summary>Toda resposta de erro sai como ProblemDetails com o <c>traceId</c> do OpenTelemetry.</summary>
    public static IServiceCollection AddStowiseProblemDetails(this IServiceCollection services)
    {
        services.AddProblemDetails(options => options.CustomizeProblemDetails = context =>
        {
            var http = context.HttpContext;
            context.ProblemDetails.Instance ??= $"{http.Request.Method} {http.Request.Path}";

            // O traceId curto (32 hex) é o mesmo dos logs e do trace, e não o Activity.Id completo.
            context.ProblemDetails.Extensions["traceId"] = Activity.Current?.TraceId.ToHexString() ?? http.TraceIdentifier;
        });
        services.AddExceptionHandler<StowiseExceptionHandler>();
        return services;
    }

    public static IApplicationBuilder UseStowiseProblemDetails(this IApplicationBuilder app)
    {
        app.UseExceptionHandler(new ExceptionHandlerOptions
        {
            SuppressDiagnosticsCallback = context => StowiseExceptionHandler.IsClientError(context.Exception),
        });
        app.UseStatusCodePages();
        return app;
    }
}
