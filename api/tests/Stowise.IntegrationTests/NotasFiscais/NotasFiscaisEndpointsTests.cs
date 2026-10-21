using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.NotasFiscais;

/// <summary>Autorização e validação da análise da NF-e, aplicadas antes de consultar o banco.</summary>
public class NotasFiscaisEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    private const string Url = "/api/v1/notas-fiscais/analise";

    [Fact]
    public async Task Anonymous_cannot_analyze()
    {
        using var client = factory.CreateClient();

        var response = await client.PostAsync(new Uri(Url, UriKind.Relative), Arquivo("<NFe/>"));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task Operator_cannot_analyze()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsync(new Uri(Url, UriKind.Relative), Arquivo("<NFe/>"));

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Fact]
    public async Task Missing_file_is_rejected()
    {
        using var client = ClientWith(Perfis.Gestor);

        var response = await client.PostAsync(new Uri(Url, UriKind.Relative), new MultipartFormDataContent { { new StringContent("1"), "outro" } });

        await AssertValidacaoAsync(response, "arquivo");
    }

    [Fact]
    public async Task Invalid_xml_is_rejected_before_touching_the_database()
    {
        using var client = ClientWith(Perfis.Gestor);

        var response = await client.PostAsync(new Uri(Url, UriKind.Relative), Arquivo("<html>não é nota</html>"));

        await AssertValidacaoAsync(response, "xml");
    }

    [Fact]
    public async Task Operator_cannot_post_an_invoice()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.PostAsJsonAsync("/api/v1/notas-fiscais/efetivacao", new { xml = "<NFe/>", itens = Array.Empty<object>() });

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Theory]
    [InlineData(null)]
    [InlineData("<html>não é nota</html>")]
    public async Task Posting_needs_a_valid_invoice_xml(string? xml)
    {
        using var client = ClientWith(Perfis.Gestor);

        var response = await client.PostAsJsonAsync("/api/v1/notas-fiscais/efetivacao", new { xml, itens = Array.Empty<object>() });

        await AssertValidacaoAsync(response, "xml");
    }

    internal static MultipartFormDataContent Arquivo(string xml)
    {
        var conteudo = new ByteArrayContent(Encoding.UTF8.GetBytes(xml));
        conteudo.Headers.ContentType = new MediaTypeHeaderValue("application/xml");
        return new MultipartFormDataContent { { conteudo, "arquivo", "nota.xml" } };
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
