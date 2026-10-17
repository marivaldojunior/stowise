using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.Domain.Estoque;

public enum StatusReserva
{
    Ativa,
    Cancelada,
    Consumida,
}

/// <summary>
/// Separa uma quantidade de um saldo (ex.: para um pedido). Não movimenta estoque: só reduz o disponível,
/// para que uma saída comum não use o que já está comprometido. É consumida por uma saída com a reserva.
/// </summary>
public sealed class Reserva : Entity
{
    public const int DocumentoReferenciaMaxLength = Movimentacao.DocumentoReferenciaMaxLength;

    private Reserva()
    {
    }

    public Guid EnderecoId { get; private set; }

    public Guid ProdutoId { get; private set; }

    public Guid? LoteId { get; private set; }

    /// <summary>Na unidade base.</summary>
    public decimal Quantidade { get; private set; }

    public string? DocumentoReferencia { get; private set; }

    public StatusReserva Status { get; private set; }

    public Guid CriadaPor { get; private set; }

    public DateTimeOffset CriadaEm { get; private set; }

    public Guid? EncerradaPor { get; private set; }

    public DateTimeOffset? EncerradaEm { get; private set; }

    /// <summary>Saída que consumiu a reserva.</summary>
    public Guid? MovimentacaoId { get; private set; }

    /// <summary>Versão para concorrência otimista (<c>xmin</c>): cancelar e consumir ao mesmo tempo não pode dar certo duas vezes.</summary>
    public uint Versao { get; private set; }

    public static Reserva Create(
        Produto produto,
        Lote? lote,
        Endereco endereco,
        Saldo saldo,
        decimal quantidade,
        string? documento,
        Guid usuarioId,
        DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(produto);
        ArgumentNullException.ThrowIfNull(endereco);
        ArgumentNullException.ThrowIfNull(saldo);

        if (saldo.EnderecoId != endereco.Id || saldo.ProdutoId != produto.Id || saldo.LoteId != lote?.Id)
        {
            throw new InvalidOperationException("The balance does not match the address, product and lot.");
        }

        Movimentacao.ValidateLote(produto, lote, exigeValidade: false);

        if (quantidade <= 0)
        {
            throw new DomainException("A quantidade reservada deve ser maior que zero.");
        }

        if (endereco.Status == StatusEndereco.Bloqueado)
        {
            throw new DomainException($"O endereço {endereco.Codigo} está bloqueado ({endereco.MotivoBloqueio}). Não é possível reservar dele.");
        }

        saldo.Reserve(quantidade);
        return new Reserva
        {
            EnderecoId = saldo.EnderecoId,
            ProdutoId = saldo.ProdutoId,
            LoteId = saldo.LoteId,
            Quantidade = quantidade,
            DocumentoReferencia = string.IsNullOrWhiteSpace(documento) ? null : Guard.Required(documento, "Documento de referência", DocumentoReferenciaMaxLength),
            Status = StatusReserva.Ativa,
            CriadaPor = usuarioId,
            CriadaEm = agora,
        };
    }

    public void Cancel(Saldo saldo, Guid usuarioId, DateTimeOffset agora)
    {
        Close(saldo, StatusReserva.Cancelada, usuarioId, agora);
    }

    internal void Consume(Saldo saldo, Guid usuarioId, DateTimeOffset agora)
    {
        Close(saldo, StatusReserva.Consumida, usuarioId, agora);
    }

    internal void LinkMovimentacao(Guid movimentacaoId) => MovimentacaoId = movimentacaoId;

    private void Close(Saldo saldo, StatusReserva status, Guid usuarioId, DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(saldo);

        if (Status != StatusReserva.Ativa)
        {
            throw new DomainException($"A reserva já está {Status.ToString().ToLowerInvariant()}.");
        }

        if (saldo.EnderecoId != EnderecoId || saldo.ProdutoId != ProdutoId || saldo.LoteId != LoteId)
        {
            throw new InvalidOperationException("The balance does not match the reservation.");
        }

        saldo.Release(Quantidade);
        Status = status;
        EncerradaPor = usuarioId;
        EncerradaEm = agora;
    }
}
