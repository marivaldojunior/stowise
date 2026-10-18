using Microsoft.Extensions.AI;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Ia;

namespace Stowise.IntegrationTests.Ia;

/// <summary>
/// <see cref="IChatClient"/> com respostas definidas pelo teste (ADR-0004: os testes nunca chamam o provedor real).
/// Cada chamada recebe o próprio número (a partir de 0), para simular falha e depois sucesso.
/// </summary>
internal sealed class FakeChatClient(Func<int, ChatOptions?, CancellationToken, Task<ChatResponse>> responder) : IChatClient
{
    public List<(IReadOnlyList<ChatMessage> Mensagens, ChatOptions? Opcoes)> Recebidas { get; } = [];

    public static FakeChatClient Responding(string texto, long tokensEntrada = 1200, long tokensSaida = 300) =>
        new((_, opcoes, _) => Task.FromResult(Ok(texto, opcoes, tokensEntrada, tokensSaida)));

    public static FakeChatClient Failing(Exception erro) => new((_, _, _) => Task.FromException<ChatResponse>(erro));

    /// <summary>Uma resposta por chamada, na ordem; a última se repete.</summary>
    public static FakeChatClient Sequence(params Func<ChatOptions?, CancellationToken, Task<ChatResponse>>[] passos) =>
        new((n, opcoes, ct) => passos[Math.Min(n, passos.Length - 1)](opcoes, ct));

    /// <summary>Nunca responde: só termina quando o token é cancelado (timeout do gateway).</summary>
    public static async Task<ChatResponse> Hang(ChatOptions? opcoes, CancellationToken ct)
    {
        await Task.Delay(Timeout.Infinite, ct);
        throw new InvalidOperationException("Unreachable.");
    }

    public static ChatResponse Ok(string texto, ChatOptions? opcoes, long tokensEntrada = 1200, long tokensSaida = 300) =>
        new(new ChatMessage(ChatRole.Assistant, texto))
        {
            ModelId = opcoes?.ModelId,
            Usage = new UsageDetails { InputTokenCount = tokensEntrada, OutputTokenCount = tokensSaida },
        };

    public Task<ChatResponse> GetResponseAsync(IEnumerable<ChatMessage> messages, ChatOptions? options = null, CancellationToken cancellationToken = default)
    {
        var mensagens = messages.ToList();
        int numero;
        lock (Recebidas)
        {
            numero = Recebidas.Count;
            Recebidas.Add((mensagens, options));
        }

        return responder(numero, options, cancellationToken);
    }

    public IAsyncEnumerable<ChatResponseUpdate> GetStreamingResponseAsync(IEnumerable<ChatMessage> messages, ChatOptions? options = null, CancellationToken cancellationToken = default) =>
        throw new NotSupportedException("The fake client does not stream.");

    public object? GetService(Type serviceType, object? serviceKey = null) => null;

    public void Dispose()
    {
    }
}

/// <summary>Cadeia fixa para os testes: o primeiro cliente é o "anthropic" (com preço), os seguintes são reservas.</summary>
internal sealed class FakeProvedoresIa(CadeiaIa? cadeia) : IProvedoresIa
{
    public static readonly FakeProvedoresIa Desligada = new(cadeia: null);

    public CadeiaIa? Cadeia { get; } = cadeia;

    public static FakeProvedoresIa With(params IChatClient[] clientes) => With(TimeSpan.FromSeconds(5), 3, clientes);

    public static FakeProvedoresIa With(TimeSpan timeout, int tentativas, params IChatClient[] clientes) =>
        new(new CadeiaIa(
            [.. clientes.Select((c, i) => i == 0
                ? new ProvedorIa("anthropic", c, Opcoes("claude-opus-5-5", 4m, 20m))
                : new ProvedorIa($"reserva-{i}", c, Opcoes("llama3.2", 0m, 0m)))],
            timeout,
            tentativas,
            TimeSpan.FromMilliseconds(1)));

    public CadeiaIa? Para(FuncionalidadeIa funcionalidade) => Cadeia;

    private static ProvedorIaOptions Opcoes(string modelo, decimal entrada, decimal saida) => new()
    {
        Modelo = modelo,
        PrecoEntradaPorMilhao = entrada,
        PrecoSaidaPorMilhao = saida,
    };
}

/// <summary>Registro em memória, para testar o gateway sem banco.</summary>
internal sealed class RegistroEmMemoria : IRegistroChamadasIa
{
    public List<ChamadaIa> Chamadas { get; } = [];

    public Task SaveAsync(ChamadaIa chamada)
    {
        Chamadas.Add(chamada);
        return Task.CompletedTask;
    }
}

/// <summary>Cota fixa para os testes do gateway, sem banco.</summary>
internal sealed class FakeVerificadorCota(Stowise.Application.Ia.UsoCotaIa? uso = null) : IVerificadorCotaIa
{
    public static readonly FakeVerificadorCota Livre = new();

    public List<(Guid UsuarioId, FuncionalidadeIa Funcionalidade)> Consultas { get; } = [];

    public Task<Stowise.Application.Ia.UsoCotaIa> CheckAsync(Guid usuarioId, FuncionalidadeIa funcionalidade, CancellationToken cancellationToken)
    {
        Consultas.Add((usuarioId, funcionalidade));
        return Task.FromResult(uso ?? new Stowise.Application.Ia.UsoCotaIa(funcionalidade, 0, null, 0, null, null, false));
    }
}
