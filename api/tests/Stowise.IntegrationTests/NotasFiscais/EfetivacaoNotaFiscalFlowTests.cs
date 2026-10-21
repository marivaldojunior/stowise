using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Api.Endpoints;
using Stowise.Application.Catalogo;
using Stowise.Application.Common;
using Stowise.Application.NotasFiscais;
using Stowise.Domain.Catalogo;
using Stowise.Infrastructure.Persistence;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.NotasFiscais;

/// <summary>
/// Efetivação da NF-e de exemplo contra o PostgreSQL: fornecedor, produto novo, de-para, recebimento e XML numa só
/// gravação; nota repetida; decisões inválidas; exclusões protegidas pelo recebimento.
/// </summary>
[Collection(PostgresTestGroup.Name)]
public sealed class EfetivacaoNotaFiscalFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };
    private static readonly Guid Revisor = Guid.CreateVersion7();

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public EfetivacaoNotaFiscalFlowTests(PostgresFixture postgres)
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
    public async Task Invoice_becomes_a_receipt_with_supplier_new_product_and_links()
    {
        var token = await LoginAsync();
        var cola = await CreateProdutoAsync(token, "COLA-2L", "Refrigerante Cola 2L", "7891000315507");
        var caixa = await AddCaixaAsync(token, cola.Id, "17891000315504", 12);

        var efetivada = (await EfetivarAsync(
            new DecisaoItemNota(1, AcaoItemNota.Confirmar),
            new DecisaoItemNota(2, AcaoItemNota.CriarProduto, NovoProduto: new NovoProdutoNota("COPO-200", "Copo descartável 200ml", null, null)))).Value;

        Assert.True(efetivada.FornecedorCriado);
        Assert.Equal(1, efetivada.ProdutosCriados);
        Assert.Equal(2, efetivada.VinculosCriados);
        Assert.Equal(caixa.Id, efetivada.Itens[0].EmbalagemId);
        Assert.Equal(120m, efetivada.Itens[0].Quantidade);
        Assert.Equal(500m, efetivada.Itens[1].Quantidade);

        using (var scope = _factory.Services.CreateScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
            var recebimento = await db.Recebimentos.Include(r => r.Itens).SingleAsync(r => r.Id == efetivada.RecebimentoId);
            Assert.Equal("35261011222333000181550010000012341123456787", recebimento.ChaveAcesso);
            Assert.Equal(120m, recebimento.Itens.Single(i => i.NumeroItem == 1).Lotes.Single().QuantidadeBase);
            Assert.True(await db.XmlsRecebimento.AnyAsync(x => x.RecebimentoId == recebimento.Id));

            // O produto novo nasce da nota: base UN (uTrib), pacote de 100 e sem medidas, então Incompleto.
            var copo = await db.Produtos.Include(p => p.Embalagens).SingleAsync(p => p.Sku == "COPO-200");
            Assert.Equal("UN", copo.UnidadeBase);
            Assert.Equal(StatusCadastro.Incompleto, copo.StatusCadastro);
            Assert.Contains(copo.Embalagens, e => e.Tipo == TipoEmbalagem.Caixa && e.FatorConversao == 100m);
        }

        // A mesma nota não entra duas vezes.
        var repetida = await EfetivarAsync(
            new DecisaoItemNota(1, AcaoItemNota.Confirmar),
            new DecisaoItemNota(2, AcaoItemNota.Confirmar));
        Assert.Equal(ErrorType.Conflict, repetida.Error!.Type);

        // A próxima análise já reconhece o fornecedor e os dois códigos.
        var analise = await AnalyzeAsync();
        Assert.Equal(efetivada.FornecedorId, analise.Fornecedor.FornecedorId);
        Assert.All(analise.Itens, i => Assert.Equal(OrigemCasamento.DePara, i.Origem));

        // O recebimento protege o vínculo, o fornecedor e a embalagem usada.
        Assert.Equal(HttpStatusCode.UnprocessableEntity,
            (await SendAsync(token, HttpMethod.Delete, $"/api/v1/fornecedores/{efetivada.FornecedorId}/produtos/{efetivada.Itens[0].ProdutoFornecedorId}")).StatusCode);
        Assert.Equal(HttpStatusCode.UnprocessableEntity,
            (await SendAsync(token, HttpMethod.Delete, $"/api/v1/produtos/{cola.Id}/embalagens/{caixa.Id}")).StatusCode);
    }

    [DockerFact]
    public async Task Invalid_decisions_are_refused_without_writing_anything()
    {
        var token = await LoginAsync();
        var cola = await CreateProdutoAsync(token, "COLA-2L", "Refrigerante Cola 2L", "7891000315507");
        var copo = await CreateProdutoAsync(token, "COPO-200", "Copo descartável 200ml", null);

        var faltando = await EfetivarAsync(new DecisaoItemNota(1, AcaoItemNota.Vincular, cola.Id, cola.Embalagens.Single().Id));
        Assert.Equal(ErrorType.Validation, faltando.Error!.Type);
        Assert.Contains("itens", faltando.Error.Fields!.Keys);

        // O item 2 não tem casamento (só similaridade): não há o que confirmar.
        var semCasamento = await EfetivarAsync(
            new DecisaoItemNota(1, AcaoItemNota.Confirmar),
            new DecisaoItemNota(2, AcaoItemNota.Confirmar));
        Assert.Equal(ErrorType.Validation, semCasamento.Error!.Type);

        var embalagemDeOutro = await EfetivarAsync(
            new DecisaoItemNota(1, AcaoItemNota.Confirmar),
            new DecisaoItemNota(2, AcaoItemNota.Vincular, copo.Id, cola.Embalagens.Single().Id));
        Assert.Equal(ErrorType.BusinessRule, embalagemDeOutro.Error!.Type);

        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
        Assert.False(await db.Recebimentos.AnyAsync());
        Assert.False(await db.Fornecedores.AnyAsync());
        Assert.False(await db.ProdutoFornecedores.AnyAsync());
    }

    private async Task<Result<NotaFiscalEfetivada>> EfetivarAsync(params DecisaoItemNota[] decisoes)
    {
        var xml = await File.ReadAllTextAsync(Path.Combine(AppContext.BaseDirectory, "NotasFiscais", "Exemplos", "nfe-autorizada.xml"));
        using var scope = _factory.Services.CreateScope();
        return await scope.ServiceProvider.GetRequiredService<IEfetivacaoNotaFiscal>().EfetivarAsync(new EfetivarNotaFiscal(xml, decisoes), Revisor);
    }

    private async Task<AnaliseNotaFiscal> AnalyzeAsync()
    {
        await using var xml = File.OpenRead(Path.Combine(AppContext.BaseDirectory, "NotasFiscais", "Exemplos", "nfe-autorizada.xml"));
        using var scope = _factory.Services.CreateScope();
        return (await scope.ServiceProvider.GetRequiredService<IAnaliseNotaFiscal>().AnalyzeAsync(xml)).Value;
    }

    private async Task<string> LoginAsync()
    {
        var response = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
    }

    private async Task<ProdutoDetalhe> CreateProdutoAsync(string token, string sku, string descricao, string? gtin)
    {
        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/produtos",
            new { sku, descricao, unidadeBase = "UN", classeArmazenagem = "Normal", embalagemBase = new { gtin } });
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<ProdutoDetalhe>(Json))!;
    }

    private async Task<EmbalagemDetalhe> AddCaixaAsync(string token, Guid produtoId, string gtin, int fator)
    {
        var response = await SendAsync(token, HttpMethod.Post, $"/api/v1/produtos/{produtoId}/embalagens", new { tipo = "Caixa", fatorConversao = fator, gtin });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<ProdutoDetalhe>(Json))!.Embalagens.Single(e => e.Tipo == TipoEmbalagem.Caixa);
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
