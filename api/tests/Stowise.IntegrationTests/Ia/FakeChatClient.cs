using Microsoft.Extensions.AI;
using Stowise.Infrastructure.Ia;

namespace Stowise.IntegrationTests.Ia;

/// <summary>
/// <see cref="IChatClient"/> com respostas definidas pelo teste (ADR-0004: os testes nunca chamam o provedor real).
/// Guarda as mensagens recebidas para o teste conferir o que foi enviado.
/// </summary>
internal sealed class FakeChatClient(Func<IReadOnlyList<ChatMessage>, ChatOptions?, ChatResponse> responder) : IChatClient
{
    public List<(IReadOnlyList<ChatMessage> Mensagens, ChatOptions? Opcoes)> Recebidas { get; } = [];

    public static FakeChatClient Responding(string texto, long tokensEntrada = 1200, long tokensSaida = 300) =>
        new((_, opcoes) => new ChatResponse(new ChatMessage(ChatRole.Assistant, texto))
        {
            ModelId = opcoes?.ModelId,
            Usage = new UsageDetails { InputTokenCount = tokensEntrada, OutputTokenCount = tokensSaida },
        });

    public static FakeChatClient Failing(Exception erro) => new((_, _) => throw erro);

    public Task<ChatResponse> GetResponseAsync(IEnumerable<ChatMessage> messages, ChatOptions? options = null, CancellationToken cancellationToken = default)
    {
        var mensagens = messages.ToList();
        Recebidas.Add((mensagens, options));
        return Task.FromResult(responder(mensagens, options));
    }

    public IAsyncEnumerable<ChatResponseUpdate> GetStreamingResponseAsync(IEnumerable<ChatMessage> messages, ChatOptions? options = null, CancellationToken cancellationToken = default) =>
        throw new NotSupportedException("The fake client does not stream.");

    public object? GetService(Type serviceType, object? serviceKey = null) => null;

    public void Dispose()
    {
    }
}

/// <summary>Provedores fixos para os testes, no lugar dos criados pela configuração.</summary>
internal sealed class FakeProvedoresIa(IChatClient? principal, IChatClient? reserva = null) : IProvedoresIa
{
    public ProvedorIa? Principal { get; } = principal is null ? null : new ProvedorIa(ProvedorIaOptions.Anthropic, principal, Opcoes("claude-opus-5-5", 4m, 20m));

    public ProvedorIa? Reserva { get; } = reserva is null ? null : new ProvedorIa(ProvedorIaOptions.Ollama, reserva, Opcoes("llama3.2", 0m, 0m));

    private static ProvedorIaOptions Opcoes(string modelo, decimal entrada, decimal saida) => new()
    {
        Modelo = modelo,
        PrecoEntradaPorMilhao = entrada,
        PrecoSaidaPorMilhao = saida,
    };
}
