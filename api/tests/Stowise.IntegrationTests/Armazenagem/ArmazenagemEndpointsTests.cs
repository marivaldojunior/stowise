using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Armazenagem;

/// <summary>Autorização e validação do motor de armazenagem, aplicadas antes de consultar o banco.</summary>
public class ArmazenagemEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public async Task Anonymous_cannot_ask_for_suggestions()
    {
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/v1/armazenagem/sugestoes", new { produtoId = Guid.CreateVersion7(), quantidade = 1 });

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task Operator_cannot_change_the_rules()
    {
        using var client = ClientWith(Perfis.Operador);

        var lista = await client.GetAsync(new Uri("/api/v1/armazenagem/regras", UriKind.Relative));
        var alteracao = await client.PutAsJsonAsync("/api/v1/armazenagem/regras/fefo", new { peso = 1, ativa = true, parametros = new { }, versao = 1 });

        Assert.Equal(HttpStatusCode.Forbidden, lista.StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, alteracao.StatusCode);
    }

    [Fact]
    public async Task Operator_cannot_recalculate_the_abc_curve()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsync(new Uri("/api/v1/armazenagem/curva-abc", UriKind.Relative), null);

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Theory]
    [InlineData(null, "produtoId")]
    [InlineData(0, "quantidade")]
    public async Task Suggestion_needs_the_product_and_a_positive_quantity(int? quantidade, string campo)
    {
        using var client = ClientWith(Perfis.Operador);
        object pedido = quantidade is null ? new { quantidade = 1 } : new { produtoId = Guid.CreateVersion7(), quantidade };

        var response = await client.PostAsJsonAsync("/api/v1/armazenagem/sugestoes", pedido);

        await AssertValidacaoAsync(response, campo);
    }

    [Theory]
    [InlineData("peso")]
    [InlineData("ativa")]
    [InlineData("parametros")]
    [InlineData("versao")]
    public async Task Rule_change_needs_weight_state_and_version(string faltando)
    {
        using var client = ClientWith(Perfis.Gestor);
        var corpo = new Dictionary<string, object> { ["peso"] = 1, ["ativa"] = true, ["parametros"] = new { }, ["versao"] = 1 };
        corpo.Remove(faltando);

        var response = await client.PutAsJsonAsync("/api/v1/armazenagem/regras/fefo", corpo);

        await AssertValidacaoAsync(response, faltando);
    }

    [Fact]
    public async Task Anonymous_cannot_list_tasks()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/api/v1/armazenagem/tarefas", UriKind.Relative));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task Confirmation_needs_the_address()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync($"/api/v1/armazenagem/tarefas/{Guid.CreateVersion7()}/confirmacao", new { motivoDivergencia = "x" });

        await AssertValidacaoAsync(response, "enderecoId");
    }

    private static async Task AssertValidacaoAsync(HttpResponseMessage response, string campo)
    {
        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problema = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.Contains(campo, problema!.Errors.Keys);
    }

    private HttpClient ClientWith(string perfil)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(perfil));
        return client;
    }
}
