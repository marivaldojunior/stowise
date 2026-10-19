using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Stowise.Api.Endpoints;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Auth;

/// <summary>Contas da demonstração pública (Gestor e Operador), criadas só quando a senha de demonstração existe.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class UsuariosDemonstracaoTests(PostgresFixture postgres)
{
    private const string Senha = "Demo-Stowise-2026";

    private StowiseApiFactory Factory(string? senhaDemonstracao)
    {
        var factory = StowiseApiFactory.WithDatabase(postgres, "admin@stowise.test", "Senha-de-teste-123");
        factory.Settings["Demonstracao:Senha"] = senhaDemonstracao;
        return factory;
    }

    private static Task<HttpResponseMessage> EntrarAsync(HttpClient client, string email, string senha) =>
        client.PostAsJsonAsync("/api/v1/auth/login", new { email, senha });

    [DockerFact]
    public async Task Com_a_senha_configurada_cria_o_Gestor_e_o_Operador()
    {
        await using var factory = Factory(Senha);
        using var client = factory.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });

        var gestor = await EntrarAsync(client, "gestor@demo.stowise.dev", Senha);
        var operador = await EntrarAsync(client, "operador@demo.stowise.dev", Senha);

        Assert.Equal(HttpStatusCode.OK, gestor.StatusCode);
        Assert.Equal(HttpStatusCode.OK, operador.StatusCode);
        Assert.Equal([Perfis.Gestor], (await gestor.Content.ReadFromJsonAsync<AuthResponse>())!.Usuario.Perfis);
        Assert.Equal([Perfis.Operador], (await operador.Content.ReadFromJsonAsync<AuthResponse>())!.Usuario.Perfis);
    }

    [DockerFact]
    public async Task Senha_errada_repetida_nao_bloqueia_a_conta_de_demonstracao()
    {
        await using var factory = Factory(Senha);
        using var client = factory.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });

        for (var tentativa = 1; tentativa <= 6; tentativa++)
        {
            var errada = await EntrarAsync(client, "gestor@demo.stowise.dev", "senha-errada");
            Assert.Equal(HttpStatusCode.Unauthorized, errada.StatusCode);
        }

        var certa = await EntrarAsync(client, "gestor@demo.stowise.dev", Senha);
        Assert.Equal(HttpStatusCode.OK, certa.StatusCode);

        // Na lista de usuários (Admin), a conta não aparece como bloqueada.
        var admin = await EntrarAsync(client, "admin@stowise.test", "Senha-de-teste-123");
        var token = (await admin.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
        using var pedido = new HttpRequestMessage(HttpMethod.Get, "/api/v1/usuarios?busca=gestor@demo.stowise.dev");
        pedido.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
        var lista = await client.SendAsync(pedido);
        var json = await lista.Content.ReadFromJsonAsync<JsonElement>();
        Assert.False(json.GetProperty("itens")[0].GetProperty("bloqueado").GetBoolean());
    }

    [DockerFact]
    public async Task Sem_a_senha_nao_cria_contas_de_demonstracao()
    {
        await using var factory = Factory(null);
        using var client = factory.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });

        var resposta = await EntrarAsync(client, "gestor@demo.stowise.dev", Senha);

        Assert.Equal(HttpStatusCode.Unauthorized, resposta.StatusCode);
    }
}
