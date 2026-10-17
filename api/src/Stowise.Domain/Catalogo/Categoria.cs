using Stowise.Domain.Common;

namespace Stowise.Domain.Catalogo;

/// <summary>Categoria de produtos em hierarquia. Ciclos e nomes repetidos entre irmãs são barrados no serviço.</summary>
public sealed class Categoria : Entity
{
    public const int NomeMaxLength = 80;

    private Categoria()
    {
    }

    public string Nome { get; private set; } = null!;

    public Guid? ParentId { get; private set; }

    public static Categoria Create(string nome, Guid? parentId) => new()
    {
        Nome = Guard.Required(nome, "Nome da categoria", NomeMaxLength),
        ParentId = parentId,
    };

    public void Update(string nome, Guid? parentId)
    {
        if (parentId == Id)
        {
            throw new DomainException("Uma categoria não pode ser a própria categoria pai.");
        }

        Nome = Guard.Required(nome, "Nome da categoria", NomeMaxLength);
        ParentId = parentId;
    }
}
