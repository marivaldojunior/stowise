using Hangfire;
using Microsoft.EntityFrameworkCore;
using Stowise.Application.Armazenagem;
using Stowise.Domain.Armazenagem;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estoque;
using Stowise.Infrastructure.Jobs;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Armazenagem;

/// <summary>
/// Job recorrente da curva ABC (ADR-0012): conta as saídas dos últimos <see cref="JanelaDias"/> dias, classifica pelo
/// <see cref="CurvaAbc"/> e grava só as classes que mudaram. Idempotente: rodar de novo sem saídas novas não muda nada.
/// Grava em lote, sem carregar os produtos, para não disputar a versão (<c>xmin</c>) com quem edita o cadastro.
/// </summary>
internal sealed class CurvaAbcJobs(StowiseDbContext db, TimeProvider time) : ICurvaAbcService
{
    public const string RecurringJobId = "curva-abc";
    public const int JanelaDias = 90;

    [Queue(Filas.Default)]
    [DisableConcurrentExecution(timeoutInSeconds: 60)]
    public async Task<ResumoCurvaAbc> RecalcularAsync(CancellationToken cancellationToken = default)
    {
        var desde = time.GetUtcNow().AddDays(-JanelaDias);
        var giro = await db.Movimentacoes.AsNoTracking()
            .Where(m => m.Tipo == TipoMovimentacao.Saida && m.OcorridoEm >= desde)
            .GroupBy(m => m.ProdutoId)
            .Select(g => new { ProdutoId = g.Key, Saidas = g.Count() })
            .ToDictionaryAsync(g => g.ProdutoId, g => (decimal)g.Saidas, cancellationToken);
        var produtos = await db.Produtos.AsNoTracking().Select(p => p.Id).ToListAsync(cancellationToken);

        var classes = CurvaAbc.Classificar(giro, produtos);
        var alterados = 0;
        foreach (var classe in Enum.GetValues<ClasseAbc>())
        {
            var ids = classes.Where(c => c.Value == classe).Select(c => c.Key).ToList();
            alterados += await db.Produtos
                .Where(p => ids.Contains(p.Id) && p.ClasseAbc != classe)
                .ExecuteUpdateAsync(s => s.SetProperty(p => p.ClasseAbc, classe), cancellationToken);
        }

        return new ResumoCurvaAbc(
            desde,
            classes.Count(c => c.Value == ClasseAbc.A),
            classes.Count(c => c.Value == ClasseAbc.B),
            classes.Count(c => c.Value == ClasseAbc.C),
            alterados);
    }
}
