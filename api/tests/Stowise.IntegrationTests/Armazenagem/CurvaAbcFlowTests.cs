using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Api.Endpoints;
using Stowise.Application.Armazenagem;
using Stowise.Application.Catalogo;
using Stowise.Application.Estrutura;
using Stowise.Domain.Catalogo;
using Stowise.Infrastructure.Persistence;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Armazenagem;

/// <summary>Recálculo da curva ABC contra o PostgreSQL, pelas saídas do livro-razão.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class CurvaAbcFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;
    private string _token = null!;

    public CurvaAbcFlowTests(PostgresFixture postgres)
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
    public async Task Products_are_classified_by_the_number_of_exits()
    {
        var login = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        _token = (await login.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;

        var armazem = await SendAsync<ArmazemDetalhe>("/api/v1/armazens", new { codigo = "CD05", nome = "Centro Oeste" });
        armazem = await SendAsync<ArmazemDetalhe>($"/api/v1/armazens/{armazem.Id}/zonas", new { codigo = "SECO", classeArmazenagem = "Normal" });
        var endereco = await SendAsync<EnderecoDetalhe>("/api/v1/enderecos", new
        {
            zonaId = armazem.Zonas.Single().Id,
            rua = "A",
            modulo = 1,
            nivel = 1,
            posicao = 1,
            capacidadePesoKg = 1000,
            alturaCm = 150,
            larguraCm = 120,
            profundidadeCm = 100,
            distanciaExpedicao = 4,
        });

        // Saídas: 8 do giro rápido, 2 do médio, nenhuma do parado (total 10).
        var rapido = await ProdutoComSaidasAsync("GIRO-RAPIDO", endereco.Id, 8);
        var medio = await ProdutoComSaidasAsync("GIRO-MEDIO", endereco.Id, 2);
        var parado = await ProdutoComSaidasAsync("PARADO", endereco.Id, 0);

        var resumo = await SendAsync<ResumoCurvaAbc>("/api/v1/armazenagem/curva-abc", null);
        Assert.Equal((1, 1, 1), (resumo.ClasseA, resumo.ClasseB, resumo.ClasseC));
        Assert.Equal(2, resumo.Alterados);
        Assert.Equal(ClasseAbc.A, await ClasseAsync(rapido));
        Assert.Equal(ClasseAbc.B, await ClasseAsync(medio));
        Assert.Equal(ClasseAbc.C, await ClasseAsync(parado));

        // Sem saídas novas, nada muda.
        Assert.Equal(0, (await SendAsync<ResumoCurvaAbc>("/api/v1/armazenagem/curva-abc", null)).Alterados);
    }

    private async Task<Guid> ProdutoComSaidasAsync(string sku, Guid enderecoId, int saidas)
    {
        var produto = await SendAsync<ProdutoDetalhe>("/api/v1/produtos", new { sku, descricao = sku, unidadeBase = "UN", classeArmazenagem = "Normal" });
        await SendAsync<object>("/api/v1/movimentacoes/entradas", new { produtoId = produto.Id, enderecoId, quantidade = 100 });
        for (var i = 0; i < saidas; i++)
        {
            await SendAsync<object>("/api/v1/movimentacoes/saidas", new { produtoId = produto.Id, enderecoId, quantidade = 1 });
        }

        return produto.Id;
    }

    private async Task<ClasseAbc> ClasseAsync(Guid produtoId)
    {
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
        return await db.Produtos.Where(p => p.Id == produtoId).Select(p => p.ClasseAbc).SingleAsync();
    }

    private async Task<T> SendAsync<T>(string url, object? body)
    {
        using var request = new HttpRequestMessage(HttpMethod.Post, url);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", _token);
        if (body is not null)
        {
            request.Content = JsonContent.Create(body);
        }

        var response = await _client.SendAsync(request);
        Assert.True(response.IsSuccessStatusCode, $"POST {url}: {(int)response.StatusCode} {await response.Content.ReadAsStringAsync()}");
        Assert.NotEqual(HttpStatusCode.NoContent, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<T>(Json))!;
    }
}
