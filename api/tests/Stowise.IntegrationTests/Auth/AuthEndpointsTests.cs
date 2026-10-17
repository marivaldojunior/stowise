using System.Net;
using System.Net.Http.Json;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Auth;

/// <summary>Regras que a API aplica antes de consultar o banco.</summary>
public class AuthEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public async Task Protected_endpoint_without_token_returns_401()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/api/v1/auth/me", UriKind.Relative));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task Protected_endpoint_with_invalid_token_returns_401()
    {
        using var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new("Bearer", "not-a-jwt");

        var response = await client.GetAsync(new Uri("/api/v1/auth/me", UriKind.Relative));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task Login_without_email_and_senha_returns_validation_problem()
    {
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/v1/auth/login", new { email = "", senha = "" });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var body = await response.Content.ReadAsStringAsync();
        Assert.Contains("email", body, StringComparison.Ordinal);
        Assert.Contains("senha", body, StringComparison.Ordinal);
    }

    [Fact]
    public async Task Refresh_without_token_returns_401()
    {
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/v1/auth/refresh", new { });

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }
}
