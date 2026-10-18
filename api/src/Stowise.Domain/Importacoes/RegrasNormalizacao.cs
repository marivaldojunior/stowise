using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;

namespace Stowise.Domain.Importacoes;

/// <summary>Como uma unidade escrita no arquivo (ex.: "Pç") vira o código do cadastro (ex.: "PC").</summary>
public sealed record UnidadeDePara(string Origem, string Destino);

/// <summary>
/// Regras de normalização da importação (SPEC, decisão 7): a IA pode sugerir, uma pessoa confirma e o código aplica
/// de forma determinística em todas as linhas. A IA nunca normaliza linha por linha.
/// </summary>
/// <param name="SeparadorDecimal">Nulo: vale o separador do layout detectado.</param>
/// <param name="ValoresVerdadeiros">Textos extras que valem "sim" (além de sim, s, x, 1, true).</param>
/// <param name="ValoresFalsos">Textos extras que valem "não".</param>
public sealed record RegrasNormalizacao(
    string? SeparadorDecimal,
    IReadOnlyList<UnidadeDePara> Unidades,
    IReadOnlyList<string> ValoresVerdadeiros,
    IReadOnlyList<string> ValoresFalsos)
{
    public const int MaxItens = 50;

    public static readonly RegrasNormalizacao Vazias = new(null, [], [], []);

    /// <summary>Regras válidas, sem itens vazios ou repetidos. Unidade de destino segue a regra do cadastro.</summary>
    public RegrasNormalizacao Validate()
    {
        if (SeparadorDecimal is not (null or "," or "."))
        {
            throw new DomainException("O separador decimal deve ser vírgula ou ponto.");
        }

        if (Unidades.Count > MaxItens || ValoresVerdadeiros.Count > MaxItens || ValoresFalsos.Count > MaxItens)
        {
            throw new DomainException($"Cada lista de regras aceita no máximo {MaxItens} itens.");
        }

        var unidades = new List<UnidadeDePara>();
        foreach (var regra in Unidades)
        {
            var origem = regra.Origem?.Trim() ?? string.Empty;
            var destino = regra.Destino?.Trim().ToUpperInvariant() ?? string.Empty;
            if (origem.Length == 0 || !Produto.IsValidUnidadeBase(destino))
            {
                throw new DomainException($"Regra de unidade inválida: \"{regra.Origem}\" → \"{regra.Destino}\". O destino tem até 6 letras ou números.");
            }

            if (unidades.TrueForAll(u => !string.Equals(u.Origem, origem, StringComparison.OrdinalIgnoreCase)))
            {
                unidades.Add(new UnidadeDePara(origem, destino));
            }
        }

        static List<string> Limpar(IEnumerable<string> valores) =>
            [.. valores.Select(v => v?.Trim() ?? string.Empty).Where(v => v.Length > 0).Distinct(StringComparer.OrdinalIgnoreCase)];

        var verdadeiros = Limpar(ValoresVerdadeiros);
        var falsos = Limpar(ValoresFalsos);
        if (verdadeiros.Intersect(falsos, StringComparer.OrdinalIgnoreCase).FirstOrDefault() is { } ambos)
        {
            throw new DomainException($"O valor \"{ambos}\" não pode valer sim e não ao mesmo tempo.");
        }

        return new RegrasNormalizacao(SeparadorDecimal, unidades, verdadeiros, falsos);
    }

    /// <summary>Mesmo conteúdo (listas comparadas item a item), para o template saber se as regras mudaram.</summary>
    public bool SameAs(RegrasNormalizacao? outras) =>
        outras is not null
        && SeparadorDecimal == outras.SeparadorDecimal
        && Unidades.SequenceEqual(outras.Unidades)
        && ValoresVerdadeiros.SequenceEqual(outras.ValoresVerdadeiros, StringComparer.Ordinal)
        && ValoresFalsos.SequenceEqual(outras.ValoresFalsos, StringComparer.Ordinal);
}

/// <summary>Coluna sugerida pela IA, com a confiança (0 a 1) que o painel mostra na revisão.</summary>
public sealed record ColunaSugerida(string Campo, int Coluna, decimal Confianca);

/// <summary>Sugestão de mapeamento da IA, guardada como foi recebida (depois de limpa) para a pessoa revisar.</summary>
/// <param name="ChamadaIaId">Registro da chamada que gerou a sugestão (custo, modelo, prompt).</param>
public sealed record SugestaoIa(
    IReadOnlyList<ColunaSugerida> Colunas,
    RegrasNormalizacao Regras,
    string? Observacao,
    Guid? ChamadaIaId);
