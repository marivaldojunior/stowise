using Stowise.Domain.Common;

namespace Stowise.Domain.Estrutura;

/// <summary>Área do armazém que define onde cada classe de produto pode ficar.</summary>
public sealed class Zona : Entity
{
    public const int CodigoMaxLength = 20;

    private Zona()
    {
    }

    internal Zona(Guid armazemId, string codigo, ClasseArmazenagem classe)
    {
        ArmazemId = armazemId;
        Update(codigo, classe);
    }

    public Guid ArmazemId { get; private set; }

    public string Codigo { get; private set; } = null!;

    public ClasseArmazenagem ClasseArmazenagem { get; private set; }

    internal static string NormalizeCodigo(string codigo) =>
        Guard.Required(codigo, "Código da zona", CodigoMaxLength).ToUpperInvariant();

    internal void Update(string codigo, ClasseArmazenagem classe)
    {
        Codigo = NormalizeCodigo(codigo);
        ClasseArmazenagem = classe;
    }
}
