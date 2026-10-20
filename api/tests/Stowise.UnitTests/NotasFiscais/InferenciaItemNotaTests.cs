using Stowise.Application.NotasFiscais;

namespace Stowise.UnitTests.NotasFiscais;

public class InferenciaItemNotaTests
{
    private static readonly DateTimeOffset Emissao = new(2026, 10, 20, 9, 30, 0, TimeSpan.FromHours(-3));

    [Fact]
    public void Ten_boxes_of_120_units_give_factor_12()
    {
        var resultado = InferenciaItemNota.Infer(Item("CX", 10, "UN", 120), Emissao, Produto("UN", fator: 12));

        Assert.Equal(new ConversaoItem(12m, OrigemFator.Nota, 120m), resultado.Conversao);
        Assert.Empty(resultado.Alertas);
    }

    [Fact]
    public void Unit_synonyms_count_as_the_base_unit()
    {
        var resultado = InferenciaItemNota.Infer(Item("FD", 2, "und", 24), Emissao, Produto("UN", fator: 12));

        Assert.Equal(OrigemFator.Nota, resultado.Conversao.Origem);
        Assert.Equal(12m, resultado.Conversao.Fator);
    }

    [Fact]
    public void Weight_factor_keeps_four_decimal_places()
    {
        var resultado = InferenciaItemNota.Infer(Item("CX", 3, "KG", 10, new LoteNota("L1", 3, null, null)), Emissao, Produto("KG", fator: 3.3333m));

        Assert.Equal(3.3333m, resultado.Conversao.Fator);

        // A quantidade base vem da razão exata (10 / 3 × 3), não do fator arredondado (9,9999).
        Assert.Equal(10m, resultado.Conversao.QuantidadeBase);
        Assert.Equal(10m, resultado.Lotes.Single().QuantidadeBase);
    }

    [Fact]
    public void Factor_from_the_invoice_that_differs_from_the_catalog_is_flagged()
    {
        var resultado = InferenciaItemNota.Infer(Item("CX", 10, "UN", 60), Emissao, Produto("UN", fator: 12));

        Assert.Equal(6m, resultado.Conversao.Fator);
        Assert.Contains(AlertaItemNota.FatorDivergente, resultado.Alertas);
    }

    [Fact]
    public void Other_taxable_unit_falls_back_to_the_catalog_factor()
    {
        // A unidade tributável (CX) não é a base (UN): a nota não diz quantas unidades há na caixa.
        var resultado = InferenciaItemNota.Infer(Item("CX", 10, "CX", 10), Emissao, Produto("UN", fator: 12, origem: OrigemFator.DePara));

        Assert.Equal(new ConversaoItem(12m, OrigemFator.DePara, 120m), resultado.Conversao);
        Assert.Empty(resultado.Alertas);
    }

    [Fact]
    public void Without_a_matched_product_the_taxable_unit_becomes_the_base()
    {
        var resultado = InferenciaItemNota.Infer(Item("PCT", 5, "UN", 500), Emissao, produto: null);

        Assert.Equal(new ConversaoItem(100m, OrigemFator.Nota, 500m), resultado.Conversao);
    }

    [Fact]
    public void Zero_quantity_leaves_the_factor_unknown()
    {
        var resultado = InferenciaItemNota.Infer(Item("CX", 0, "UN", 0), Emissao, produto: null);

        Assert.Equal(new ConversaoItem(null, OrigemFator.Desconhecido, null), resultado.Conversao);
    }

    [Fact]
    public void Batches_are_converted_to_the_base_unit()
    {
        var item = Item("CX", 10, "UN", 120, new LoteNota("L1", 6, null, new DateOnly(2027, 1, 31)), new LoteNota("L2", 4, null, new DateOnly(2027, 2, 28)));

        var resultado = InferenciaItemNota.Infer(item, Emissao, Produto("UN", fator: 12, controlaLote: true, controlaValidade: true));

        Assert.Equal([72m, 48m], resultado.Lotes.Select(l => l.QuantidadeBase));
        Assert.Empty(resultado.Alertas);
    }

    [Fact]
    public void Batch_problems_become_alerts()
    {
        var item = Item("CX", 10, "UN", 120, new LoteNota("L1", 6, null, new DateOnly(2026, 10, 19)), new LoteNota("L2", 3, null, null));

        var resultado = InferenciaItemNota.Infer(item, Emissao, Produto("UN", fator: 12, controlaLote: true, controlaValidade: true));

        Assert.Equal(
            [AlertaItemNota.LotesNaoFecham, AlertaItemNota.ValidadeFaltando, AlertaItemNota.LoteVencido],
            resultado.Alertas);
    }

    [Fact]
    public void Product_with_batch_control_needs_the_tracking_group()
    {
        var resultado = InferenciaItemNota.Infer(Item("CX", 10, "UN", 120), Emissao, Produto("UN", fator: 12, controlaLote: true));

        Assert.Equal([AlertaItemNota.LoteFaltando], resultado.Alertas);
    }

    private static ItemNota Item(string uCom, decimal qCom, string uTrib, decimal qTrib, params LoteNota[] lotes) =>
        new(1, "REF-001", null, "REFRIGERANTE COLA 2L", "22021000", null, "5102", uCom, qCom, 95.4m, null, uTrib, qTrib, lotes);

    private static ProdutoParaInferencia Produto(
        string unidadeBase,
        decimal fator,
        bool controlaLote = false,
        bool controlaValidade = false,
        OrigemFator origem = OrigemFator.Embalagem) =>
        new(unidadeBase, controlaLote, controlaValidade, fator, origem);
}
