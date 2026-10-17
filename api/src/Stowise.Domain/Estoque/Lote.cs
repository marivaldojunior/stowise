using Stowise.Domain.Common;

namespace Stowise.Domain.Estoque;

/// <summary>Lote de fabricação de um produto. O número é único por produto.</summary>
public sealed class Lote : Entity
{
    public const int NumeroMaxLength = 40;

    private Lote()
    {
    }

    public Guid ProdutoId { get; private set; }

    public string Numero { get; private set; } = null!;

    public DateOnly? Fabricacao { get; private set; }

    public DateOnly? Validade { get; private set; }

    public static Lote Create(Guid produtoId, string numero, DateOnly? fabricacao, DateOnly? validade)
    {
        if (fabricacao is not null && validade is not null && validade < fabricacao)
        {
            throw new DomainException("A validade do lote não pode ser anterior à fabricação.");
        }

        return new Lote
        {
            ProdutoId = produtoId,
            Numero = NormalizeNumero(numero),
            Fabricacao = fabricacao,
            Validade = validade,
        };
    }

    public static string NormalizeNumero(string? numero) =>
        Guard.Required(numero, "Número do lote", NumeroMaxLength).ToUpperInvariant();
}
