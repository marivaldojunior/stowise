using Stowise.Domain.Catalogo;

namespace Stowise.Domain.Armazenagem;

/// <summary>
/// Classificação ABC pelo giro (ADR-0012). Do maior para o menor giro, o produto é A enquanto a soma dos giros
/// anteriores fica abaixo de <c>limiteA</c>% do total, e B abaixo de <c>limiteB</c>%; o resto é C. Por isso o primeiro
/// produto com giro é sempre A. Produto sem giro é C. O empate é decidido pelo id, para o resultado ser estável.
/// </summary>
public static class CurvaAbc
{
    public const decimal LimiteAPadrao = 80m;
    public const decimal LimiteBPadrao = 95m;

    /// <param name="giro">Giro por produto (ex.: número de saídas na janela). Produtos sem giro podem faltar.</param>
    /// <param name="produtos">Todos os produtos a classificar.</param>
    public static IReadOnlyDictionary<Guid, ClasseAbc> Classificar(
        IReadOnlyDictionary<Guid, decimal> giro,
        IEnumerable<Guid> produtos,
        decimal limiteA = LimiteAPadrao,
        decimal limiteB = LimiteBPadrao)
    {
        ArgumentNullException.ThrowIfNull(giro);
        ArgumentNullException.ThrowIfNull(produtos);
        if (limiteA <= 0 || limiteA > limiteB || limiteB > 100)
        {
            throw new ArgumentException("Limits must satisfy 0 < A <= B <= 100.", nameof(limiteA));
        }

        var classes = produtos.Distinct().ToDictionary(id => id, _ => ClasseAbc.C);
        var comGiro = giro
            .Where(g => g.Value > 0 && classes.ContainsKey(g.Key))
            .OrderByDescending(g => g.Value)
            .ThenBy(g => g.Key)
            .ToList();
        var total = comGiro.Sum(g => g.Value);

        var acumulado = 0m;
        foreach (var (id, valor) in comGiro)
        {
            var antes = acumulado / total * 100m;
            classes[id] = antes < limiteA ? ClasseAbc.A : antes < limiteB ? ClasseAbc.B : ClasseAbc.C;
            acumulado += valor;
        }

        return classes;
    }
}
