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
using Stowise.Application.Common;
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

    [DockerFact]
    public async Task Transfer_moves_stock_and_occupancy_between_addresses_of_the_same_warehouse()
    {
        var destino = await CreateEnderecoAsync(_endereco.ZonaId, modulo: 2);
        await SendAsync("/api/v1/movimentacoes/entradas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 10 });
        var transferencia = new
        {
            produtoId = _refrigerante.Id,
            enderecoOrigemId = _endereco.Id,
            enderecoDestinoId = destino.Id,
            quantidade = 10,
            idempotencyKey = Guid.NewGuid(),
        };

        var resposta = await SendAsync("/api/v1/movimentacoes/transferencias", transferencia);
        Assert.Equal(HttpStatusCode.Created, resposta.StatusCode);
        Assert.Equal(TipoMovimentacao.Transferencia, (await resposta.Content.ReadFromJsonAsync<MovimentacaoDetalhe>(Json))!.Tipo);
        Assert.Equal(0m, await SaldoAsync(_refrigerante.Id));
        Assert.Equal(10m, await SaldoEmAsync(_refrigerante.Id, destino.Id));
        Assert.Equal(StatusEndereco.Livre, await StatusEnderecoAsync());
        Assert.Equal(StatusEndereco.Ocupado, (await GetAsync<EnderecoDetalhe>($"/api/v1/enderecos/{destino.Id}")).Status);

        var reenvio = await SendAsync("/api/v1/movimentacoes/transferencias", transferencia);
        Assert.Equal(HttpStatusCode.OK, reenvio.StatusCode);
        Assert.Equal(10m, await SaldoEmAsync(_refrigerante.Id, destino.Id));

        var outroArmazem = await PostAsync<ArmazemDetalhe>("/api/v1/armazens", new { codigo = "CD09", nome = "Outro" });
        outroArmazem = await PostAsync<ArmazemDetalhe>($"/api/v1/armazens/{outroArmazem.Id}/zonas", new { codigo = "SECO", classeArmazenagem = "Normal" });
        var longe = await CreateEnderecoAsync(outroArmazem.Zonas.Single().Id, modulo: 1);
        var entreArmazens = await SendAsync("/api/v1/movimentacoes/transferencias", new
        {
            produtoId = _refrigerante.Id,
            enderecoOrigemId = destino.Id,
            enderecoDestinoId = longe.Id,
            quantidade = 1,
        });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, entreArmazens.StatusCode);
    }

    [DockerFact]
    public async Task Reservation_holds_stock_until_consumed_or_cancelled()
    {
        await SendAsync("/api/v1/movimentacoes/entradas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 10 });

        var reserva = await PostAsync<ReservaDetalhe>("/api/v1/reservas", new
        {
            produtoId = _refrigerante.Id,
            enderecoId = _endereco.Id,
            quantidade = 7,
            documentoReferencia = "PED-42",
        });
        Assert.Equal(StatusReserva.Ativa, reserva.Status);

        var acimaDoDisponivel = await SendAsync("/api/v1/movimentacoes/saidas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 4 });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, acimaDoDisponivel.StatusCode);
        var outraReserva = await SendAsync("/api/v1/reservas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 4 });
        Assert.Equal(HttpStatusCode.UnprocessableEntity, outraReserva.StatusCode);

        var consumo = new { idempotencyKey = Guid.NewGuid() };
        var saida = await SendAsync($"/api/v1/reservas/{reserva.Id}/consumir", consumo);
        Assert.Equal(HttpStatusCode.Created, saida.StatusCode);
        var movimento = (await saida.Content.ReadFromJsonAsync<MovimentacaoDetalhe>(Json))!;
        Assert.Equal(7m, movimento.Quantidade);
        Assert.Equal("PED-42", movimento.DocumentoReferencia);
        Assert.Equal(3m, await SaldoAsync(_refrigerante.Id));

        var consumida = await GetAsync<ReservaDetalhe>($"/api/v1/reservas/{reserva.Id}");
        Assert.Equal(StatusReserva.Consumida, consumida.Status);
        Assert.Equal(movimento.Id, consumida.MovimentacaoId);

        Assert.Equal(HttpStatusCode.OK, (await SendAsync($"/api/v1/reservas/{reserva.Id}/consumir", consumo)).StatusCode);
        Assert.Equal(HttpStatusCode.UnprocessableEntity, (await SendAsync($"/api/v1/reservas/{reserva.Id}/consumir", new { })).StatusCode);
        Assert.Equal(3m, await SaldoAsync(_refrigerante.Id));

        var segunda = await PostAsync<ReservaDetalhe>("/api/v1/reservas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 3 });
        var cancelada = await SendAsync($"/api/v1/reservas/{segunda.Id}/cancelar", body: null);
        Assert.Equal(StatusReserva.Cancelada, (await cancelada.Content.ReadFromJsonAsync<ReservaDetalhe>(Json))!.Status);
        Assert.Equal(HttpStatusCode.UnprocessableEntity, (await SendAsync($"/api/v1/reservas/{segunda.Id}/cancelar", body: null)).StatusCode);
        Assert.Equal(HttpStatusCode.Created, (await SendAsync("/api/v1/movimentacoes/saidas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 3 })).StatusCode);
    }

    [DockerFact]
    public async Task Balances_statement_and_point_in_time_balance_agree_with_the_ledger()
    {
        var b = await CreateEnderecoAsync(_endereco.ZonaId, modulo: 2);
        var dia1 = new DateTimeOffset(2026, 10, 1, 10, 0, 0, TimeSpan.Zero);
        var dia2 = dia1.AddDays(1);
        var dia3 = dia1.AddDays(2);

        // Dia 1: 10 no A. Dia 2: 4 do A para o B e 2 lotes de iogurte no B. Dia 3: sai 1 do B e entra 1 no A por ajuste.
        await Movimentar("entradas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 10, ocorridoEm = dia1 });
        await Movimentar("transferencias", new { produtoId = _refrigerante.Id, enderecoOrigemId = _endereco.Id, enderecoDestinoId = b.Id, quantidade = 4, ocorridoEm = dia2 });
        await Movimentar("entradas", new { produtoId = _iogurte.Id, enderecoId = b.Id, quantidade = 5, ocorridoEm = dia2, lote = new { numero = "L-NOV", validade = "2026-11-30" } });
        await Movimentar("entradas", new { produtoId = _iogurte.Id, enderecoId = b.Id, quantidade = 3, ocorridoEm = dia2, lote = new { numero = "L-OUT", validade = "2026-10-31" } });
        await Movimentar("saidas", new { produtoId = _refrigerante.Id, enderecoId = b.Id, quantidade = 1, ocorridoEm = dia3 });
        await Movimentar("ajustes", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 1, motivo = "Sobra", ocorridoEm = dia3 });
        await PostAsync<ReservaDetalhe>("/api/v1/reservas", new { produtoId = _refrigerante.Id, enderecoId = _endereco.Id, quantidade = 2 });

        // Saldos atuais: refrigerante 7 no A (2 reservados) e 3 no B; iogurte por validade (FEFO).
        var refrigerante = await GetAsync<PagedResult<SaldoItem>>($"/api/v1/saldos?produtoId={_refrigerante.Id}");
        Assert.Equal([(_endereco.Codigo, 7m, 2m, 5m), (b.Codigo, 3m, 0m, 3m)],
            refrigerante.Itens.Select(s => (s.EnderecoCodigo, s.Quantidade, s.QuantidadeReservada, s.QuantidadeDisponivel)));
        var iogurte = await GetAsync<PagedResult<SaldoItem>>($"/api/v1/saldos?enderecoId={b.Id}&produtoId={_iogurte.Id}");
        Assert.Equal(["L-OUT", "L-NOV"], iogurte.Itens.Select(s => s.LoteNumero));

        var resumo = await GetAsync<ResumoSaldoProduto>($"/api/v1/saldos/produtos/{_iogurte.Id}");
        Assert.Equal(8m, resumo.Quantidade);
        Assert.Equal(1, resumo.Enderecos);
        Assert.Equal([("L-OUT", 3m), ("L-NOV", 5m)], resumo.Lotes.Select(l => (l.Numero, l.Quantidade)));

        // Extrato do endereço B: a transferência aparece como chegada; mais recente primeiro.
        var extratoB = await GetAsync<PagedResult<ExtratoItem>>($"/api/v1/movimentacoes?enderecoId={b.Id}&produtoId={_refrigerante.Id}");
        Assert.Equal([TipoMovimentacao.Saida, TipoMovimentacao.Transferencia], extratoB.Itens.Select(m => m.Tipo));
        Assert.Equal(_endereco.Codigo, extratoB.Itens[1].EnderecoOrigemCodigo);
        var soDia2 = await GetAsync<PagedResult<ExtratoItem>>($"/api/v1/movimentacoes?de={Uri.EscapeDataString(dia2.ToString("O"))}&ate={Uri.EscapeDataString(dia2.ToString("O"))}");
        Assert.Equal(3, soDia2.Total);

        // Saldo no fim do dia 2, só pelo livro-razão: 6 no A e 4 no B.
        var fimDia2 = Uri.EscapeDataString(dia2.AddHours(12).ToString("O"));
        var naData = await GetAsync<PagedResult<SaldoNaData>>($"/api/v1/saldos/em-data?data={fimDia2}&produtoId={_refrigerante.Id}");
        Assert.Equal([(_endereco.Codigo, 6m), (b.Codigo, 4m)], naData.Itens.Select(s => (s.EnderecoCodigo, s.Quantidade)));

        // Consistência do ADR-0001: o livro-razão até agora é igual à projeção (tabela de saldos).
        var agora = Uri.EscapeDataString(DateTimeOffset.UtcNow.AddMinutes(1).ToString("O"));
        var razao = await GetAsync<PagedResult<SaldoNaData>>($"/api/v1/saldos/em-data?data={agora}");
        var projecao = await GetAsync<PagedResult<SaldoItem>>("/api/v1/saldos");
        Assert.Equal(
            projecao.Itens.Where(s => s.Quantidade != 0).Select(s => (s.EnderecoId, s.ProdutoId, s.LoteId, s.Quantidade)).Order(),
            razao.Itens.Select(s => (s.EnderecoId, s.ProdutoId, s.LoteId, s.Quantidade)).Order());

        var reservas = await GetAsync<PagedResult<ReservaDetalhe>>($"/api/v1/reservas?produtoId={_refrigerante.Id}&status=Ativa");
        Assert.Equal(2m, Assert.Single(reservas.Itens).Quantidade);
    }

    private async Task Movimentar(string tipo, object body)
    {
        var response = await SendAsync($"/api/v1/movimentacoes/{tipo}", body);
        Assert.True(response.StatusCode == HttpStatusCode.Created, $"{tipo} → {(int)response.StatusCode}: {await response.Content.ReadAsStringAsync()}");
    }

    private async Task<EnderecoDetalhe> CreateEnderecoAsync(Guid zonaId, int modulo) =>
        await PostAsync<EnderecoDetalhe>("/api/v1/enderecos", new
        {
            zonaId,
            rua = "B",
            modulo,
            nivel = 1,
            posicao = 1,
            capacidadePesoKg = 1000,
            alturaCm = 150,
            larguraCm = 120,
            profundidadeCm = 100,
            distanciaExpedicao = 4,
        });

    private async Task<decimal> SaldoEmAsync(Guid produtoId, Guid enderecoId) =>
        await QueryAsync(db => db.Saldos.Where(s => s.ProdutoId == produtoId && s.EnderecoId == enderecoId).SumAsync(s => s.Quantidade));

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
