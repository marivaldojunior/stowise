using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Api.Endpoints;
using Stowise.Application.Common;
using Stowise.Application.Importacoes;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Persistence;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Importacoes;

/// <summary>Envio de arquivos contra o PostgreSQL: layout em <c>jsonb</c>, arquivo original e bloqueio de duplicata.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class ImportacoesFlowTests : IAsyncLifetime
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;

    public ImportacoesFlowTests(PostgresFixture postgres)
    {
        _factory = StowiseApiFactory.WithDatabase(postgres, AdminEmail, AdminPassword);
        _client = _factory.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });
    }

    public async Task InitializeAsync()
    {
        if (!DockerEnvironment.IsAvailable && !DockerEnvironment.IsRequired)
        {
            return;
        }

        var login = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        var token = (await login.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    }

    public Task DisposeAsync()
    {
        _client.Dispose();
        _factory.Dispose();
        return Task.CompletedTask;
    }

    [DockerFact]
    public async Task Csv_upload_stores_the_layout_and_the_original_file_once()
    {
        var conteudo = Encoding.UTF8.GetBytes("SKU;Descrição;Preço\nCAN-01;Caneta azul;1,50\nLAP-02;Lápis preto;0,75\n");

        var response = await UploadAsync("produtos.csv", conteudo);

        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        var criada = (await response.Content.ReadFromJsonAsync<ImportacaoDetalhe>(Json))!;
        Assert.EndsWith($"/api/v1/importacoes/{criada.Id}", response.Headers.Location!.ToString(), StringComparison.Ordinal);
        Assert.Equal(StatusImportacao.Recebido, criada.Status);
        Assert.Equal(TipoImportacao.Produtos, criada.Tipo);
        Assert.Equal(2, criada.TotalLinhas);

        var lida = (await _client.GetFromJsonAsync<ImportacaoDetalhe>($"/api/v1/importacoes/{criada.Id}", Json))!;
        Assert.Equal((FormatoArquivo.Delimitado, ";", ","), (lida.Layout.Formato, lida.Layout.Delimitador, lida.Layout.SeparadorDecimal));
        Assert.Equal(["SKU", "Descrição", "Preço"], lida.Layout.Colunas.Select(c => c.Nome));
        Assert.Equal(["LAP-02", "Lápis preto", "0,75"], lida.Amostra[1]);

        var lista = (await _client.GetFromJsonAsync<PagedResult<ImportacaoResumo>>("/api/v1/importacoes?tipo=Produtos", Json))!;
        Assert.Equal(criada.Id, Assert.Single(lista.Itens).Id);

        var original = await QueryAsync(db => db.ArquivosImportacao.SingleAsync(a => a.ImportacaoId == criada.Id));
        Assert.Equal(conteudo, original.Conteudo);

        var repetida = await UploadAsync("copia.csv", conteudo);
        Assert.Equal(HttpStatusCode.Conflict, repetida.StatusCode);
        Assert.Equal(1, await QueryAsync(db => db.Importacoes.CountAsync()));
    }

    [DockerFact]
    public async Task Positional_windows_1252_file_keeps_column_positions_after_reading_back()
    {
        var texto = string.Join("\r\n", [
            $"{"CODIGO",-8}{"DESCRICAO",-20}{"PRECO",8}",
            $"{"A1",-8}{"PÃO DE AÇÚCAR",-20}{"4,99",8}",
            $"{"A2",-8}{"CAFÉ",-20}{"12,50",8}",
        ]);
        var conteudo = CodePagesEncodingProvider.Instance.GetEncoding(1252)!.GetBytes(texto);

        var response = await UploadAsync("produtos.txt", conteudo);

        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        var id = (await response.Content.ReadFromJsonAsync<ImportacaoDetalhe>(Json))!.Id;
        var lida = (await _client.GetFromJsonAsync<ImportacaoDetalhe>($"/api/v1/importacoes/{id}", Json))!;
        Assert.Equal((FormatoArquivo.Posicional, "windows-1252", ","), (lida.Layout.Formato, lida.Layout.Encoding, lida.Layout.SeparadorDecimal));
        Assert.Equal(
            [new ColunaArquivo(0, "CODIGO", 0, 8), new ColunaArquivo(1, "DESCRICAO", 8, 23), new ColunaArquivo(2, "PRECO", 31, 5)],
            lida.Layout.Colunas);
        Assert.Equal(["A1", "PÃO DE AÇÚCAR", "4,99"], lida.Amostra[0]);
    }

    [DockerFact]
    public async Task Unknown_import_is_not_found()
    {
        var response = await _client.GetAsync(new Uri($"/api/v1/importacoes/{Guid.NewGuid()}", UriKind.Relative));

        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    private Task<HttpResponseMessage> UploadAsync(string nome, byte[] conteudo) =>
        _client.PostAsync(new Uri("/api/v1/importacoes/produtos", UriKind.Relative), ImportacoesEndpointsTests.Arquivo(nome, conteudo));

    private async Task<T> QueryAsync<T>(Func<StowiseDbContext, Task<T>> query)
    {
        await using var scope = _factory.Services.CreateAsyncScope();
        return await query(scope.ServiceProvider.GetRequiredService<StowiseDbContext>());
    }
}
