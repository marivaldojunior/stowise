using System.Globalization;

namespace Stowise.Domain.Armazenagem;

/// <summary>
/// Estratégia de pontuação de endereços. O <see cref="Codigo"/> é a chave da <c>RegraArmazenagem</c> gravada no banco.
/// Uma regra restritiva também recusa endereços, e a recusa vale mesmo com a regra inativa.
/// </summary>
public interface IRegraArmazenagem
{
    string Codigo { get; }

    bool Restritiva { get; }

    /// <summary>Parâmetros que a regra aceita, com o valor usado quando a configuração não traz o parâmetro.</summary>
    IReadOnlyDictionary<string, decimal> ParametrosPadrao { get; }

    /// <summary>Avalia todos os candidatos de uma vez (algumas regras comparam os endereços entre si).</summary>
    /// <returns>Uma avaliação por candidato, na mesma ordem.</returns>
    IReadOnlyList<AvaliacaoRegra> Avaliar(ItemArmazenagem item, IReadOnlyList<CandidatoEndereco> candidatos, ParametrosRegra parametros);
}

/// <param name="Nota">De 0 a 1; nula quando a regra não se aplica.</param>
/// <param name="Apto">Falso quando uma regra restritiva recusa o endereço.</param>
public sealed record AvaliacaoRegra(decimal? Nota, bool Apto, string Explicacao)
{
    public static AvaliacaoRegra Com(decimal nota, string explicacao) =>
        new(Math.Round(Math.Clamp(nota, 0m, 1m), 4), true, explicacao);

    public static AvaliacaoRegra NaoAplicavel(string explicacao) => new(null, true, explicacao);

    public static AvaliacaoRegra Inapto(string explicacao) => new(0m, false, explicacao);
}

/// <summary>Parâmetros numéricos de uma regra (o <c>ParametrosJson</c> da configuração), com valor padrão.</summary>
public sealed class ParametrosRegra(IReadOnlyDictionary<string, decimal>? valores)
{
    public static readonly ParametrosRegra Vazio = new(null);

    public decimal Get(string nome, decimal padrao) =>
        valores is not null && valores.TryGetValue(nome, out var valor) ? valor : padrao;
}

internal static class Formato
{
    public static string Numero(decimal valor) => valor.ToString("0.##", CultureInfo.GetCultureInfo("pt-BR"));

    public static string Percentual(decimal fracao) => $"{Numero(Math.Round(fracao * 100, 1))}%";

    public static string Data(DateOnly data) => data.ToString("dd/MM/yyyy", CultureInfo.InvariantCulture);
}
