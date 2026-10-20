using System.ClientModel;
using System.ClientModel.Primitives;
using Anthropic;
using Google.GenAI;
using Microsoft.Extensions.AI;
using OllamaSharp;
using OpenAI;
using OpenAI.Chat;
using HttpOptions = Google.GenAI.Types.HttpOptions;
using HttpRetryOptions = Google.GenAI.Types.HttpRetryOptions;

namespace Stowise.Infrastructure.Ia;

/// <summary>
/// Cria o <see cref="IChatClient"/> de um tipo de provedor. Um provedor novo é uma classe nova registrada no DI;
/// trocar entre os tipos já registrados é só configuração. As novas tentativas internas dos SDKs ficam
/// desligadas: quem decide tentar de novo é o <see cref="GatewayIa"/>, para contar as tentativas uma vez só.
/// </summary>
internal interface IFabricaProvedorIa
{
    string Tipo { get; }

    IChatClient Create(ProvedorIaOptions opcoes);

    /// <summary>
    /// Classificação de erros próprios do SDK: <c>true</c> para falha transitória, <c>false</c> para permanente e
    /// <c>null</c> para usar a regra geral do gateway (status 408, 429 e 5xx, rede e timeout).
    /// </summary>
    bool? IsTransient(Exception erro) => null;

    /// <summary>Gerador de embeddings do tipo (ADR-0011). Nem todo provedor gera embeddings (a Anthropic não gera).</summary>
    IEmbeddingGenerator<string, Embedding<float>> CreateEmbeddings(ProvedorIaOptions opcoes) =>
        throw new InvalidOperationException($"The AI provider type '{Tipo}' does not generate embeddings. Use OpenAICompativel, Gemini or Ollama.");
}

/// <summary>Claude pelo SDK oficial da Anthropic. Sem chave na configuração, o SDK lê <c>ANTHROPIC_API_KEY</c>.</summary>
internal sealed class AnthropicFabrica : IFabricaProvedorIa
{
    public string Tipo => "Anthropic";

    public IChatClient Create(ProvedorIaOptions opcoes)
    {
        ArgumentNullException.ThrowIfNull(opcoes);

        var client = string.IsNullOrWhiteSpace(opcoes.ApiKey)
            ? new AnthropicClient { MaxRetries = 0 }
            : new AnthropicClient { ApiKey = opcoes.ApiKey, MaxRetries = 0 };
        return client.AsIChatClient(opcoes.Modelo);
    }

    /// <summary>A falha de rede do SDK não herda de <see cref="IOException"/>.</summary>
    public bool? IsTransient(Exception erro) => erro is Anthropic.Exceptions.AnthropicIOException ? true : null;
}

/// <summary>
/// API no formato da OpenAI: a própria OpenAI e os provedores compatíveis (DeepSeek, Qwen/DashScope, Kimi/Moonshot,
/// GLM/Zhipu, Groq, Together, OpenRouter), trocando só o <see cref="ProvedorIaOptions.Endpoint"/>.
/// </summary>
internal sealed class OpenAICompativelFabrica : IFabricaProvedorIa
{
    public string Tipo => "OpenAICompativel";

    public IChatClient Create(ProvedorIaOptions opcoes)
    {
        ArgumentNullException.ThrowIfNull(opcoes);

        var (apiKey, clientOptions) = Cliente(opcoes);
        return new ChatClient(opcoes.Modelo, new ApiKeyCredential(apiKey), clientOptions).AsIChatClient();
    }

    public IEmbeddingGenerator<string, Embedding<float>> CreateEmbeddings(ProvedorIaOptions opcoes)
    {
        ArgumentNullException.ThrowIfNull(opcoes);

        var (apiKey, clientOptions) = Cliente(opcoes);
        return new OpenAI.Embeddings.EmbeddingClient(opcoes.Modelo, new ApiKeyCredential(apiKey), clientOptions).AsIEmbeddingGenerator();
    }

    private static (string ApiKey, OpenAIClientOptions Options) Cliente(ProvedorIaOptions opcoes)
    {
        var apiKey = string.IsNullOrWhiteSpace(opcoes.ApiKey) ? Environment.GetEnvironmentVariable("OPENAI_API_KEY") : opcoes.ApiKey;
        if (string.IsNullOrWhiteSpace(apiKey))
        {
            throw new InvalidOperationException($"The AI provider '{opcoes.Nome}' needs an ApiKey (or OPENAI_API_KEY).");
        }

        var clientOptions = new OpenAIClientOptions { RetryPolicy = new ClientRetryPolicy(maxRetries: 0) };
        if (!string.IsNullOrWhiteSpace(opcoes.Endpoint))
        {
            clientOptions.Endpoint = new Uri(opcoes.Endpoint);
        }

        return (apiKey, clientOptions);
    }
}

/// <summary>Gemini pelo SDK oficial do Google. Sem chave na configuração, usa <c>GOOGLE_API_KEY</c>.</summary>
internal sealed class GeminiFabrica : IFabricaProvedorIa
{
    public string Tipo => "Gemini";

    public IChatClient Create(ProvedorIaOptions opcoes)
    {
        ArgumentNullException.ThrowIfNull(opcoes);

        var apiKey = string.IsNullOrWhiteSpace(opcoes.ApiKey) ? Environment.GetEnvironmentVariable("GOOGLE_API_KEY") : opcoes.ApiKey;
        if (string.IsNullOrWhiteSpace(apiKey))
        {
            throw new InvalidOperationException($"The AI provider '{opcoes.Nome}' needs an ApiKey (or GOOGLE_API_KEY).");
        }

        var client = new Client(apiKey: apiKey, httpOptions: new HttpOptions { RetryOptions = new HttpRetryOptions { Attempts = 1 } });
        return client.AsIChatClient(opcoes.Modelo);
    }

    public IEmbeddingGenerator<string, Embedding<float>> CreateEmbeddings(ProvedorIaOptions opcoes)
    {
        ArgumentNullException.ThrowIfNull(opcoes);

        var apiKey = string.IsNullOrWhiteSpace(opcoes.ApiKey) ? Environment.GetEnvironmentVariable("GOOGLE_API_KEY") : opcoes.ApiKey;
        if (string.IsNullOrWhiteSpace(apiKey))
        {
            throw new InvalidOperationException($"The AI provider '{opcoes.Nome}' needs an ApiKey (or GOOGLE_API_KEY).");
        }

        var client = new Client(apiKey: apiKey, httpOptions: new HttpOptions { RetryOptions = new HttpRetryOptions { Attempts = 1 } });
        return client.AsIEmbeddingGenerator(opcoes.Modelo);
    }
}

/// <summary>Modelos abertos rodando localmente no Ollama (Llama, Qwen, DeepSeek, Gemma e outros). Sem chave.</summary>
internal sealed class OllamaFabrica : IFabricaProvedorIa
{
    public string Tipo => "Ollama";

    public IChatClient Create(ProvedorIaOptions opcoes)
    {
        ArgumentNullException.ThrowIfNull(opcoes);

        return new OllamaApiClient(new Uri(opcoes.Endpoint ?? "http://localhost:11434"), opcoes.Modelo);
    }

    public IEmbeddingGenerator<string, Embedding<float>> CreateEmbeddings(ProvedorIaOptions opcoes)
    {
        ArgumentNullException.ThrowIfNull(opcoes);

        return new OllamaApiClient(new Uri(opcoes.Endpoint ?? "http://localhost:11434"), opcoes.Modelo);
    }
}
