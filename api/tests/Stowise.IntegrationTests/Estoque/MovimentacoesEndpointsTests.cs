using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Http;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Estoque;

/// <summary>Autorização e validação das movimentações, aplicadas antes de consultar o banco.</summary>
public class MovimentacoesEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public async Task Anonymous_cannot_move_stock()
    {
        using var client = factory.CreateClient();

        var response = await client.PostAsJsonAsync("/api/v1/movimentacoes/entradas", new { });

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task Ajuste_requires_admin_or_gestor()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync("/api/v1/movimentacoes/ajustes", new { });

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Fact]
    public async Task Operador_reaches_entry_validation()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync("/api/v1/movimentacoes/entradas", new
        {
            quantidade = 0,
            ocorridoEm = DateTimeOffset.UtcNow.AddHours(2),
            lote = new { numero = "" },
        });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problem = await response.Content.ReadFromJsonAsync<HttpValidationProblemDetails>();
        Assert.Equal(
            ["enderecoId", "lote.numero", "ocorridoEm", "produtoId", "quantidade"],
            problem!.Errors.Keys.Order(StringComparer.Ordinal));
    }

    [Fact]
    public async Task Transfer_to_the_same_address_is_a_validation_error()
    {
        using var client = ClientWith(Perfis.Operador);
        var endereco = Guid.NewGuid();

        var response = await client.PostAsJsonAsync("/api/v1/movimentacoes/transferencias", new
        {
            produtoId = Guid.NewGuid(),
            enderecoOrigemId = endereco,
            enderecoDestinoId = endereco,
            quantidade = 1,
        });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problem = await response.Content.ReadFromJsonAsync<HttpValidationProblemDetails>();
        Assert.Equal(["enderecoDestinoId"], problem!.Errors.Keys);
    }

    [Fact]
    public async Task Reservation_needs_product_address_and_positive_quantity()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync("/api/v1/reservas", new { quantidade = 0 });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problem = await response.Content.ReadFromJsonAsync<HttpValidationProblemDetails>();
        Assert.Equal(["enderecoId", "produtoId", "quantidade"], problem!.Errors.Keys.Order(StringComparer.Ordinal));
    }

    private HttpClient ClientWith(string perfil)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(perfil));
        return client;
    }
}
