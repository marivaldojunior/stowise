using Microsoft.EntityFrameworkCore;
using Pgvector;
using Pgvector.EntityFrameworkCore;
using Stowise.Application.Catalogo;
using Stowise.Application.Common;
using Stowise.Infrastructure.Ia;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Catalogo;

/// <summary>
/// Similares por embeddings quando o modelo está ligado e já há vetores; senão, por trigramas (ADR-0011). Considera só
/// produtos ativos.
/// </summary>
internal sealed class BuscaProdutosSimilares(StowiseDbContext db, GeradorEmbeddings gerador) : IBuscaProdutosSimilares
{
    /// <summary>Abaixo disso, dois textos quase não têm trigramas em comum.</summary>
    public const double TrigramaMinimo = 0.1;

    public async Task<Result<ProdutosSimilares>> FindAsync(string? texto, int? limite, CancellationToken cancellationToken = default)
    {
        var valor = texto?.Trim();
        if (string.IsNullOrEmpty(valor))
        {
            return AppError.Validation("texto", "Informe o texto para buscar produtos parecidos.");
        }

        if (valor.Length > LimitesSimilares.TextoMaximo)
        {
            return AppError.Validation("texto", $"O texto deve ter no máximo {LimitesSimilares.TextoMaximo} caracteres.");
        }

        if (limite is < 1 or > LimitesSimilares.Maximo)
        {
            return AppError.Validation("limite", $"O limite vai de 1 a {LimitesSimilares.Maximo}.");
        }

        var quantidade = limite ?? LimitesSimilares.Padrao;
        if (gerador.Disponivel && await PorEmbeddingsAsync(valor, quantidade, cancellationToken) is { Count: > 0 } semanticos)
        {
            return new ProdutosSimilares(MetodoSimilaridade.Semantica, semanticos);
        }

        return new ProdutosSimilares(MetodoSimilaridade.Trigramas, await PorTrigramasAsync(valor, quantidade, cancellationToken));
    }

    private async Task<List<ProdutoSimilar>?> PorEmbeddingsAsync(string texto, int quantidade, CancellationToken cancellationToken)
    {
        var vetores = await gerador.GenerateAsync([texto], cancellationToken);
        if (vetores is null)
        {
            return null;
        }

        var consulta = new Vector(vetores[0]);
        var linhas = await db.ProdutoEmbeddings.AsNoTracking()
            .Where(e => e.Modelo == gerador.Modelo)
            .Join(db.Produtos.Where(p => p.Ativo), e => e.ProdutoId, p => p.Id, (e, p) => new { p.Id, p.Sku, p.Descricao, p.UnidadeBase, Distancia = e.Vetor.CosineDistance(consulta) })
            .OrderBy(x => x.Distancia)
            .Take(quantidade)
            .ToListAsync(cancellationToken);

        // Distância de cosseno vai de 0 (mesma direção) a 2 (oposta); a pontuação vai de 1 a 0.
        return [.. linhas.Select(x => new ProdutoSimilar(x.Id, x.Sku, x.Descricao, x.UnidadeBase, Math.Clamp(1 - (x.Distancia / 2), 0, 1)))];
    }

    private async Task<List<ProdutoSimilar>> PorTrigramasAsync(string texto, int quantidade, CancellationToken cancellationToken)
    {
        var linhas = await db.Produtos.AsNoTracking()
            .Where(p => p.Ativo)
            .Select(p => new { p.Id, p.Sku, p.Descricao, p.UnidadeBase, Pontuacao = EF.Functions.TrigramsSimilarity(p.Descricao, texto) })
            .Where(x => x.Pontuacao >= TrigramaMinimo)
            .OrderByDescending(x => x.Pontuacao)
            .ThenBy(x => x.Id)
            .Take(quantidade)
            .ToListAsync(cancellationToken);

        return [.. linhas.Select(x => new ProdutoSimilar(x.Id, x.Sku, x.Descricao, x.UnidadeBase, x.Pontuacao))];
    }
}
