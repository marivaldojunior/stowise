using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Stowise.Application.Auth;
using Stowise.Application.Importacoes;

namespace Stowise.Api.Hubs;

/// <summary>
/// Progresso das importações em tempo real, em <c>/hubs/importacoes</c>. O cliente chama <see cref="Acompanhar"/>
/// com o id da importação e recebe o evento <c>progresso</c> (<see cref="ProgressoImportacao"/>) a cada lote e a
/// cada troca de status. O token vai no parâmetro <c>access_token</c>, porque WebSocket não envia cabeçalho.
/// </summary>
[Authorize(Policy = Politicas.Gestao)]
public sealed class ImportacoesHub : Hub
{
    public const string Rota = "/hubs/importacoes";
    public const string EventoProgresso = "progresso";

    public Task Acompanhar(Guid importacaoId) => Groups.AddToGroupAsync(Context.ConnectionId, Grupo(importacaoId));

    public Task Deixar(Guid importacaoId) => Groups.RemoveFromGroupAsync(Context.ConnectionId, Grupo(importacaoId));

    internal static string Grupo(Guid importacaoId) => $"importacao:{importacaoId}";
}

/// <summary>Publica o progresso para o grupo da importação. Falha de envio não interrompe o processamento.</summary>
internal sealed partial class SignalRNotificadorImportacao(IHubContext<ImportacoesHub> hub, ILogger<SignalRNotificadorImportacao> logger) : INotificadorImportacao
{
    public async Task NotificarAsync(ProgressoImportacao progresso, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(progresso);

        try
        {
            await hub.Clients.Group(ImportacoesHub.Grupo(progresso.Id)).SendAsync(ImportacoesHub.EventoProgresso, progresso, cancellationToken);
        }
        catch (Exception e) when (e is not OperationCanceledException)
        {
            LogSendFailed(e, progresso.Id);
        }
    }

    [LoggerMessage(Level = LogLevel.Warning, Message = "Could not send the progress of import {ImportacaoId}")]
    private partial void LogSendFailed(Exception exception, Guid importacaoId);
}
