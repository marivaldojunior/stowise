using Hangfire;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Pgvector;
using Stowise.Infrastructure.Ia;
using Stowise.Infrastructure.Jobs;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Catalogo;

/// <summary>
/// Job recorrente (ADR-0011): gera os vetores dos produtos ativos que não têm vetor, ou cujo texto ou modelo mudou.
/// Idempotente: roda de novo sem efeito quando não há pendência. Uma falha do provedor encerra a rodada; a próxima
/// rodada tenta de novo.
/// </summary>
internal sealed partial class EmbeddingsJobs(
    StowiseDbContext db,
    GeradorEmbeddings gerador,
    IOptions<IaOptions> options,
    TimeProvider time,
    ILogger<EmbeddingsJobs> logger)
{
    public const string RecurringJobId = "embeddings-produtos";

    /// <summary>Lotes por rodada, para a rodada não segurar o worker por muito tempo.</summary>
    public const int LotesPorRodada = 20;

    /// <returns>Vetores gravados nesta rodada.</returns>
    [Queue(Filas.Ia)]
    [DisableConcurrentExecution(timeoutInSeconds: 60)]
    [AutomaticRetry(Attempts = 0)]
    public async Task<int> AtualizarAsync(CancellationToken cancellationToken)
    {
        if (!gerador.Disponivel)
        {
            return 0;
        }

        var lote = Math.Max(1, options.Value.Embeddings.Lote);
        var gravados = 0;
        for (var rodada = 0; rodada < LotesPorRodada; rodada++)
        {
            var pendentes = await PendentesAsync(lote, cancellationToken);
            if (pendentes.Count == 0)
            {
                break;
            }

            var vetores = await gerador.GenerateAsync([.. pendentes.Select(p => p.Descricao)], cancellationToken);
            if (vetores is null)
            {
                LogBatchFailed(pendentes.Count);
                break;
            }

            await SaveAsync(pendentes, vetores, cancellationToken);
            gravados += pendentes.Count;
            if (pendentes.Count < lote)
            {
                break;
            }
        }

        return gravados;
    }

    private Task<List<Pendente>> PendentesAsync(int lote, CancellationToken cancellationToken)
    {
        var modelo = gerador.Modelo;
        return (
            from p in db.Produtos.AsNoTracking().Where(p => p.Ativo)
            join e in db.ProdutoEmbeddings.AsNoTracking() on p.Id equals e.ProdutoId into vetores
            from e in vetores.DefaultIfEmpty()
            where e == null || e.Modelo != modelo || e.Texto != p.Descricao
            orderby p.Id
            select new Pendente(p.Id, p.Descricao))
            .Take(lote)
            .ToListAsync(cancellationToken);
    }

    private async Task SaveAsync(List<Pendente> pendentes, IReadOnlyList<float[]> vetores, CancellationToken cancellationToken)
    {
        var ids = pendentes.Select(p => p.Id).ToList();
        var existentes = await db.ProdutoEmbeddings.Where(e => ids.Contains(e.ProdutoId)).ToDictionaryAsync(e => e.ProdutoId, cancellationToken);
        var agora = time.GetUtcNow();
        for (var i = 0; i < pendentes.Count; i++)
        {
            if (!existentes.TryGetValue(pendentes[i].Id, out var embedding))
            {
                embedding = new ProdutoEmbedding { ProdutoId = pendentes[i].Id };
                db.ProdutoEmbeddings.Add(embedding);
            }

            embedding.Vetor = new Vector(vetores[i]);
            embedding.Modelo = gerador.Modelo;
            embedding.Texto = pendentes[i].Descricao;
            embedding.GeradoEm = agora;
        }

        await db.SaveChangesAsync(cancellationToken);
        db.ChangeTracker.Clear();
    }

    [LoggerMessage(Level = LogLevel.Warning, Message = "Embedding batch of {Quantidade} products failed; the next run retries")]
    private partial void LogBatchFailed(int quantidade);

    internal sealed record Pendente(Guid Id, string Descricao);
}
