using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Fornecedores;

/// <summary>Autorização e validação dos fornecedores, aplicadas antes de consultar o banco.</summary>
public class FornecedoresEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    private static readonly Guid FornecedorId = Guid.CreateVersion7();

    [Fact]
    public async Task Anonymous_cannot_read_suppliers()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/api/v1/fornecedores", UriKind.Relative));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Theory]
    [InlineData("/api/v1/fornecedores")]
    [InlineData("/api/v1/fornecedores/{0}/produtos")]
    public async Task Writes_require_admin_or_gestor(string url)
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync(string.Format(System.Globalization.CultureInfo.InvariantCulture, url, FornecedorId), new { });

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Fact]
    public async Task Invalid_supplier_returns_field_errors()
    {
        using var client = ClientWith(Perfis.Gestor);

        var response = await client.PostAsJsonAsync("/api/v1/fornecedores", new { cnpj = "11.222.333/0001-82", razaoSocial = " " });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problema = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.Equal(["cnpj", "razaoSocial"], problema!.Errors.Keys.Order());
    }

    [Fact]
    public async Task Invalid_link_returns_field_errors()
    {
        using var client = ClientWith(Perfis.Admin);

        var response = await client.PostAsJsonAsync($"/api/v1/fornecedores/{FornecedorId}/produtos", new { codigoFornecedor = "ABC", fatorConversao = 0 });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problema = await response.Content.ReadFromJsonAsync<ValidationProblemDetails>();
        Assert.Equal(["embalagemId", "fatorConversao", "produtoId", "unidadeFornecedor"], problema!.Errors.Keys.Order());
    }

    private HttpClient ClientWith(string perfil)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(perfil));
        return client;
    }
}
