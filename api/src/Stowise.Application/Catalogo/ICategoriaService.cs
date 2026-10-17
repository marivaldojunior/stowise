using Stowise.Application.Common;

namespace Stowise.Application.Catalogo;

public interface ICategoriaService
{
    /// <summary>Todas as categorias, ordenadas pelo caminho completo (ex.: "Bebidas › Refrigerantes").</summary>
    Task<IReadOnlyList<CategoriaDetalhe>> ListAsync(CancellationToken cancellationToken = default);

    Task<Result<CategoriaDetalhe>> CreateAsync(SalvarCategoria comando, CancellationToken cancellationToken = default);

    /// <summary>Renomeia ou move a categoria. Mover para uma descendente criaria um ciclo e é recusado.</summary>
    Task<Result<CategoriaDetalhe>> UpdateAsync(Guid id, SalvarCategoria comando, CancellationToken cancellationToken = default);

    /// <summary>Exclui só categorias sem subcategorias e sem produtos.</summary>
    Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default);
}

public sealed record CategoriaDetalhe(Guid Id, string Nome, Guid? ParentId, string Caminho);

public sealed record SalvarCategoria(string? Nome, Guid? ParentId);
