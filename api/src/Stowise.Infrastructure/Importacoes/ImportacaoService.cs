using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Npgsql;
using Stowise.Application.Common;
using Stowise.Application.Importacoes;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Importacoes;

internal sealed partial class ImportacaoService(
    StowiseDbContext db,
    IFilaTrabalhos fila,
    INotificadorImportacao notificador,
    TimeProvider time,
    ILogger<ImportacaoService> logger) : IImportacaoService
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

        // Arquivo com estrutura conhecida: o mapeamento confirmado antes vira a sugestão, sem chamar a IA.
        if (importacao.Fingerprint is { } fingerprint
            && await db.TemplatesImportacao.FirstOrDefaultAsync(t => t.Tipo == comando.Tipo && t.Fingerprint == fingerprint, cancellationToken) is { } template)
        {
            importacao.ApplyTemplate(template);
        }

        db.Importacoes.Add(importacao);
        db.ArquivosImportacao.Add(ArquivoImportacao.Create(importacao, conteudo));
        await db.SaveChangesAsync(cancellationToken);
        return ToDetalhe(importacao);
    }

    public async Task<Result<ImportacaoDetalhe>> ConfirmarMapeamentoAsync(Guid id, ConfirmarMapeamento comando, Guid usuarioId, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var importacao = await db.Importacoes.FirstOrDefaultAsync(i => i.Id == id, cancellationToken);
        if (importacao is null)
        {
            return NotFound();
        }

        var errors = ImportacaoValidation.Validate(comando, importacao.Tipo);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        if (importacao.Versao != comando.Versao)
        {
            return AppError.Conflict("A importação foi alterada por outra pessoa depois que você a abriu. Recarregue e tente de novo.");
        }

        var colunas = comando.Colunas!;
        var foraDoArquivo = colunas.Select((m, i) => (m, i)).Where(x => x.m.Coluna >= importacao.Colunas.Count).ToList();
        if (foraDoArquivo.Count > 0)
        {
            return AppError.Validation(foraDoArquivo.ToDictionary(
                x => $"colunas[{x.i}].coluna",
                _ => new[] { $"O arquivo tem {importacao.Colunas.Count} colunas (de 0 a {importacao.Colunas.Count - 1})." }));
        }

        if (comando.SalvarTemplate && importacao.Fingerprint is null)
        {
            return AppError.Validation("salvarTemplate", "Arquivo delimitado sem cabeçalho não gera template: não há como reconhecê-lo depois.");
        }

        var agora = time.GetUtcNow();
        var novoUso = importacao.MapeamentoConfirmadoPor is null;
        db.Entry(importacao).Property(i => i.Versao).OriginalValue = comando.Versao!.Value;
        importacao.ConfirmMapeamento(colunas, usuarioId, agora);

        var template = importacao.Fingerprint is null
            ? null
            : await db.TemplatesImportacao.FirstOrDefaultAsync(t => t.Tipo == importacao.Tipo && t.Fingerprint == importacao.Fingerprint, cancellationToken);
        if (template is null && comando.SalvarTemplate)
        {
            var nome = string.IsNullOrWhiteSpace(comando.NomeTemplate) ? Path.GetFileNameWithoutExtension(importacao.NomeArquivo) : comando.NomeTemplate;
            template = TemplateImportacao.Create(importacao, nome, sugeridoPorIa: false, usuarioId, agora);
            db.TemplatesImportacao.Add(template);
        }
        else if (template is not null && (comando.SalvarTemplate || importacao.Mapeamento!.SequenceEqual(template.Mapeamento)))
        {
            // Sem "salvar", o template só conta o uso; com "salvar", também passa a ter o mapeamento confirmado agora.
            template.RegisterUse(importacao, novoUso, sugeridoPorIa: false, usuarioId, agora);
            if (comando.SalvarTemplate && !string.IsNullOrWhiteSpace(comando.NomeTemplate))
            {
                template.Rename(comando.NomeTemplate);
            }
        }
        else
        {
            template = null;
        }

        if (template is not null)
        {
            importacao.LinkTemplate(template);
        }

        await db.SaveChangesAsync(cancellationToken);

        // ADR-0007: o staging roda em background. Sem fila, a importação falha com o motivo em vez de ficar
        // parada em Validando.
        try
        {
            fila.EnfileirarStaging(importacao.Id);
        }
        catch (Exception e) when (e is not OperationCanceledException)
        {
            LogEnqueueFailed(e, importacao.Id);
            importacao.Fail("Não foi possível agendar a validação das linhas. Confirme o mapeamento de novo.", time.GetUtcNow());
            await db.SaveChangesAsync(cancellationToken);
        }

        await notificador.NotificarAsync(ProgressoImportacao.From(importacao), cancellationToken);
        return ToDetalhe(importacao);
    }

    [LoggerMessage(Level = LogLevel.Error, Message = "Could not enqueue the staging of import {ImportacaoId}")]
    private partial void LogEnqueueFailed(Exception exception, Guid importacaoId);

    public async Task<Result<ImportacaoDetalhe>> EfetivarAsync(Guid id, EfetivarImportacao comando, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(comando);

        if (comando.Versao is null)
        {
            return AppError.Validation("versao", "Informe a versão da importação lida antes da efetivação.");
        }

        var importacao = await db.Importacoes.FirstOrDefaultAsync(i => i.Id == id, cancellationToken);
        if (importacao is null)
        {
            return NotFound();
        }

        if (importacao.Versao != comando.Versao)
        {
            return AppError.Conflict("A importação foi alterada por outra pessoa depois que você a abriu. Recarregue e tente de novo.");
        }

        db.Entry(importacao).Property(i => i.Versao).OriginalValue = comando.Versao.Value;
        importacao.StartEfetivacao();
        await db.SaveChangesAsync(cancellationToken);

        try
        {
            fila.EnfileirarEfetivacao(importacao.Id);
        }
        catch (Exception e) when (e is not OperationCanceledException)
        {
            LogEnqueueFailed(e, importacao.Id);
            importacao.Fail("Não foi possível agendar a gravação no catálogo. Envie o arquivo de novo.", time.GetUtcNow());
            await db.SaveChangesAsync(cancellationToken);
        }

        await notificador.NotificarAsync(ProgressoImportacao.From(importacao), cancellationToken);
        return ToDetalhe(importacao);
    }

    public async Task<Result<RelatorioImportacao>> GetRelatorioAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var importacao = await db.Importacoes.AsNoTracking().FirstOrDefaultAsync(i => i.Id == id, cancellationToken);
        if (importacao is null)
        {
            return NotFound();
        }

        var erros = await ErrosPorCampoAsync(id, cancellationToken);

        return new RelatorioImportacao(
            importacao.Id,
            importacao.NomeArquivo,
            importacao.Status,
            importacao.TotalLinhas,
            importacao.LinhasValidas,
            importacao.LinhasComErro,
            importacao.LinhasPossivelDuplicata,
            importacao.ProdutosCriados,
            importacao.ProdutosAtualizados,
            erros,
            importacao.IniciadoEm,
            importacao.ConcluidoEm,
            importacao.MotivoFalha);
    }

    /// <summary>
    /// Os erros ficam num array <c>jsonb</c> por linha; o agrupamento por campo é feito no banco. Leitura por
    /// posição, com ADO.NET, para não depender do mapeamento de nomes de coluna de um tipo sem entidade.
    /// </summary>
    private async Task<SortedDictionary<string, int>> ErrosPorCampoAsync(Guid importacaoId, CancellationToken cancellationToken)
    {
        var erros = new SortedDictionary<string, int>(StringComparer.Ordinal);
        await db.Database.OpenConnectionAsync(cancellationToken);
        try
        {
            await using var comando = db.Database.GetDbConnection().CreateCommand();
            comando.CommandText = """
                SELECT e.erro ->> 'campo', count(*)::int
                FROM importacao_linhas l, jsonb_array_elements(l.erros) AS e(erro)
                WHERE l.importacao_id = @id
                GROUP BY 1
                """;
            comando.Parameters.Add(new NpgsqlParameter("id", importacaoId));
            await using var leitor = await comando.ExecuteReaderAsync(cancellationToken);
            while (await leitor.ReadAsync(cancellationToken))
            {
                erros[leitor.IsDBNull(0) ? "linha" : leitor.GetString(0)] = leitor.GetInt32(1);
            }
        }
        finally
        {
            await db.Database.CloseConnectionAsync();
        }

        return erros;
    }

    public async Task<Result<ImportacaoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var importacao = await db.Importacoes.AsNoTracking().FirstOrDefaultAsync(i => i.Id == id, cancellationToken);
        return importacao is null ? NotFound() : ToDetalhe(importacao);
    }

    public async Task<Result<PagedResult<ImportacaoLinhaDetalhe>>> ListLinhasAsync(Guid id, LinhaFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);

        if (!await db.Importacoes.AnyAsync(i => i.Id == id, cancellationToken))
        {
            return NotFound();
        }

        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);
        var query = db.ImportacaoLinhas.AsNoTracking().Where(l => l.ImportacaoId == id);
        if (filtro.Status is { } status)
        {
            query = query.Where(l => l.Status == status);
        }

        if (filtro.Acao is { } acao)
        {
            query = query.Where(l => l.Acao == acao);
        }

        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .OrderBy(l => l.NumeroLinha)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .ToListAsync(cancellationToken);

        return new PagedResult<ImportacaoLinhaDetalhe>(
            [.. itens.Select(l => new ImportacaoLinhaDetalhe(l.Id, l.NumeroLinha, l.DadosBrutos, l.DadosNormalizados, l.Status, l.Acao, l.ProdutoCorrespondenteId, l.Similaridade, l.Erros, l.EfetivadaEm))],
            pagina,
            tamanhoPagina,
            total);
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
            .Select(i => new ImportacaoResumo(i.Id, i.Tipo, i.Formato, i.Status, i.NomeArquivo, i.TotalLinhas, i.LinhasValidas, i.LinhasComErro, i.UsuarioId, i.IniciadoEm, i.ConcluidoEm))
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
            i.ConcluidoEm,
            i.Fingerprint,
            i.TemplateId,
            i.Mapeamento,
            i.MapeamentoConfirmadoPor,
            i.MapeamentoConfirmadoEm,
            i.LinhasValidas,
            i.LinhasComErro,
            i.LinhasPossivelDuplicata,
            i.LinhasProcessadas,
            i.ProdutosCriados,
            i.ProdutosAtualizados,
            i.MotivoFalha,
            i.Versao);

    private static AppError NotFound() => AppError.NotFound("Importação não encontrada.");
}

