using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Catalogo;

public class ProdutoTests
{
    private static readonly DadosEmbalagem SemMedidas = new(null, null, null, null, null);

    private static DadosProduto Dados(bool controlaLote = false, bool controlaValidade = false, string? ncm = null) =>
        new("Refrigerante Cola 2L", "un", ClasseArmazenagem.Normal, controlaLote, controlaValidade, ncm, null, null);

    private static Produto Novo() => Produto.Create("ref-cola-2l", Dados(), new DadosEmbalagem("7891000315507", 2.1m, 33m, 10m, 10m));

    [Fact]
    public void Create_normalizes_sku_and_unit_and_adds_the_base_package()
    {
        var produto = Novo();

        Assert.Equal("REF-COLA-2L", produto.Sku);
        Assert.Equal("UN", produto.UnidadeBase);
        Assert.True(produto.Ativo);
        var embalagem = Assert.Single(produto.Embalagens);
        Assert.True(embalagem.UnidadeBase);
        Assert.Equal(TipoEmbalagem.Unidade, embalagem.Tipo);
        Assert.Equal(1m, embalagem.FatorConversao);
        Assert.Equal(produto.Id, embalagem.ProdutoId);
        Assert.True(embalagem.TemMedidasCompletas);
    }

    [Theory]
    [InlineData("")]
    [InlineData("SKU COM ESPAÇO")]
    [InlineData("SKU/BARRA")]
    public void Create_rejects_invalid_sku(string sku)
    {
        Assert.Throws<DomainException>(() => Produto.Create(sku, Dados(), SemMedidas));
    }

    [Fact]
    public void Validity_control_requires_lot_control()
    {
        Assert.Throws<DomainException>(() => Produto.Create("SKU1", Dados(controlaLote: false, controlaValidade: true), SemMedidas));

        var produto = Produto.Create("SKU1", Dados(controlaLote: true, controlaValidade: true), SemMedidas);
        Assert.True(produto.ControlaValidade);
    }

    [Fact]
    public void Update_normalizes_ncm_and_rejects_wrong_length()
    {
        var produto = Novo();

        produto.Update(Dados(ncm: "2202.10.00"));
        Assert.Equal("22021000", produto.Ncm);

        Assert.Throws<DomainException>(() => produto.Update(Dados(ncm: "2202")));
    }

    [Fact]
    public void Base_package_without_measures_is_allowed_but_incomplete()
    {
        var produto = Produto.Create("SKU1", Dados(), SemMedidas);

        Assert.False(produto.EmbalagemBase.TemMedidasCompletas);
        Assert.Null(produto.EmbalagemBase.Gtin);
    }

    [Fact]
    public void AddEmbalagem_accepts_box_with_factor_above_one()
    {
        var produto = Novo();

        var caixa = produto.AddEmbalagem(TipoEmbalagem.Caixa, 6m, new DadosEmbalagem("17891000315504", 13m, 34m, 31m, 21m));

        Assert.Equal(2, produto.Embalagens.Count);
        Assert.False(caixa.UnidadeBase);
        Assert.Equal(6m, caixa.FatorConversao);
    }

    [Theory]
    [InlineData(TipoEmbalagem.Unidade, 6)]
    [InlineData(TipoEmbalagem.Caixa, 1)]
    [InlineData(TipoEmbalagem.Caixa, 0.5)]
    public void AddEmbalagem_rejects_unit_type_or_factor_not_above_one(TipoEmbalagem tipo, double fator)
    {
        Assert.Throws<DomainException>(() => Novo().AddEmbalagem(tipo, (decimal)fator, SemMedidas));
    }

    [Fact]
    public void AddEmbalagem_rejects_same_type_and_factor_and_repeated_gtin()
    {
        var produto = Novo();
        produto.AddEmbalagem(TipoEmbalagem.Caixa, 6m, SemMedidas);

        Assert.Throws<DomainException>(() => produto.AddEmbalagem(TipoEmbalagem.Caixa, 6m, SemMedidas));
        Assert.Throws<DomainException>(() => produto.AddEmbalagem(TipoEmbalagem.Caixa, 12m, new DadosEmbalagem("7891000315507", null, null, null, null)));

        var outraCaixa = produto.AddEmbalagem(TipoEmbalagem.Caixa, 12m, SemMedidas);
        Assert.Equal(12m, outraCaixa.FatorConversao);
    }

    [Fact]
    public void Package_rejects_invalid_gtin_and_non_positive_measures()
    {
        var produto = Novo();

        Assert.Throws<DomainException>(() => produto.AddEmbalagem(TipoEmbalagem.Palete, 120m, new DadosEmbalagem("123", null, null, null, null)));
        Assert.Throws<DomainException>(() => produto.AddEmbalagem(TipoEmbalagem.Palete, 120m, new DadosEmbalagem(null, 0m, null, null, null)));
    }

    [Fact]
    public void UpdateEmbalagem_changes_measures_and_keeps_type_and_factor()
    {
        var produto = Novo();
        var caixa = produto.AddEmbalagem(TipoEmbalagem.Caixa, 6m, SemMedidas);

        produto.UpdateEmbalagem(caixa.Id, new DadosEmbalagem(null, 13m, 34m, 31m, 21m));

        Assert.True(caixa.TemMedidasCompletas);
        Assert.Equal(6m, caixa.FatorConversao);
    }

    [Fact]
    public void Base_package_cannot_be_removed_but_others_can()
    {
        var produto = Novo();
        var caixa = produto.AddEmbalagem(TipoEmbalagem.Caixa, 6m, SemMedidas);

        Assert.Throws<DomainException>(() => produto.RemoveEmbalagem(produto.EmbalagemBase.Id));

        produto.RemoveEmbalagem(caixa.Id);
        Assert.Single(produto.Embalagens);
    }

    [Fact]
    public void Deactivate_and_reactivate_toggle_ativo()
    {
        var produto = Novo();

        produto.Deactivate();
        Assert.False(produto.Ativo);

        produto.Reactivate();
        Assert.True(produto.Ativo);
    }

    [Fact]
    public void Categoria_cannot_be_its_own_parent()
    {
        var categoria = Categoria.Create("Bebidas", parentId: null);

        Assert.Throws<DomainException>(() => categoria.Update("Bebidas", categoria.Id));
    }
}
