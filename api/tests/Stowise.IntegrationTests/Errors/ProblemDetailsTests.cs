using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Errors;

/// <summary>Toda resposta de erro da API é ProblemDetails com traceId.</summary>
public class ProblemDetailsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public async Task Unauthorized_response_is_problem_details_with_trace_id()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/api/v1/auth/me", UriKind.Relative));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
        Assert.Equal("application/problem+json", response.Content.Headers.ContentType?.MediaType);
        var problem = await response.Content.ReadFromJsonAsync<ProblemDetails>();
        AssertTraceId(problem!);
        Assert.Equal("GET /api/v1/auth/me", problem!.Instance);
    }

    [Fact]
    public async Task Unknown_route_returns_404_problem_details_to_authenticated_users()
    {
        // Anônimos recebem 401 em qualquer rota (política de fallback): eles não descobrem quais rotas existem.
        using var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(Perfis.Operador));

        var response = await client.GetAsync(new Uri("/api/v1/nao-existe", UriKind.Relative));

        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        AssertTraceId((await response.Content.ReadFromJsonAsync<ProblemDetails>())!);
    }

    [Fact]
    public async Task Malformed_json_body_returns_400_problem_details()
    {
        using var client = factory.CreateClient();
        using var body = new StringContent("{ \"email\": ", Encoding.UTF8, "application/json");

        var response = await client.PostAsync(new Uri("/api/v1/auth/login", UriKind.Relative), body);

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        AssertTraceId((await response.Content.ReadFromJsonAsync<ProblemDetails>())!);
    }

    [Fact]
    public async Task Validation_problem_from_endpoint_also_carries_trace_id()
    {
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/v1/auth/login", new { email = "", senha = "" });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        AssertTraceId((await response.Content.ReadFromJsonAsync<ProblemDetails>())!);
    }

    private static void AssertTraceId(ProblemDetails problem)
    {
        Assert.True(problem.Extensions.TryGetValue("traceId", out var traceId), "ProblemDetails sem traceId.");
        Assert.Matches("^[0-9a-f]{32}$", traceId!.ToString());
    }
}
