using System.ComponentModel;
using Hangfire;
using Hangfire.Common;
using Hangfire.States;
using Hangfire.Storage;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Stowise.Application.Importacoes;
using Stowise.Domain.Common;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Jobs;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Importacoes;

/// <summary>
/// Jobs da importação (ADR-0007). Idempotentes: cada um confere o status antes de agir, porque o Hangfire pode
/// entregar o mesmo job mais de uma vez.
/// </summary>
internal sealed partial class ImportacaoJobs(
    StowiseDbContext db,
    StagingProdutos staging,
    EfetivacaoProdutos efetivacao,
    INotificadorImportacao notificador,
    TimeProvider time,
    ILogger<ImportacaoJobs> logger)
{
    [Queue(Filas.Importacao)]
    [AutomaticRetry(Attempts = 3, DelaysInSeconds = [10, 60, 300], OnAttemptsExceeded = AttemptsExceededAction.Fail)]
    [DisplayName("Staging da importação {0}")]
    public async Task StagingAsync(Guid importacaoId, CancellationToken cancellationToken)
    {
        using var activity = JobsTelemetry.Source.StartActivity("importacao.staging");
        activity?.SetTag("stowise.importacao.id", importacaoId);

        var importacao = await db.Importacoes.FirstOrDefaultAsync(i => i.Id == importacaoId, cancellationToken);
        if (importacao is not { Status: StatusImportacao.Validando })
        {
            LogSkipped(nameof(StagingAsync), importacaoId, importacao?.Status);
            return;
        }

        try
        {
            await staging.BuildAsync(
                importacao,
                (andamento, ct) => notificador.NotificarAsync(ProgressoImportacao.From(andamento), ct),
                cancellationToken);
        }
        catch (Exception e) when (e is DomainException or InvalidDataException)
        {
            // Regra de negócio ou arquivo ilegível: repetir não resolve. A importação falha com o motivo.
            LogBusinessFailure(e, importacaoId);
            db.ChangeTracker.Clear();
            importacao = await db.Importacoes.FirstAsync(i => i.Id == importacaoId, cancellationToken);
            importacao.Fail(e.Message, time.GetUtcNow());
        }

        await db.SaveChangesAsync(cancellationToken);
        await notificador.NotificarAsync(ProgressoImportacao.From(importacao), cancellationToken);
    }

    [Queue(Filas.Importacao)]
    [AutomaticRetry(Attempts = 3, DelaysInSeconds = [10, 60, 300], OnAttemptsExceeded = AttemptsExceededAction.Fail)]
    [DisplayName("Efetivação da importação {0}")]
    public async Task EfetivacaoAsync(Guid importacaoId, CancellationToken cancellationToken)
    {
        using var activity = JobsTelemetry.Source.StartActivity("importacao.efetivacao");
        activity?.SetTag("stowise.importacao.id", importacaoId);

        var importacao = await db.Importacoes.FirstOrDefaultAsync(i => i.Id == importacaoId, cancellationToken);
        if (importacao is not { Status: StatusImportacao.Efetivando })
        {
            LogSkipped(nameof(EfetivacaoAsync), importacaoId, importacao?.Status);
            return;
        }

        // Erros de uma linha (regra do cadastro) não chegam aqui: viram erro da linha. O que sobe é infraestrutura,
        // e a nova tentativa continua das linhas ainda não efetivadas.
        await efetivacao.RunAsync(
            importacao,
            (andamento, ct) => notificador.NotificarAsync(ProgressoImportacao.From(andamento), ct),
            cancellationToken);
        await db.SaveChangesAsync(cancellationToken);
        await notificador.NotificarAsync(ProgressoImportacao.From(importacao), cancellationToken);
    }

    [LoggerMessage(Level = LogLevel.Information, Message = "{Job} skipped for import {ImportacaoId}: status is {Status}")]
    private partial void LogSkipped(string job, Guid importacaoId, StatusImportacao? status);

    [LoggerMessage(Level = LogLevel.Warning, Message = "Staging failed for import {ImportacaoId} without retry")]
    private partial void LogBusinessFailure(Exception exception, Guid importacaoId);
}

/// <summary>
/// Quando as novas tentativas de um job de importação acabam, grava a importação como <c>Falhou</c>, para ela
/// não ficar parada em <c>Validando</c>.
/// </summary>
internal sealed partial class ImportacaoFalhaFilter(IServiceScopeFactory scopes, ILogger<ImportacaoFalhaFilter> logger) : JobFilterAttribute, IApplyStateFilter
{
    public const string Motivo = "O processamento falhou depois de várias tentativas. Envie o arquivo de novo ou fale com o suporte.";

    public void OnStateApplied(ApplyStateContext context, IWriteOnlyTransaction transaction)
    {
        ArgumentNullException.ThrowIfNull(context);

        if (context.NewState is not FailedState || context.BackgroundJob.Job?.Type != typeof(ImportacaoJobs)
            || context.BackgroundJob.Job.Args is not [Guid importacaoId, ..])
        {
            return;
        }

        try
        {
            MarkFailedAsync(importacaoId).GetAwaiter().GetResult();
        }
        catch (Exception e) when (e is DbUpdateException or InvalidOperationException or TimeoutException)
        {
            // O filtro não pode derrubar a troca de estado do Hangfire; o erro fica no log.
            LogMarkFailed(e, importacaoId);
        }
    }

    public void OnStateUnapplied(ApplyStateContext context, IWriteOnlyTransaction transaction)
    {
    }

    private async Task MarkFailedAsync(Guid importacaoId)
    {
        await using var scope = scopes.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
        var importacao = await db.Importacoes.FirstOrDefaultAsync(i => i.Id == importacaoId);
        if (importacao is null or { Status: StatusImportacao.Concluido or StatusImportacao.Falhou })
        {
            return;
        }

        importacao.Fail(Motivo, scope.ServiceProvider.GetRequiredService<TimeProvider>().GetUtcNow());
        await db.SaveChangesAsync();
        await scope.ServiceProvider.GetRequiredService<INotificadorImportacao>().NotificarAsync(ProgressoImportacao.From(importacao));
    }

    [LoggerMessage(Level = LogLevel.Error, Message = "Could not mark import {ImportacaoId} as failed after the retries")]
    private partial void LogMarkFailed(Exception exception, Guid importacaoId);
}
