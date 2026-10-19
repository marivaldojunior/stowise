using System.Net;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Web;

/// <summary>O painel React servido pela API (imagem de demonstração), sem misturar com as rotas da API.</summary>
public sealed class PainelWebTests : IDisposable
{
    private const string Index = "<!doctype html><title>Stowise</title><div id=\"root\"></div>";

    private readonly string _wwwroot = Directory.CreateTempSubdirectory("stowise-wwwroot-").FullName;
    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public PainelWebTests()
    {
        File.WriteAllText(Path.Combine(_wwwroot, "index.html"), Index);
        Directory.CreateDirectory(Path.Combine(_wwwroot, "assets"));
        File.WriteAllText(Path.Combine(_wwwroot, "assets", "app-3f9a.js"), "console.log('stowise')");
        _factory = new StowiseApiFactory { Settings = { ["webroot"] = _wwwroot } };
        _client = _factory.CreateClient();
    }

    public void Dispose()
    {
        _client.Dispose();
        _factory.Dispose();
        Directory.Delete(_wwwroot, recursive: true);
    }

    [Theory]
    [InlineData("/")]
    [InlineData("/catalogo")]
    [InlineData("/catalogo/0192f5e0-0000-7000-8000-000000000001")]
    [InlineData("/estoque/extrato?produtoId=1")]
    public async Task Rotas_do_painel_devolvem_o_index_sem_cache(string rota)
    {
        var resposta = await _client.GetAsync(new Uri(rota, UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, resposta.StatusCode);
        Assert.Equal("text/html", resposta.Content.Headers.ContentType?.MediaType);
        Assert.Equal(Index, await resposta.Content.ReadAsStringAsync());
        Assert.True(resposta.Headers.CacheControl?.NoCache);
    }

    [Fact]
    public async Task Arquivos_com_hash_ficam_em_cache_por_um_ano()
    {
        var resposta = await _client.GetAsync(new Uri("/assets/app-3f9a.js", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, resposta.StatusCode);
        Assert.Equal("console.log('stowise')", await resposta.Content.ReadAsStringAsync());
        Assert.Equal(TimeSpan.FromDays(365), resposta.Headers.CacheControl?.MaxAge);
        Assert.Contains("immutable", resposta.Headers.CacheControl?.ToString(), StringComparison.Ordinal);
    }

    [Theory]
    [InlineData("/api/v1/rota-que-nao-existe")]
    [InlineData("/hubs/nao-existe")]
    [InlineData("/openapi/v2.json")]
    public async Task Rotas_desconhecidas_da_api_continuam_404(string rota)
    {
        var resposta = await _client.GetAsync(new Uri(rota, UriKind.Relative));

        Assert.Equal(HttpStatusCode.NotFound, resposta.StatusCode);
        Assert.NotEqual(Index, await resposta.Content.ReadAsStringAsync());
    }

    [Fact]
    public async Task A_api_continua_respondendo_e_exigindo_login()
    {
        var saude = await _client.GetAsync(new Uri("/health/live", UriKind.Relative));
        var protegida = await _client.GetAsync(new Uri("/api/v1/produtos", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, saude.StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, protegida.StatusCode);
    }

    [Fact]
    public async Task So_GET_recebe_o_painel()
    {
        var resposta = await _client.PostAsync(new Uri("/catalogo", UriKind.Relative), null);

        Assert.Equal(HttpStatusCode.NotFound, resposta.StatusCode);
    }

    [Fact]
    public async Task Sem_o_build_do_painel_nada_muda()
    {
        using var semPainel = new StowiseApiFactory();
        using var client = semPainel.CreateClient();

        var resposta = await client.GetAsync(new Uri("/catalogo", UriKind.Relative));

        Assert.NotEqual(HttpStatusCode.OK, resposta.StatusCode);
    }
}
