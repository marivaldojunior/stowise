using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Estoque;
using Stowise.Domain.Estoque;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Estoque;

/// <summary>Cria e cancela reservas. Alterar a quantidade reservada do saldo segue o ADR-0006 (xmin e nova tentativa).</summary>
internal sealed class ReservaService(StowiseDbContext db, TimeProvider time) : IReservaService
{
    public async Task<Result<ReservaDetalhe>> CreateAsync(CriarReserva comando, Guid usuarioId, CancellationToken cancellationToken = default)
    {
        var errors = EstoqueValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        return await RetryAsync(
            async () =>
            {
                var produto = await db.Produtos.FirstOrDefaultAsync(p => p.Id == comando.ProdutoId, cancellationToken);
                if (produto is null)
                {
                    return AppError.Validation("produtoId", "Produto não encontrado.");
                }

                var endereco = await db.Enderecos.FindAsync([comando.EnderecoId!.Value], cancellationToken);
                if (endereco is null)
                {
                    return AppError.Validation("enderecoId", "Endereço não encontrado.");
                }

                Lote? lote = null;
                if (!string.IsNullOrWhiteSpace(comando.Lote))
                {
                    var numero = Lote.NormalizeNumero(comando.Lote);
                    lote = await db.Lotes.FirstOrDefaultAsync(l => l.ProdutoId == produto.Id && l.Numero == numero, cancellationToken);
                    if (lote is null)
                    {
                        return AppError.BusinessRule($"O lote {numero} não existe para este produto.");
                    }
                }

                var saldo = await db.Saldos.FirstOrDefaultAsync(
                    s => s.EnderecoId == endereco.Id && s.ProdutoId == produto.Id && s.LoteId == (lote == null ? null : lote.Id),
                    cancellationToken);
                if (saldo is null)
                {
                    return AppError.BusinessRule($"Não há saldo deste produto{(lote is null ? string.Empty : $" e lote {lote.Numero}")} no endereço {endereco.Codigo}.");
                }

                var reserva = Reserva.Create(produto, lote, endereco, saldo, comando.Quantidade!.Value, comando.DocumentoReferencia, usuarioId, time.GetUtcNow());
                db.Reservas.Add(reserva);
                await db.SaveChangesAsync(cancellationToken);
                return ToDetalhe(reserva, lote?.Numero);
            },
            cancellationToken);
    }

    public Task<Result<ReservaDetalhe>> CancelAsync(Guid id, Guid usuarioId, CancellationToken cancellationToken = default) =>
        RetryAsync(
            async () =>
            {
                var reserva = await db.Reservas.FindAsync([id], cancellationToken);
                if (reserva is null)
                {
                    return NotFound();
                }

                var saldo = await db.Saldos.FirstAsync(
                    s => s.EnderecoId == reserva.EnderecoId && s.ProdutoId == reserva.ProdutoId && s.LoteId == reserva.LoteId,
                    cancellationToken);
                reserva.Cancel(saldo, usuarioId, time.GetUtcNow());
                await db.SaveChangesAsync(cancellationToken);
                return await DetalheAsync(id, cancellationToken) is { } detalhe ? detalhe : NotFound();
            },
            cancellationToken);

    public async Task<Result<ReservaDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default) =>
        await DetalheAsync(id, cancellationToken) is { } detalhe ? detalhe : NotFound();

    /// <summary>Repete a operação com dados frescos quando o saldo ou a reserva mudaram no meio do caminho.</summary>
    private async Task<Result<ReservaDetalhe>> RetryAsync(Func<Task<Result<ReservaDetalhe>>> operacao, CancellationToken cancellationToken)
    {
        for (var tentativa = 1; ; tentativa++)
        {
            try
            {
                return await operacao();
            }
            catch (DbUpdateException e) when (tentativa < EstoqueRetry.MaxTentativas && EstoqueRetry.IsRetryable(e))
            {
                db.ChangeTracker.Clear();
                await EstoqueRetry.DelayAsync(tentativa, time, cancellationToken);
            }
        }
    }

    private async Task<ReservaDetalhe?> DetalheAsync(Guid id, CancellationToken cancellationToken)
    {
        var encontrada = await (
                from r in db.Reservas.AsNoTracking()
                join l in db.Lotes on r.LoteId equals l.Id into lotes
                from l in lotes.DefaultIfEmpty()
                where r.Id == id
                select new { r, LoteNumero = l == null ? null : l.Numero })
            .FirstOrDefaultAsync(cancellationToken);

        return encontrada is null ? null : ToDetalhe(encontrada.r, encontrada.LoteNumero);
    }

    private static ReservaDetalhe ToDetalhe(Reserva r, string? loteNumero) =>
        new(
            r.Id,
            r.EnderecoId,
            r.ProdutoId,
            r.LoteId,
            loteNumero,
            r.Quantidade,
            r.DocumentoReferencia,
            r.Status,
            r.CriadaPor,
            r.CriadaEm,
            r.EncerradaPor,
            r.EncerradaEm,
            r.MovimentacaoId);

    private static AppError NotFound() => AppError.NotFound("Reserva não encontrada.");
}
