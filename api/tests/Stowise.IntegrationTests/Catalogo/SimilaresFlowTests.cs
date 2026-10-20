using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Stowise.Api.Endpoints;
using Stowise.Application.Catalogo;
using Stowise.Infrastructure.Catalogo;
using Stowise.Infrastructure.Ia;
using Stowise.IntegrationTests.Ia;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Catalogo;

/// <summary>Busca de similares contra o PostgreSQL (ADR-0011): trigramas sem IA, embeddings com o job e o modelo ligados.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class SimilaresFlowTests : IDisposable
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;

    public SimilaresFlowTests(PostgresFixture postgres)
    {
        _factory = StowiseApiFactory.WithDatabase(postgres, AdminEmail, AdminPassword);
    }

    public void Dispose() => _factory.Dispose();

    [DockerFact]
    public async Task Without_embeddings_the_search_uses_trigrams()
    {
        using var client = _factory.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });
        var token = await LoginAsync(client);
        await CreateProdutosAsync(client, token);

        var similares = await BuscarAsync(client, token, "REFRIGERANTE COLA 2 LITROS");

        Assert.Equal(MetodoSimilaridade.Trigramas, similares.Metodo);
        Assert.Equal("COLA-2L", similares.Produtos[0].Sku);
        Assert.InRange(similares.Produtos[0].Pontuacao, BuscaProdutosSimilares.TrigramaMinimo, 1);
    }

    [DockerFact]
    public async Task With_embeddings_the_job_fills_the_vectors_and_the_search_is_semantic()
    {
        var registro = new RegistroEmMemoria();
        using var comEmbeddings = _factory.WithWebHostBuilder(builder => builder.ConfigureTestServices(services =>
            services.AddSingleton(new GeradorEmbeddings(
                new FakeEmbeddingGenerator(),
                new EmbeddingsIaOptions { Habilitado = true, Tipo = "Ollama", Modelo = "fake" },
                registro,
                TimeProvider.System,
                NullLogger<GeradorEmbeddings>.Instance))));
        using var client = comEmbeddings.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });
        var token = await LoginAsync(client);
        await CreateProdutosAsync(client, token);

        using (var scope = comEmbeddings.Services.CreateScope())
        {
            var job = scope.ServiceProvider.GetRequiredService<EmbeddingsJobs>();
            Assert.Equal(3, await job.AtualizarAsync(CancellationToken.None));

            // Idempotente: sem mudança, a próxima rodada não gera nada.
            Assert.Equal(0, await job.AtualizarAsync(CancellationToken.None));
        }

        // A abreviação da nota não tem trigramas suficientes, mas a palavra-chave aproxima os vetores.
        var similares = await BuscarAsync(client, token, "REFRIG COLA CX12");

        Assert.Equal(MetodoSimilaridade.Semantica, similares.Metodo);
        Assert.Equal("COLA-2L", similares.Produtos[0].Sku);
        Assert.True(similares.Produtos[0].Pontuacao > similares.Produtos[1].Pontuacao);
    }

    private static async Task<ProdutosSimilares> BuscarAsync(HttpClient client, string token, string texto)
    {
        using var request = new HttpRequestMessage(HttpMethod.Get, $"/api/v1/produtos/similares?texto={Uri.EscapeDataString(texto)}&limite=3");
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
        var response = await client.SendAsync(request);
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<ProdutosSimilares>(Json))!;
    }

    private static async Task CreateProdutosAsync(HttpClient client, string token)
    {
        foreach (var (sku, descricao) in new[]
        {
            ("COLA-2L", "Refrigerante Cola 2L"),
            ("AGUA-500", "Água mineral sem gás 500ml"),
            ("COPO-200", "Copo descartável 200ml"),
        })
        {
            using var request = new HttpRequestMessage(HttpMethod.Post, "/api/v1/produtos")
            {
                Content = JsonContent.Create(new { sku, descricao, unidadeBase = "UN", classeArmazenagem = "Normal" }),
            };
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
            Assert.Equal(HttpStatusCode.Created, (await client.SendAsync(request)).StatusCode);
        }
    }

    private static async Task<string> LoginAsync(HttpClient client)
    {
        var response = await client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
    }
}
