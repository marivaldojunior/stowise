using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Rfid;

namespace Stowise.UnitTests.Rfid;

public class Sgtin96Tests
{
    // Exemplo do GS1 EPC Tag Data Standard: GTIN 80614141123458, prefixo 0614141, série 6789, filtro 3.
    private const string ExemploGs1Hex = "3074257BF7194E4000001A85";

    [Fact]
    public void Encodes_the_gs1_standard_example()
    {
        var epc = Sgtin96.Create("80614141123458", 7, 6789, FiltroEpc.Reservado3);

        Assert.Equal(ExemploGs1Hex, epc.Hex);
        Assert.Equal("urn:epc:id:sgtin:0614141.812345.6789", epc.Uri);
    }

    [Fact]
    public void Decodes_the_gs1_standard_example()
    {
        Assert.True(Sgtin96.TryParseHex(ExemploGs1Hex.ToLowerInvariant(), out var epc));

        Assert.Equal("80614141123458", epc!.Gtin14);
        Assert.Equal("0614141", epc.PrefixoEmpresa);
        Assert.Equal("812345", epc.ReferenciaItem);
        Assert.Equal(6789, epc.Serie);
        Assert.Equal(FiltroEpc.Reservado3, epc.Filtro);
    }

    [Theory]
    [InlineData("7891000315507", 6)] // GTIN-13 vira GTIN-14 com zero à esquerda
    [InlineData("17891000315504", 7)]
    [InlineData("17891000315504", 9)]
    [InlineData("17891000315504", 12)]
    [InlineData("96385074", 8)] // GTIN-8
    public void Round_trips_every_partition(string gtin, int tamanhoPrefixo)
    {
        var original = Sgtin96.Create(gtin, tamanhoPrefixo, Sgtin96.SerieMaxima, FiltroEpc.CaixaDeTransporte);

        Assert.True(Sgtin96.TryParseHex(original.Hex, out var lido));
        Assert.Equal(Gtin.ToGtin14(gtin), lido!.Gtin14);
        Assert.Equal(Sgtin96.SerieMaxima, lido.Serie);
        Assert.Equal(original.Hex, lido.Hex);
        Assert.Equal(FiltroEpc.CaixaDeTransporte, lido.Filtro);
    }

    [Theory]
    [InlineData("3074257BF7194E4000001A8")] // 23 caracteres
    [InlineData("3074257BF7194E4000001A85FF")] // mais de 96 bits
    [InlineData("3474257BF7194E4000001A85")] // cabeçalho 0x34 (SSCC-96), não SGTIN-96
    [InlineData("307C257BF7194E4000001A85")] // partição 7 não existe
    [InlineData("3074257BF7194E4000001A8G")] // não é hexadecimal
    [InlineData("7891000315507")] // código de barras, não EPC
    [InlineData("")]
    [InlineData(null)]
    public void Rejects_values_that_are_not_sgtin96(string? hex)
    {
        Assert.False(Sgtin96.TryParseHex(hex, out var epc));
        Assert.Null(epc);
    }

    [Fact]
    public void Rejects_item_reference_out_of_range()
    {
        // Partição 6 (prefixo de 6 dígitos): referência de 24 bits, mas só 7 dígitos (até 9999999). 0xFFFFFF = 16777215.
        Assert.False(Sgtin96.TryParseHex("301800003FFFFFC000000001", out _));
    }

    [Theory]
    [InlineData("7891000315508", 7, 1)] // dígito verificador errado
    [InlineData("7891000315507", 5, 1)] // prefixo curto demais
    [InlineData("7891000315507", 13, 1)] // prefixo longo demais
    [InlineData("7891000315507", 7, -1)]
    [InlineData("7891000315507", 7, Sgtin96.SerieMaxima + 1)]
    public void Create_validates_gtin_prefix_and_serial(string gtin, int tamanhoPrefixo, long serie)
    {
        Assert.Throws<DomainException>(() => Sgtin96.Create(gtin, tamanhoPrefixo, serie, FiltroEpc.ItemDeVenda));
    }

    [Theory]
    [InlineData(TipoEmbalagem.Unidade, FiltroEpc.ItemDeVenda)]
    [InlineData(TipoEmbalagem.Caixa, FiltroEpc.CaixaDeTransporte)]
    [InlineData(TipoEmbalagem.Palete, FiltroEpc.CargaUnitaria)]
    public void Filter_follows_the_package_type(TipoEmbalagem tipo, FiltroEpc filtro)
    {
        Assert.Equal(filtro, Sgtin96.FilterFor(tipo));
    }

    [Fact]
    public void Gtin14_equivalents_include_the_shorter_forms()
    {
        Assert.Equal(["07891000315507", "7891000315507"], Gtin.Equivalents("07891000315507"));
        Assert.Equal(["00000096385074", "0000096385074", "000096385074", "96385074"], Gtin.Equivalents("00000096385074"));
        Assert.Equal(["17891000315504"], Gtin.Equivalents("17891000315504"));
    }
}
