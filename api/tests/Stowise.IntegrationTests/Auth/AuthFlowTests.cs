using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Stowise.Api.Endpoints;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Auth;

/// <summary>Fluxo completo de autenticação contra o PostgreSQL (ADR-0005).</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class AuthFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public AuthFlowTests(PostgresFixture postgres)
    {
        _factory = StowiseApiFactory.WithDatabase(postgres, AdminEmail, AdminPassword);
        _client = _factory.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });
    }

    public void Dispose()
    {
        _client.Dispose();
        _factory.Dispose();
    }

    [DockerFact]
    public async Task Login_returns_tokens_and_me_returns_bootstrap_admin()
    {
        var session = await LoginAsync();

        Assert.False(string.IsNullOrEmpty(session.AccessToken));
        Assert.False(string.IsNullOrEmpty(session.RefreshToken));
        Assert.Equal([Perfis.Admin], session.Usuario.Perfis);

        using var request = new HttpRequestMessage(HttpMethod.Get, "/api/v1/auth/me");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", session.AccessToken);
        var me = await _client.SendAsync(request);

        Assert.Equal(HttpStatusCode.OK, me.StatusCode);
        var usuario = await me.Content.ReadFromJsonAsync<UsuarioResumo>();
        Assert.Equal(AdminEmail, usuario!.Email);
    }

    [DockerFact]
    public async Task Wrong_password_returns_401_and_five_failures_lock_the_user()
    {
        for (var attempt = 1; attempt <= 5; attempt++)
        {
            var failed = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = "senha-errada" });
            Assert.Equal(HttpStatusCode.Unauthorized, failed.StatusCode);
        }

        var locked = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });

        Assert.Equal(HttpStatusCode.Unauthorized, locked.StatusCode);
    }

    [DockerFact]
    public async Task Refresh_rotates_the_token_and_reuse_revokes_the_whole_family()
    {
        var login = await LoginAsync();

        var rotated = await RefreshAsync(login.RefreshToken!);
        Assert.Equal(HttpStatusCode.OK, rotated.StatusCode);
        var second = (await rotated.Content.ReadFromJsonAsync<AuthResponse>())!;
        Assert.NotEqual(login.RefreshToken, second.RefreshToken);

        var reuse = await RefreshAsync(login.RefreshToken!);
        Assert.Equal(HttpStatusCode.Unauthorized, reuse.StatusCode);

        var afterReuse = await RefreshAsync(second.RefreshToken!);
        Assert.Equal(HttpStatusCode.Unauthorized, afterReuse.StatusCode);
    }

    [DockerFact]
    public async Task Logout_revokes_the_session()
    {
        var login = await LoginAsync();

        var logout = await _client.PostAsJsonAsync("/api/v1/auth/logout", new { refreshToken = login.RefreshToken });
        Assert.Equal(HttpStatusCode.NoContent, logout.StatusCode);

        var refresh = await RefreshAsync(login.RefreshToken!);
        Assert.Equal(HttpStatusCode.Unauthorized, refresh.StatusCode);
    }

    [DockerFact]
    public async Task Cookie_mode_keeps_refresh_token_out_of_the_body()
    {
        var login = await _client.PostAsJsonAsync(
            "/api/v1/auth/login",
            new { email = AdminEmail, senha = AdminPassword, useCookie = true });

        Assert.Equal(HttpStatusCode.OK, login.StatusCode);
        var body = (await login.Content.ReadFromJsonAsync<AuthResponse>())!;
        Assert.Null(body.RefreshToken);

        var cookie = Assert.Single(login.Headers.GetValues("Set-Cookie"));
        Assert.StartsWith($"{AuthEndpoints.RefreshCookieName}=", cookie, StringComparison.Ordinal);
        Assert.Contains("httponly", cookie, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("secure", cookie, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("samesite=strict", cookie, StringComparison.OrdinalIgnoreCase);
        Assert.Contains("path=/api/v1/auth", cookie, StringComparison.OrdinalIgnoreCase);

        using var refresh = new HttpRequestMessage(HttpMethod.Post, "/api/v1/auth/refresh")
        {
            Content = JsonContent.Create(new { useCookie = true }),
        };
        refresh.Headers.Add("Cookie", cookie.Split(';')[0]);
        var refreshed = await _client.SendAsync(refresh);

        Assert.Equal(HttpStatusCode.OK, refreshed.StatusCode);
        Assert.Null((await refreshed.Content.ReadFromJsonAsync<AuthResponse>())!.RefreshToken);
    }

    private async Task<AuthResponse> LoginAsync()
    {
        var response = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!;
    }

    private Task<HttpResponseMessage> RefreshAsync(string refreshToken) =>
        _client.PostAsJsonAsync("/api/v1/auth/refresh", new { refreshToken });
}
