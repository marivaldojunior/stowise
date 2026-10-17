using Stowise.Domain.Catalogo;

namespace Stowise.UnitTests.Catalogo;

public class GtinAndCodigosFiscaisTests
{
    [Theory]
    [InlineData("7891000315507")] // GTIN-13
    [InlineData("96385074")] // GTIN-8
    [InlineData("036000291452")] // GTIN-12 (UPC-A)
    [InlineData("17891000315504")] // GTIN-14 (caixa)
    public void Valid_gtins_pass_the_check_digit(string gtin)
    {
        Assert.True(Gtin.IsValid(gtin));
    }

    [Theory]
    [InlineData("7891000315508")] // dígito verificador errado
    [InlineData("789100031550")] // 12 dígitos com dígito errado
    [InlineData("78910003155")] // 11 dígitos: tamanho inválido
    [InlineData("789100031550A")]
    [InlineData("SEM GTIN")]
    [InlineData("")]
    [InlineData(null)]
    public void Invalid_gtins_are_rejected(string? gtin)
    {
        Assert.False(Gtin.IsValid(gtin));
    }

    [Theory]
    [InlineData("2202.10.00", "22021000", true)]
    [InlineData("22021000", "22021000", true)]
    [InlineData("2202.10", "220210", false)]
    public void Ncm_is_normalized_and_needs_8_digits(string input, string normalized, bool valid)
    {
        var result = CodigosFiscais.NormalizeNcm(input);

        Assert.Equal(normalized, result);
        Assert.Equal(valid, CodigosFiscais.IsValidNcm(result));
    }

    [Fact]
    public void Cest_needs_7_digits_and_blank_means_absent()
    {
        Assert.True(CodigosFiscais.IsValidCest(CodigosFiscais.NormalizeCest("03.002.00")));
        Assert.False(CodigosFiscais.IsValidCest(CodigosFiscais.NormalizeCest("03.002")));
        Assert.Null(CodigosFiscais.NormalizeCest("  "));
    }
}
