using Anthropic;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using OllamaSharp;

namespace Stowise.Infrastructure.Ia;

/// <summary>Configuração da camada de IA (seção <c>Ia</c>). A chave do provedor fica só no servidor (ADR-0004, item 1).</summary>
public sealed class IaOptions
{
    public const string SectionName = "Ia";

    /// <summary>Desligada, nenhuma funcionalidade chama IA e os fluxos seguem manuais.</summary>
    public bool Habilitada { get; set; }

    public ProvedorIaOptions Principal { get; set; } = new();

    /// <summary>Provedor usado quando o principal falha (fallback, ADR-0004 item 4). Opcional.</summary>
    public ProvedorIaOptions? Reserva { get; set; }
}

public sealed class ProvedorIaOptions
{
    public const string Anthropic = "Anthropic";
    public const string Ollama = "Ollama";

    /// <summary><see cref="Anthropic"/> ou <see cref="Ollama"/>.</summary>
    public string Provedor { get; set; } = Anthropic;

    public string Modelo { get; set; } = "claude-opus-5-5";

    /// <summary>Endereço do servidor (Ollama). Na Anthropic, vazio usa a API pública.</summary>
    public string? Endpoint { get; set; }

    /// <summary>Chave da Anthropic. Vazia, o SDK lê <c>ANTHROPIC_API_KEY</c> do ambiente. Nunca versionar.</summary>
    public string? ApiKey { get; set; }

    public int MaxTokensSaida { get; set; } = 4096;

    /// <summary>Preço em dólares por milhão de tokens de entrada, para o custo estimado.</summary>
    public decimal PrecoEntradaPorMilhao { get; set; }

    public decimal PrecoSaidaPorMilhao { get; set; }

    public decimal? EstimateCost(int? tokensEntrada, int? tokensSaida) =>
        tokensEntrada is null && tokensSaida is null
            ? null
            : Math.Round((((tokensEntrada ?? 0) * PrecoEntradaPorMilhao) + ((tokensSaida ?? 0) * PrecoSaidaPorMilhao)) / 1_000_000m, 6);
}

/// <summary>Traces das chamadas de IA (OpenTelemetry), exportados junto com os da API.</summary>
public static class IaTelemetry
{
    public const string SourceName = "Stowise.Ia";
}

/// <summary>Um provedor pronto para uso: o cliente e a configuração que o originou.</summary>
internal sealed record ProvedorIa(string Nome, IChatClient Cliente, ProvedorIaOptions Opcoes);

/// <summary>Os clientes de IA configurados. Trocar de provedor não afeta Domain, Application nem os clientes.</summary>
internal interface IProvedoresIa
{
    /// <summary>Nulo quando a IA está desligada.</summary>
    ProvedorIa? Principal { get; }

    ProvedorIa? Reserva { get; }
}

/// <summary>
/// Cria os <see cref="IChatClient"/> do <c>Microsoft.Extensions.AI</c> a partir da configuração: Anthropic pelo
/// SDK oficial e Ollama pelo OllamaSharp. Cada cliente ganha traces do OpenTelemetry (<see cref="IaTelemetry"/>).
/// </summary>
internal sealed class ProvedoresIa : IProvedoresIa, IDisposable
{
    private readonly List<IDisposable> _descartaveis = [];

    public ProvedoresIa(IOptions<IaOptions> options, ILoggerFactory loggers)
    {
        ArgumentNullException.ThrowIfNull(options);

        var ia = options.Value;
        if (!ia.Habilitada)
        {
            return;
        }

        Principal = Create(ia.Principal, loggers);
        Reserva = ia.Reserva is null ? null : Create(ia.Reserva, loggers);
    }

    public ProvedorIa? Principal { get; }

    public ProvedorIa? Reserva { get; }

    public void Dispose()
    {
        foreach (var descartavel in _descartaveis)
        {
            descartavel.Dispose();
        }
    }

    private ProvedorIa Create(ProvedorIaOptions opcoes, ILoggerFactory loggers)
    {
        IChatClient cliente = opcoes.Provedor switch
        {
            ProvedorIaOptions.Anthropic => CreateAnthropic(opcoes),
            ProvedorIaOptions.Ollama => new OllamaApiClient(new Uri(opcoes.Endpoint ?? "http://localhost:11434"), opcoes.Modelo),
            _ => throw new InvalidOperationException($"Unknown AI provider '{opcoes.Provedor}'. Use {ProvedorIaOptions.Anthropic} or {ProvedorIaOptions.Ollama}."),
        };
        _descartaveis.Add(cliente);

        var instrumentado = new ChatClientBuilder(cliente)
            .UseOpenTelemetry(loggers, IaTelemetry.SourceName)
            .Build();
        return new ProvedorIa(opcoes.Provedor, instrumentado, opcoes);
    }

    private static IChatClient CreateAnthropic(ProvedorIaOptions opcoes)
    {
        var client = string.IsNullOrWhiteSpace(opcoes.ApiKey) ? new AnthropicClient() : new AnthropicClient { ApiKey = opcoes.ApiKey };
        return client.AsIChatClient(opcoes.Modelo);
    }
}
