using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Stowise.Api.Endpoints;
using Stowise.Application.Auth;
using Stowise.Application.Catalogo;
using Stowise.Application.Rfid;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Rfid;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Rfid;

/// <summary>RFID contra o PostgreSQL (ADR-0010): geração de EPCs com séries únicas, leitura em lote e busca por EPC.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class RfidFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";
    private const string GtinUnidade = "7891000315507";
    private const string GtinCaixa = "17891000315504";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public RfidFlowTests(PostgresFixture postgres)
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
    public async Task Generated_tags_have_unique_serials_and_are_read_back_as_quantities()
    {
        var token = await LoginAsync();
        var produto = await CreateProdutoAsync(token);
        var caixa = await AddCaixaAsync(token, produto.Id);

        var primeiras = await GenerateAsync(token, caixa.Id, 3);
        var segundas = await GenerateAsync(token, caixa.Id, 2);

        Assert.Equal(GtinCaixa, primeiras.Gtin);
        var todas = primeiras.Etiquetas.Concat(segundas.Etiquetas).ToList();
        Assert.Equal(5, todas.Select(e => e.Epc).Distinct().Count());
        Assert.All(todas, e =>
        {
            Assert.True(Sgtin96.TryParseHex(e.Epc, out var epc));
            Assert.Equal(GtinCaixa, epc!.Gtin14);
            Assert.Equal(FiltroEpc.CaixaDeTransporte, epc.Filtro);
            Assert.Equal(e.Serie, epc.Serie);
        });

        // A unidade base usa o GTIN-13 do cadastro; o EPC traz o GTIN-14 com zero à esquerda.
        var unidade = Sgtin96.Create(GtinUnidade, 7, 99, FiltroEpc.ItemDeVenda).Hex;
        var lidas = todas.Select(e => e.Epc.ToLowerInvariant())
            .Append(todas[0].Epc) // repetida: conta uma vez
            .Append(unidade)
            .Append("E28011700000020A1B2C3D4E") // TID de fábrica, não SGTIN-96
            .ToList();

        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/rfid/leituras", new { epcs = lidas });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var resolvidas = (await response.Content.ReadFromJsonAsync<LeiturasRfidResolvidas>(Json))!;

        Assert.Equal(7, resolvidas.Leituras.Count);
        Assert.Equal(1, resolvidas.NaoReconhecidas);
        var contagemCaixa = Assert.Single(resolvidas.Produtos, c => c.EmbalagemId == caixa.Id);
        Assert.Equal(5, contagemCaixa.Etiquetas);
        Assert.Equal(30m, contagemCaixa.QuantidadeBase);
        var contagemUnidade = Assert.Single(resolvidas.Produtos, c => c.Tipo == TipoEmbalagem.Unidade);
        Assert.Equal(1m, contagemUnidade.QuantidadeBase);
    }

    [DockerFact]
    public async Task Product_lookup_accepts_the_epc_typed_by_a_keyboard_reader()
    {
        var token = await LoginAsync();
        var produto = await CreateProdutoAsync(token);
        var caixa = await AddCaixaAsync(token, produto.Id);
        var etiqueta = (await GenerateAsync(token, caixa.Id, 1)).Etiquetas.Single();

        var porEpc = await GetAsync<ProdutoPorCodigo>(token, $"/api/v1/produtos/codigo/{etiqueta.Epc}");

        Assert.Equal(produto.Id, porEpc.Produto.Id);
        Assert.Equal(caixa.Id, porEpc.EmbalagemId);

        var desconhecido = Sgtin96.Create("96385074", 7, 1, FiltroEpc.ItemDeVenda).Hex;
        var response = await SendAsync(token, HttpMethod.Get, $"/api/v1/produtos/codigo/{desconhecido}");
        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    [DockerFact]
    public async Task Packages_without_gtin_cannot_get_tags()
    {
        var token = await LoginAsync();
        var semGtin = await CreateProdutoAsync(token, gtin: null);

        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/rfid/etiquetas",
            new { embalagemId = semGtin.Embalagens.Single().Id, quantidade = 1 });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, response.StatusCode);

        var inexistente = await SendAsync(token, HttpMethod.Post, "/api/v1/rfid/etiquetas", new { embalagemId = Guid.NewGuid(), quantidade = 1 });
        Assert.Equal(HttpStatusCode.NotFound, inexistente.StatusCode);
    }

    private async Task<EtiquetasRfidGeradas> GenerateAsync(string token, Guid embalagemId, int quantidade)
    {
        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/rfid/etiquetas", new { embalagemId, quantidade });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<EtiquetasRfidGeradas>(Json))!;
    }

    private async Task<string> LoginAsync()
    {
        var response = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
    }

    private async Task<ProdutoDetalhe> CreateProdutoAsync(string token, string? gtin = GtinUnidade)
    {
        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/produtos", new
        {
            sku = gtin is null ? "SEM-GTIN" : "COLA-2L",
            descricao = "Refrigerante Cola 2L",
            unidadeBase = "UN",
            classeArmazenagem = "Normal",
            embalagemBase = new { gtin },
        });
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<ProdutoDetalhe>(Json))!;
    }

    private async Task<EmbalagemDetalhe> AddCaixaAsync(string token, Guid produtoId)
    {
        var response = await SendAsync(token, HttpMethod.Post, $"/api/v1/produtos/{produtoId}/embalagens",
            new { tipo = "Caixa", fatorConversao = 6, gtin = GtinCaixa });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var produto = (await response.Content.ReadFromJsonAsync<ProdutoDetalhe>(Json))!;
        return produto.Embalagens.Single(e => e.Tipo == TipoEmbalagem.Caixa);
    }

    private async Task<T> GetAsync<T>(string token, string url)
    {
        var response = await SendAsync(token, HttpMethod.Get, url);
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<T>(Json))!;
    }

    private async Task<HttpResponseMessage> SendAsync(string token, HttpMethod method, string url, object? body = null)
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
