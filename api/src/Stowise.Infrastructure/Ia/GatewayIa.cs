using System.Diagnostics;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Ia;

/// <param name="PromptVersao">Versão do prompt e do schema, gravada no registro para comparar versões.</param>
internal sealed record PedidoIa(
    FuncionalidadeIa Funcionalidade,
    string PromptVersao,
    IReadOnlyList<ChatMessage> Mensagens,
    Guid? UsuarioId,
    ChatOptions? Opcoes = null);

/// <summary>Resultado de uma chamada. Sem sucesso, a funcionalidade devolve "sem sugestão" e o fluxo segue manual.</summary>
internal sealed record RespostaIa(bool Sucesso, ChatResponse? Resposta, Guid? ChamadaId)
{
    public static readonly RespostaIa Indisponivel = new(false, null, null);

    public string? Texto => Resposta?.Text;
}

/// <summary>
/// Porta única para os provedores de IA (ADR-0004). Toda chamada, com sucesso ou falha, vira um
/// <see cref="ChamadaIa"/>, gravado num escopo próprio: o registro não depende da transação de quem chamou e não
/// grava por engano as mudanças que ela ainda tem em memória.
/// </summary>
internal sealed partial class GatewayIa(IProvedoresIa provedores, IServiceScopeFactory scopes, TimeProvider time, ILogger<GatewayIa> logger)
{
    public async Task<RespostaIa> SendAsync(PedidoIa pedido, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(pedido);

        if (provedores.Principal is not { } provedor)
        {
            return RespostaIa.Indisponivel;
        }

        var opcoes = pedido.Opcoes?.Clone() ?? new ChatOptions();
        opcoes.ModelId ??= provedor.Opcoes.Modelo;
        opcoes.MaxOutputTokens ??= provedor.Opcoes.MaxTokensSaida;

        var inicio = time.GetTimestamp();
        ChatResponse? resposta = null;
        string? erro = null;
        try
        {
            resposta = await provedor.Cliente.GetResponseAsync(pedido.Mensagens, opcoes, cancellationToken);
        }
        catch (Exception e) when (e is not OperationCanceledException || !cancellationToken.IsCancellationRequested)
        {
            // A mensagem do provedor não leva o prompt; o tipo ajuda a separar timeout, cota e erro de rede.
            erro = $"{e.GetType().Name}: {e.Message}";
            LogCallFailed(e, pedido.Funcionalidade, provedor.Nome);
        }

        var uso = new UsoIa(
            ToInt(resposta?.Usage?.InputTokenCount),
            ToInt(resposta?.Usage?.OutputTokenCount),
            (int)time.GetElapsedTime(inicio).TotalMilliseconds);
        var chamada = ChamadaIa.Create(
            pedido.Funcionalidade,
            pedido.UsuarioId,
            provedor.Nome,
            resposta?.ModelId ?? opcoes.ModelId,
            pedido.PromptVersao,
            uso,
            provedor.Opcoes.EstimateCost(uso.TokensEntrada, uso.TokensSaida),
            erro,
            Activity.Current?.TraceId.ToString(),
            time.GetUtcNow());

        await using (var scope = scopes.CreateAsyncScope())
        {
            var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
            db.ChamadasIa.Add(chamada);
            await db.SaveChangesAsync(CancellationToken.None);
        }

        return new RespostaIa(erro is null, resposta, chamada.Id);
    }

    private static int? ToInt(long? valor) => valor is null ? null : (int)Math.Min(valor.Value, int.MaxValue);

    [LoggerMessage(Level = LogLevel.Warning, Message = "AI call for {Funcionalidade} failed on {Provedor}")]
    private partial void LogCallFailed(Exception exception, FuncionalidadeIa funcionalidade, string provedor);
}
