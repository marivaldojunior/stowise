using Stowise.Domain.Common;

namespace Stowise.Domain.Estrutura;

/// <summary>Agregado da estrutura física: o armazém é dono das zonas. O código não muda.</summary>
public sealed class Armazem : Entity
{
    public const int CodigoMaxLength = 20;
    public const int NomeMaxLength = 120;

    private readonly List<Zona> _zonas = [];

    private Armazem()
    {
    }

    public string Codigo { get; private set; } = null!;

    public string Nome { get; private set; } = null!;

    public IReadOnlyCollection<Zona> Zonas => _zonas.AsReadOnly();

    public static Armazem Create(string codigo, string nome) => new()
    {
        Codigo = Guard.Required(codigo, "Código do armazém", CodigoMaxLength).ToUpperInvariant(),
        Nome = Guard.Required(nome, "Nome do armazém", NomeMaxLength),
    };

    public void Rename(string nome) => Nome = Guard.Required(nome, "Nome do armazém", NomeMaxLength);

    public Zona AddZona(string codigo, ClasseArmazenagem classe)
    {
        EnsureCodigoLivre(Zona.NormalizeCodigo(codigo), except: null);
        var zona = new Zona(Id, codigo, classe);
        _zonas.Add(zona);
        return zona;
    }

    public Zona UpdateZona(Guid zonaId, string codigo, ClasseArmazenagem classe)
    {
        var zona = FindZona(zonaId);
        EnsureCodigoLivre(Zona.NormalizeCodigo(codigo), except: zona);
        zona.Update(codigo, classe);
        return zona;
    }

    /// <summary>Remove a zona. Quem chama garante que ela não tem endereços.</summary>
    public void RemoveZona(Guid zonaId) => _zonas.Remove(FindZona(zonaId));

    private Zona FindZona(Guid zonaId) =>
        _zonas.Find(z => z.Id == zonaId) ?? throw new DomainException("Zona não encontrada neste armazém.");

    private void EnsureCodigoLivre(string codigo, Zona? except)
    {
        if (_zonas.Exists(z => z != except && z.Codigo == codigo))
        {
            throw new DomainException($"A zona {codigo} já existe no armazém {Codigo}.");
        }
    }
}
