using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Api.Endpoints;
using Stowise.Application.Catalogo;
using Stowise.Application.Fornecedores;
using Stowise.Application.NotasFiscais;
using Stowise.Domain.Catalogo;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.NotasFiscais;

/// <summary>
/// Casamento dos itens da NF-e de exemplo (Exemplos/nfe-autorizada.xml) contra o PostgreSQL: de-para, GTIN,
/// similaridade e sem candidato. Item 1: REF-001, GTIN da caixa 17891000315504. Item 2: REF-077, sem GTIN, copo.
/// </summary>
[Collection(PostgresTestGroup.Name)]
public sealed class AnaliseNotaFiscalFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public AnaliseNotaFiscalFlowTests(PostgresFixture postgres)
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
    public async Task New_supplier_items_match_by_gtin_or_by_similar_description()
    {
        var token = await LoginAsync();
        var cola = await CreateProdutoAsync(token, "COLA-2L", "Refrigerante Cola 2L", "7891000315507");
        var caixa = await AddCaixaAsync(token, cola.Id, "17891000315504", 12);
        var copo = await CreateProdutoAsync(token, "COPO-200", "Copo descartável 200ml", null);

        var analise = await AnalyzeAsync();

        Assert.Equal("35261011222333000181550010000012341123456787", analise.ChaveAcesso);
        Assert.True(analise.Autorizada);
        Assert.Null(analise.Fornecedor.FornecedorId);
        Assert.Equal("11222333000181", analise.Fornecedor.Cnpj);

        var refrigerante = analise.Itens[0];
        Assert.Equal(OrigemCasamento.Gtin, refrigerante.Origem);
        Assert.Equal(caixa.Id, refrigerante.Casamento!.EmbalagemId);
        Assert.Equal(12m, refrigerante.Casamento.FatorConversao);
        Assert.True(refrigerante.RequerConfirmacao);

        // 10 CX = 120 UN: o fator da nota confere com o da caixa, e o lote L2610A vira 120 UN.
        Assert.Equal(new ConversaoItem(12m, OrigemFator.Nota, 120m), refrigerante.Conversao);
        Assert.Equal(120m, Assert.Single(refrigerante.Lotes).QuantidadeBase);
        Assert.Empty(refrigerante.Alertas);

        var copos = analise.Itens[1];
        Assert.Equal(OrigemCasamento.Similaridade, copos.Origem);
        Assert.Null(copos.Casamento);
        Assert.Equal(MetodoSimilaridade.Trigramas, copos.MetodoSugestoes);
        Assert.Equal(copo.Id, copos.Sugestoes[0].Id);
        Assert.True(copos.RequerConfirmacao);

        // Sem produto casado, a unidade tributável (UN) é a base: 5 PCT = 500 UN.
        Assert.Equal(new ConversaoItem(100m, OrigemFator.Nota, 500m), copos.Conversao);
    }

    [DockerFact]
    public async Task Known_supplier_code_matches_by_the_confirmed_link()
    {
        var token = await LoginAsync();
        var copo = await CreateProdutoAsync(token, "COPO-200", "Copo descartável 200ml", null);
        var fornecedor = await PostAsync<FornecedorDetalhe>(token, "/api/v1/fornecedores",
            new { cnpj = "11.222.333/0001-81", razaoSocial = "Distribuidora Exemplo Ltda" }, HttpStatusCode.Created);
        var vinculo = await PostAsync<ProdutoFornecedorDetalhe>(token, $"/api/v1/fornecedores/{fornecedor.Id}/produtos",
            new { codigoFornecedor = "REF-077", produtoId = copo.Id, embalagemId = copo.Embalagens.Single().Id, unidadeFornecedor = "PCT", fatorConversao = 100 },
            HttpStatusCode.Created);

        var analise = await AnalyzeAsync();

        Assert.Equal(fornecedor.Id, analise.Fornecedor.FornecedorId);
        var copos = analise.Itens[1];
        Assert.Equal(OrigemCasamento.DePara, copos.Origem);
        Assert.Equal(vinculo.Id, copos.Casamento!.ProdutoFornecedorId);
        Assert.Equal(100m, copos.Casamento.FatorConversao);
        Assert.Empty(copos.Alertas);
        Assert.False(copos.RequerConfirmacao);

        // Sem nada parecido no catálogo, o refrigerante fica sem candidato.
        Assert.Equal(OrigemCasamento.SemCandidato, analise.Itens[0].Origem);
        Assert.Empty(analise.Itens[0].Sugestoes);
    }

    [DockerFact]
    public async Task Upload_returns_the_analysis()
    {
        var token = await LoginAsync();
        await CreateProdutoAsync(token, "COLA-2L", "Refrigerante Cola 2L", "17891000315504");
        var xml = await File.ReadAllTextAsync(Path.Combine(AppContext.BaseDirectory, "NotasFiscais", "Exemplos", "nfe-autorizada.xml"));

        using var request = new HttpRequestMessage(HttpMethod.Post, "/api/v1/notas-fiscais/analise") { Content = NotasFiscaisEndpointsTests.Arquivo(xml) };
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
        var response = await _client.SendAsync(request);

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var analise = (await response.Content.ReadFromJsonAsync<AnaliseNotaFiscal>(Json))!;
        Assert.Equal(2, analise.Itens.Count);
        Assert.Equal(OrigemCasamento.Gtin, analise.Itens[0].Origem);
        Assert.Equal("REF-001", analise.Itens[0].Item.CodigoFornecedor);
    }

    private async Task<AnaliseNotaFiscal> AnalyzeAsync()
    {
        await using var xml = File.OpenRead(Path.Combine(AppContext.BaseDirectory, "NotasFiscais", "Exemplos", "nfe-autorizada.xml"));
        using var scope = _factory.Services.CreateScope();
        var resultado = await scope.ServiceProvider.GetRequiredService<IAnaliseNotaFiscal>().AnalyzeAsync(xml);
        Assert.True(resultado.IsSuccess, resultado.Error?.Message);
        return resultado.Value;
    }

    private async Task<string> LoginAsync()
    {
        var response = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
    }

    private Task<ProdutoDetalhe> CreateProdutoAsync(string token, string sku, string descricao, string? gtin) =>
        PostAsync<ProdutoDetalhe>(token, "/api/v1/produtos",
            new { sku, descricao, unidadeBase = "UN", classeArmazenagem = "Normal", embalagemBase = new { gtin } }, HttpStatusCode.Created);

    private async Task<EmbalagemDetalhe> AddCaixaAsync(string token, Guid produtoId, string gtin, int fator)
    {
        var produto = await PostAsync<ProdutoDetalhe>(token, $"/api/v1/produtos/{produtoId}/embalagens",
            new { tipo = "Caixa", fatorConversao = fator, gtin }, HttpStatusCode.OK);
        return produto.Embalagens.Single(e => e.Tipo == TipoEmbalagem.Caixa);
    }

    private async Task<T> PostAsync<T>(string token, string url, object body, HttpStatusCode esperado)
    {
        using var request = new HttpRequestMessage(HttpMethod.Post, url) { Content = JsonContent.Create(body) };
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
        var response = await _client.SendAsync(request);
        Assert.Equal(esperado, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<T>(Json))!;
    }
}
