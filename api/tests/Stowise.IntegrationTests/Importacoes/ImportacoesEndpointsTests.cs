using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Http;
using Stowise.Application.Auth;
using Stowise.Application.Importacoes;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Importacoes;

/// <summary>Autorização e recusa de arquivos, aplicadas antes de consultar o banco.</summary>
public class ImportacoesEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    private const string Url = "/api/v1/importacoes/produtos";

    [Fact]
    public async Task Anonymous_cannot_upload()
    {
        using var client = factory.CreateClient();

        var response = await client.PostAsync(new Uri(Url, UriKind.Relative), Arquivo("a.csv", [0x41]));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Theory]
    [InlineData("/api/v1/importacoes")]
    [InlineData(Url)]
    public async Task Operador_cannot_import(string url)
    {
        using var client = ClientWith(Perfis.Operador);

        var response = url == Url
            ? await client.PostAsync(new Uri(url, UriKind.Relative), Arquivo("a.csv", [0x41]))
            : await client.GetAsync(new Uri(url, UriKind.Relative));

        Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
    }

    [Fact]
    public async Task Request_without_a_file_is_a_validation_error()
    {
        using var client = ClientWith(Perfis.Gestor);
        using var form = new MultipartFormDataContent { { new StringContent("x"), "outro" } };

        var response = await client.PostAsync(new Uri(Url, UriKind.Relative), form);

        await AssertArquivoInvalidoAsync(response, "Envie um arquivo.");
    }

    [Fact]
    public async Task Excel_file_is_refused_with_a_hint()
    {
        using var client = ClientWith(Perfis.Gestor);

        var response = await client.PostAsync(new Uri(Url, UriKind.Relative), Arquivo("produtos.xlsx", [0x50, 0x4B, 0x03, 0x04, 0x14, 0x00]));

        await AssertArquivoInvalidoAsync(response, "Arquivos Excel ainda não são aceitos. Salve a planilha como CSV e envie de novo.");
    }

    [Fact]
    public async Task File_above_the_limit_is_refused_before_reading()
    {
        using var client = ClientWith(Perfis.Gestor);

        var response = await client.PostAsync(
            new Uri(Url, UriKind.Relative),
            Arquivo("grande.csv", new byte[ImportacaoValidation.TamanhoMaximoBytes + 1]));

        await AssertArquivoInvalidoAsync(response, ImportacaoValidation.MensagemTamanhoMaximo);
    }

    internal static MultipartFormDataContent Arquivo(string nome, byte[] conteudo)
    {
        var arquivo = new ByteArrayContent(conteudo);
        arquivo.Headers.ContentType = new MediaTypeHeaderValue("text/csv");
        return new MultipartFormDataContent { { arquivo, "arquivo", nome } };
    }

    private static async Task AssertArquivoInvalidoAsync(HttpResponseMessage response, string mensagem)
    {
        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problem = await response.Content.ReadFromJsonAsync<HttpValidationProblemDetails>();
        var erro = Assert.Single(problem!.Errors);
        Assert.Equal(("arquivo", mensagem), (erro.Key, erro.Value.Single()));
    }

    private HttpClient ClientWith(string perfil)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(perfil));
        return client;
    }
}
