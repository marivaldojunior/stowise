using System.Globalization;
using Microsoft.EntityFrameworkCore;
using Stowise.Application.Catalogo;
using Stowise.Application.Common;
using Stowise.Domain.Catalogo;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Catalogo;

internal sealed class CategoriaService(StowiseDbContext db) : ICategoriaService
{
    private const string Separador = " › ";

    private static readonly StringComparer PtBr = StringComparer.Create(CultureInfo.GetCultureInfo("pt-BR"), ignoreCase: true);

    public async Task<IReadOnlyList<CategoriaDetalhe>> ListAsync(CancellationToken cancellationToken = default)
    {
        var categorias = await db.Categorias.AsNoTracking().ToListAsync(cancellationToken);
        var porId = categorias.ToDictionary(c => c.Id);

        return [.. categorias
            .Select(c => new CategoriaDetalhe(c.Id, c.Nome, c.ParentId, Caminho(c, porId)))
            .OrderBy(c => c.Caminho, PtBr)];
    }

    public async Task<Result<CategoriaDetalhe>> CreateAsync(SalvarCategoria comando, CancellationToken cancellationToken = default)
    {
        var errors = CatalogoValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var nome = comando.Nome!.Trim();
        var invalid = await ValidateParentAndNameAsync(id: null, comando.ParentId, nome, cancellationToken);
        if (invalid is not null)
        {
            return invalid;
        }

        var categoria = Categoria.Create(nome, comando.ParentId);
        db.Categorias.Add(categoria);
        await db.SaveChangesAsync(cancellationToken);
        return await DetalheAsync(categoria.Id, cancellationToken);
    }

    public async Task<Result<CategoriaDetalhe>> UpdateAsync(Guid id, SalvarCategoria comando, CancellationToken cancellationToken = default)
    {
        var errors = CatalogoValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var categoria = await db.Categorias.FindAsync([id], cancellationToken);
        if (categoria is null)
        {
            return NotFound();
        }

        var nome = comando.Nome!.Trim();
        var invalid = await ValidateParentAndNameAsync(id, comando.ParentId, nome, cancellationToken);
        if (invalid is not null)
        {
            return invalid;
        }

        categoria.Update(nome, comando.ParentId);
        await db.SaveChangesAsync(cancellationToken);
        return await DetalheAsync(id, cancellationToken);
    }

    public async Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var categoria = await db.Categorias.FindAsync([id], cancellationToken);
        if (categoria is null)
        {
            return NotFound();
        }

        if (await db.Categorias.AnyAsync(c => c.ParentId == id, cancellationToken))
        {
            return AppError.BusinessRule("A categoria tem subcategorias. Mova ou exclua as subcategorias antes.");
        }

        if (await db.Produtos.AnyAsync(p => p.CategoriaId == id, cancellationToken))
        {
            return AppError.BusinessRule("A categoria tem produtos. Mude a categoria desses produtos antes.");
        }

        db.Categorias.Remove(categoria);
        await db.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    private async Task<AppError?> ValidateParentAndNameAsync(Guid? id, Guid? parentId, string nome, CancellationToken cancellationToken)
    {
        if (parentId is not null)
        {
            if (parentId == id)
            {
                return AppError.BusinessRule("Uma categoria não pode ser a própria categoria pai.");
            }

            var ancestrais = await db.Categorias.AsNoTracking()
                .Select(c => new { c.Id, c.ParentId })
                .ToDictionaryAsync(c => c.Id, c => c.ParentId, cancellationToken);
            if (!ancestrais.ContainsKey(parentId.Value))
            {
                return AppError.Validation("parentId", "Categoria pai não encontrada.");
            }

            // Sobe a partir da nova categoria pai: se passar pela própria categoria, a mudança criaria um ciclo.
            for (Guid? atual = parentId; atual is not null && id is not null; atual = ancestrais.GetValueOrDefault(atual.Value))
            {
                if (atual == id)
                {
                    return AppError.BusinessRule("Não é possível mover a categoria para dentro de uma subcategoria dela.");
                }
            }
        }

        // ILIKE sem curingas: igualdade sem diferenciar maiúsculas de minúsculas.
        var pattern = LikePattern.Escape(nome);
        var repetido = await db.Categorias.AnyAsync(
            c => c.ParentId == parentId && EF.Functions.ILike(c.Nome, pattern, LikePattern.EscapeCharacter) && c.Id != id,
            cancellationToken);
        return repetido ? AppError.Conflict($"Já existe a categoria \"{nome}\" neste nível.") : null;
    }

    private async Task<CategoriaDetalhe> DetalheAsync(Guid id, CancellationToken cancellationToken) =>
        (await ListAsync(cancellationToken)).Single(c => c.Id == id);

    private static string Caminho(Categoria categoria, Dictionary<Guid, Categoria> porId)
    {
        var nomes = new List<string> { categoria.Nome };
        var atual = categoria.ParentId;
        while (atual is not null && porId.TryGetValue(atual.Value, out var pai) && nomes.Count <= porId.Count)
        {
            nomes.Add(pai.Nome);
            atual = pai.ParentId;
        }

        nomes.Reverse();
        return string.Join(Separador, nomes);
    }

    private static AppError NotFound() => AppError.NotFound("Categoria não encontrada.");
}
