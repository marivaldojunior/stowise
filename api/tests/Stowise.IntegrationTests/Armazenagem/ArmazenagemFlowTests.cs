using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Stowise.Api.Endpoints;
using Stowise.Application.Armazenagem;
using Stowise.Application.Catalogo;
using Stowise.Application.Estrutura;
using Stowise.Domain.Armazenagem;
using Stowise.Domain.Catalogo;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Armazenagem;

/// <summary>
/// Sugestão de endereços contra o PostgreSQL, com as regras da migration. O refrigerante (classe C, caixa de 12 com
/// 24 kg) já tem 2 caixas no A-02, longe da expedição; o A-03 aguenta só 50 kg e o F-01 é da zona de inflamáveis.
/// </summary>
[Collection(PostgresTestGroup.Name)]
public sealed class ArmazenagemFlowTests : IAsyncLifetime
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;
    private string _token = null!;
    private ProdutoDetalhe _refrigerante = null!;
    private Guid _caixaId;

    public ArmazenagemFlowTests(PostgresFixture postgres)
    {
        _factory = StowiseApiFactory.WithDatabase(postgres, AdminEmail, AdminPassword);
        _client = _factory.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });
    }

    public async Task InitializeAsync()
    {
        if (!DockerEnvironment.IsAvailable && !DockerEnvironment.IsRequired)
        {
            return;
        }

        var login = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        _token = (await login.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;

        var armazem = await SendAsync<ArmazemDetalhe>(HttpMethod.Post, "/api/v1/armazens", new { codigo = "CD03", nome = "Centro Norte" });
        await SendAsync<ArmazemDetalhe>(HttpMethod.Post, $"/api/v1/armazens/{armazem.Id}/zonas", new { codigo = "SECO", classeArmazenagem = "Normal" });
        armazem = await SendAsync<ArmazemDetalhe>(HttpMethod.Post, $"/api/v1/armazens/{armazem.Id}/zonas", new { codigo = "INFL", classeArmazenagem = "Inflamavel" });
        var seco = armazem.Zonas.Single(z => z.Codigo == "SECO").Id;
        var inflamaveis = armazem.Zonas.Single(z => z.Codigo == "INFL").Id;

        await EnderecoAsync(seco, "A", 1, distancia: 4, capacidadeKg: 1000);
        var longe = await EnderecoAsync(seco, "A", 2, distancia: 30, capacidadeKg: 1000);
        await EnderecoAsync(seco, "A", 3, distancia: 10, capacidadeKg: 50);
        await EnderecoAsync(inflamaveis, "F", 1, distancia: 2, capacidadeKg: 1000);

        _refrigerante = await SendAsync<ProdutoDetalhe>(HttpMethod.Post, "/api/v1/produtos", new
        {
            sku = "COLA-2L",
            descricao = "Refrigerante Cola 2L",
            unidadeBase = "UN",
            classeArmazenagem = "Normal",
            embalagemBase = new { pesoKg = 2 },
        });
        _refrigerante = await SendAsync<ProdutoDetalhe>(HttpMethod.Post, $"/api/v1/produtos/{_refrigerante.Id}/embalagens", new
        {
            tipo = "Caixa",
            fatorConversao = 12,
            pesoKg = 24,
            alturaCm = 30,
            larguraCm = 40,
            comprimentoCm = 20,
        });
        _caixaId = _refrigerante.Embalagens.Single(e => e.Tipo == TipoEmbalagem.Caixa).Id;

        var entrada = await RawAsync(HttpMethod.Post, "/api/v1/movimentacoes/entradas", new
        {
            produtoId = _refrigerante.Id,
            embalagemId = _caixaId,
            enderecoId = longe.Id,
            quantidade = 2,
        });
        Assert.Equal(HttpStatusCode.Created, entrada.StatusCode);
    }

    public Task DisposeAsync()
    {
        _client.Dispose();
        _factory.Dispose();
        return Task.CompletedTask;
    }

    [DockerFact]
    public async Task Suggestion_ranks_the_addresses_and_explains_the_discarded_ones()
    {
        var sugestao = await SugerirAsync();

        Assert.Equal(120m, sugestao.Quantidade);
        Assert.Equal(240m, sugestao.PesoKg);
        Assert.Equal(ClasseAbc.C, sugestao.ClasseAbc);
        Assert.Equal(4, sugestao.TotalCandidatos);

        // Classe C longe da expedição e junto do mesmo produto: (1 × 0,288 + 3 × 1 + 2 × 1) / 6.
        Assert.Equal(["A-02-01-1", "A-01-01-1"], sugestao.Sugestoes.Select(s => s.Codigo));
        Assert.Equal(88.13m, sugestao.Sugestoes[0].Pontuacao);
        Assert.Null(sugestao.Sugestoes[0].Notas.Single(n => n.Codigo == CodigosRegra.Fefo).Nota);

        Assert.Equal(2, sugestao.TotalDescartados);
        Assert.Contains("Peso excede", Assert.Single(sugestao.Descartados, d => d.Codigo == "A-03-01-1").Motivos[0], StringComparison.Ordinal);
        Assert.Contains("inflamáveis", Assert.Single(sugestao.Descartados, d => d.Codigo == "F-01-01-1").Motivos[0], StringComparison.Ordinal);
    }

    [DockerFact]
    public async Task New_weights_change_the_score_and_stale_versions_are_refused()
    {
        var regras = await SendAsync<List<RegraArmazenagemDetalhe>>(HttpMethod.Get, "/api/v1/armazenagem/regras");
        Assert.Equal(
            [CodigosRegra.Zona, CodigosRegra.Capacidade, CodigosRegra.CurvaAbc, CodigosRegra.Fefo, CodigosRegra.Consolidacao],
            regras.Select(r => r.Codigo));
        var curva = regras.Single(r => r.Codigo == CodigosRegra.CurvaAbc);
        Assert.Equal(3m, curva.Peso);

        var alterada = await SendAsync<RegraArmazenagemDetalhe>(HttpMethod.Put, "/api/v1/armazenagem/regras/curva-abc", new { peso = 0, ativa = true, parametros = new { }, versao = curva.Versao });
        Assert.Equal(0m, alterada.Peso);
        Assert.NotNull(alterada.AtualizadoPor);

        var desatualizada = await RawAsync(HttpMethod.Put, "/api/v1/armazenagem/regras/curva-abc", new { peso = 1, ativa = true, parametros = new { }, versao = curva.Versao });
        Assert.Equal(HttpStatusCode.Conflict, desatualizada.StatusCode);

        var desconhecido = await RawAsync(HttpMethod.Put, "/api/v1/armazenagem/regras/fefo", new
        {
            peso = 1,
            ativa = true,
            parametros = new { altura = 1 },
            versao = regras.Single(r => r.Codigo == CodigosRegra.Fefo).Versao,
        });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, desconhecido.StatusCode);

        Assert.Equal(HttpStatusCode.NotFound, (await RawAsync(HttpMethod.Put, "/api/v1/armazenagem/regras/altura", new { peso = 1, ativa = true, parametros = new { }, versao = 1 })).StatusCode);

        // Sem a curva ABC: (1 × 0,288 + 2 × 1) / 3.
        var sugestao = await SugerirAsync();
        Assert.Equal(76.27m, sugestao.Sugestoes[0].Pontuacao);
        Assert.Equal(0m, sugestao.Sugestoes[0].Notas.Single(n => n.Codigo == CodigosRegra.CurvaAbc).Peso);
    }

    private Task<SugestaoArmazenagem> SugerirAsync() =>
        SendAsync<SugestaoArmazenagem>(HttpMethod.Post, "/api/v1/armazenagem/sugestoes", new { produtoId = _refrigerante.Id, embalagemId = _caixaId, quantidade = 10 });

    private Task<EnderecoDetalhe> EnderecoAsync(Guid zonaId, string rua, int modulo, decimal distancia, decimal capacidadeKg) =>
        SendAsync<EnderecoDetalhe>(HttpMethod.Post, "/api/v1/enderecos", new
        {
            zonaId,
            rua,
            modulo,
            nivel = 1,
            posicao = 1,
            capacidadePesoKg = capacidadeKg,
            alturaCm = 150,
            larguraCm = 120,
            profundidadeCm = 100,
            distanciaExpedicao = distancia,
        });

    private async Task<T> SendAsync<T>(HttpMethod method, string url, object? body = null)
    {
        var response = await RawAsync(method, url, body);
        Assert.True(response.IsSuccessStatusCode, $"{method} {url}: {(int)response.StatusCode} {await response.Content.ReadAsStringAsync()}");
        return (await response.Content.ReadFromJsonAsync<T>(Json))!;
    }

    private async Task<HttpResponseMessage> RawAsync(HttpMethod method, string url, object? body = null)
    {
        using var request = new HttpRequestMessage(method, url);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", _token);
        if (body is not null)
        {
            request.Content = JsonContent.Create(body);
        }

        return await _client.SendAsync(request);
    }
}
