using System.Globalization;
using Microsoft.EntityFrameworkCore;
using Stowise.Application.Armazenagem;
using Stowise.Application.Common;
using Stowise.Application.Estoque;
using Stowise.Domain.Armazenagem;
using Stowise.Domain.Common;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Armazenagem;

internal sealed class TarefaArmazenagemService(StowiseDbContext db, IMovimentacaoService movimentacoes, TimeProvider time) : ITarefaArmazenagemService
{
    public async Task<PagedResult<TarefaArmazenagemResumo>> ListAsync(TarefaArmazenagemFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query = db.TarefasArmazenagem.AsNoTracking();
        if (filtro.Status is { } status)
        {
            query = query.Where(t => t.Status == status);
        }

        if (filtro.RecebimentoId is { } recebimentoId)
        {
            query = query.Where(t => t.RecebimentoId == recebimentoId);
        }

        var total = await query.CountAsync(cancellationToken);
        var ids = await query
            .OrderBy(t => t.CriadoEm)
            .ThenBy(t => t.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .Select(t => t.Id)
            .ToListAsync(cancellationToken);

        var itens = (await LoadAsync(ids, cancellationToken)).Select(x => x.Resumo).ToList();
        return new PagedResult<TarefaArmazenagemResumo>(itens, pagina, tamanhoPagina, total);
    }

    public async Task<Result<TarefaArmazenagemDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default) =>
        await DetalheAsync(id, cancellationToken) is { } detalhe ? detalhe : NotFound();

    public async Task<Result<TarefaArmazenagemDetalhe>> ConfirmAsync(
        Guid id,
        ConfirmarTarefaArmazenagem comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(comando);
        if (comando.EnderecoId is not { } enderecoId)
        {
            return AppError.Validation("enderecoId", "Informe o endereço onde a mercadoria foi guardada.");
        }

        // Sem rastreio: o serviço de movimentação limpa o ChangeTracker quando repete a operação.
        var tarefa = await db.TarefasArmazenagem.AsNoTracking().FirstOrDefaultAsync(t => t.Id == id, cancellationToken);
        if (tarefa is null)
        {
            return NotFound();
        }

        if (JaConfirmada(tarefa, enderecoId))
        {
            return (await DetalheAsync(id, cancellationToken))!;
        }

        var produto = await db.Produtos.AsNoTracking().Where(p => p.Id == tarefa.ProdutoId).Select(p => new { p.ClasseArmazenagem }).FirstAsync(cancellationToken);
        var zona = await (
                from e in db.Enderecos.AsNoTracking()
                join z in db.Zonas on e.ZonaId equals z.Id
                where e.Id == enderecoId
                select new { e.Codigo, z.ClasseArmazenagem })
            .FirstOrDefaultAsync(cancellationToken);
        if (zona is null)
        {
            return AppError.BusinessRule("Endereço não encontrado.");
        }

        string? motivo;
        try
        {
            motivo = tarefa.EnsureConfirmavel(enderecoId, comando.MotivoDivergencia);
        }
        catch (DomainException e)
        {
            return AppError.BusinessRule(e.Message);
        }

        // A zona é uma restrição de segurança: vale também quando o operador escolhe outro endereço (ADR-0012).
        if (zona.ClasseArmazenagem != produto.ClasseArmazenagem)
        {
            return AppError.BusinessRule($"O endereço {zona.Codigo} é de uma zona {zona.ClasseArmazenagem}; o produto é {produto.ClasseArmazenagem}.");
        }

        var nota = await db.Recebimentos.AsNoTracking().Where(r => r.Id == tarefa.RecebimentoId).Select(r => new { r.Numero, r.Serie }).FirstAsync(cancellationToken);
        var lote = tarefa.LoteNumero is null ? null : new LoteInformado(tarefa.LoteNumero, tarefa.LoteFabricacao, tarefa.LoteValidade);
        var entrada = await movimentacoes.RegistrarEntradaAsync(
            new RegistrarEntrada(
                tarefa.ProdutoId,
                EmbalagemId: null,
                enderecoId,
                tarefa.Quantidade,
                lote,
                string.Create(CultureInfo.InvariantCulture, $"NF-e {nota.Numero}/{nota.Serie}"),
                comando.DispositivoId,
                comando.OcorridoEm,
                IdempotencyKey: tarefa.Id),
            usuarioId,
            cancellationToken);
        if (!entrada.IsSuccess)
        {
            return entrada.Error!;
        }

        db.ChangeTracker.Clear();
        var rastreada = await db.TarefasArmazenagem.FirstAsync(t => t.Id == id, cancellationToken);
        if (!JaConfirmada(rastreada, enderecoId))
        {
            rastreada.Confirm(enderecoId, motivo, entrada.Value.Movimentacao.Id, usuarioId, time.GetUtcNow());
            try
            {
                await db.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateConcurrencyException)
            {
                // Outra confirmação da mesma tarefa gravou antes; a entrada no estoque é a mesma (mesma chave).
                db.ChangeTracker.Clear();
            }
        }

        return (await DetalheAsync(id, cancellationToken))!;
    }

    /// <summary>Repetição da mesma confirmação (ex.: a resposta se perdeu na rede): devolve a tarefa como está.</summary>
    private static bool JaConfirmada(TarefaArmazenagem tarefa, Guid enderecoId) =>
        tarefa.Status != StatusTarefaArmazenagem.Pendente && tarefa.EnderecoConfirmadoId == enderecoId;

    private async Task<TarefaArmazenagemDetalhe?> DetalheAsync(Guid id, CancellationToken cancellationToken)
    {
        var linhas = await LoadAsync([id], cancellationToken);
        if (linhas.Count == 0)
        {
            return null;
        }

        var linha = linhas[0];
        return new TarefaArmazenagemDetalhe(
                linha.Resumo, linha.Tarefa.Notas, linha.Tarefa.RegrasVersao, linha.Tarefa.EnderecoConfirmadoId, linha.Tarefa.MovimentacaoId, linha.Tarefa.ConcluidoPor);
    }

    /// <summary>Tarefas com a nota, o produto e os códigos dos endereços, na ordem dos ids.</summary>
    private async Task<IReadOnlyList<(TarefaArmazenagem Tarefa, TarefaArmazenagemResumo Resumo)>> LoadAsync(IReadOnlyList<Guid> ids, CancellationToken cancellationToken)
    {
        var linhas = await (
                from t in db.TarefasArmazenagem.AsNoTracking()
                join r in db.Recebimentos on t.RecebimentoId equals r.Id
                join p in db.Produtos on t.ProdutoId equals p.Id
                join s in db.Enderecos on t.EnderecoSugeridoId equals s.Id into sugeridos
                from s in sugeridos.DefaultIfEmpty()
                join c in db.Enderecos on t.EnderecoConfirmadoId equals c.Id into confirmados
                from c in confirmados.DefaultIfEmpty()
                where ids.Contains(t.Id)
                select new
                {
                    Tarefa = t,
                    r.Numero,
                    p.Sku,
                    p.Descricao,
                    p.UnidadeBase,
                    Sugerido = s == null ? null : s.Codigo,
                    Confirmado = c == null ? null : c.Codigo,
                })
            .ToListAsync(cancellationToken);

        var ordem = ids.Select((id, i) => (id, i)).ToDictionary(x => x.id, x => x.i);
        return linhas
            .OrderBy(x => ordem[x.Tarefa.Id])
            .Select(x =>
            {
                var t = x.Tarefa;
                var resumo = new TarefaArmazenagemResumo(
                    t.Id, t.RecebimentoId, x.Numero, t.ProdutoId, x.Sku, x.Descricao, x.UnidadeBase, t.LoteNumero, t.LoteValidade, t.Quantidade,
                    t.EnderecoSugeridoId, x.Sugerido, t.Pontuacao, t.Status, x.Confirmado, t.MotivoDivergencia, t.CriadoEm, t.ConcluidoEm);
                return (t, resumo);
            })
            .ToList();
    }

    private static AppError NotFound() => AppError.NotFound("Tarefa de armazenagem não encontrada.");
}
