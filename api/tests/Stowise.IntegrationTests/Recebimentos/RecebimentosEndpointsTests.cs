using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Recebimentos;

/// <summary>Autorização e validação da conferência, aplicadas antes de consultar o banco.</summary>
public class RecebimentosEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    private static readonly Guid Id = Guid.CreateVersion7();

    [Fact]
    public async Task Anonymous_cannot_list_receipts()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/api/v1/recebimentos", UriKind.Relative));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Theory]
    [InlineData("inicio")]
    [InlineData("conclusao")]
    public async Task Status_changes_need_the_version(string acao)
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync($"/api/v1/recebimentos/{Id}/conferencia/{acao}", new { });

        await AssertValidacaoAsync(response, "versao");
    }

    [Fact]
    public async Task Item_count_needs_the_quantity()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PutAsJsonAsync($"/api/v1/recebimentos/{Id}/itens/{Guid.CreateVersion7()}/conferencia", new { lotes = Array.Empty<object>() });

        await AssertValidacaoAsync(response, "quantidade");
    }

    private static async Task AssertValidacaoAsync(HttpResponseMessage response, string campo)
    {
        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problema = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.Contains(campo, problema!.Errors.Keys);
    }

    private HttpClient ClientWith(string perfil)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(perfil));
        return client;
    }
}
