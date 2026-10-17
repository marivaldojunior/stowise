using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Testing;
using Stowise.Api.Endpoints;
using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Application.Usuarios;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Usuarios;

/// <summary>Gestão de usuários contra o PostgreSQL: regras que dependem do banco.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class UsuariosFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";
    private const string Senha = "Senha-do-usuario-1";

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public UsuariosFlowTests(PostgresFixture postgres)
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
    public async Task Admin_creates_gets_and_lists_users_with_filters()
    {
        var admin = await LoginAsync(AdminEmail, AdminPassword);

        var created = await SendAsync(admin.AccessToken, HttpMethod.Post, "/api/v1/usuarios",
            new { nome = "Bruna Operadora", email = "bruna@stowise.test", senha = Senha, perfis = new[] { Perfis.Operador } });
        Assert.Equal(HttpStatusCode.Created, created.StatusCode);
        var bruna = (await created.Content.ReadFromJsonAsync<UsuarioDetalhe>())!;
        Assert.EndsWith($"/api/v1/usuarios/{bruna.Id}", created.Headers.Location!.ToString(), StringComparison.Ordinal);
        Assert.Equal([Perfis.Operador], bruna.Perfis);
        Assert.True(bruna.Ativo);

        await SendAsync(admin.AccessToken, HttpMethod.Post, "/api/v1/usuarios",
            new { nome = "Carlos Gestor", email = "carlos@stowise.test", senha = Senha, perfis = new[] { Perfis.Gestor } });

        var porBusca = await GetPageAsync(admin.AccessToken, "/api/v1/usuarios?busca=BRUNA");
        Assert.Equal("bruna@stowise.test", Assert.Single(porBusca.Itens).Email);

        var gestores = await GetPageAsync(admin.AccessToken, $"/api/v1/usuarios?perfil={Perfis.Gestor}");
        Assert.Equal("carlos@stowise.test", Assert.Single(gestores.Itens).Email);

        var paginaUm = await GetPageAsync(admin.AccessToken, "/api/v1/usuarios?pagina=1&tamanhoPagina=2");
        Assert.Equal(3, paginaUm.Total);
        Assert.Equal(2, paginaUm.Itens.Count);
        Assert.Equal(2, paginaUm.TotalPaginas);

        var curinga = await GetPageAsync(admin.AccessToken, "/api/v1/usuarios?busca=%25");
        Assert.Empty(curinga.Itens);

        var get = await SendAsync(admin.AccessToken, HttpMethod.Get, $"/api/v1/usuarios/{bruna.Id}");
        Assert.Equal(HttpStatusCode.OK, get.StatusCode);
        var missing = await SendAsync(admin.AccessToken, HttpMethod.Get, $"/api/v1/usuarios/{Guid.NewGuid()}");
        Assert.Equal(HttpStatusCode.NotFound, missing.StatusCode);
    }

    [DockerFact]
    public async Task Duplicated_email_returns_409_and_weak_password_returns_400()
    {
        var admin = await LoginAsync(AdminEmail, AdminPassword);

        var duplicated = await SendAsync(admin.AccessToken, HttpMethod.Post, "/api/v1/usuarios",
            new { nome = "Outro Admin", email = AdminEmail.ToUpperInvariant(), senha = Senha, perfis = new[] { Perfis.Admin } });
        Assert.Equal(HttpStatusCode.Conflict, duplicated.StatusCode);

        var weak = await SendAsync(admin.AccessToken, HttpMethod.Post, "/api/v1/usuarios",
            new { nome = "Dora", email = "dora@stowise.test", senha = "curta", perfis = new[] { Perfis.Operador } });
        Assert.Equal(HttpStatusCode.BadRequest, weak.StatusCode);
        var problem = await weak.Content.ReadFromJsonAsync<HttpValidationProblemDetails>();
        Assert.Contains("senha", problem!.Errors.Keys);
    }

    [DockerFact]
    public async Task Updated_perfis_reach_the_user_on_next_login()
    {
        var admin = await LoginAsync(AdminEmail, AdminPassword);
        var bruna = await CreateAsync(admin.AccessToken, "bruna@stowise.test", Perfis.Operador);

        var updated = await SendAsync(admin.AccessToken, HttpMethod.Put, $"/api/v1/usuarios/{bruna.Id}",
            new { nome = "Bruna Gestora", perfis = new[] { Perfis.Gestor, Perfis.Operador } });

        Assert.Equal(HttpStatusCode.OK, updated.StatusCode);
        var login = await LoginAsync("bruna@stowise.test", Senha);
        Assert.Equal("Bruna Gestora", login.Usuario.Nome);
        Assert.Equal([Perfis.Gestor, Perfis.Operador], login.Usuario.Perfis);
    }

    [DockerFact]
    public async Task Deactivated_user_cannot_login_or_refresh_until_reactivated()
    {
        var admin = await LoginAsync(AdminEmail, AdminPassword);
        var bruna = await CreateAsync(admin.AccessToken, "bruna@stowise.test", Perfis.Operador);
        var session = await LoginAsync("bruna@stowise.test", Senha);

        var deactivated = await SendAsync(admin.AccessToken, HttpMethod.Post, $"/api/v1/usuarios/{bruna.Id}/desativar");
        Assert.Equal(HttpStatusCode.NoContent, deactivated.StatusCode);

        Assert.Equal(HttpStatusCode.Unauthorized, (await PostLoginAsync("bruna@stowise.test", Senha)).StatusCode);
        var refresh = await _client.PostAsJsonAsync("/api/v1/auth/refresh", new { refreshToken = session.RefreshToken });
        Assert.Equal(HttpStatusCode.Unauthorized, refresh.StatusCode);

        var reactivated = await SendAsync(admin.AccessToken, HttpMethod.Post, $"/api/v1/usuarios/{bruna.Id}/reativar");
        Assert.Equal(HttpStatusCode.NoContent, reactivated.StatusCode);
        Assert.Equal(HttpStatusCode.OK, (await PostLoginAsync("bruna@stowise.test", Senha)).StatusCode);
    }

    [DockerFact]
    public async Task Admin_cannot_deactivate_self_or_drop_own_admin_perfil()
    {
        var admin = await LoginAsync(AdminEmail, AdminPassword);

        var selfDeactivate = await SendAsync(admin.AccessToken, HttpMethod.Post, $"/api/v1/usuarios/{admin.Usuario.Id}/desativar");
        var selfDemote = await SendAsync(admin.AccessToken, HttpMethod.Put, $"/api/v1/usuarios/{admin.Usuario.Id}",
            new { nome = "Admin", perfis = new[] { Perfis.Gestor } });

        Assert.Equal(HttpStatusCode.UnprocessableEntity, selfDeactivate.StatusCode);
        Assert.Equal(HttpStatusCode.UnprocessableEntity, selfDemote.StatusCode);
    }

    [DockerFact]
    public async Task Last_active_admin_is_protected_even_from_a_stale_admin_token()
    {
        var primeiro = await LoginAsync(AdminEmail, AdminPassword);
        var segundo = await CreateAsync(primeiro.AccessToken, "segundo@stowise.test", Perfis.Admin);
        var segundoSession = await LoginAsync("segundo@stowise.test", Senha);

        // Com dois Admins, o segundo pode remover o perfil Admin do primeiro.
        var demoteFirst = await SendAsync(segundoSession.AccessToken, HttpMethod.Put, $"/api/v1/usuarios/{primeiro.Usuario.Id}",
            new { nome = "Ex-Admin", perfis = new[] { Perfis.Gestor } });
        Assert.Equal(HttpStatusCode.OK, demoteFirst.StatusCode);

        // O access token antigo do primeiro ainda diz "Admin" por até 15 minutos (ADR-0005).
        // Mesmo assim, o segundo agora é o único Admin ativo e não pode ser desativado nem rebaixado.
        var deactivate = await SendAsync(primeiro.AccessToken, HttpMethod.Post, $"/api/v1/usuarios/{segundo.Id}/desativar");
        var demote = await SendAsync(primeiro.AccessToken, HttpMethod.Put, $"/api/v1/usuarios/{segundo.Id}",
            new { nome = "Segundo", perfis = new[] { Perfis.Operador } });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, deactivate.StatusCode);
        Assert.Equal(HttpStatusCode.UnprocessableEntity, demote.StatusCode);

        // Com um token novo, o primeiro já é só Gestor e nem chega à regra.
        var gestor = await LoginAsync(AdminEmail, AdminPassword);
        Assert.Equal(HttpStatusCode.Forbidden,
            (await SendAsync(gestor.AccessToken, HttpMethod.Post, $"/api/v1/usuarios/{segundo.Id}/desativar")).StatusCode);
    }

    [DockerFact]
    public async Task Reset_password_unlocks_user_and_revokes_sessions()
    {
        var admin = await LoginAsync(AdminEmail, AdminPassword);
        var bruna = await CreateAsync(admin.AccessToken, "bruna@stowise.test", Perfis.Operador);
        var session = await LoginAsync("bruna@stowise.test", Senha);
        for (var attempt = 0; attempt < 5; attempt++)
        {
            await PostLoginAsync("bruna@stowise.test", "senha-errada");
        }

        var locked = await SendAsync(admin.AccessToken, HttpMethod.Get, $"/api/v1/usuarios/{bruna.Id}");
        Assert.True((await locked.Content.ReadFromJsonAsync<UsuarioDetalhe>())!.Bloqueado);

        var weak = await SendAsync(admin.AccessToken, HttpMethod.Post, $"/api/v1/usuarios/{bruna.Id}/senha", new { novaSenha = "curta" });
        Assert.Equal(HttpStatusCode.BadRequest, weak.StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await PostLoginAsync("bruna@stowise.test", "Nova-senha-123")).StatusCode);

        var reset = await SendAsync(admin.AccessToken, HttpMethod.Post, $"/api/v1/usuarios/{bruna.Id}/senha", new { novaSenha = "Nova-senha-123" });
        Assert.Equal(HttpStatusCode.NoContent, reset.StatusCode);

        Assert.Equal(HttpStatusCode.Unauthorized, (await PostLoginAsync("bruna@stowise.test", Senha)).StatusCode);
        Assert.Equal(HttpStatusCode.OK, (await PostLoginAsync("bruna@stowise.test", "Nova-senha-123")).StatusCode);
        var refresh = await _client.PostAsJsonAsync("/api/v1/auth/refresh", new { refreshToken = session.RefreshToken });
        Assert.Equal(HttpStatusCode.Unauthorized, refresh.StatusCode);
    }

    private async Task<UsuarioDetalhe> CreateAsync(string accessToken, string email, string perfil)
    {
        var response = await SendAsync(accessToken, HttpMethod.Post, "/api/v1/usuarios",
            new { nome = email.Split('@')[0], email, senha = Senha, perfis = new[] { perfil } });
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<UsuarioDetalhe>())!;
    }

    private async Task<AuthResponse> LoginAsync(string email, string senha)
    {
        var response = await PostLoginAsync(email, senha);
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!;
    }

    private Task<HttpResponseMessage> PostLoginAsync(string email, string senha) =>
        _client.PostAsJsonAsync("/api/v1/auth/login", new { email, senha });

    private async Task<PagedResult<UsuarioDetalhe>> GetPageAsync(string accessToken, string url)
    {
        var response = await SendAsync(accessToken, HttpMethod.Get, url);
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<PagedResult<UsuarioDetalhe>>())!;
    }

    private async Task<HttpResponseMessage> SendAsync(string accessToken, HttpMethod method, string url, object? body = null)
    {
        using var request = new HttpRequestMessage(method, url);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        if (body is not null)
        {
            request.Content = JsonContent.Create(body);
        }

        return await _client.SendAsync(request);
    }
}
