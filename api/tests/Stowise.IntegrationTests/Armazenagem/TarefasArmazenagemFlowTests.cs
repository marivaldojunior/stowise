using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Api.Endpoints;
using Stowise.Application.Armazenagem;
using Stowise.Application.Common;
using Stowise.Application.Estrutura;
using Stowise.Application.NotasFiscais;
using Stowise.Application.Recebimentos;
using Stowise.Domain.Armazenagem;
using Stowise.Infrastructure.Persistence;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Armazenagem;

/// <summary>
/// NF-e de exemplo → conferência → tarefas de armazenagem → entrada no estoque, contra o PostgreSQL. Os produtos
/// novos são classe C e sem medidas: a capacidade não se aplica, e a curva ABC leva ao A-02, longe da expedição.
/// </summary>
[Collection(PostgresTestGroup.Name)]
public sealed class TarefasArmazenagemFlowTests : IAsyncLifetime
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;
    private string _token = null!;
    private readonly Dictionary<string, Guid> _enderecos = [];

    public TarefasArmazenagemFlowTests(PostgresFixture postgres)
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
        _token = (await login.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;

        var armazem = await SendAsync<ArmazemDetalhe>(HttpMethod.Post, "/api/v1/armazens", new { codigo = "CD04", nome = "Centro Leste" });
        await SendAsync<ArmazemDetalhe>(HttpMethod.Post, $"/api/v1/armazens/{armazem.Id}/zonas", new { codigo = "SECO", classeArmazenagem = "Normal" });
        armazem = await SendAsync<ArmazemDetalhe>(HttpMethod.Post, $"/api/v1/armazens/{armazem.Id}/zonas", new { codigo = "INFL", classeArmazenagem = "Inflamavel" });
        await EnderecoAsync(armazem.Zonas.Single(z => z.Codigo == "SECO").Id, "A", 1, distancia: 4);
        await EnderecoAsync(armazem.Zonas.Single(z => z.Codigo == "SECO").Id, "A", 2, distancia: 30);
        await EnderecoAsync(armazem.Zonas.Single(z => z.Codigo == "INFL").Id, "F", 1, distancia: 2);
    }

    public Task DisposeAsync()
    {
        _client.Dispose();
        _factory.Dispose();
        return Task.CompletedTask;
    }

    [DockerFact]
    public async Task Checked_receipt_becomes_tasks_and_confirmation_enters_the_stock_once()
    {
        var recebimentoId = await ConferirNotaAsync();

        var lista = await SendAsync<PagedResult<TarefaArmazenagemResumo>>(HttpMethod.Get, $"/api/v1/armazenagem/tarefas?recebimentoId={recebimentoId}&status=Pendente");
        Assert.Equal(2, lista.Total);
        var cola = lista.Itens.Single(t => t.LoteNumero == "L2610A");
        var copos = lista.Itens.Single(t => t.LoteNumero is null);
        Assert.Equal(120m, cola.Quantidade);
        Assert.Equal(1234, cola.NumeroNota);
        Assert.Equal("A-02-01-1", cola.EnderecoSugerido);
        Assert.Equal("A-02-01-1", copos.EnderecoSugerido);

        // A carga planejada da cola conta para os copos: o A-02 passa a ter "só outros produtos".
        var detalheCopos = await SendAsync<TarefaArmazenagemDetalhe>(HttpMethod.Get, $"/api/v1/armazenagem/tarefas/{copos.Id}");
        Assert.Equal(0m, detalheCopos.Notas.Single(n => n.Codigo == CodigosRegra.Consolidacao).Nota);
        Assert.Equal(5, detalheCopos.Notas.Count);

        var zonaErrada = await RawAsync(HttpMethod.Post, $"/api/v1/armazenagem/tarefas/{cola.Id}/confirmacao", new { enderecoId = _enderecos["F"], motivoDivergencia = "Mais perto" });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, zonaErrada.StatusCode);
        var semMotivo = await RawAsync(HttpMethod.Post, $"/api/v1/armazenagem/tarefas/{cola.Id}/confirmacao", new { enderecoId = _enderecos["A-01"] });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, semMotivo.StatusCode);
        Assert.Equal(0m, await SaldoAsync(cola.ProdutoId));

        var confirmada = await SendAsync<TarefaArmazenagemDetalhe>(HttpMethod.Post, $"/api/v1/armazenagem/tarefas/{cola.Id}/confirmacao", new { enderecoId = _enderecos["A-02"] });
        Assert.Equal(StatusTarefaArmazenagem.Concluida, confirmada.Tarefa.Status);
        Assert.Equal("A-02-01-1", confirmada.Tarefa.EnderecoConfirmado);
        Assert.NotNull(confirmada.MovimentacaoId);
        Assert.Equal(120m, await SaldoAsync(cola.ProdutoId));

        // A resposta se perdeu e o app repete: a entrada não duplica.
        var repetida = await SendAsync<TarefaArmazenagemDetalhe>(HttpMethod.Post, $"/api/v1/armazenagem/tarefas/{cola.Id}/confirmacao", new { enderecoId = _enderecos["A-02"] });
        Assert.Equal(confirmada.MovimentacaoId, repetida.MovimentacaoId);
        Assert.Equal(120m, await SaldoAsync(cola.ProdutoId));
        var outroEndereco = await RawAsync(HttpMethod.Post, $"/api/v1/armazenagem/tarefas/{cola.Id}/confirmacao", new { enderecoId = _enderecos["A-01"], motivoDivergencia = "x" });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, outroEndereco.StatusCode);

        var divergente = await SendAsync<TarefaArmazenagemDetalhe>(HttpMethod.Post, $"/api/v1/armazenagem/tarefas/{copos.Id}/confirmacao", new
        {
            enderecoId = _enderecos["A-01"],
            motivoDivergencia = "A-02 cheio de paletes de outro cliente",
        });
        Assert.Equal(StatusTarefaArmazenagem.Divergente, divergente.Tarefa.Status);
        Assert.Equal(400m, await SaldoAsync(copos.ProdutoId));

        var divergencias = await SendAsync<PagedResult<TarefaArmazenagemResumo>>(HttpMethod.Get, "/api/v1/armazenagem/tarefas?status=Divergente");
        Assert.Equal("A-02 cheio de paletes de outro cliente", Assert.Single(divergencias.Itens).MotivoDivergencia);
    }

    /// <summary>Efetiva a NF-e de exemplo e confere: 10 CX de cola (lote L2610A) e 4 de 5 pacotes de copos.</summary>
    private async Task<Guid> ConferirNotaAsync()
    {
        var xml = await File.ReadAllTextAsync(Path.Combine(AppContext.BaseDirectory, "NotasFiscais", "Exemplos", "nfe-autorizada.xml"));
        Guid recebimentoId;
        using (var scope = _factory.Services.CreateScope())
        {
            var resultado = await scope.ServiceProvider.GetRequiredService<IEfetivacaoNotaFiscal>().EfetivarAsync(
                new EfetivarNotaFiscal(xml,
                [
                    new DecisaoItemNota(1, AcaoItemNota.CriarProduto, NovoProduto: new NovoProdutoNota("COLA-2L", "Refrigerante Cola 2L", null, null)),
                    new DecisaoItemNota(2, AcaoItemNota.CriarProduto, NovoProduto: new NovoProdutoNota("COPO-200", "Copo descartável 200ml", null, null)),
                ]),
                Guid.CreateVersion7());
            Assert.True(resultado.IsSuccess, resultado.Error?.Message);
            recebimentoId = resultado.Value.RecebimentoId;
        }

        var recebimento = await SendAsync<RecebimentoDetalhe>(HttpMethod.Get, $"/api/v1/recebimentos/{recebimentoId}");
        var iniciado = await SendAsync<RecebimentoDetalhe>(HttpMethod.Post, $"/api/v1/recebimentos/{recebimentoId}/conferencia/inicio", new { versao = recebimento.Versao });
        await SendAsync<RecebimentoDetalhe>(HttpMethod.Put, $"/api/v1/recebimentos/{recebimentoId}/itens/{recebimento.Itens[0].Id}/conferencia", new
        {
            quantidade = 10,
            lotes = new[] { new { numero = "L2610A", quantidade = 10, validade = "2027-04-30" } },
        });
        await SendAsync<RecebimentoDetalhe>(HttpMethod.Put, $"/api/v1/recebimentos/{recebimentoId}/itens/{recebimento.Itens[1].Id}/conferencia", new { quantidade = 4 });
        await SendAsync<RecebimentoDetalhe>(HttpMethod.Post, $"/api/v1/recebimentos/{recebimentoId}/conferencia/conclusao", new { versao = iniciado.Versao });
        return recebimentoId;
    }

    private async Task<decimal> SaldoAsync(Guid produtoId)
    {
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
        return await db.Saldos.Where(s => s.ProdutoId == produtoId).SumAsync(s => s.Quantidade);
    }

    private async Task EnderecoAsync(Guid zonaId, string rua, int modulo, decimal distancia)
    {
        var endereco = await SendAsync<EnderecoDetalhe>(HttpMethod.Post, "/api/v1/enderecos", new
        {
            zonaId,
            rua,
            modulo,
            nivel = 1,
            posicao = 1,
            capacidadePesoKg = 1000,
            alturaCm = 150,
            larguraCm = 120,
            profundidadeCm = 100,
            distanciaExpedicao = distancia,
        });
        _enderecos[rua == "F" ? "F" : $"{rua}-{modulo:00}"] = endereco.Id;
    }

    private async Task<T> SendAsync<T>(HttpMethod method, string url, object? body = null)
    {
        var response = await RawAsync(method, url, body);
        Assert.True(response.IsSuccessStatusCode, $"{method} {url}: {(int)response.StatusCode} {await response.Content.ReadAsStringAsync()}");
        return (await response.Content.ReadFromJsonAsync<T>(Json))!;
    }

    private async Task<HttpResponseMessage> RawAsync(HttpMethod method, string url, object? body = null)
    {
        using var request = new HttpRequestMessage(method, url);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", _token);
        if (body is not null)
        {
            request.Content = JsonContent.Create(body);
        }

        return await _client.SendAsync(request);
    }
}
