using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Http;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Catalogo;

/// <summary>Autorização e validação do catálogo, aplicadas antes de consultar o banco.</summary>
public class CatalogoEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Theory]
    [InlineData("/api/v1/produtos")]
    [InlineData("/api/v1/categorias")]
    public async Task Writes_require_admin_or_gestor(string url)
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync(url, new { });

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Fact]
    public async Task Anonymous_cannot_read_the_catalog()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/api/v1/produtos", UriKind.Relative));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Theory]
    [InlineData(Perfis.Gestor)]
    [InlineData(Perfis.Admin)]
    public async Task Invalid_product_returns_field_errors_for_gestao(string perfil)
    {
        using var client = ClientWith(perfil);

        var response = await client.PostAsJsonAsync("/api/v1/produtos", new
        {
            sku = "sku inválido",
            descricao = "",
            unidadeBase = "UN",
            classeArmazenagem = "Refrigerado",
            controlaValidade = true,
            embalagemBase = new { gtin = "7891000315508" },
        });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problem = await response.Content.ReadFromJsonAsync<HttpValidationProblemDetails>();
        Assert.Equal(
            ["controlaValidade", "descricao", "embalagemBase.gtin", "sku"],
            problem!.Errors.Keys.Order(StringComparer.Ordinal));
    }

    [Fact]
    public async Task Unknown_enum_value_is_a_bad_request()
    {
        using var client = ClientWith(Perfis.Gestor);

        var response = await client.PostAsJsonAsync("/api/v1/produtos", new
        {
            sku = "SKU1",
            descricao = "Produto",
            unidadeBase = "UN",
            classeArmazenagem = "Radioativo",
        });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Theory]
    [InlineData("/api/v1/produtos/similares", "texto")]
    [InlineData("/api/v1/produtos/similares?texto=cola&limite=21", "limite")]
    public async Task Similar_search_validates_text_and_limit(string url, string campo)
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.GetAsync(new Uri(url, UriKind.Relative));

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problema = await response.Content.ReadFromJsonAsync<Microsoft.AspNetCore.Mvc.ValidationProblemDetails>();
        Assert.Contains(campo, problema!.Errors.Keys);
    }

    private HttpClient ClientWith(string perfil)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(perfil));
        return client;
    }
}
