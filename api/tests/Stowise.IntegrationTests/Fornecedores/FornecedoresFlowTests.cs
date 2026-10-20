using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Stowise.Api.Endpoints;
using Stowise.Application.Catalogo;
using Stowise.Application.Common;
using Stowise.Application.Fornecedores;
using Stowise.Domain.Catalogo;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Fornecedores;

/// <summary>Fornecedores e de-para contra o PostgreSQL: CNPJ único, concorrência, vínculos e exclusões protegidas.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class FornecedoresFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public FornecedoresFlowTests(PostgresFixture postgres)
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
    public async Task Supplier_has_a_unique_cnpj_and_optimistic_concurrency()
    {
        var token = await LoginAsync();
        var fornecedor = await CreateFornecedorAsync(token, "12.abc.345/01de-35");
        Assert.Equal("12ABC34501DE35", fornecedor.Cnpj);

        var repetido = await SendAsync(token, HttpMethod.Post, "/api/v1/fornecedores", new { cnpj = "12ABC34501DE35", razaoSocial = "Outra" });
        Assert.Equal(HttpStatusCode.Conflict, repetido.StatusCode);

        var porCnpj = await GetAsync<PagedResult<FornecedorResumo>>(token, "/api/v1/fornecedores?busca=345%2F01DE");
        Assert.Equal(fornecedor.Id, Assert.Single(porCnpj.Itens).Id);
        var porNome = await GetAsync<PagedResult<FornecedorResumo>>(token, "/api/v1/fornecedores?busca=exemplo");
        Assert.Single(porNome.Itens);

        var atualizado = await SendAsync(token, HttpMethod.Put, $"/api/v1/fornecedores/{fornecedor.Id}",
            new { razaoSocial = "Distribuidora Exemplo S.A.", nomeFantasia = "Exemplo", versao = fornecedor.Versao });
        Assert.Equal(HttpStatusCode.OK, atualizado.StatusCode);

        var desatualizado = await SendAsync(token, HttpMethod.Put, $"/api/v1/fornecedores/{fornecedor.Id}",
            new { razaoSocial = "Outra razão", versao = fornecedor.Versao });
        Assert.Equal(HttpStatusCode.Conflict, desatualizado.StatusCode);
    }

    [DockerFact]
    public async Task Supplier_codes_link_to_a_product_package_and_protect_deletes()
    {
        var token = await LoginAsync();
        var fornecedor = await CreateFornecedorAsync(token, "11.222.333/0001-81");
        var produto = await CreateProdutoAsync(token, "COLA-2L", "7891000315507");
        var caixa = await AddCaixaAsync(token, produto.Id, "17891000315504");
        var outro = await CreateProdutoAsync(token, "AGUA-500", "7891000100103");

        // Sem fator, vale o da embalagem (caixa com 6).
        var vinculo = await LinkAsync(token, fornecedor.Id, new { codigoFornecedor = "REF-001", produtoId = produto.Id, embalagemId = caixa.Id, unidadeFornecedor = "cx" });
        Assert.Equal(6m, vinculo.FatorConversao);
        Assert.Equal("CX", vinculo.UnidadeFornecedor);
        Assert.Equal(TipoEmbalagem.Caixa, vinculo.TipoEmbalagem);
        Assert.Equal("COLA-2L", vinculo.Sku);

        var repetido = await SendAsync(token, HttpMethod.Post, $"/api/v1/fornecedores/{fornecedor.Id}/produtos",
            new { codigoFornecedor = "REF-001", produtoId = outro.Id, embalagemId = outro.Embalagens.Single().Id, unidadeFornecedor = "UN" });
        Assert.Equal(HttpStatusCode.Conflict, repetido.StatusCode);

        var embalagemDeOutroProduto = await SendAsync(token, HttpMethod.Post, $"/api/v1/fornecedores/{fornecedor.Id}/produtos",
            new { codigoFornecedor = "REF-002", produtoId = produto.Id, embalagemId = outro.Embalagens.Single().Id, unidadeFornecedor = "UN" });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, embalagemDeOutroProduto.StatusCode);

        var porCodigo = await GetAsync<ProdutoFornecedorDetalhe>(token, $"/api/v1/fornecedores/{fornecedor.Id}/produtos/codigo/REF-001");
        Assert.Equal(vinculo.Id, porCodigo.Id);

        var trocado = await SendAsync(token, HttpMethod.Put, $"/api/v1/fornecedores/{fornecedor.Id}/produtos/{vinculo.Id}",
            new { produtoId = produto.Id, embalagemId = caixa.Id, unidadeFornecedor = "FD", fatorConversao = 12, versao = vinculo.Versao });
        Assert.Equal(HttpStatusCode.OK, trocado.StatusCode);
        Assert.Equal(12m, (await trocado.Content.ReadFromJsonAsync<ProdutoFornecedorDetalhe>(Json))!.FatorConversao);

        var lista = await GetAsync<PagedResult<ProdutoFornecedorDetalhe>>(token, $"/api/v1/fornecedores/{fornecedor.Id}/produtos?busca=cola");
        Assert.Single(lista.Itens);

        // Vínculo protege a embalagem e o fornecedor.
        var removerCaixa = await SendAsync(token, HttpMethod.Delete, $"/api/v1/produtos/{produto.Id}/embalagens/{caixa.Id}");
        Assert.Equal(HttpStatusCode.UnprocessableEntity, removerCaixa.StatusCode);
        var excluirFornecedor = await SendAsync(token, HttpMethod.Delete, $"/api/v1/fornecedores/{fornecedor.Id}");
        Assert.Equal(HttpStatusCode.UnprocessableEntity, excluirFornecedor.StatusCode);

        Assert.Equal(HttpStatusCode.NoContent, (await SendAsync(token, HttpMethod.Delete, $"/api/v1/fornecedores/{fornecedor.Id}/produtos/{vinculo.Id}")).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await SendAsync(token, HttpMethod.Get, $"/api/v1/fornecedores/{fornecedor.Id}/produtos/codigo/REF-001")).StatusCode);
        Assert.Equal(HttpStatusCode.NoContent, (await SendAsync(token, HttpMethod.Delete, $"/api/v1/fornecedores/{fornecedor.Id}")).StatusCode);
    }

    private async Task<FornecedorDetalhe> CreateFornecedorAsync(string token, string cnpj)
    {
        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/fornecedores",
            new { cnpj, razaoSocial = "Distribuidora Exemplo Ltda", nomeFantasia = (string?)null });
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<FornecedorDetalhe>(Json))!;
    }

    private async Task<ProdutoFornecedorDetalhe> LinkAsync(string token, Guid fornecedorId, object body)
    {
        var response = await SendAsync(token, HttpMethod.Post, $"/api/v1/fornecedores/{fornecedorId}/produtos", body);
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<ProdutoFornecedorDetalhe>(Json))!;
    }

    private async Task<string> LoginAsync()
    {
        var response = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
    }

    private async Task<ProdutoDetalhe> CreateProdutoAsync(string token, string sku, string gtin)
    {
        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/produtos", new
        {
            sku,
            descricao = sku == "COLA-2L" ? "Refrigerante Cola 2L" : "Água mineral 500ml",
            unidadeBase = "UN",
            classeArmazenagem = "Normal",
            embalagemBase = new { gtin },
        });
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<ProdutoDetalhe>(Json))!;
    }

    private async Task<EmbalagemDetalhe> AddCaixaAsync(string token, Guid produtoId, string gtin)
    {
        var response = await SendAsync(token, HttpMethod.Post, $"/api/v1/produtos/{produtoId}/embalagens",
            new { tipo = "Caixa", fatorConversao = 6, gtin });
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
