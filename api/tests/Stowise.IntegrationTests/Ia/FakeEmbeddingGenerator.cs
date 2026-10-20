using Microsoft.Extensions.AI;
using Stowise.Infrastructure.Ia;

namespace Stowise.IntegrationTests.Ia;

/// <summary>
/// Gerador de embeddings dos testes: cada palavra-chave vira um eixo do vetor, então textos com as mesmas palavras
/// ficam próximos ("REFRIG COLA" perto de "Refrigerante Cola"). Pode falhar nas primeiras chamadas.
/// </summary>
internal sealed class FakeEmbeddingGenerator(int dimensoes = EmbeddingsIaOptions.Dimensoes, int falhas = 0, Exception? erro = null)
    : IEmbeddingGenerator<string, Embedding<float>>
{
    private static readonly string[] Eixos = ["cola", "agua", "copo", "cafe", "arroz"];

    private int _falhas = falhas;

    public int Chamadas { get; private set; }

    public Task<GeneratedEmbeddings<Embedding<float>>> GenerateAsync(
        IEnumerable<string> values,
        EmbeddingGenerationOptions? options = null,
        CancellationToken cancellationToken = default)
    {
        Chamadas++;
        if (_falhas > 0)
        {
            _falhas--;
            throw erro ?? new HttpRequestException("indisponível", null, System.Net.HttpStatusCode.ServiceUnavailable);
        }

        var embeddings = values.Select(texto => new Embedding<float>(Vetor(texto))).ToList();
        return Task.FromResult(new GeneratedEmbeddings<Embedding<float>>(embeddings) { Usage = new UsageDetails { InputTokenCount = 10 } });
    }

    public object? GetService(Type serviceType, object? serviceKey = null) => null;

    public void Dispose()
    {
    }

    private float[] Vetor(string texto)
    {
        var minusculo = texto.ToLowerInvariant().Replace("á", "a", StringComparison.Ordinal).Replace("é", "e", StringComparison.Ordinal);
        var vetor = new float[dimensoes];
        for (var i = 0; i < Eixos.Length && i < dimensoes; i++)
        {
            vetor[i] = minusculo.Contains(Eixos[i], StringComparison.Ordinal) ? 1 : 0;
        }

        // Um pouco em comum para nenhum vetor ser zero.
        vetor[^1] = 0.1f;
        return vetor;
    }
}
