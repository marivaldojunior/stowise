using Stowise.Application.Common;

namespace Stowise.Application.Catalogo;

/// <summary>
/// Produtos do catálogo parecidos com um texto (ex.: o xProd da NF-e), para o casamento de itens (ADR-0011). Só sugere:
/// quem confirma o vínculo é uma pessoa.
/// </summary>
public interface IBuscaProdutosSimilares
{
    Task<Result<ProdutosSimilares>> FindAsync(string? texto, int? limite, CancellationToken cancellationToken = default);
}

public static class LimitesSimilares
{
    public const int Padrao = 5;

    public const int Maximo = 20;

    public const int TextoMaximo = 200;
}

/// <summary>Como a busca comparou os textos.</summary>
public enum MetodoSimilaridade
{
    /// <summary>Distância de cosseno entre embeddings (entende sinônimos e abreviações).</summary>
    Semantica,

    /// <summary>Trigramas do PostgreSQL (compara letras), quando não há embeddings.</summary>
    Trigramas,
}

public sealed record ProdutosSimilares(MetodoSimilaridade Metodo, IReadOnlyList<ProdutoSimilar> Produtos);

/// <param name="Pontuacao">De 0 (nada parecido) a 1 (igual).</param>
public sealed record ProdutoSimilar(Guid Id, string Sku, string Descricao, string UnidadeBase, double Pontuacao);
