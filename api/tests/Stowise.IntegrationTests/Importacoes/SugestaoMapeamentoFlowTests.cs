using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Api.Endpoints;
using Stowise.Application.Common;
using Stowise.Application.Importacoes;
using Stowise.Domain.Ia;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Ia;
using Stowise.Infrastructure.Persistence;
using Stowise.IntegrationTests.Ia;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Importacoes;

/// <summary>Sugestão de mapeamento pela IA de ponta a ponta: upload, job, revisão, confirmação e regras no staging.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class SugestaoMapeamentoFlowTests : IAsyncLifetime
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _base;
    private readonly FakeChatClient _ia = FakeChatClient.Responding(SugestaoMapeamentoIaTests.RespostaValida);
    private readonly WebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public SugestaoMapeamentoFlowTests(PostgresFixture postgres)
    {
        _base = StowiseApiFactory.WithDatabase(postgres, AdminEmail, AdminPassword, jobs: true);
        _factory = _base.WithWebHostBuilder(b => b.ConfigureTestServices(s => s.AddSingleton<IProvedoresIa>(FakeProvedoresIa.With(_ia))));
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

    public async Task DisposeAsync()
    {
        _client.Dispose();
        await _factory.DisposeAsync();
        await _base.DisposeAsync();
    }

    [DockerFact]
    public async Task New_file_gets_an_ai_suggestion_that_a_person_confirms_and_the_rules_reach_the_staging()
    {
        var conteudo = Encoding.UTF8.GetBytes("SKU;Descrição;Unidade;Lote\nA1;Arroz 5kg;Saco;Ativo\nB2;Feijão 1kg;UN;Inativo\n");
        var upload = await _client.PostAsync(new Uri("/api/v1/importacoes/produtos", UriKind.Relative), ImportacoesEndpointsTests.Arquivo("novo.csv", conteudo));
        Assert.Equal(HttpStatusCode.Created, upload.StatusCode);
        var recebida = (await upload.Content.ReadFromJsonAsync<ImportacaoDetalhe>(Json))!;
        Assert.Equal(StatusImportacao.Mapeando, recebida.Status);

        var proposta = await WaitForStatusAsync(recebida.Id, s => s != StatusImportacao.Mapeando);
        Assert.Equal(StatusImportacao.AguardandoConfirmacao, proposta.Status);
        Assert.True(proposta.MapeamentoSugeridoPorIa);
        Assert.Equal(["sku", "descricao", "unidadeBase", "controlaLote"], proposta.Mapeamento!.Select(m => m.Campo));
        Assert.Equal(0.98m, proposta.SugestaoIa!.Colunas[0].Confianca);
        Assert.Equal(new UnidadeDePara("Saco", "SC"), Assert.Single(proposta.Regras!.Unidades));
        Assert.Contains("[\"A1\",\"Arroz 5kg\",\"Saco\",\"Ativo\"]", _ia.Recebidas.Single().Mensagens[1].Text, StringComparison.Ordinal);

        // A pessoa confirma a proposta como está (sem mandar regras: valem as sugeridas que ela viu).
        var confirmacao = await _client.PutAsJsonAsync($"/api/v1/importacoes/{proposta.Id}/mapeamento", new
        {
            colunas = proposta.Mapeamento,
            salvarTemplate = true,
            versao = proposta.Versao,
        });
        Assert.Equal(HttpStatusCode.Accepted, confirmacao.StatusCode);
        var revisao = await WaitForStatusAsync(proposta.Id, s => s != StatusImportacao.Validando);
        Assert.Equal((StatusImportacao.AguardandoRevisao, 2, 0), (revisao.Status, revisao.LinhasValidas, revisao.LinhasComErro));

        var linhas = (await _client.GetFromJsonAsync<PagedResult<ImportacaoLinhaDetalhe>>($"/api/v1/importacoes/{proposta.Id}/linhas", Json))!.Itens;
        Assert.Equal(("SC", "true"), (linhas[0].DadosNormalizados["unidadeBase"], linhas[0].DadosNormalizados["controlaLote"]));
        Assert.Equal(("UN", "false"), (linhas[1].DadosNormalizados["unidadeBase"], linhas[1].DadosNormalizados["controlaLote"]));

        var template = (await _client.GetFromJsonAsync<TemplateDetalhe>($"/api/v1/importacoes/templates/{revisao.TemplateId}", Json))!;
        Assert.True(template.SugeridoPorIa);
        Assert.Equal(new UnidadeDePara("Saco", "SC"), Assert.Single(template.Regras.Unidades));

        var deNovo = await _client.PostAsJsonAsync($"/api/v1/importacoes/{proposta.Id}/sugestao", new { versao = revisao.Versao });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, deNovo.StatusCode);

        await using var scope = _factory.Services.CreateAsyncScope();
        var chamada = await scope.ServiceProvider.GetRequiredService<StowiseDbContext>().ChamadasIa.SingleAsync();
        Assert.Equal((FuncionalidadeIa.Mapeamento, "mapeamento-v1", true), (chamada.Funcionalidade, chamada.PromptVersao, chamada.Sucesso));
    }

    private async Task<ImportacaoDetalhe> WaitForStatusAsync(Guid id, Func<StatusImportacao, bool> condicao)
    {
        var limite = DateTime.UtcNow.AddSeconds(60);
        while (true)
        {
            var atual = (await _client.GetFromJsonAsync<ImportacaoDetalhe>($"/api/v1/importacoes/{id}", Json))!;
            if (condicao(atual.Status))
            {
                return atual;
            }

            Assert.True(DateTime.UtcNow < limite, $"A importação {id} ficou em {atual.Status}.");
            await Task.Delay(200);
        }
    }
}
