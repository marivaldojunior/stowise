using Stowise.Domain.NotasFiscais;

namespace Stowise.UnitTests.NotasFiscais;

public class ChaveAcessoTests
{
    // SP (35), outubro de 2026, CNPJ 11.222.333/0001-81, modelo 55, série 1, número 1234, emissão normal, código 12345678.
    private const string Numerica = "35261011222333000181550010000012341123456787";

    // A mesma nota com o CNPJ alfanumérico 12.ABC.345/01DE-35.
    private const string Alfanumerica = "35261012ABC34501DE35550010000012341123456788";

    [Fact]
    public void Reads_every_part_of_the_key()
    {
        Assert.True(ChaveAcesso.TryParse(Numerica, out var chave));

        Assert.Equal("35", chave.Uf);
        Assert.Equal("2610", chave.AnoMes);
        Assert.Equal("11222333000181", chave.DocumentoEmitente);
        Assert.Equal("55", chave.Modelo);
        Assert.Equal(1, chave.Serie);
        Assert.Equal(1234, chave.Numero);
    }

    [Fact]
    public void Accepts_the_alphanumeric_cnpj_in_lowercase()
    {
        Assert.True(ChaveAcesso.TryParse(Alfanumerica.ToLowerInvariant(), out var chave));
        Assert.Equal("12ABC34501DE35", chave.DocumentoEmitente);
    }

    [Theory]
    [InlineData("35261011222333000181550010000012341123456786")] // dígito errado
    [InlineData("35261011222333000181550010000012341123456788")]
    [InlineData("3526101122233300018155001000001234112345678")] // 43 caracteres
    [InlineData("35261011222333000181550010000012341123456787X")]
    [InlineData("3526101122233300018155001000001234112345678A")] // dígito com letra
    [InlineData("")]
    [InlineData(null)]
    public void Rejects_invalid_keys(string? valor)
    {
        Assert.False(ChaveAcesso.TryParse(valor, out var chave));
        Assert.Null(chave);
    }
}
