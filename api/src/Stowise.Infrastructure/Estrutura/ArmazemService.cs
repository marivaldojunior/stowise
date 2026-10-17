using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Estrutura;
using Stowise.Domain.Estrutura;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Estrutura;

internal sealed class ArmazemService(StowiseDbContext db) : IArmazemService
{
    public async Task<IReadOnlyList<ArmazemResumo>> ListAsync(CancellationToken cancellationToken = default) =>
        await db.Armazens.AsNoTracking()
            .OrderBy(a => a.Codigo)
            .Select(a => new ArmazemResumo(
                a.Id,
                a.Codigo,
                a.Nome,
                a.Zonas.Count,
                db.Enderecos.Count(e => e.ArmazemId == a.Id)))
            .ToListAsync(cancellationToken);

    public async Task<Result<ArmazemDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var detalhe = await DetalheAsync(id, cancellationToken);
        return detalhe is null ? NotFound() : detalhe;
    }

    public async Task<Result<ArmazemDetalhe>> CreateAsync(CriarArmazem comando, CancellationToken cancellationToken = default)
    {
        var errors = EstruturaValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var armazem = Armazem.Create(comando.Codigo!, comando.Nome!);
        if (await db.Armazens.AnyAsync(a => a.Codigo == armazem.Codigo, cancellationToken))
        {
            return AppError.Conflict($"Já existe um armazém com o código {armazem.Codigo}.");
        }

        db.Armazens.Add(armazem);
        await db.SaveChangesAsync(cancellationToken);
        return (await DetalheAsync(armazem.Id, cancellationToken))!;
    }

    public async Task<Result<ArmazemDetalhe>> RenameAsync(Guid id, RenomearArmazem comando, CancellationToken cancellationToken = default)
    {
        var errors = EstruturaValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var armazem = await db.Armazens.FindAsync([id], cancellationToken);
        if (armazem is null)
        {
            return NotFound();
        }

        armazem.Rename(comando.Nome!);
        await db.SaveChangesAsync(cancellationToken);
        return (await DetalheAsync(id, cancellationToken))!;
    }

    public async Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var armazem = await LoadAsync(id, cancellationToken);
        if (armazem is null)
        {
            return NotFound();
        }

        if (armazem.Zonas.Count > 0)
        {
            return AppError.BusinessRule("O armazém tem zonas. Remova as zonas antes de excluir o armazém.");
        }

        db.Armazens.Remove(armazem);
        await db.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result<ArmazemDetalhe>> AddZonaAsync(Guid armazemId, SalvarZona comando, CancellationToken cancellationToken = default)
    {
        var errors = EstruturaValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var armazem = await LoadAsync(armazemId, cancellationToken);
        if (armazem is null)
        {
            return NotFound();
        }

        if (ZonaCodigoEmUso(armazem, comando.Codigo!, exceptZonaId: null) is { } conflito)
        {
            return conflito;
        }

        armazem.AddZona(comando.Codigo!, comando.ClasseArmazenagem!.Value);
        await db.SaveChangesAsync(cancellationToken);
        return (await DetalheAsync(armazemId, cancellationToken))!;
    }

    public async Task<Result<ArmazemDetalhe>> UpdateZonaAsync(
        Guid armazemId,
        Guid zonaId,
        SalvarZona comando,
        CancellationToken cancellationToken = default)
    {
        var errors = EstruturaValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var armazem = await LoadAsync(armazemId, cancellationToken);
        if (armazem is null || armazem.Zonas.All(z => z.Id != zonaId))
        {
            return armazem is null ? NotFound() : ZonaNotFound();
        }

        if (ZonaCodigoEmUso(armazem, comando.Codigo!, zonaId) is { } conflito)
        {
            return conflito;
        }

        armazem.UpdateZona(zonaId, comando.Codigo!, comando.ClasseArmazenagem!.Value);
        await db.SaveChangesAsync(cancellationToken);
        return (await DetalheAsync(armazemId, cancellationToken))!;
    }

    public async Task<Result<ArmazemDetalhe>> RemoveZonaAsync(Guid armazemId, Guid zonaId, CancellationToken cancellationToken = default)
    {
        var armazem = await LoadAsync(armazemId, cancellationToken);
        if (armazem is null || armazem.Zonas.All(z => z.Id != zonaId))
        {
            return armazem is null ? NotFound() : ZonaNotFound();
        }

        if (await db.Enderecos.AnyAsync(e => e.ZonaId == zonaId, cancellationToken))
        {
            return AppError.BusinessRule("A zona tem endereços. Exclua os endereços antes de remover a zona.");
        }

        armazem.RemoveZona(zonaId);
        await db.SaveChangesAsync(cancellationToken);
        return (await DetalheAsync(armazemId, cancellationToken))!;
    }

    private Task<Armazem?> LoadAsync(Guid id, CancellationToken cancellationToken) =>
        db.Armazens.Include(a => a.Zonas).FirstOrDefaultAsync(a => a.Id == id, cancellationToken);

    private async Task<ArmazemDetalhe?> DetalheAsync(Guid id, CancellationToken cancellationToken)
    {
        var armazem = await db.Armazens.AsNoTracking().Include(a => a.Zonas).FirstOrDefaultAsync(a => a.Id == id, cancellationToken);
        if (armazem is null)
        {
            return null;
        }

        var enderecosPorZona = await db.Enderecos.AsNoTracking()
            .Where(e => e.ArmazemId == id)
            .GroupBy(e => e.ZonaId)
            .Select(g => new { ZonaId = g.Key, Total = g.Count() })
            .ToDictionaryAsync(g => g.ZonaId, g => g.Total, cancellationToken);

        return new ArmazemDetalhe(
            armazem.Id,
            armazem.Codigo,
            armazem.Nome,
            [.. armazem.Zonas
                .OrderBy(z => z.Codigo, StringComparer.Ordinal)
                .Select(z => new ZonaDetalhe(z.Id, z.Codigo, z.ClasseArmazenagem, enderecosPorZona.GetValueOrDefault(z.Id)))]);
    }

    private static AppError? ZonaCodigoEmUso(Armazem armazem, string codigo, Guid? exceptZonaId)
    {
        var normalizado = codigo.Trim().ToUpperInvariant();
        return armazem.Zonas.Any(z => z.Codigo == normalizado && z.Id != exceptZonaId)
            ? AppError.Conflict($"A zona {normalizado} já existe no armazém {armazem.Codigo}.")
            : null;
    }

    private static AppError NotFound() => AppError.NotFound("Armazém não encontrado.");

    private static AppError ZonaNotFound() => AppError.NotFound("Zona não encontrada neste armazém.");
}
