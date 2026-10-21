using System.Diagnostics;
using Hangfire;
using Hangfire.PostgreSql;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Stowise.Application.Armazenagem;
using Stowise.Application.Importacoes;
using Stowise.Infrastructure.Armazenagem;
using Stowise.Infrastructure.Catalogo;
using Stowise.Infrastructure.Importacoes;

namespace Stowise.Infrastructure.Jobs;

public sealed class JobsOptions
{
    public const string SectionName = "Jobs";

    /// <summary>Liga o servidor de jobs neste processo. Desligado, a API só enfileira (outro processo executa).</summary>
    public bool Enabled { get; set; }

    public int Workers { get; set; } = 2;

    /// <summary>Intervalo de consulta da fila. O LISTEN/NOTIFY do PostgreSQL acorda o servidor antes disso.</summary>
    public double PollIntervalSeconds { get; set; } = 5;
}

/// <summary>Filas do ADR-0007.</summary>
public static class Filas
{
    public const string Importacao = "importacao";
    public const string Ia = "ia";
    public const string Default = "default";

    /// <summary>Ordem de prioridade dos workers.</summary>
    public static readonly string[] Todas = [Importacao, Ia, Default];
}

/// <summary>Traces dos jobs, exportados junto com os da API (ADR-0007, item 9).</summary>
public static class JobsTelemetry
{
    public const string SourceName = "Stowise.Jobs";

    internal static readonly ActivitySource Source = new(SourceName);
}

internal static class JobsSetup
{
    public const string SchemaName = "hangfire";

    /// <summary>
    /// Hangfire com armazenamento no mesmo PostgreSQL, num schema próprio criado pelo Hangfire. O storage só é
    /// criado (e só conecta) quando alguém enfileira ou quando o servidor sobe.
    /// </summary>
    public static IServiceCollection AddJobs(this IServiceCollection services)
    {
        services.AddOptions<JobsOptions>().BindConfiguration(JobsOptions.SectionName);
        services.AddSingleton<ImportacaoFalhaFilter>();

        services.AddHangfire((provider, config) =>
        {
            var configuration = provider.GetRequiredService<IConfiguration>();
            var connectionString = configuration.GetConnectionString(DependencyInjection.ConnectionStringName)
                ?? throw new InvalidOperationException($"Connection string '{DependencyInjection.ConnectionStringName}' is not configured.");
            var options = configuration.GetSection(JobsOptions.SectionName).Get<JobsOptions>() ?? new JobsOptions();

            config
                .SetDataCompatibilityLevel(CompatibilityLevel.Version_180)
                .UseSimpleAssemblyNameTypeSerializer()
                .UseRecommendedSerializerSettings()
                .UseFilter(provider.GetRequiredService<ImportacaoFalhaFilter>())
                .UsePostgreSqlStorage(
                    bootstrapper => bootstrapper.UseNpgsqlConnection(connectionString),
                    new PostgreSqlStorageOptions
                    {
                        SchemaName = SchemaName,
                        PrepareSchemaIfNecessary = true,
                        EnableLongPolling = true,
                        QueuePollInterval = TimeSpan.FromSeconds(options.PollIntervalSeconds),
                    });
        });

        services.AddScoped<IFilaTrabalhos, HangfireFilaTrabalhos>();
        services.AddScoped<ImportacaoJobs>();
        services.AddScoped<EmbeddingsJobs>();
        services.AddScoped<CurvaAbcJobs>();
        services.AddScoped<ICurvaAbcService>(sp => sp.GetRequiredService<CurvaAbcJobs>());
        services.TryAddScoped<INotificadorImportacao, NotificadorImportacaoNulo>();
        return services;
    }

    /// <summary>Sobe o servidor de jobs neste processo quando <see cref="JobsOptions.Enabled"/> está ligado.</summary>
    public static IServiceCollection AddJobsServer(this IServiceCollection services, IConfiguration configuration)
    {
        var options = configuration.GetSection(JobsOptions.SectionName).Get<JobsOptions>() ?? new JobsOptions();
        if (options.Enabled)
        {
            services.AddHangfireServer(server =>
            {
                server.WorkerCount = Math.Max(1, options.Workers);
                server.Queues = Filas.Todas;
                server.SchedulePollingInterval = TimeSpan.FromSeconds(options.PollIntervalSeconds);

                // Abaixo do limite de parada do host (30 s): um job interrompido volta para a fila e roda de novo.
                server.ShutdownTimeout = TimeSpan.FromSeconds(10);
            });
            services.AddHostedService<AgendaRecorrente>();
        }

        return services;
    }
}

/// <summary>Usa o Hangfire só na hora de enfileirar: resolver o cliente cria o storage, que conecta no banco.</summary>
internal sealed class HangfireFilaTrabalhos(IServiceProvider provider) : IFilaTrabalhos
{
    public void EnfileirarStaging(Guid importacaoId) =>
        provider.GetRequiredService<IBackgroundJobClient>()
            .Enqueue<ImportacaoJobs>(j => j.StagingAsync(importacaoId, CancellationToken.None));

    public void EnfileirarEfetivacao(Guid importacaoId) =>
        provider.GetRequiredService<IBackgroundJobClient>()
            .Enqueue<ImportacaoJobs>(j => j.EfetivacaoAsync(importacaoId, CancellationToken.None));

    public void EnfileirarSugestaoMapeamento(Guid importacaoId, Guid usuarioId) =>
        provider.GetRequiredService<IBackgroundJobClient>()
            .Enqueue<ImportacaoJobs>(j => j.SugestaoMapeamentoAsync(importacaoId, usuarioId, CancellationToken.None));
}

/// <summary>Sem painel conectado (ex.: worker separado), o andamento fica só no banco.</summary>
internal sealed class NotificadorImportacaoNulo : INotificadorImportacao
{
    public Task NotificarAsync(ProgressoImportacao progresso, CancellationToken cancellationToken = default) => Task.CompletedTask;
}
