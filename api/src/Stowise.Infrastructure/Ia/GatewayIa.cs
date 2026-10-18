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

/// <summary>
/// Resultado de uma chamada. Sem sucesso, a funcionalidade devolve "sem sugestão" e o fluxo segue manual. Com a cota
/// excedida, a funcionalidade responde HTTP 429 com <see cref="MotivoCota"/> (ADR-0004, item 5).
/// </summary>
internal sealed record RespostaIa(bool Sucesso, ChatResponse? Resposta, Guid? ChamadaId, string? MotivoCota = null)
{
    public static readonly RespostaIa Indisponivel = new(false, null, null);

    public string? Texto => Resposta?.Text;

    public bool CotaExcedida => MotivoCota is not null;
}

/// <summary>Resultado de uma chamada com saída estruturada: o valor já validado pelo schema da funcionalidade.</summary>
internal sealed record RespostaIa<T>(bool Sucesso, T? Valor, Guid? ChamadaId, string? MotivoCota = null)
    where T : class
{
    public bool CotaExcedida => MotivoCota is not null;
}

/// <summary>
/// Porta única para os provedores de IA (ADR-0004). Para cada pedido, percorre a cadeia de provedores da
/// funcionalidade: cada tentativa tem timeout; falha transitória (timeout, 408, 429, 5xx, rede) tenta de novo no
/// mesmo provedor com espera exponencial e jitter; outra falha (chave inválida, modelo inexistente, resposta fora do
/// schema) passa direto para o próximo provedor. O pedido inteiro vira um único <see cref="ChamadaIa"/>.
/// </summary>
internal sealed partial class GatewayIa(
    IProvedoresIa provedores,
    IRegistroChamadasIa registro,
    IVerificadorCotaIa cotas,
    TimeProvider time,
    ILogger<GatewayIa> logger)
{
    private static readonly TimeSpan EsperaMaxima = TimeSpan.FromSeconds(10);

    /// <summary>Texto livre, sem schema. Para saída que vira dado, use a sobrecarga com <see cref="ContratoSaidaIa{T}"/>.</summary>
    public Task<RespostaIa> SendAsync(PedidoIa pedido, CancellationToken cancellationToken) =>
        SendCoreAsync(pedido, preparar: null, validar: null, cancellationToken);

    /// <summary>
    /// Saída estruturada (ADR-0004, item 3): pede JSON no modo de cada provedor (<see cref="ProvedorIaOptions.ModoJson"/>)
    /// e só aceita a resposta que passa no schema do contrato. A versão do contrato vai para o registro.
    /// </summary>
    public async Task<RespostaIa<T>> SendAsync<T>(PedidoIa pedido, ContratoSaidaIa<T> contrato, CancellationToken cancellationToken)
        where T : class
    {
        ArgumentNullException.ThrowIfNull(pedido);
        ArgumentNullException.ThrowIfNull(contrato);

        T? valor = null;
        var resposta = await SendCoreAsync(
            pedido with { PromptVersao = contrato.Versao },
            (opcoes, mensagens, provedor) => ApplyContract(contrato, opcoes, mensagens, provedor),
            r =>
            {
                var saida = contrato.Parse(r.Text);
                valor = saida.Valor;
                return saida.Erro;
            },
            cancellationToken);

        return new RespostaIa<T>(resposta.Sucesso, resposta.Sucesso ? valor : null, resposta.ChamadaId, resposta.MotivoCota);
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

    /// <summary>
    /// Modo nativo: o schema vai no <see cref="ChatOptions.ResponseFormat"/>. Nos outros modos, vai como mensagem de
    /// sistema no início da conversa, e o provedor recebe só "responda em JSON" (ou nada).
    /// </summary>
    private static IReadOnlyList<ChatMessage> ApplyContract<T>(ContratoSaidaIa<T> contrato, ChatOptions opcoes, IReadOnlyList<ChatMessage> mensagens, ProvedorIa provedor)
        where T : class
    {
        if (string.Equals(provedor.Opcoes.ModoJson, ModosJson.JsonSchema, StringComparison.OrdinalIgnoreCase))
        {
            opcoes.ResponseFormat = ChatResponseFormat.ForJsonSchema(contrato.Schema, contrato.Nome);
            return mensagens;
        }

        opcoes.ResponseFormat = string.Equals(provedor.Opcoes.ModoJson, ModosJson.Json, StringComparison.OrdinalIgnoreCase) ? ChatResponseFormat.Json : null;
        return [new ChatMessage(ChatRole.System, contrato.InstrucaoNoPrompt()), .. mensagens];
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

    private static int? Sum(int? atual, long? mais) =>
        mais is null ? atual : (int)Math.Min((atual ?? 0) + mais.Value, int.MaxValue);

    /// <param name="preparar">Ajusta opções e mensagens para cada provedor (ex.: modo de JSON).</param>
    /// <param name="validar">Devolve o motivo de recusa da resposta, ou nulo se ela serve.</param>
    private async Task<RespostaIa> SendCoreAsync(
        PedidoIa pedido,
        Func<ChatOptions, IReadOnlyList<ChatMessage>, ProvedorIa, IReadOnlyList<ChatMessage>>? preparar,
        Func<ChatResponse, string?>? validar,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(pedido);

        if (provedores.Para(pedido.Funcionalidade) is not { Provedores.Count: > 0 } cadeia)
        {
            return RespostaIa.Indisponivel;
        }

        // Cota antes do provedor: acima do limite, nenhuma chamada sai e nada é registrado (não é uma chamada).
        // A verificação e a chamada não são atômicas: pedidos simultâneos podem passar um pouco do limite.
        if (pedido.UsuarioId is { } usuarioId && await cotas.CheckAsync(usuarioId, pedido.Funcionalidade, cancellationToken) is { Excedida: true } uso)
        {
            LogQuotaExceeded(pedido.Funcionalidade, usuarioId);
            return new RespostaIa(false, null, null, DescribeQuota(uso));
        }

        var inicio = time.GetTimestamp();
        var tentativas = 0;
        int? tokensEntrada = null, tokensSaida = null;
        decimal? custo = null;
        var usado = cadeia.Provedores[0];
        var modelo = usado.Opcoes.Modelo;
        string? erro = null;

        for (var indice = 0; indice < cadeia.Provedores.Count; indice++)
        {
            usado = cadeia.Provedores[indice];
            var opcoes = OptionsFor(pedido, usado);
            var mensagens = preparar?.Invoke(opcoes, pedido.Mensagens, usado) ?? pedido.Mensagens;
            modelo = opcoes.ModelId!;

            for (var tentativa = 1; tentativa <= cadeia.TentativasPorProvedor; tentativa++)
            {
                tentativas++;
                using var limite = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
                limite.CancelAfter(cadeia.Timeout);
                try
                {
                    var resposta = await usado.Cliente.GetResponseAsync(mensagens, opcoes, limite.Token);

                    // Respostas recusadas também custam: tokens e custo de cada uma entram no total, cada uma pelo
                    // preço do provedor que a gerou.
                    tokensEntrada = Sum(tokensEntrada, resposta.Usage?.InputTokenCount);
                    tokensSaida = Sum(tokensSaida, resposta.Usage?.OutputTokenCount);
                    if (usado.Opcoes.EstimateCost(ToInt(resposta.Usage?.InputTokenCount), ToInt(resposta.Usage?.OutputTokenCount)) is { } custoDaResposta)
                    {
                        custo = (custo ?? 0) + custoDaResposta;
                    }

                    if (validar?.Invoke(resposta) is { } invalida)
                    {
                        erro = $"SaidaInvalida: {invalida}";
                        LogAttemptFailed(null, pedido.Funcionalidade, usado.Nome, tentativa, "invalid output");
                        break;
                    }

                    var chamada = await RecordAsync(pedido, usado, resposta.ModelId ?? modelo, new UsoIa(tokensEntrada, tokensSaida, Elapsed(inicio), tentativas, indice > 0), custo, erro: null);
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

        var falha = await RecordAsync(pedido, usado, modelo, new UsoIa(tokensEntrada, tokensSaida, Elapsed(inicio), tentativas, cadeia.Provedores.Count > 1), custo, erro);
        return new RespostaIa(false, null, falha.Id);
    }

    /// <summary>Mensagem para o usuário, no corpo do HTTP 429.</summary>
    internal static string DescribeQuota(Stowise.Application.Ia.UsoCotaIa uso)
    {
        ArgumentNullException.ThrowIfNull(uso);

        var motivo = uso.LimiteChamadasDia is { } chamadas && uso.ChamadasHoje >= chamadas
            ? $"{uso.ChamadasHoje} de {chamadas} chamadas hoje"
            : $"{uso.TokensMes} de {uso.LimiteTokensMes} tokens neste mês";
        return $"Cota de IA atingida ({uso.Origem}): {motivo}. Continue sem a sugestão da IA ou fale com o administrador.";
    }

    private static int? ToInt(long? valor) => valor is null ? null : (int)Math.Min(valor.Value, int.MaxValue);

    private int Elapsed(long inicio) => (int)time.GetElapsedTime(inicio).TotalMilliseconds;

    private async Task<ChamadaIa> RecordAsync(PedidoIa pedido, ProvedorIa provedor, string modelo, UsoIa uso, decimal? custo, string? erro)
    {
        var chamada = ChamadaIa.Create(
            pedido.Funcionalidade,
            pedido.UsuarioId,
            provedor.Nome,
            modelo,
            pedido.PromptVersao,
            uso,
            custo,
            erro,
            Activity.Current?.TraceId.ToString(),
            time.GetUtcNow());

        await registro.SaveAsync(chamada);
        return chamada;
    }

    [LoggerMessage(Level = LogLevel.Information, Message = "AI quota exceeded for {Funcionalidade} by user {UsuarioId}")]
    private partial void LogQuotaExceeded(FuncionalidadeIa funcionalidade, Guid usuarioId);

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
