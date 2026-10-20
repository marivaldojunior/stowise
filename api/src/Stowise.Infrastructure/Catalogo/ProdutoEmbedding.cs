using Pgvector;

namespace Stowise.Infrastructure.Catalogo;

/// <summary>
/// Vetor da descrição de um produto (ADR-0011). Fica fora do domínio: é um índice de busca, recalculado pelo job, e
/// não uma regra de negócio. Desatualizado quando o texto (a descrição) ou o modelo mudam.
/// </summary>
internal sealed class ProdutoEmbedding
{
    public Guid ProdutoId { get; set; }

    public Vector Vetor { get; set; } = null!;

    /// <summary>Tipo e modelo que geraram o vetor (ex.: ollama:nomic-embed-text).</summary>
    public string Modelo { get; set; } = null!;

    /// <summary>Texto vetorizado (a descrição do produto quando o vetor foi gerado).</summary>
    public string Texto { get; set; } = null!;

    public DateTimeOffset GeradoEm { get; set; }
}
