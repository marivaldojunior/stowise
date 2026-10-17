using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Stowise.Api.Endpoints;
using Stowise.Application.Common;
using Stowise.Application.Estrutura;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Estrutura;

/// <summary>Armazéns, zonas e endereços contra o PostgreSQL.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class EstruturaFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public EstruturaFlowTests(PostgresFixture postgres)
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
    public async Task Armazem_and_zonas_follow_the_rules()
    {
        var token = await LoginAsync();
        var cd = await CreateArmazemAsync(token, "cd02", "Centro Sul");
        Assert.Equal("CD02", cd.Codigo);

        var duplicado = await SendAsync(token, HttpMethod.Post, "/api/v1/armazens", new { codigo = "CD02", nome = "Outro" });
        Assert.Equal(HttpStatusCode.Conflict, duplicado.StatusCode);

        await AddZonaAsync(token, cd.Id, "seco", "Normal");
        var comZonas = await AddZonaAsync(token, cd.Id, "FRIO", "Refrigerado");
        Assert.Equal(["FRIO", "SECO"], comZonas.Zonas.Select(z => z.Codigo));

        var zonaRepetida = await SendAsync(token, HttpMethod.Post, $"/api/v1/armazens/{cd.Id}/zonas", new { codigo = "Seco", classeArmazenagem = "Fragil" });
        Assert.Equal(HttpStatusCode.Conflict, zonaRepetida.StatusCode);

        var seco = comZonas.Zonas.Single(z => z.Codigo == "SECO");
        var renomeada = await SendAsync(token, HttpMethod.Put, $"/api/v1/armazens/{cd.Id}/zonas/{seco.Id}", new { codigo = "SECO-1", classeArmazenagem = "Fragil" });
        Assert.Equal(HttpStatusCode.OK, renomeada.StatusCode);

        await CreateEnderecoAsync(token, seco.Id, "A", 1);
        var zonaComEnderecos = await SendAsync(token, HttpMethod.Delete, $"/api/v1/armazens/{cd.Id}/zonas/{seco.Id}");
        Assert.Equal(HttpStatusCode.UnprocessableEntity, zonaComEnderecos.StatusCode);

        var armazemComZonas = await SendAsync(token, HttpMethod.Delete, $"/api/v1/armazens/{cd.Id}");
        Assert.Equal(HttpStatusCode.UnprocessableEntity, armazemComZonas.StatusCode);

        var detalhe = await GetAsync<ArmazemDetalhe>(token, $"/api/v1/armazens/{cd.Id}");
        Assert.Equal(1, detalhe.Zonas.Single(z => z.Codigo == "SECO-1").Enderecos);
        Assert.Equal("Centro Sul", Assert.Single((await GetAsync<List<ArmazemResumo>>(token, "/api/v1/armazens")), a => a.Codigo == "CD02").Nome);
    }

    [DockerFact]
    public async Task Endereco_codigo_is_unique_in_the_warehouse_across_zones()
    {
        var token = await LoginAsync();
        var cd = await CreateArmazemAsync(token, "CD02", "Centro Sul");
        var seco = (await AddZonaAsync(token, cd.Id, "SECO", "Normal")).Zonas.Single();
        var frio = (await AddZonaAsync(token, cd.Id, "FRIO", "Refrigerado")).Zonas.Single(z => z.Codigo == "FRIO");

        var endereco = await CreateEnderecoAsync(token, seco.Id, "a", 3);
        Assert.Equal("A-03-02-1", endereco.Codigo);
        Assert.Equal(cd.Id, endereco.ArmazemId);

        var outraZona = await SendAsync(token, HttpMethod.Post, "/api/v1/enderecos", EnderecoBody(frio.Id, "A", 3));
        Assert.Equal(HttpStatusCode.Conflict, outraZona.StatusCode);

        // Em outro armazém, o mesmo código é permitido.
        var cd3 = await CreateArmazemAsync(token, "CD03", "Centro Leste");
        var zonaCd3 = (await AddZonaAsync(token, cd3.Id, "SECO", "Normal")).Zonas.Single();
        Assert.Equal("A-03-02-1", (await CreateEnderecoAsync(token, zonaCd3.Id, "A", 3)).Codigo);
    }

    [DockerFact]
    public async Task Endereco_is_found_by_code_listed_by_prefix_updated_and_deleted()
    {
        var token = await LoginAsync();
        var cd = await CreateArmazemAsync(token, "CD02", "Centro Sul");
        var seco = (await AddZonaAsync(token, cd.Id, "SECO", "Normal")).Zonas.Single();
        var a03 = await CreateEnderecoAsync(token, seco.Id, "A", 3);
        await CreateEnderecoAsync(token, seco.Id, "A", 4);
        await CreateEnderecoAsync(token, seco.Id, "B", 3);

        var lido = await GetAsync<EnderecoDetalhe>(token, $"/api/v1/armazens/{cd.Id}/enderecos/codigo/a-03-02-1");
        Assert.Equal(a03.Id, lido.Id);
        var inexistente = await SendAsync(token, HttpMethod.Get, $"/api/v1/armazens/{cd.Id}/enderecos/codigo/Z-01-01-1");
        Assert.Equal(HttpStatusCode.NotFound, inexistente.StatusCode);

        var ruaA = await GetAsync<PagedResult<EnderecoDetalhe>>(token, $"/api/v1/enderecos?armazemId={cd.Id}&codigo=A-");
        Assert.Equal(["A-03-02-1", "A-04-02-1"], ruaA.Itens.Select(e => e.Codigo));
        var livres = await GetAsync<PagedResult<EnderecoDetalhe>>(token, $"/api/v1/enderecos?armazemId={cd.Id}&status=Livre");
        Assert.Equal(3, livres.Total);

        var atualizado = await SendAsync(token, HttpMethod.Put, $"/api/v1/enderecos/{a03.Id}",
            new { capacidadePesoKg = 800, alturaCm = 200, larguraCm = 100, profundidadeCm = 90, distanciaExpedicao = 30 });
        Assert.Equal(HttpStatusCode.OK, atualizado.StatusCode);
        var dimensoes = (await atualizado.Content.ReadFromJsonAsync<EnderecoDetalhe>(Json))!;
        Assert.Equal(800m, dimensoes.CapacidadePesoKg);
        Assert.Equal("A-03-02-1", dimensoes.Codigo);

        Assert.Equal(HttpStatusCode.NoContent, (await SendAsync(token, HttpMethod.Delete, $"/api/v1/enderecos/{a03.Id}")).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await SendAsync(token, HttpMethod.Get, $"/api/v1/enderecos/{a03.Id}")).StatusCode);
    }

    [DockerFact]
    public async Task Lote_simulates_creates_refuses_overlap_and_can_skip_existing()
    {
        var token = await LoginAsync();
        var cd = await CreateArmazemAsync(token, "CD02", "Centro Sul");
        var seco = (await AddZonaAsync(token, cd.Id, "SECO", "Normal")).Zonas.Single();

        var simulacao = await GerarLoteAsync(token, seco.Id, ruas: ["A", "B"], moduloFinal: 5, simular: true);
        Assert.Equal(HttpStatusCode.OK, simulacao.StatusCode);
        var previa = (await simulacao.Content.ReadFromJsonAsync<GeracaoEnderecosResultado>(Json))!;
        Assert.True(previa.Simulado);
        Assert.Equal(20, previa.Total);
        Assert.Equal(20, previa.Criados);
        Assert.Equal("A-01-01-1", previa.Amostra[0]);
        Assert.Equal(0, (await GetAsync<PagedResult<EnderecoDetalhe>>(token, $"/api/v1/enderecos?armazemId={cd.Id}")).Total);

        var criacao = await GerarLoteAsync(token, seco.Id, ruas: ["A", "B"], moduloFinal: 5);
        Assert.Equal(HttpStatusCode.OK, criacao.StatusCode);
        Assert.Equal(20, (await GetAsync<PagedResult<EnderecoDetalhe>>(token, $"/api/v1/enderecos?armazemId={cd.Id}")).Total);
        var distante = await GetAsync<EnderecoDetalhe>(token, $"/api/v1/armazens/{cd.Id}/enderecos/codigo/A-05-02-1");
        Assert.Equal(12m, distante.DistanciaExpedicao);

        // Ampliar a rua B até o módulo 8 sobrepõe os módulos 1 a 5 já criados.
        var sobreposto = await GerarLoteAsync(token, seco.Id, ruas: ["B"], moduloFinal: 8);
        Assert.Equal(HttpStatusCode.Conflict, sobreposto.StatusCode);

        var ampliado = await GerarLoteAsync(token, seco.Id, ruas: ["B"], moduloFinal: 8, ignorarExistentes: true);
        Assert.Equal(HttpStatusCode.OK, ampliado.StatusCode);
        var resultado = (await ampliado.Content.ReadFromJsonAsync<GeracaoEnderecosResultado>(Json))!;
        Assert.Equal(6, resultado.Criados);
        Assert.Equal(10, resultado.Ignorados);
        Assert.Contains("B-01-01-1", resultado.CodigosExistentes);
        Assert.Equal(26, (await GetAsync<PagedResult<EnderecoDetalhe>>(token, $"/api/v1/enderecos?armazemId={cd.Id}")).Total);
    }

    private Task<HttpResponseMessage> GerarLoteAsync(
        string token,
        Guid zonaId,
        string[] ruas,
        int moduloFinal,
        bool simular = false,
        bool ignorarExistentes = false) =>
        SendAsync(token, HttpMethod.Post, "/api/v1/enderecos/lote", new
        {
            zonaId,
            ruas,
            moduloInicial = 1,
            moduloFinal,
            nivelInicial = 1,
            nivelFinal = 2,
            posicaoInicial = 1,
            posicaoFinal = 1,
            capacidadePesoKg = 1000,
            alturaCm = 150,
            larguraCm = 120,
            profundidadeCm = 100,
            distanciaBase = 4,
            distanciaPorModulo = 2,
            simular,
            ignorarExistentes,
        });

    private async Task<string> LoginAsync()
    {
        var response = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
    }

    private async Task<ArmazemDetalhe> CreateArmazemAsync(string token, string codigo, string nome)
    {
        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/armazens", new { codigo, nome });
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<ArmazemDetalhe>(Json))!;
    }

    private async Task<ArmazemDetalhe> AddZonaAsync(string token, Guid armazemId, string codigo, string classe)
    {
        var response = await SendAsync(token, HttpMethod.Post, $"/api/v1/armazens/{armazemId}/zonas", new { codigo, classeArmazenagem = classe });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<ArmazemDetalhe>(Json))!;
    }

    private async Task<EnderecoDetalhe> CreateEnderecoAsync(string token, Guid zonaId, string rua, int modulo)
    {
        var response = await SendAsync(token, HttpMethod.Post, "/api/v1/enderecos", EnderecoBody(zonaId, rua, modulo));
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<EnderecoDetalhe>(Json))!;
    }

    private static object EnderecoBody(Guid zonaId, string rua, int modulo) => new
    {
        zonaId,
        rua,
        modulo,
        nivel = 2,
        posicao = 1,
        capacidadePesoKg = 1000,
        alturaCm = 150,
        larguraCm = 120,
        profundidadeCm = 100,
        distanciaExpedicao = modulo * 4,
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
