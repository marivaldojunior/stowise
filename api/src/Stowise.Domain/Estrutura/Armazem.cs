using Stowise.Domain.Common;

namespace Stowise.Domain.Estrutura;

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

    public Zona AddZona(string codigo, ClasseArmazenagem classe)
    {
        var zona = new Zona(Id, codigo, classe);
        if (_zonas.Exists(z => z.Codigo == zona.Codigo))
        {
            throw new DomainException($"A zona {zona.Codigo} já existe no armazém {Codigo}.");
        }

        _zonas.Add(zona);
        return zona;
    }
}
