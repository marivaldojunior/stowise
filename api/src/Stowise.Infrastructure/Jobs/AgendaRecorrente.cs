using Hangfire;
using Microsoft.Extensions.Hosting;
using Stowise.Infrastructure.Catalogo;
using Stowise.Infrastructure.Ia;

namespace Stowise.Infrastructure.Jobs;

/// <summary>
/// Agenda os jobs recorrentes na partida do servidor de jobs. O job de embeddings só existe com o modelo ligado;
/// desligado, o agendamento antigo é removido.
/// </summary>
internal sealed class AgendaRecorrente(IRecurringJobManager agenda, GeradorEmbeddings embeddings) : IHostedService
{
    /// <summary>A cada 5 minutos (ADR-0011).</summary>
    public const string CronEmbeddings = "*/5 * * * *";

    public Task StartAsync(CancellationToken cancellationToken)
    {
        if (embeddings.Disponivel)
        {
            agenda.AddOrUpdate<EmbeddingsJobs>(EmbeddingsJobs.RecurringJobId, Filas.Ia, j => j.AtualizarAsync(CancellationToken.None), CronEmbeddings);
        }
        else
        {
            agenda.RemoveIfExists(EmbeddingsJobs.RecurringJobId);
        }

        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken) => Task.CompletedTask;
}
