using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Importacoes;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Importacoes;

internal sealed class TemplateImportacaoService(StowiseDbContext db) : ITemplateImportacaoService
{
    public async Task<PagedResult<TemplateDetalhe>> ListAsync(TemplateFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query = db.TemplatesImportacao.AsNoTracking();
        if (filtro.Tipo is { } tipo)
        {
            query = query.Where(t => t.Tipo == tipo);
        }

        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .OrderBy(t => t.Nome)
            .ThenBy(t => t.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .ToListAsync(cancellationToken);

        return new PagedResult<TemplateDetalhe>([.. itens.Select(ToDetalhe)], pagina, tamanhoPagina, total);
    }

    public async Task<Result<TemplateDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var template = await db.TemplatesImportacao.AsNoTracking().FirstOrDefaultAsync(t => t.Id == id, cancellationToken);
        return template is null ? NotFound() : ToDetalhe(template);
    }

    public async Task<Result<TemplateDetalhe>> RenameAsync(Guid id, RenomearTemplate comando, CancellationToken cancellationToken = default)
    {
        var errors = ImportacaoValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var template = await db.TemplatesImportacao.FirstOrDefaultAsync(t => t.Id == id, cancellationToken);
        if (template is null)
        {
            return NotFound();
        }

        if (template.Versao != comando.Versao)
        {
            return AppError.Conflict("O template foi alterado depois que você o abriu. Recarregue e tente de novo.");
        }

        db.Entry(template).Property(t => t.Versao).OriginalValue = comando.Versao!.Value;
        template.Rename(comando.Nome!);
        await db.SaveChangesAsync(cancellationToken);
        return ToDetalhe(template);
    }

    public async Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var apagados = await db.TemplatesImportacao.Where(t => t.Id == id).ExecuteDeleteAsync(cancellationToken);
        return apagados == 0 ? NotFound() : Result.Success();
    }

    private static TemplateDetalhe ToDetalhe(TemplateImportacao t) =>
        new(
            t.Id,
            t.Tipo,
            t.Nome,
            t.Fingerprint,
            t.Formato,
            t.Encoding,
            t.Delimitador,
            t.SeparadorDecimal,
            t.Mapeamento,
            t.SugeridoPorIa,
            t.ConfirmadoPor,
            t.ConfirmadoEm,
            t.VezesUsado,
            t.UltimoUsoEm,
            t.Versao);

    private static AppError NotFound() => AppError.NotFound("Template de importação não encontrado.");
}
