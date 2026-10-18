using System.Diagnostics;
using System.Net;
using System.Reflection;
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
/// Porta única para os provedores de IA (ADR-0004). Para cada pedido, percorre a cadeia de provedores da
/// funcionalidade: cada tentativa tem timeout; falha transitória (timeout, 408, 429, 5xx, rede) tenta de novo no
/// mesmo provedor com espera exponencial e jitter; outra falha (chave inválida, modelo inexistente) passa direto
/// para o próximo provedor. O pedido inteiro vira um único <see cref="ChamadaIa"/>, gravado em escopo próprio.
/// </summary>
internal sealed partial class GatewayIa(IProvedoresIa provedores, IRegistroChamadasIa registro, TimeProvider time, ILogger<GatewayIa> logger)
{
    private static readonly TimeSpan EsperaMaxima = TimeSpan.FromSeconds(10);

    public async Task<RespostaIa> SendAsync(PedidoIa pedido, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(pedido);

        if (provedores.Para(pedido.Funcionalidade) is not { Provedores.Count: > 0 } cadeia)
        {
            return RespostaIa.Indisponivel;
        }

        var inicio = time.GetTimestamp();
        var tentativas = 0;
        ProvedorIa usado = cadeia.Provedores[0];
        string modelo = usado.Opcoes.Modelo;
        string? erro = null;

        for (var indice = 0; indice < cadeia.Provedores.Count; indice++)
        {
            usado = cadeia.Provedores[indice];
            var opcoes = OptionsFor(pedido, usado);
            modelo = opcoes.ModelId!;

            for (var tentativa = 1; tentativa <= cadeia.TentativasPorProvedor; tentativa++)
            {
                tentativas++;
                using var limite = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
                limite.CancelAfter(cadeia.Timeout);
                try
                {
                    var resposta = await usado.Cliente.GetResponseAsync(pedido.Mensagens, opcoes, limite.Token);
                    var chamada = await RecordAsync(pedido, usado, resposta.ModelId ?? modelo, resposta.Usage, inicio, tentativas, indice > 0, erro: null);
                    return new RespostaIa(true, resposta, chamada.Id);
                }
                catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
                {
                    erro = $"Timeout: no answer from {usado.Nome} in {cadeia.Timeout.TotalSeconds:0.#} s.";
                    LogAttemptFailed(null, pedido.Funcionalidade, usado.Nome, tentativa, "timeout");
                }
                catch (Exception e) when (e is not OperationCanceledException)
                {
                    erro = $"{e.GetType().Name}: {e.Message}";
                    if (!(usado.Transitoria?.Invoke(e) ?? IsTransient(e)))
                    {
                        // Erro de configuração ou de pedido: repetir no mesmo provedor não resolve.
                        LogAttemptFailed(e, pedido.Funcionalidade, usado.Nome, tentativa, "permanent");
                        break;
                    }

                    LogAttemptFailed(e, pedido.Funcionalidade, usado.Nome, tentativa, "transient");
                }

                if (tentativa < cadeia.TentativasPorProvedor)
                {
                    await Task.Delay(Backoff(cadeia.EsperaInicial, tentativa), time, cancellationToken);
                }
            }
        }

        var falha = await RecordAsync(pedido, usado, modelo, usage: null, inicio, tentativas, cadeia.Provedores.Count > 1, erro);
        return new RespostaIa(false, null, falha.Id);
    }

    /// <summary>Espera antes da próxima tentativa: dobra a cada vez, entre 50% e 100% do valor (jitter), até 10 s.</summary>
    internal static TimeSpan Backoff(TimeSpan inicial, int tentativa)
    {
        var base_ = inicial.TotalMilliseconds * Math.Pow(2, tentativa - 1);
        var comJitter = base_ * (0.5 + (Random.Shared.NextDouble() * 0.5));
        return TimeSpan.FromMilliseconds(Math.Min(comJitter, EsperaMaxima.TotalMilliseconds));
    }

    /// <summary>
    /// Falha que pode passar sozinha: rede, timeout ou status 408, 429 e 5xx. Os SDKs expõem o status com nomes
    /// diferentes (<c>StatusCode</c>, <c>Status</c>), então ele é lido pelo nome da propriedade.
    /// </summary>
    internal static bool IsTransient(Exception e)
    {
        for (var atual = e; atual is not null; atual = atual.InnerException)
        {
            if (atual is TimeoutException or IOException || (atual is HttpRequestException { StatusCode: null }))
            {
                return true;
            }

            if (StatusOf(atual) is { } status)
            {
                return status is 408 or 429 or >= 500;
            }
        }

        return false;
    }

    private static int? StatusOf(Exception e)
    {
        foreach (var nome in (string[])["StatusCode", "Status"])
        {
            var valor = e.GetType().GetProperty(nome, BindingFlags.Public | BindingFlags.Instance)?.GetValue(e);
            switch (valor)
            {
                case HttpStatusCode codigo:
                    return (int)codigo;
                case int numero when numero >= 100:
                    return numero;
            }
        }

        return null;
    }

    private static ChatOptions OptionsFor(PedidoIa pedido, ProvedorIa provedor)
    {
        var opcoes = pedido.Opcoes?.Clone() ?? new ChatOptions();
        opcoes.ModelId = provedor.Opcoes.Modelo;
        opcoes.MaxOutputTokens ??= provedor.Opcoes.MaxTokensSaida;
        if (provedor.Opcoes.ParametrosAdicionais.Count > 0)
        {
            opcoes.AdditionalProperties ??= [];
            foreach (var (chave, valor) in provedor.Opcoes.ParametrosAdicionais)
            {
                opcoes.AdditionalProperties[chave] = valor;
            }
        }

        return opcoes;
    }

    private async Task<ChamadaIa> RecordAsync(
        PedidoIa pedido,
        ProvedorIa provedor,
        string modelo,
        UsageDetails? usage,
        long inicio,
        int tentativas,
        bool usouFallback,
        string? erro)
    {
        var uso = new UsoIa(
            ToInt(usage?.InputTokenCount),
            ToInt(usage?.OutputTokenCount),
            (int)time.GetElapsedTime(inicio).TotalMilliseconds,
            tentativas,
            usouFallback);
        var chamada = ChamadaIa.Create(
            pedido.Funcionalidade,
            pedido.UsuarioId,
            provedor.Nome,
            modelo,
            pedido.PromptVersao,
            uso,
            provedor.Opcoes.EstimateCost(uso.TokensEntrada, uso.TokensSaida),
            erro,
            Activity.Current?.TraceId.ToString(),
            time.GetUtcNow());

        await registro.SaveAsync(chamada);
        return chamada;
    }

    private static int? ToInt(long? valor) => valor is null ? null : (int)Math.Min(valor.Value, int.MaxValue);

    [LoggerMessage(Level = LogLevel.Warning, Message = "AI attempt {Tentativa} for {Funcionalidade} failed on {Provedor} ({Tipo})")]
    private partial void LogAttemptFailed(Exception? exception, FuncionalidadeIa funcionalidade, string provedor, int tentativa, string tipo);
}

/// <summary>Onde os registros de chamada são gravados.</summary>
internal interface IRegistroChamadasIa
{
    Task SaveAsync(ChamadaIa chamada);
}

/// <summary>
/// Grava em escopo próprio: o registro não depende da transação de quem chamou, não grava por engano as mudanças
/// que ela ainda tem em memória e é gravado mesmo se o pedido de quem chamou for cancelado.
/// </summary>
internal sealed class RegistroChamadasIaEf(IServiceScopeFactory scopes) : IRegistroChamadasIa
{
    public async Task SaveAsync(ChamadaIa chamada)
    {
        await using var scope = scopes.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
        db.ChamadasIa.Add(chamada);
        await db.SaveChangesAsync(CancellationToken.None);
    }
}
