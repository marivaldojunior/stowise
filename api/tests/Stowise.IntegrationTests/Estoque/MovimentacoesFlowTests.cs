using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Api.Endpoints;
using Stowise.Application.Catalogo;
using Stowise.Application.Estoque;
using Stowise.Application.Estrutura;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;
using Stowise.Infrastructure.Persistence;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Estoque;

/// <summary>Movimentações contra o PostgreSQL: saldo, ocupação do endereço, lotes e regras de bloqueio.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class MovimentacoesFlowTests : IAsyncLifetime
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _factory;
    private readonly HttpClient _client;
    private string _token = null!;
    private EnderecoDetalhe _endereco = null!;
    private ProdutoDetalhe _refrigerante = null!;
    private ProdutoDetalhe _iogurte = null!;

    public MovimentacoesFlowTests(PostgresFixture postgres)
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

        var armazem = await PostAsync<ArmazemDetalhe>("/api/v1/armazens", new { codigo = "CD02", nome = "Centro Sul" });
        armazem = await PostAsync<ArmazemDetalhe>($"/api/v1/armazens/{armazem.Id}/zonas", new { codigo = "SECO", classeArmazenagem = "Normal" });
        _endereco = await PostAsync<EnderecoDetalhe>("/api/v1/enderecos", new
        {
            zonaId = armazem.Zonas.Single().Id,
            rua = "A",
            modulo = 1,
            nivel = 1,
            posicao = 1,
            capacidadePesoKg = 1000,
            alturaCm = 150,
            larguraCm = 120,
            profundidadeCm = 100,
            distanciaExpedicao = 4,
        });

        _refrigerante = await PostAsync<ProdutoDetalhe>("/api/v1/produtos", new
        {
            sku = "COLA-2L",
            descricao = "Refrigerante Cola 2L",
            unidadeBase = "UN",
            classeArmazenagem = "Normal",
        });
        _refrigerante = await PostAsync<ProdutoDetalhe>($"/api/v1/produtos/{_refrigerante.Id}/embalagens", new { tipo = "Caixa", fatorConversao = 12 });

        _iogurte = await PostAsync<ProdutoDetalhe>("/api/v1/produtos", new
        {
            sku = "IOG-170",
            descricao = "Iogurte 170g",
            unidadeBase = "UN",
            classeArmazenagem = "Normal",
            controlaLote = true,
            controlaValidade = true,
        });
    }

    public Task DisposeAsync()
    {
        _client.Dispose();
        _factory.Dispose();
        return Task.CompletedTask;
    }

    [DockerFact]
    public async Task Entry_in_boxes_becomes_base_units_and_exit_empties_the_address()
    {
        var caixa = _refrigerante.Embalagens.Single(e => e.Tipo == TipoEmbalagem.Caixa);

        var entrada = await SendAsync("/api/v1/movimentacoes/entradas", new
        {
            produtoId = _refrigerante.Id,
            embalagemId = caixa.Id,
            enderecoId = _endereco.Id,
            quantidade = 2,
            documentoReferencia = "NF 1001",
        });
        Assert.Equal(HttpStatusCode.Created, entrada.StatusCode);
        var movimento = (await entrada.Content.ReadFromJsonAsync<MovimentacaoDetalhe>(Json))!;
        Assert.Equal(24m, movimento.Quantidade);
        Assert.Equal(TipoMovimentacao.Entrada, movimento.Tipo);
        Assert.Equal(24m, await SaldoAsync(_refrigerante.Id));
        Assert.Equal(StatusEndereco.Ocupado, await StatusEnderecoAsync());

        var demais = await SendAsync("/api/v1/movimentacoes/saidas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 30 });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, demais.StatusCode);
        Assert.Equal(24m, await SaldoAsync(_refrigerante.Id));

        var saida = await SendAsync("/api/v1/movimentacoes/saidas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 24 });
        Assert.Equal(HttpStatusCode.Created, saida.StatusCode);
        Assert.Equal(0m, await SaldoAsync(_refrigerante.Id));
        Assert.Equal(StatusEndereco.Livre, await StatusEnderecoAsync());

        var lido = await GetAsync<MovimentacaoDetalhe>($"/api/v1/movimentacoes/{movimento.Id}");
        Assert.Equal("NF 1001", lido.DocumentoReferencia);
        Assert.Equal(2, await QueryAsync(db => db.Movimentacoes.CountAsync()));
    }

    [DockerFact]
    public async Task Lot_controlled_product_needs_lot_with_consistent_dates()
    {
        var semLote = await SendAsync("/api/v1/movimentacoes/entradas", new { produtoId = _iogurte.Id, enderecoId = _endereco.Id, quantidade = 10 });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, semLote.StatusCode);

        var lote = new { numero = "l-2610", fabricacao = "2026-10-01", validade = "2026-11-15" };
        var comLote = await SendAsync("/api/v1/movimentacoes/entradas", new { produtoId = _iogurte.Id, enderecoId = _endereco.Id, quantidade = 10, lote });
        Assert.Equal(HttpStatusCode.Created, comLote.StatusCode);
        Assert.Equal("L-2610", (await comLote.Content.ReadFromJsonAsync<MovimentacaoDetalhe>(Json))!.LoteNumero);

        var mesmoLote = await SendAsync("/api/v1/movimentacoes/entradas", new
        {
            produtoId = _iogurte.Id,
            enderecoId = _endereco.Id,
            quantidade = 5,
            lote = new { numero = "L-2610" },
        });
        Assert.Equal(HttpStatusCode.Created, mesmoLote.StatusCode);
        Assert.Equal(15m, await SaldoAsync(_iogurte.Id));
        Assert.Equal(1, await QueryAsync(db => db.Lotes.CountAsync()));

        var validadeDiferente = await SendAsync("/api/v1/movimentacoes/entradas", new
        {
            produtoId = _iogurte.Id,
            enderecoId = _endereco.Id,
            quantidade = 1,
            lote = new { numero = "L-2610", validade = "2026-12-31" },
        });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, validadeDiferente.StatusCode);

        var loteDesconhecido = await SendAsync("/api/v1/movimentacoes/saidas", new { produtoId = _iogurte.Id, enderecoId = _endereco.Id, quantidade = 1, lote = "L-9999" });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, loteDesconhecido.StatusCode);

        var saidaDoLote = await SendAsync("/api/v1/movimentacoes/saidas", new { produtoId = _iogurte.Id, enderecoId = _endereco.Id, quantidade = 3, lote = "l-2610" });
        Assert.Equal(HttpStatusCode.Created, saidaDoLote.StatusCode);
        Assert.Equal(12m, await SaldoAsync(_iogurte.Id));
    }

    [DockerFact]
    public async Task Blocked_address_rejects_entries_and_unblock_restores_occupancy()
    {
        await SendAsync("/api/v1/movimentacoes/entradas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 6 });
        await SendAsync($"/api/v1/enderecos/{_endereco.Id}/bloquear", new { motivo = "Longarina amassada" });

        var entrada = await SendAsync("/api/v1/movimentacoes/entradas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 1 });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, entrada.StatusCode);

        var exclusao = await _client.SendAsync(Request(HttpMethod.Delete, $"/api/v1/enderecos/{_endereco.Id}"));
        Assert.Equal(HttpStatusCode.UnprocessableEntity, exclusao.StatusCode);

        var desbloqueio = await SendAsync($"/api/v1/enderecos/{_endereco.Id}/desbloquear", body: null);
        Assert.Equal(StatusEndereco.Ocupado, (await desbloqueio.Content.ReadFromJsonAsync<EnderecoDetalhe>(Json))!.Status);
    }

    [DockerFact]
    public async Task Ajuste_records_the_reason_and_cannot_go_below_zero()
    {
        var aumento = await SendAsync("/api/v1/movimentacoes/ajustes", new
        {
            produtoId = _refrigerante.Id,
            enderecoId = _endereco.Id,
            quantidade = 5,
            motivo = "Sobra na contagem",
        });
        Assert.Equal(HttpStatusCode.Created, aumento.StatusCode);
        var ajuste = (await aumento.Content.ReadFromJsonAsync<MovimentacaoDetalhe>(Json))!;
        Assert.Equal("Sobra na contagem", ajuste.Observacao);
        Assert.Equal(_endereco.Id, ajuste.EnderecoDestinoId);

        var negativo = await SendAsync("/api/v1/movimentacoes/ajustes", new
        {
            produtoId = _refrigerante.Id,
            enderecoId = _endereco.Id,
            quantidade = -8,
            motivo = "Avaria",
        });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, negativo.StatusCode);
        Assert.Equal(5m, await SaldoAsync(_refrigerante.Id));
    }

    [DockerFact]
    public async Task Same_key_replays_the_original_without_moving_stock_again()
    {
        var chave = Guid.NewGuid();
        var entrada = new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 4, idempotencyKey = chave };

        var primeira = await SendAsync("/api/v1/movimentacoes/entradas", entrada);
        var reenvio = await SendAsync("/api/v1/movimentacoes/entradas", entrada);

        Assert.Equal(HttpStatusCode.Created, primeira.StatusCode);
        Assert.Equal(HttpStatusCode.OK, reenvio.StatusCode);
        Assert.Equal("true", Assert.Single(reenvio.Headers.GetValues(MovimentacoesEndpoints.ReplayHeader)));
        var original = (await primeira.Content.ReadFromJsonAsync<MovimentacaoDetalhe>(Json))!;
        Assert.Equal(original.Id, (await reenvio.Content.ReadFromJsonAsync<MovimentacaoDetalhe>(Json))!.Id);
        Assert.Equal(chave, original.IdempotencyKey);
        Assert.Equal(4m, await SaldoAsync(_refrigerante.Id));

        var outraOperacao = await SendAsync("/api/v1/movimentacoes/entradas", entrada with { quantidade = 5 });
        Assert.Equal(HttpStatusCode.Conflict, outraOperacao.StatusCode);
        Assert.Equal(4m, await SaldoAsync(_refrigerante.Id));
    }

    [DockerFact]
    public async Task Replayed_exit_succeeds_even_after_the_stock_was_consumed()
    {
        await SendAsync("/api/v1/movimentacoes/entradas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 3 });
        var saida = new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 3, idempotencyKey = Guid.NewGuid() };

        Assert.Equal(HttpStatusCode.Created, (await SendAsync("/api/v1/movimentacoes/saidas", saida)).StatusCode);
        var reenvio = await SendAsync("/api/v1/movimentacoes/saidas", saida);

        Assert.Equal(HttpStatusCode.OK, reenvio.StatusCode);
        Assert.Equal(0m, await SaldoAsync(_refrigerante.Id));
    }

    [DockerFact]
    public async Task Concurrent_entries_on_the_same_balance_lose_no_update()
    {
        var respostas = await Task.WhenAll(Enumerable.Range(0, MovimentacaoConcorrencia).Select(_ =>
            SendAsync("/api/v1/movimentacoes/entradas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 1 })));

        Assert.All(respostas, r => Assert.Equal(HttpStatusCode.Created, r.StatusCode));
        Assert.Equal(MovimentacaoConcorrencia, await SaldoAsync(_refrigerante.Id));
        Assert.Equal(MovimentacaoConcorrencia, await QueryAsync(db => db.Movimentacoes.CountAsync()));
    }

    [DockerFact]
    public async Task Concurrent_sends_with_the_same_key_record_a_single_movement()
    {
        var entrada = new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 2, idempotencyKey = Guid.NewGuid() };

        var respostas = await Task.WhenAll(Enumerable.Range(0, MovimentacaoConcorrencia).Select(_ =>
            SendAsync("/api/v1/movimentacoes/entradas", entrada)));

        Assert.All(respostas, r => Assert.True(r.IsSuccessStatusCode, $"status {(int)r.StatusCode}"));
        Assert.Single(respostas, r => r.StatusCode == HttpStatusCode.Created);
        Assert.Equal(2m, await SaldoAsync(_refrigerante.Id));
        Assert.Equal(1, await QueryAsync(db => db.Movimentacoes.CountAsync()));
    }

    /// <summary>Até 5 operações simultâneas no mesmo saldo terminam sem erro (ADR-0006).</summary>
    private const int MovimentacaoConcorrencia = 5;

    private async Task<decimal> SaldoAsync(Guid produtoId) =>
        await QueryAsync(db => db.Saldos.Where(s => s.ProdutoId == produtoId && s.EnderecoId == _endereco.Id).SumAsync(s => s.Quantidade));

    private async Task<StatusEndereco> StatusEnderecoAsync() =>
        (await GetAsync<EnderecoDetalhe>($"/api/v1/enderecos/{_endereco.Id}")).Status;

    private async Task<T> QueryAsync<T>(Func<StowiseDbContext, Task<T>> query)
    {
        await using var scope = _factory.Services.CreateAsyncScope();
        return await query(scope.ServiceProvider.GetRequiredService<StowiseDbContext>());
    }

    private async Task<T> PostAsync<T>(string url, object body)
    {
        var response = await SendAsync(url, body);
        Assert.True(response.IsSuccessStatusCode, $"POST {url} → {(int)response.StatusCode}: {await response.Content.ReadAsStringAsync()}");
        return (await response.Content.ReadFromJsonAsync<T>(Json))!;
    }

    private async Task<T> GetAsync<T>(string url)
    {
        var response = await _client.SendAsync(Request(HttpMethod.Get, url));
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return (await response.Content.ReadFromJsonAsync<T>(Json))!;
    }

    private Task<HttpResponseMessage> SendAsync(string url, object? body)
    {
        var request = Request(HttpMethod.Post, url);
        if (body is not null)
        {
            request.Content = JsonContent.Create(body);
        }

        return _client.SendAsync(request);
    }

    private HttpRequestMessage Request(HttpMethod method, string url)
    {
        var request = new HttpRequestMessage(method, url);
        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", _token);
        return request;
    }
}
