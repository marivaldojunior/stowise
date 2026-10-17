using Stowise.Application.Catalogo;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Catalogo;

public class CatalogoValidationTests
{
    private static CriarProduto Valid() => new(
        "REF-COLA-2L",
        "Refrigerante Cola 2L",
        "UN",
        ClasseArmazenagem.Normal,
        ControlaLote: true,
        ControlaValidade: true,
        "2202.10.00",
        null,
        null,
        new EmbalagemMedidas("7891000315507", 2.1m, 33m, 10m, 10m));

    [Fact]
    public void Valid_create_command_has_no_errors()
    {
        Assert.Empty(CatalogoValidation.Validate(Valid()));
    }

    [Fact]
    public void Create_reports_each_invalid_field()
    {
        var errors = CatalogoValidation.Validate(new CriarProduto(
            "sku inválido",
            "",
            "UNIDADE",
            null,
            ControlaLote: false,
            ControlaValidade: true,
            "123",
            "99",
            null,
            new EmbalagemMedidas("123", 0m, null, -1m, null)));

        Assert.Equal(
            ["cest", "classeArmazenagem", "controlaValidade", "descricao", "embalagemBase.gtin", "embalagemBase.larguraCm", "embalagemBase.pesoKg", "ncm", "sku", "unidadeBase"],
            errors.Keys.Order(StringComparer.Ordinal));
    }

    [Fact]
    public void Update_requires_versao()
    {
        var errors = CatalogoValidation.Validate(new AtualizarProduto(
            "Refrigerante", "UN", ClasseArmazenagem.Normal, false, false, null, null, null, Versao: null));

        Assert.Equal(["versao"], errors.Keys);
    }

    [Theory]
    [InlineData(null, 6)]
    [InlineData(TipoEmbalagem.Unidade, 6)]
    public void Add_package_requires_box_or_pallet(TipoEmbalagem? tipo, double fator)
    {
        var errors = CatalogoValidation.Validate(new AdicionarEmbalagem(tipo, (decimal)fator, null, null, null, null, null));

        Assert.Equal(["tipo"], errors.Keys);
    }

    [Theory]
    [InlineData(null)]
    [InlineData(1.0)]
    public void Add_package_requires_factor_above_one(double? fator)
    {
        var errors = CatalogoValidation.Validate(new AdicionarEmbalagem(TipoEmbalagem.Caixa, (decimal?)fator, null, null, null, null, null));

        Assert.Equal(["fatorConversao"], errors.Keys);
    }

    [Fact]
    public void Categoria_needs_a_name_within_the_limit()
    {
        Assert.Equal(["nome"], CatalogoValidation.Validate(new SalvarCategoria(" ", null)).Keys);
        Assert.Equal(["nome"], CatalogoValidation.Validate(new SalvarCategoria(new string('x', Categoria.NomeMaxLength + 1), null)).Keys);
        Assert.Empty(CatalogoValidation.Validate(new SalvarCategoria("Bebidas", null)));
    }
}
