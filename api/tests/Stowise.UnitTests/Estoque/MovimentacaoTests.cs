using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Estoque;

public class MovimentacaoTests
{
    private static readonly Registro Registro = new(Guid.CreateVersion7(), null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow);
    private static readonly Zona Zona = Armazem.Create("CD01", "Centro").AddZona("SECO", ClasseArmazenagem.Normal);

    private static Endereco NovoEndereco() =>
        Endereco.Create(Zona, "A", 1, 1, 1, new DimensoesEndereco(1000m, 150m, 120m, 100m, 4m));

    private static Produto NovoProduto(bool controlaLote = false, bool controlaValidade = false) =>
        Produto.Create(
            "SKU-" + Guid.NewGuid().ToString("N")[..6],
            new DadosProduto("Produto", "UN", ClasseArmazenagem.Normal, controlaLote, controlaValidade, null, null, null),
            new DadosEmbalagem(null, null, null, null, null));

    private static Saldo SaldoDe(Endereco endereco, Produto produto, Lote? lote = null) => Saldo.Create(endereco.Id, produto.Id, lote?.Id);

    [Fact]
    public void Entrada_adds_to_the_destination_balance()
    {
        var produto = NovoProduto();
        var endereco = NovoEndereco();
        var saldo = SaldoDe(endereco, produto);

        var movimentacao = Movimentacao.Entrada(produto, null, endereco, saldo, 24m, Registro, "NF 123");

        Assert.Equal(24m, saldo.Quantidade);
        Assert.Equal(TipoMovimentacao.Entrada, movimentacao.Tipo);
        Assert.Equal(endereco.Id, movimentacao.EnderecoDestinoId);
        Assert.Null(movimentacao.EnderecoOrigemId);
        Assert.Equal("NF 123", movimentacao.DocumentoReferencia);
        Assert.Equal(Registro.UsuarioId, movimentacao.UsuarioId);
    }

    [Fact]
    public void Saida_requires_available_balance_and_leaves_it_untouched_on_failure()
    {
        var produto = NovoProduto();
        var endereco = NovoEndereco();
        var saldo = SaldoDe(endereco, produto);
        Movimentacao.Entrada(produto, null, endereco, saldo, 10m, Registro, null);

        var ex = Assert.Throws<DomainException>(() => Movimentacao.Saida(produto, null, endereco, saldo, 11m, Registro, null));
        Assert.Contains("Saldo insuficiente", ex.Message, StringComparison.Ordinal);
        Assert.Equal(10m, saldo.Quantidade);

        var saida = Movimentacao.Saida(produto, null, endereco, saldo, 10m, Registro, null);
        Assert.Equal(0m, saldo.Quantidade);
        Assert.Equal(endereco.Id, saida.EnderecoOrigemId);
    }

    [Theory]
    [InlineData(0)]
    [InlineData(-1)]
    public void Quantity_must_be_positive(double quantidade)
    {
        var produto = NovoProduto();
        var endereco = NovoEndereco();

        Assert.Throws<DomainException>(() =>
            Movimentacao.Entrada(produto, null, endereco, SaldoDe(endereco, produto), (decimal)quantidade, Registro, null));
    }

    [Fact]
    public void Blocked_address_cannot_receive_but_can_be_emptied()
    {
        var produto = NovoProduto();
        var endereco = NovoEndereco();
        var saldo = SaldoDe(endereco, produto);
        Movimentacao.Entrada(produto, null, endereco, saldo, 5m, Registro, null);
        endereco.Block("Avaria", DateTimeOffset.UtcNow, Guid.NewGuid());

        Assert.Throws<DomainException>(() => Movimentacao.Entrada(produto, null, endereco, saldo, 1m, Registro, null));

        Movimentacao.Saida(produto, null, endereco, saldo, 5m, Registro, null);
        Assert.Equal(0m, saldo.Quantidade);
    }

    [Fact]
    public void Inactive_product_cannot_receive_entries()
    {
        var produto = NovoProduto();
        produto.Deactivate();
        var endereco = NovoEndereco();

        Assert.Throws<DomainException>(() => Movimentacao.Entrada(produto, null, endereco, SaldoDe(endereco, produto), 1m, Registro, null));
    }

    [Fact]
    public void Lot_rules_follow_the_product_configuration()
    {
        var semLote = NovoProduto();
        var comLote = NovoProduto(controlaLote: true, controlaValidade: true);
        var endereco = NovoEndereco();
        var loteSemValidade = Lote.Create(comLote.Id, "L1", null, null);
        var loteValido = Lote.Create(comLote.Id, "L2", new DateOnly(2026, 1, 1), new DateOnly(2027, 1, 1));
        var loteDeOutro = Lote.Create(semLote.Id, "X", null, null);

        Assert.Throws<DomainException>(() => Movimentacao.Entrada(comLote, null, endereco, SaldoDe(endereco, comLote), 1m, Registro, null));
        Assert.Throws<DomainException>(() => Movimentacao.Entrada(semLote, loteDeOutro, endereco, SaldoDe(endereco, semLote, loteDeOutro), 1m, Registro, null));
        Assert.Throws<DomainException>(() => Movimentacao.Entrada(comLote, loteDeOutro, endereco, SaldoDe(endereco, comLote, loteDeOutro), 1m, Registro, null));
        Assert.Throws<DomainException>(() => Movimentacao.Entrada(comLote, loteSemValidade, endereco, SaldoDe(endereco, comLote, loteSemValidade), 1m, Registro, null));

        var entrada = Movimentacao.Entrada(comLote, loteValido, endereco, SaldoDe(endereco, comLote, loteValido), 1m, Registro, null);
        Assert.Equal(loteValido.Id, entrada.LoteId);
    }

    [Fact]
    public void Ajuste_moves_by_the_sign_and_requires_a_reason()
    {
        var produto = NovoProduto();
        var endereco = NovoEndereco();
        var saldo = SaldoDe(endereco, produto);

        var aumento = Movimentacao.Ajuste(produto, null, endereco, saldo, 7m, Registro, "Contagem cíclica");
        Assert.Equal(endereco.Id, aumento.EnderecoDestinoId);
        Assert.Equal(7m, aumento.Quantidade);

        var reducao = Movimentacao.Ajuste(produto, null, endereco, saldo, -2m, Registro, "Avaria");
        Assert.Equal(endereco.Id, reducao.EnderecoOrigemId);
        Assert.Equal(2m, reducao.Quantidade);
        Assert.Equal(5m, saldo.Quantidade);

        Assert.Throws<DomainException>(() => Movimentacao.Ajuste(produto, null, endereco, saldo, 0m, Registro, "Nada"));
        Assert.Throws<DomainException>(() => Movimentacao.Ajuste(produto, null, endereco, saldo, 1m, Registro, " "));
        Assert.Throws<DomainException>(() => Movimentacao.Ajuste(produto, null, endereco, saldo, -6m, Registro, "Avaria"));
    }

    [Fact]
    public void Balance_of_another_address_is_a_programming_error()
    {
        var produto = NovoProduto();
        var endereco = NovoEndereco();
        var outro = Saldo.Create(Guid.NewGuid(), produto.Id, null);

        Assert.Throws<InvalidOperationException>(() => Movimentacao.Entrada(produto, null, endereco, outro, 1m, Registro, null));
    }

    [Fact]
    public void Lote_normalizes_number_and_rejects_validity_before_manufacture()
    {
        var lote = Lote.Create(Guid.NewGuid(), " l-2026a ", new DateOnly(2026, 1, 1), new DateOnly(2026, 6, 1));
        Assert.Equal("L-2026A", lote.Numero);

        Assert.Throws<DomainException>(() => Lote.Create(Guid.NewGuid(), "L1", new DateOnly(2026, 6, 1), new DateOnly(2026, 1, 1)));
    }

    [Fact]
    public void SyncOcupacao_follows_the_balance_but_keeps_a_block()
    {
        var endereco = NovoEndereco();

        endereco.SyncOcupacao(temSaldo: true);
        Assert.Equal(StatusEndereco.Ocupado, endereco.Status);

        endereco.SyncOcupacao(temSaldo: false);
        Assert.Equal(StatusEndereco.Livre, endereco.Status);

        endereco.Block("Avaria", DateTimeOffset.UtcNow, Guid.NewGuid());
        endereco.SyncOcupacao(temSaldo: true);
        Assert.Equal(StatusEndereco.Bloqueado, endereco.Status);
    }

    [Fact]
    public void Idempotency_key_comes_from_the_request_metadata()
    {
        var produto = NovoProduto();
        var endereco = NovoEndereco();
        var chave = Guid.NewGuid();

        var movimentacao = Movimentacao.Entrada(produto, null, endereco, SaldoDe(endereco, produto), 1m, Registro with { IdempotencyKey = chave }, null);

        Assert.Equal(chave, movimentacao.IdempotencyKey);
    }
}
