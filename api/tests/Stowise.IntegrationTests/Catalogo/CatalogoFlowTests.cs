using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Stowise.Api.Endpoints;
using Stowise.Application.Auth;
using Stowise.Application.Catalogo;
using Stowise.Application.Common;
using Stowise.Domain.Catalogo;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Catalogo;

/// <summary>Catálogo contra o PostgreSQL: unicidade, concorrência, hierarquia e busca por código.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class CatalogoFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";
    private const string GtinUnidade = "7891000315507";
    private const string GtinCaixa = "17891000315504";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public CatalogoFlowTests(PostgresFixture postgres)
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
    public async Task Categorias_form_a_tree_without_cycles_and_only_empty_ones_are_deleted()
    {
        var token = await LoginAsync();
        var bebidas = await CreateCategoriaAsync(token, "Bebidas", null);
        var refrigerantes = await CreateCategoriaAsync(token, "Refrigerantes", bebidas.Id);
        var colas = await CreateCategoriaAsync(token, "Colas", refrigerantes.Id);
        Assert.Equal("Bebidas › Refrigerantes › Colas", colas.Caminho);

        var duplicada = await SendAsync(token, HttpMethod.Post, "/api/v1/categorias", new { nome = "refrigerantes", parentId = bebidas.Id });
        Assert.Equal(HttpStatusCode.Conflict, duplicada.StatusCode);

        var raizDuplicada = await SendAsync(token, HttpMethod.Post, "/api/v1/categorias", new { nome = "BEBIDAS" });
        Assert.Equal(HttpStatusCode.Conflict, raizDuplicada.StatusCode);

        var ciclo = await SendAsync(token, HttpMethod.Put, $"/api/v1/categorias/{bebidas.Id}", new { nome = "Bebidas", parentId = colas.Id });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, ciclo.StatusCode);

        var comFilhas = await SendAsync(token, HttpMethod.Delete, $"/api/v1/categorias/{refrigerantes.Id}");
        Assert.Equal(HttpStatusCode.UnprocessableEntity, comFilhas.StatusCode);

        await CreateProdutoAsync(token, "COLA-2L", colas.Id, GtinUnidade);
        var comProdutos = await SendAsync(token, HttpMethod.Delete, $"/api/v1/categorias/{colas.Id}");
        Assert.Equal(HttpStatusCode.UnprocessableEntity, comProdutos.StatusCode);

        var vazia = await CreateCategoriaAsync(token, "Sucos", bebidas.Id);
        Assert.Equal(HttpStatusCode.NoContent, (await SendAsync(token, HttpMethod.Delete, $"/api/v1/categorias/{vazia.Id}")).StatusCode);

        var lista = await GetAsync<List<CategoriaDetalhe>>(token, "/api/v1/categorias");
        Assert.Equal(["Bebidas", "Bebidas › Refrigerantes", "Bebidas › Refrigerantes › Colas"], lista.Select(c => c.Caminho));
    }

    [DockerFact]
    public async Task Produto_is_created_found_by_sku_or_gtin_and_listed()
    {
        var token = await LoginAsync();
        var criado = await CreateProdutoAsync(token, "cola-2l", categoriaId: null, GtinUnidade);
        Assert.Equal("COLA-2L", criado.Sku);
        Assert.True(criado.Versao > 0);
        var caixa = await AddCaixaAsync(token, criado.Id);

        var porGtinCaixa = await GetAsync<ProdutoPorCodigo>(token, $"/api/v1/produtos/codigo/{GtinCaixa}");
        Assert.Equal(criado.Id, porGtinCaixa.Produto.Id);
        Assert.Equal(caixa.Id, porGtinCaixa.EmbalagemId);

        var porSku = await GetAsync<ProdutoPorCodigo>(token, "/api/v1/produtos/codigo/cola-2l");
        Assert.Equal(criado.Embalagens.Single(e => e.UnidadeBase).Id, porSku.EmbalagemId);

        var desconhecido = await SendAsync(token, HttpMethod.Get, "/api/v1/produtos/codigo/0000000000000");
        Assert.Equal(HttpStatusCode.NotFound, desconhecido.StatusCode);

        var porBusca = await GetAsync<PagedResult<ProdutoResumo>>(token, "/api/v1/produtos?busca=refriger");
        Assert.Equal("COLA-2L", Assert.Single(porBusca.Itens).Sku);
        var porGtin = await GetAsync<PagedResult<ProdutoResumo>>(token, $"/api/v1/produtos?busca={GtinUnidade}");
        Assert.Single(porGtin.Itens);
    }

    [DockerFact]
    public async Task Sku_and_gtin_are_unique()
    {
        var token = await LoginAsync();
        await CreateProdutoAsync(token, "COLA-2L", categoriaId: null, GtinUnidade);

        var mesmoSku = await SendAsync(token, HttpMethod.Post, "/api/v1/produtos", ProdutoBody("cola-2l", null, null));
        var mesmoGtin = await SendAsync(token, HttpMethod.Post, "/api/v1/produtos", ProdutoBody("OUTRO", null, GtinUnidade));

        Assert.Equal(HttpStatusCode.Conflict, mesmoSku.StatusCode);
        Assert.Equal(HttpStatusCode.Conflict, mesmoGtin.StatusCode);
    }

    [DockerFact]
    public async Task Update_with_stale_versao_returns_409()
    {
        var token = await LoginAsync();
        var produto = await CreateProdutoAsync(token, "COLA-2L", categoriaId: null, GtinUnidade);

        var primeira = await SendAsync(token, HttpMethod.Put, $"/api/v1/produtos/{produto.Id}", AtualizarBody("Cola 2 litros", produto.Versao));
        Assert.Equal(HttpStatusCode.OK, primeira.StatusCode);
        var atualizado = (await primeira.Content.ReadFromJsonAsync<ProdutoDetalhe>(Json))!;
        Assert.NotEqual(produto.Versao, atualizado.Versao);

        var antiga = await SendAsync(token, HttpMethod.Put, $"/api/v1/produtos/{produto.Id}", AtualizarBody("Outra descrição", produto.Versao));
        Assert.Equal(HttpStatusCode.Conflict, antiga.StatusCode);
    }

    [DockerFact]
    public async Task Packages_follow_domain_rules_through_the_api()
    {
        var token = await LoginAsync();
        var produto = await CreateProdutoAsync(token, "COLA-2L", categoriaId: null, GtinUnidade);
        var caixa = await AddCaixaAsync(token, produto.Id);

        var repetida = await SendAsync(token, HttpMethod.Post, $"/api/v1/produtos/{produto.Id}/embalagens", new { tipo = "Caixa", fatorConversao = 6 });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, repetida.StatusCode);

        var medidas = await SendAsync(token, HttpMethod.Put, $"/api/v1/produtos/{produto.Id}/embalagens/{caixa.Id}",
            new { gtin = GtinCaixa, pesoKg = 13.2, alturaCm = 34, larguraCm = 31, comprimentoCm = 21 });
        Assert.Equal(HttpStatusCode.OK, medidas.StatusCode);

        var baseId = produto.Embalagens.Single(e => e.UnidadeBase).Id;
        var removerBase = await SendAsync(token, HttpMethod.Delete, $"/api/v1/produtos/{produto.Id}/embalagens/{baseId}");
        Assert.Equal(HttpStatusCode.UnprocessableEntity, removerBase.StatusCode);

        var removida = await SendAsync(token, HttpMethod.Delete, $"/api/v1/produtos/{produto.Id}/embalagens/{caixa.Id}");
        Assert.Equal(HttpStatusCode.OK, removida.StatusCode);
        Assert.Single((await removida.Content.ReadFromJsonAsync<ProdutoDetalhe>(Json))!.Embalagens);

        // O GTIN da caixa removida pode ser usado de novo.
        var novaCaixa = await SendAsync(token, HttpMethod.Post, $"/api/v1/produtos/{produto.Id}/embalagens",
            new { tipo = "Caixa", fatorConversao = 12, gtin = GtinCaixa });
        Assert.Equal(HttpStatusCode.OK, novaCaixa.StatusCode);
    }

    [DockerFact]
    public async Task Deactivated_product_still_resolves_but_is_filtered_by_ativo()
    {
        var token = await LoginAsync();
        var produto = await CreateProdutoAsync(token, "COLA-2L", categoriaId: null, GtinUnidade);

        Assert.Equal(HttpStatusCode.NoContent, (await SendAsync(token, HttpMethod.Post, $"/api/v1/produtos/{produto.Id}/desativar")).StatusCode);

        var ativos = await GetAsync<PagedResult<ProdutoResumo>>(token, "/api/v1/produtos?ativo=true");
        Assert.Empty(ativos.Itens);
        var porCodigo = await GetAsync<ProdutoPorCodigo>(token, $"/api/v1/produtos/codigo/{GtinUnidade}");
        Assert.False(porCodigo.Produto.Ativo);
    }

    private async Task<string> LoginAsync()
    {
        var response = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
    }

    private async Task<CategoriaDetalhe> CreateCategoriaAsync(string token, string nome, Guid? parentId)
    {
        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/categorias", new { nome, parentId });
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<CategoriaDetalhe>(Json))!;
    }

    private async Task<ProdutoDetalhe> CreateProdutoAsync(string token, string sku, Guid? categoriaId, string? gtin)
    {
        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/produtos", ProdutoBody(sku, categoriaId, gtin));
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

    private static object ProdutoBody(string sku, Guid? categoriaId, string? gtin) => new
    {
        sku,
        descricao = "Refrigerante Cola 2L",
        unidadeBase = "UN",
        classeArmazenagem = "Normal",
        controlaLote = true,
        controlaValidade = true,
        ncm = "2202.10.00",
        categoriaId,
        embalagemBase = new { gtin, pesoKg = 2.1, alturaCm = 33, larguraCm = 10, comprimentoCm = 10 },
    };

    private static object AtualizarBody(string descricao, uint versao) => new
    {
        descricao,
        unidadeBase = "UN",
        classeArmazenagem = "Normal",
        controlaLote = true,
        controlaValidade = true,
        ncm = "22021000",
        versao,
    };

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
