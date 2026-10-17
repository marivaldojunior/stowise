using Stowise.Application.Estoque;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Estoque;

public class TransferenciaEReservaTests
{
    private static readonly Registro Registro = new(Guid.CreateVersion7(), null, DateTimeOffset.UtcNow, DateTimeOffset.UtcNow);
    private static readonly Zona Seco = Armazem.Create("CD01", "Centro").AddZona("SECO", ClasseArmazenagem.Normal);
    private static readonly Zona OutroArmazem = Armazem.Create("CD02", "Sul").AddZona("SECO", ClasseArmazenagem.Normal);

    private static Endereco Endereco(Zona zona, int modulo) =>
        Domain.Estrutura.Endereco.Create(zona, "A", modulo, 1, 1, new DimensoesEndereco(1000m, 150m, 120m, 100m, 4m));

    private static Produto Produto() =>
        Domain.Catalogo.Produto.Create(
            "SKU-" + Guid.NewGuid().ToString("N")[..6],
            new DadosProduto("Produto", "UN", ClasseArmazenagem.Normal, false, false, null, null, null),
            new DadosEmbalagem(null, null, null, null, null));

    private static (Produto Produto, Endereco Origem, Saldo SaldoOrigem) ComSaldo(decimal quantidade)
    {
        var produto = Produto();
        var origem = Endereco(Seco, 1);
        var saldo = Saldo.Create(origem.Id, produto.Id, null);
        Movimentacao.Entrada(produto, null, origem, saldo, quantidade, Registro, null);
        return (produto, origem, saldo);
    }

    [Fact]
    public void Transferencia_moves_between_addresses_in_one_entry()
    {
        var (produto, origem, saldoOrigem) = ComSaldo(10m);
        var destino = Endereco(Seco, 2);
        var saldoDestino = Saldo.Create(destino.Id, produto.Id, null);

        var movimentacao = Movimentacao.Transferencia(produto, null, origem, saldoOrigem, destino, saldoDestino, 4m, Registro, null);

        Assert.Equal(TipoMovimentacao.Transferencia, movimentacao.Tipo);
        Assert.Equal(origem.Id, movimentacao.EnderecoOrigemId);
        Assert.Equal(destino.Id, movimentacao.EnderecoDestinoId);
        Assert.Equal(6m, saldoOrigem.Quantidade);
        Assert.Equal(4m, saldoDestino.Quantidade);
    }

    [Fact]
    public void Transferencia_rejects_same_address_other_warehouse_blocked_destination_and_missing_stock()
    {
        var (produto, origem, saldoOrigem) = ComSaldo(10m);
        var outro = Endereco(OutroArmazem, 1);
        var bloqueado = Endereco(Seco, 3);
        bloqueado.Block("Avaria", DateTimeOffset.UtcNow, Guid.NewGuid());

        Assert.Throws<DomainException>(() => Movimentacao.Transferencia(produto, null, origem, saldoOrigem, origem, saldoOrigem, 1m, Registro, null));
        Assert.Throws<DomainException>(() => Movimentacao.Transferencia(produto, null, origem, saldoOrigem, outro, Saldo.Create(outro.Id, produto.Id, null), 1m, Registro, null));
        Assert.Throws<DomainException>(() => Movimentacao.Transferencia(produto, null, origem, saldoOrigem, bloqueado, Saldo.Create(bloqueado.Id, produto.Id, null), 1m, Registro, null));

        var destino = Endereco(Seco, 2);
        Assert.Throws<DomainException>(() => Movimentacao.Transferencia(produto, null, origem, saldoOrigem, destino, Saldo.Create(destino.Id, produto.Id, null), 11m, Registro, null));
        Assert.Equal(10m, saldoOrigem.Quantidade);
    }

    [Fact]
    public void Reserva_takes_quantity_out_of_the_available_balance()
    {
        var (produto, origem, saldo) = ComSaldo(10m);

        var reserva = Reserva.Create(produto, null, origem, saldo, 7m, "PED-1", Registro.UsuarioId, DateTimeOffset.UtcNow);

        Assert.Equal(StatusReserva.Ativa, reserva.Status);
        Assert.Equal(10m, saldo.Quantidade);
        Assert.Equal(7m, saldo.QuantidadeReservada);
        Assert.Equal(3m, saldo.QuantidadeDisponivel);

        // Uma saída comum só pode usar o disponível, e não o reservado.
        Assert.Throws<DomainException>(() => Movimentacao.Saida(produto, null, origem, saldo, 4m, Registro, null));
        Assert.Throws<DomainException>(() => Reserva.Create(produto, null, origem, saldo, 4m, null, Registro.UsuarioId, DateTimeOffset.UtcNow));
    }

    [Fact]
    public void Reserva_is_refused_on_a_blocked_address()
    {
        var (produto, origem, saldo) = ComSaldo(10m);
        origem.Block("Avaria", DateTimeOffset.UtcNow, Guid.NewGuid());

        Assert.Throws<DomainException>(() => Reserva.Create(produto, null, origem, saldo, 1m, null, Registro.UsuarioId, DateTimeOffset.UtcNow));
    }

    [Fact]
    public void Cancel_releases_the_quantity_once()
    {
        var (produto, origem, saldo) = ComSaldo(10m);
        var reserva = Reserva.Create(produto, null, origem, saldo, 7m, null, Registro.UsuarioId, DateTimeOffset.UtcNow);

        reserva.Cancel(saldo, Registro.UsuarioId, DateTimeOffset.UtcNow);

        Assert.Equal(StatusReserva.Cancelada, reserva.Status);
        Assert.Equal(0m, saldo.QuantidadeReservada);
        Assert.NotNull(reserva.EncerradaEm);
        Assert.Throws<DomainException>(() => reserva.Cancel(saldo, Registro.UsuarioId, DateTimeOffset.UtcNow));
    }

    [Fact]
    public void Reserved_exit_consumes_the_reservation_and_lowers_the_balance()
    {
        var (produto, origem, saldo) = ComSaldo(10m);
        var reserva = Reserva.Create(produto, null, origem, saldo, 7m, "PED-1", Registro.UsuarioId, DateTimeOffset.UtcNow);

        var saida = Movimentacao.SaidaReservada(produto, null, origem, saldo, reserva, Registro, documento: null);

        Assert.Equal(TipoMovimentacao.Saida, saida.Tipo);
        Assert.Equal(7m, saida.Quantidade);
        Assert.Equal("PED-1", saida.DocumentoReferencia);
        Assert.Equal(StatusReserva.Consumida, reserva.Status);
        Assert.Equal(saida.Id, reserva.MovimentacaoId);
        Assert.Equal(3m, saldo.Quantidade);
        Assert.Equal(0m, saldo.QuantidadeReservada);
        Assert.Throws<DomainException>(() => Movimentacao.SaidaReservada(produto, null, origem, saldo, reserva, Registro, null));
    }

    [Fact]
    public void Validation_requires_distinct_addresses_and_positive_quantities()
    {
        var mesmoEndereco = Guid.NewGuid();
        var transferencia = new RegistrarTransferencia(Guid.NewGuid(), null, mesmoEndereco, mesmoEndereco, 0m, null, null, null, null);
        Assert.Equal(["enderecoDestinoId", "quantidade"], EstoqueValidation.Validate(transferencia, DateTimeOffset.UtcNow).Keys.Order(StringComparer.Ordinal));

        var semOrigem = transferencia with { EnderecoOrigemId = null, EnderecoDestinoId = Guid.NewGuid(), Quantidade = 1m };
        Assert.Equal(["enderecoOrigemId"], EstoqueValidation.Validate(semOrigem, DateTimeOffset.UtcNow).Keys);

        var reserva = new CriarReserva(null, Guid.NewGuid(), null, -1m, null);
        Assert.Equal(["produtoId", "quantidade"], EstoqueValidation.Validate(reserva).Keys.Order(StringComparer.Ordinal));
    }
}
