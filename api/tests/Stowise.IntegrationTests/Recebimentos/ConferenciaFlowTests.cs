using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Api.Endpoints;
using Stowise.Application.Common;
using Stowise.Application.NotasFiscais;
using Stowise.Application.Recebimentos;
using Stowise.Domain.Recebimentos;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Recebimentos;

/// <summary>
/// Conferência de um recebimento da NF-e de exemplo contra o PostgreSQL: início, contagem com lote, divergência,
/// versão desatualizada e conclusão. Item 1: 10 CX (120 UN) do lote L2610A. Item 2: 5 PCT (500 UN), sem lote.
/// </summary>
[Collection(PostgresTestGroup.Name)]
public sealed class ConferenciaFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public ConferenciaFlowTests(PostgresFixture postgres)
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
    public async Task Receipt_is_checked_item_by_item_and_closed_with_the_divergences()
    {
        var token = await LoginAsync();
        var recebimentoId = await EfetivarAsync();

        var lista = await SendAsync<PagedResult<RecebimentoResumo>>(token, HttpMethod.Get, "/api/v1/recebimentos?status=AguardandoConferencia");
        var resumo = Assert.Single(lista.Itens);
        Assert.Equal(1234, resumo.Numero);
        Assert.Equal("Distribuidora Exemplo Ltda", resumo.Fornecedor);
        Assert.Equal(0, resumo.ItensConferidos);

        var recebimento = await SendAsync<RecebimentoDetalhe>(token, HttpMethod.Get, $"/api/v1/recebimentos/{recebimentoId}");
        var cola = recebimento.Itens[0];
        var copos = recebimento.Itens[1];
        Assert.True(cola.ControlaLote);

        // Antes do início, a contagem é recusada.
        Assert.Equal(HttpStatusCode.UnprocessableEntity,
            (await RawAsync(token, HttpMethod.Put, $"/api/v1/recebimentos/{recebimentoId}/itens/{copos.Id}/conferencia", new { quantidade = 5 })).StatusCode);

        var iniciado = await SendAsync<RecebimentoDetalhe>(token, HttpMethod.Post, $"/api/v1/recebimentos/{recebimentoId}/conferencia/inicio", new { versao = recebimento.Versao });
        Assert.Equal(StatusRecebimento.EmConferencia, iniciado.Status);
        Assert.NotNull(iniciado.DataChegada);

        // A versão lida antes do início ficou desatualizada.
        Assert.Equal(HttpStatusCode.Conflict,
            (await RawAsync(token, HttpMethod.Post, $"/api/v1/recebimentos/{recebimentoId}/conferencia/conclusao", new { versao = recebimento.Versao })).StatusCode);

        // Faltou um pacote: 4 PCT = 400 UN de 500.
        var comCopos = await SendAsync<RecebimentoDetalhe>(token, HttpMethod.Put, $"/api/v1/recebimentos/{recebimentoId}/itens/{copos.Id}/conferencia", new { quantidade = 4 });
        Assert.Equal(400m, comCopos.Itens[1].QuantidadeConferida);
        Assert.True(comCopos.Itens[1].Divergente);

        // O produto controla lote: sem lote, 422.
        Assert.Equal(HttpStatusCode.UnprocessableEntity,
            (await RawAsync(token, HttpMethod.Put, $"/api/v1/recebimentos/{recebimentoId}/itens/{cola.Id}/conferencia", new { quantidade = 10 })).StatusCode);

        var naoFecha = await RawAsync(token, HttpMethod.Post, $"/api/v1/recebimentos/{recebimentoId}/conferencia/conclusao", new { versao = iniciado.Versao });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, naoFecha.StatusCode);

        var comCola = await SendAsync<RecebimentoDetalhe>(token, HttpMethod.Put, $"/api/v1/recebimentos/{recebimentoId}/itens/{cola.Id}/conferencia", new
        {
            quantidade = 10,
            lotes = new[] { new { numero = "L2610A", quantidade = 10, validade = "2027-04-30" } },
        });
        Assert.Equal(120m, comCola.Itens[0].QuantidadeConferida);
        Assert.False(comCola.Itens[0].Divergente);

        var conferido = await SendAsync<RecebimentoDetalhe>(token, HttpMethod.Post, $"/api/v1/recebimentos/{recebimentoId}/conferencia/conclusao", new { versao = iniciado.Versao });
        Assert.Equal(StatusRecebimento.Conferido, conferido.Status);
        Assert.True(conferido.TemDivergencia);
        Assert.NotNull(conferido.ConferidoPor);

        var conferidos = await SendAsync<PagedResult<RecebimentoResumo>>(token, HttpMethod.Get, "/api/v1/recebimentos?status=Conferido&busca=Exemplo");
        Assert.Equal(2, Assert.Single(conferidos.Itens).ItensConferidos);
    }

    /// <summary>A NF-e de exemplo com dois produtos novos (o refrigerante controla lote e validade pelo rastro).</summary>
    private async Task<Guid> EfetivarAsync()
    {
        var xml = await File.ReadAllTextAsync(Path.Combine(AppContext.BaseDirectory, "NotasFiscais", "Exemplos", "nfe-autorizada.xml"));
        using var scope = _factory.Services.CreateScope();
        var resultado = await scope.ServiceProvider.GetRequiredService<IEfetivacaoNotaFiscal>().EfetivarAsync(
            new EfetivarNotaFiscal(xml,
            [
                new DecisaoItemNota(1, AcaoItemNota.CriarProduto, NovoProduto: new NovoProdutoNota("COLA-2L", "Refrigerante Cola 2L", null, null)),
                new DecisaoItemNota(2, AcaoItemNota.CriarProduto, NovoProduto: new NovoProdutoNota("COPO-200", "Copo descartável 200ml", null, null)),
            ]),
            Guid.CreateVersion7());
        Assert.True(resultado.IsSuccess, resultado.Error?.Message);
        return resultado.Value.RecebimentoId;
    }

    private async Task<string> LoginAsync()
    {
        var response = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
    }

    private async Task<T> SendAsync<T>(string token, HttpMethod method, string url, object? body = null)
    {
        var response = await RawAsync(token, method, url, body);
        Assert.True(response.IsSuccessStatusCode, $"{method} {url}: {(int)response.StatusCode} {await response.Content.ReadAsStringAsync()}");
        return (await response.Content.ReadFromJsonAsync<T>(Json))!;
    }

    private async Task<HttpResponseMessage> RawAsync(string token, HttpMethod method, string url, object? body = null)
    {
        using var request = new HttpRequestMessage(method, url);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
        if (body is not null)
        {
            request.Content = JsonContent.Create(body);
        }

        return await _client.SendAsync(request);
    }
}
