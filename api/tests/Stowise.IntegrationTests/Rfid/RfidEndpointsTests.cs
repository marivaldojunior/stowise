using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Rfid;

/// <summary>Autorização e validação dos endpoints de RFID, aplicadas antes de consultar o banco.</summary>
public class RfidEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Theory]
    [InlineData("/api/v1/rfid/leituras")]
    [InlineData("/api/v1/rfid/etiquetas")]
    public async Task Anonymous_cannot_use_rfid(string url)
    {
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync(url, new { });

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task Empty_batch_of_readings_is_rejected()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync("/api/v1/rfid/leituras", new { epcs = new[] { " ", "" } });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problema = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.Contains("epcs", problema!.Errors.Keys);
    }

    [Fact]
    public async Task Too_many_readings_are_rejected()
    {
        using var client = ClientWith(Perfis.Operador);
        var epcs = Enumerable.Range(0, 1001).Select(i => i.ToString("X24", System.Globalization.CultureInfo.InvariantCulture));

        var response = await client.PostAsJsonAsync("/api/v1/rfid/leituras", new { epcs });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Fact]
    public async Task Tag_generation_validates_package_quantity_and_prefix()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync("/api/v1/rfid/etiquetas", new { quantidade = 501, tamanhoPrefixoEmpresa = 5 });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problema = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.Equal(["embalagemId", "quantidade", "tamanhoPrefixoEmpresa"], problema!.Errors.Keys.Order());
    }

    private HttpClient ClientWith(string perfil)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(perfil));
        return client;
    }
}
