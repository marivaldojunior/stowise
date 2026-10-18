using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Importacoes;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Importacoes;

internal sealed class ImportacaoService(StowiseDbContext db, TimeProvider time) : IImportacaoService
{
    public async Task<Result<ImportacaoDetalhe>> ReceberAsync(ReceberArquivo comando, Guid usuarioId, CancellationToken cancellationToken = default)
    {
        var errors = ImportacaoValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var conteudo = comando.Conteudo!;

        // A detecção não usa o banco: um arquivo ilegível é recusado antes de qualquer consulta.
        var deteccao = DetectorLayout.IsZip(conteudo) ? LeitorXlsx.Detect(conteudo) : DetectorLayout.Detect(conteudo);
        if (!deteccao.IsSuccess)
        {
            return deteccao.Error!;
        }

        var hash = Convert.ToHexStringLower(SHA256.HashData(conteudo));
        var anterior = await db.Importacoes.AsNoTracking()
            .Where(i => i.Tipo == comando.Tipo && i.HashArquivo == hash && i.Status != StatusImportacao.Falhou)
            .Select(i => new { i.Id, i.NomeArquivo })
            .FirstOrDefaultAsync(cancellationToken);
        if (anterior is not null)
        {
            return AppError.Conflict($"Este arquivo já foi enviado como {anterior.NomeArquivo} (importação {anterior.Id}).");
        }

        var arquivo = deteccao.Value;
        var importacao = Importacao.Create(
            comando.Tipo,
            Path.GetFileName(comando.NomeArquivo!.Trim()),
            hash,
            conteudo.LongLength,
            arquivo.Layout,
            arquivo.Amostra,
            arquivo.TotalLinhas,
            usuarioId,
            time.GetUtcNow());

        db.Importacoes.Add(importacao);
        db.ArquivosImportacao.Add(ArquivoImportacao.Create(importacao, conteudo));
        await db.SaveChangesAsync(cancellationToken);
        return ToDetalhe(importacao);
    }

    public async Task<Result<ImportacaoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var importacao = await db.Importacoes.AsNoTracking().FirstOrDefaultAsync(i => i.Id == id, cancellationToken);
        return importacao is null ? AppError.NotFound("Importação não encontrada.") : ToDetalhe(importacao);
    }

    public async Task<PagedResult<ImportacaoResumo>> ListAsync(ImportacaoFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query = db.Importacoes.AsNoTracking();
        if (filtro.Tipo is { } tipo)
        {
            query = query.Where(i => i.Tipo == tipo);
        }

        if (filtro.Status is { } status)
        {
            query = query.Where(i => i.Status == status);
        }

        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .OrderByDescending(i => i.IniciadoEm)
            .ThenByDescending(i => i.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .Select(i => new ImportacaoResumo(i.Id, i.Tipo, i.Formato, i.Status, i.NomeArquivo, i.TotalLinhas, i.UsuarioId, i.IniciadoEm, i.ConcluidoEm))
            .ToListAsync(cancellationToken);

        return new PagedResult<ImportacaoResumo>(itens, pagina, tamanhoPagina, total);
    }

    private static ImportacaoDetalhe ToDetalhe(Importacao i) =>
        new(
            i.Id,
            i.Tipo,
            i.Status,
            i.NomeArquivo,
            i.HashArquivo,
            i.TamanhoBytes,
            i.Layout,
            i.Amostra,
            i.TotalLinhas,
            i.UsuarioId,
            i.IniciadoEm,
            i.ConcluidoEm);
}
