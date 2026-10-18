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
    SugestaoMapeamentoIa sugestao,
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

    /// <summary>
    /// Pede a sugestão à IA e guarda como proposta. Sem sugestão (IA fora, cota, resposta inválida), a importação volta
    /// e o motivo fica visível; as falhas de provedor já foram tratadas pelo gateway, sem exceção.
    /// </summary>
    [Queue(Filas.Ia)]
    [AutomaticRetry(Attempts = 2, DelaysInSeconds = [10, 60], OnAttemptsExceeded = AttemptsExceededAction.Fail)]
    [DisplayName("Sugestão de mapeamento da importação {0}")]
    public async Task SugestaoMapeamentoAsync(Guid importacaoId, Guid usuarioId, CancellationToken cancellationToken)
    {
        using var activity = JobsTelemetry.Source.StartActivity("importacao.sugestao");
        activity?.SetTag("stowise.importacao.id", importacaoId);

        var importacao = await db.Importacoes.FirstOrDefaultAsync(i => i.Id == importacaoId, cancellationToken);
        if (importacao is not { Status: StatusImportacao.Mapeando })
        {
            LogSkipped(nameof(SugestaoMapeamentoAsync), importacaoId, importacao?.Status);
            return;
        }

        var resposta = await sugestao.SuggestAsync(importacao, usuarioId, cancellationToken);

        // A pessoa pode ter confirmado à mão enquanto a IA trabalhava: nesse caso a sugestão é descartada.
        await db.Entry(importacao).ReloadAsync(cancellationToken);
        if (importacao.Status != StatusImportacao.Mapeando)
        {
            LogSkipped(nameof(SugestaoMapeamentoAsync), importacaoId, importacao.Status);
            return;
        }

        if (resposta is { Sucesso: true, Valor: { } valor })
        {
            importacao.ApplySugestao(SugestaoMapeamentoIa.ToSugestao(valor, resposta.ChamadaId));
        }
        else
        {
            importacao.FailSugestao(resposta.MotivoCota ?? "A IA não conseguiu sugerir o mapeamento agora. Faça o mapeamento manual ou peça de novo.");
        }

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
            var sugestao = context.BackgroundJob.Job.Method.Name == nameof(ImportacaoJobs.SugestaoMapeamentoAsync);
            MarkFailedAsync(importacaoId, sugestao).GetAwaiter().GetResult();
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

    /// <param name="sugestao">Falha na sugestão da IA não encerra a importação: ela volta para o mapeamento manual.</param>
    private async Task MarkFailedAsync(Guid importacaoId, bool sugestao)
    {
        await using var scope = scopes.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
        var importacao = await db.Importacoes.FirstOrDefaultAsync(i => i.Id == importacaoId);
        if (importacao is null or { Status: StatusImportacao.Concluido or StatusImportacao.Falhou })
        {
            return;
        }

        if (sugestao)
        {
            if (importacao.Status != StatusImportacao.Mapeando)
            {
                return;
            }

            importacao.FailSugestao("A sugestão da IA falhou depois de várias tentativas. Faça o mapeamento manual.");
        }
        else
        {
            importacao.Fail(Motivo, scope.ServiceProvider.GetRequiredService<TimeProvider>().GetUtcNow());
        }

        await db.SaveChangesAsync();
        await scope.ServiceProvider.GetRequiredService<INotificadorImportacao>().NotificarAsync(ProgressoImportacao.From(importacao));
    }

    [LoggerMessage(Level = LogLevel.Error, Message = "Could not mark import {ImportacaoId} as failed after the retries")]
    private partial void LogMarkFailed(Exception exception, Guid importacaoId);
}
