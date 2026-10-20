namespace Stowise.Application.NotasFiscais;

/// <summary>De onde veio o fator de conversão do item (unidades base por unidade comercial da nota).</summary>
public enum OrigemFator
{
    /// <summary>A unidade tributável da nota é a unidade base do produto: fator = qTrib / qCom.</summary>
    Nota,

    /// <summary>Do vínculo confirmado do fornecedor.</summary>
    DePara,

    /// <summary>Da embalagem casada pelo GTIN.</summary>
    Embalagem,

    /// <summary>Sem dado para inferir: uma pessoa informa.</summary>
    Desconhecido,
}

/// <summary>Avisos para a revisão do item. Nenhum aviso impede a análise; todos pedem o olhar de uma pessoa.</summary>
public enum AlertaItemNota
{
    /// <summary>O fator da nota é diferente do fator do de-para ou da embalagem.</summary>
    FatorDivergente,

    /// <summary>A soma das quantidades dos lotes (qLote) é diferente da quantidade do item (qCom).</summary>
    LotesNaoFecham,

    /// <summary>O produto controla lote, mas a nota não traz o rastro.</summary>
    LoteFaltando,

    /// <summary>O produto controla validade, mas algum lote não traz a data de validade.</summary>
    ValidadeFaltando,

    /// <summary>Algum lote já estava vencido na data de emissão da nota.</summary>
    LoteVencido,
}

/// <param name="Fator">Unidades base em 1 unidade comercial; nulo quando <see cref="OrigemFator.Desconhecido"/>.</param>
/// <param name="QuantidadeBase">qCom × fator, na unidade base; nula sem fator.</param>
public sealed record ConversaoItem(decimal? Fator, OrigemFator Origem, decimal? QuantidadeBase);

/// <param name="QuantidadeBase">qLote × fator, na unidade base; nula sem fator.</param>
public sealed record LoteInferido(string Numero, decimal QuantidadeNota, decimal? QuantidadeBase, DateOnly? Fabricacao, DateOnly? Validade);

/// <summary>O que o catálogo já sabe do produto casado, para conferir a nota.</summary>
/// <param name="FatorCadastro">Fator do de-para ou da embalagem casada.</param>
public sealed record ProdutoParaInferencia(
    string UnidadeBase,
    bool ControlaLote,
    bool ControlaValidade,
    decimal FatorCadastro,
    OrigemFator OrigemCadastro);

public sealed record InferenciaItem(ConversaoItem Conversao, IReadOnlyList<LoteInferido> Lotes, IReadOnlyList<AlertaItemNota> Alertas);

/// <summary>
/// Inferência determinística do fator de conversão (uCom/qCom × uTrib/qTrib) e dos lotes (rastro) de um item da NF-e
/// (SPEC, 2.2). Ex.: 10 CX e 120 UN, com a unidade base UN, dão fator 12. Sem IA.
/// </summary>
public static class InferenciaItemNota
{
    /// <summary>Casas decimais das quantidades (SPEC, decisão 2: decimal(18,4)).</summary>
    public const int Casas = 4;

    private static readonly Dictionary<string, string> Sinonimos = new(StringComparer.OrdinalIgnoreCase)
    {
        ["UND"] = "UN",
        ["UNID"] = "UN",
        ["UNIDADE"] = "UN",
        ["UNI"] = "UN",
        ["KGS"] = "KG",
        ["QUILO"] = "KG",
        ["LT"] = "L",
        ["LTS"] = "L",
        ["LITRO"] = "L",
        ["MT"] = "M",
        ["MTS"] = "M",
        ["METRO"] = "M",
    };

    /// <param name="produto">Produto casado; nulo quando o item ainda não tem produto (o fator da nota não é conferido).</param>
    public static InferenciaItem Infer(ItemNota item, DateTimeOffset dataEmissao, ProdutoParaInferencia? produto)
    {
        ArgumentNullException.ThrowIfNull(item);

        var alertas = new List<AlertaItemNota>();
        var conversao = Conversao(item, produto, alertas);

        // Com o fator da nota, a conta usa a razão exata qTrib / qCom e arredonda só no fim (3 CX = 10 KG, não 9,9999).
        Func<decimal, decimal?> paraBase = conversao.Origem == OrigemFator.Nota
            ? q => Math.Round(q * item.QuantidadeTributavel / item.QuantidadeComercial, Casas, MidpointRounding.AwayFromZero)
            : q => Base(q, conversao.Fator);
        var lotes = item.Lotes
            .Select(l => new LoteInferido(l.Numero, l.Quantidade, paraBase(l.Quantidade), l.Fabricacao, l.Validade))
            .ToList();

        if (lotes.Count > 0 && lotes.Sum(l => l.QuantidadeNota) != item.QuantidadeComercial)
        {
            alertas.Add(AlertaItemNota.LotesNaoFecham);
        }

        if (produto is { ControlaLote: true } && lotes.Count == 0)
        {
            alertas.Add(AlertaItemNota.LoteFaltando);
        }

        if (produto is { ControlaValidade: true } && lotes.Any(l => l.Validade is null))
        {
            alertas.Add(AlertaItemNota.ValidadeFaltando);
        }

        if (lotes.Any(l => l.Validade < DateOnly.FromDateTime(dataEmissao.Date)))
        {
            alertas.Add(AlertaItemNota.LoteVencido);
        }

        return new InferenciaItem(conversao, lotes, alertas);
    }

    /// <summary>Unidade sem espaços, em maiúsculas e com os sinônimos comuns trocados (UND → UN, KGS → KG, LT → L).</summary>
    public static string NormalizeUnidade(string unidade)
    {
        var limpa = unidade.Trim().ToUpperInvariant();
        return Sinonimos.TryGetValue(limpa, out var padrao) ? padrao : limpa;
    }

    private static ConversaoItem Conversao(ItemNota item, ProdutoParaInferencia? produto, List<AlertaItemNota> alertas)
    {
        var fatorNota = FatorDaNota(item, produto?.UnidadeBase);
        if (fatorNota is { } fator)
        {
            if (produto is not null && produto.FatorCadastro != fator)
            {
                alertas.Add(AlertaItemNota.FatorDivergente);
            }

            return new ConversaoItem(fator, OrigemFator.Nota, item.QuantidadeTributavel);
        }

        return produto is null
            ? new ConversaoItem(null, OrigemFator.Desconhecido, null)
            : new ConversaoItem(produto.FatorCadastro, produto.OrigemCadastro, Base(item.QuantidadeComercial, produto.FatorCadastro));
    }

    /// <summary>
    /// qTrib / qCom quando a unidade tributável é a unidade base do produto. Sem produto casado, o produto novo nasce com
    /// a unidade tributável como unidade base, então o fator também é qTrib / qCom.
    /// </summary>
    private static decimal? FatorDaNota(ItemNota item, string? unidadeBase)
    {
        if (item.QuantidadeComercial <= 0 || item.QuantidadeTributavel <= 0)
        {
            return null;
        }

        var tributavel = NormalizeUnidade(item.UnidadeTributavel);
        return unidadeBase is null || tributavel == NormalizeUnidade(unidadeBase)
            ? Math.Round(item.QuantidadeTributavel / item.QuantidadeComercial, Casas, MidpointRounding.AwayFromZero)
            : null;
    }

    private static decimal? Base(decimal quantidade, decimal? fator) =>
        fator is null ? null : Math.Round(quantidade * fator.Value, Casas, MidpointRounding.AwayFromZero);
}
