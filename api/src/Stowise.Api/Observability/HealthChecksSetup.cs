using System.Text.Json;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Stowise.Infrastructure;

namespace Stowise.Api.Observability;

public static class HealthChecksSetup
{
    /// <summary>
    /// <c>/health/live</c>: o processo responde (sem dependências).
    /// <c>/health/ready</c>: as dependências marcadas como "ready" (banco) respondem; 503 se alguma falhar.
    /// </summary>
    public static IEndpointRouteBuilder MapStowiseHealthChecks(this IEndpointRouteBuilder app)
    {
        app.MapHealthChecks("/health/live", new HealthCheckOptions
        {
            Predicate = _ => false,
            ResponseWriter = WriteJsonAsync,
        }).AllowAnonymous();

        app.MapHealthChecks("/health/ready", new HealthCheckOptions
        {
            Predicate = check => check.Tags.Contains(DependencyInjection.ReadyTag),
            ResponseWriter = WriteJsonAsync,
        }).AllowAnonymous();

        return app;
    }

    /// <summary>Situação geral e de cada verificação, sem mensagens de exceção.</summary>
    private static Task WriteJsonAsync(HttpContext http, HealthReport report)
    {
        http.Response.ContentType = "application/json; charset=utf-8";
        var body = new
        {
            status = report.Status.ToString(),
            totalDurationMs = Math.Round(report.TotalDuration.TotalMilliseconds, 1),
            checks = report.Entries.Select(entry => new
            {
                name = entry.Key,
                status = entry.Value.Status.ToString(),
                durationMs = Math.Round(entry.Value.Duration.TotalMilliseconds, 1),
            }),
        };
        return JsonSerializer.SerializeAsync(http.Response.Body, body, cancellationToken: http.RequestAborted);
    }
}
