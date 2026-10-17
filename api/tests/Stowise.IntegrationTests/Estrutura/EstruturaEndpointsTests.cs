using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Http;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Estrutura;

/// <summary>Autorização e validação da estrutura física, aplicadas antes de consultar o banco.</summary>
public class EstruturaEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Theory]
    [InlineData("/api/v1/armazens")]
    [InlineData("/api/v1/enderecos")]
    public async Task Writes_require_admin_or_gestor(string url)
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync(url, new { });

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Fact]
    public async Task Invalid_endereco_returns_field_errors()
    {
        using var client = ClientWith(Perfis.Gestor);

        var response = await client.PostAsJsonAsync("/api/v1/enderecos", new { rua = "A1", modulo = 0, nivel = 1, posicao = 1 });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problem = await response.Content.ReadFromJsonAsync<HttpValidationProblemDetails>();
        Assert.Equal(
            ["alturaCm", "capacidadePesoKg", "distanciaExpedicao", "larguraCm", "modulo", "profundidadeCm", "rua", "zonaId"],
            problem!.Errors.Keys.Order(StringComparer.Ordinal));
    }

    [Fact]
    public async Task Invalid_zona_returns_field_errors()
    {
        using var client = ClientWith(Perfis.Admin);

        var response = await client.PostAsJsonAsync($"/api/v1/armazens/{Guid.NewGuid()}/zonas", new { codigo = "" });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }

    private HttpClient ClientWith(string perfil)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(perfil));
        return client;
    }
}
