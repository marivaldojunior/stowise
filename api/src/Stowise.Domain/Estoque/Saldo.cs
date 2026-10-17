using Stowise.Domain.Common;

namespace Stowise.Domain.Estoque;

/// <summary>
/// Projeção do livro-razão: quantidade de um produto (e lote) num endereço, na unidade base.
/// Só o serviço de movimentação altera o saldo (ADR-0001).
/// </summary>
public sealed class Saldo : Entity
{
    private Saldo()
    {
    }

    public Guid EnderecoId { get; private set; }

    public Guid ProdutoId { get; private set; }

    public Guid? LoteId { get; private set; }

    public decimal Quantidade { get; private set; }

    public decimal QuantidadeReservada { get; private set; }

    public decimal QuantidadeDisponivel => Quantidade - QuantidadeReservada;

    /// <summary>Versão para concorrência otimista (<c>xmin</c>, ADR-0006).</summary>
    public uint Versao { get; private set; }

    public static Saldo Create(Guid enderecoId, Guid produtoId, Guid? loteId) =>
        new() { EnderecoId = enderecoId, ProdutoId = produtoId, LoteId = loteId };

    internal void Add(decimal quantidade) => Quantidade += quantidade;

    internal void Remove(decimal quantidade)
    {
        if (quantidade > QuantidadeDisponivel)
        {
            throw new DomainException(
                $"Saldo insuficiente: disponível {QuantidadeDisponivel:0.####}, solicitado {quantidade:0.####}.");
        }

        Quantidade -= quantidade;
    }
}
