using System.Globalization;
using System.Numerics;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;

namespace Stowise.Domain.Rfid;

/// <summary>
/// EPC SGTIN-96 (GS1 EPC Tag Data Standard): GTIN-14 de uma embalagem + número de série, em 96 bits.
/// Layout: cabeçalho 0x30 (8 bits), filtro (3), partição (3), prefixo da empresa + referência do item (44) e série (38).
/// </summary>
public sealed record Sgtin96
{
    public const byte Cabecalho = 0x30;

    /// <summary>Maior série que cabe em 38 bits.</summary>
    public const long SerieMaxima = (1L << 38) - 1;

    /// <summary>Tamanho do EPC em hexadecimal (96 bits).</summary>
    public const int TamanhoHex = 24;

    // Partição → (bits do prefixo, dígitos do prefixo, bits da referência). Prefixo + referência sempre somam 44 bits.
    private static readonly (int BitsPrefixo, int DigitosPrefixo, int BitsReferencia)[] Particoes =
    [
        (40, 12, 4),
        (37, 11, 7),
        (34, 10, 10),
        (30, 9, 14),
        (27, 8, 17),
        (24, 7, 20),
        (20, 6, 24),
    ];

    private Sgtin96(FiltroEpc filtro, string prefixoEmpresa, string referenciaItem, long serie)
    {
        Filtro = filtro;
        PrefixoEmpresa = prefixoEmpresa;
        ReferenciaItem = referenciaItem;
        Serie = serie;
    }

    public FiltroEpc Filtro { get; }

    /// <summary>Prefixo da empresa GS1 (6 a 12 dígitos).</summary>
    public string PrefixoEmpresa { get; }

    /// <summary>Dígito indicador seguido da referência do item (13 dígitos menos o prefixo).</summary>
    public string ReferenciaItem { get; }

    public long Serie { get; }

    /// <summary>GTIN-14 com o dígito verificador.</summary>
    public string Gtin14
    {
        get
        {
            var semDigito = ReferenciaItem[..1] + PrefixoEmpresa + ReferenciaItem[1..];
            return semDigito + Gtin.CheckDigit(semDigito).ToString(CultureInfo.InvariantCulture);
        }
    }

    /// <summary>URI de identidade pura, ex.: <c>urn:epc:id:sgtin:0614141.812345.6789</c>.</summary>
    public string Uri => $"urn:epc:id:sgtin:{PrefixoEmpresa}.{ReferenciaItem}.{Serie.ToString(CultureInfo.InvariantCulture)}";

    /// <summary>EPC em hexadecimal maiúsculo (24 caracteres), como é gravado na etiqueta.</summary>
    public string Hex
    {
        get
        {
            var particao = Array.FindIndex(Particoes, p => p.DigitosPrefixo == PrefixoEmpresa.Length);
            var (bitsPrefixo, _, bitsReferencia) = Particoes[particao];

            var valor = new BigInteger(Cabecalho);
            valor = (valor << 3) | (int)Filtro;
            valor = (valor << 3) | particao;
            valor = (valor << bitsPrefixo) | BigInteger.Parse(PrefixoEmpresa, CultureInfo.InvariantCulture);
            valor = (valor << bitsReferencia) | BigInteger.Parse(ReferenciaItem, CultureInfo.InvariantCulture);
            valor = (valor << 38) | Serie;

            return valor.ToString("X", CultureInfo.InvariantCulture).PadLeft(TamanhoHex, '0')[^TamanhoHex..];
        }
    }

    /// <summary>Monta o EPC de uma embalagem. O tamanho do prefixo da empresa não está no GTIN: quem codifica informa.</summary>
    public static Sgtin96 Create(string gtin, int tamanhoPrefixoEmpresa, long serie, FiltroEpc filtro)
    {
        if (!Gtin.IsValid(gtin))
        {
            throw new DomainException($"O GTIN {gtin} não é válido.");
        }

        if (tamanhoPrefixoEmpresa is < 6 or > 12)
        {
            throw new DomainException("O prefixo da empresa GS1 tem de 6 a 12 dígitos.");
        }

        if (serie is < 0 or > SerieMaxima)
        {
            throw new DomainException($"A série do SGTIN-96 vai de 0 a {SerieMaxima}.");
        }

        if (!Enum.IsDefined(filtro))
        {
            throw new DomainException("O filtro do EPC vai de 0 a 7.");
        }

        var gtin14 = Gtin.ToGtin14(gtin);
        var prefixo = gtin14.Substring(1, tamanhoPrefixoEmpresa);
        var referencia = gtin14[..1] + gtin14[(1 + tamanhoPrefixoEmpresa)..13];
        return new Sgtin96(filtro, prefixo, referencia, serie);
    }

    /// <summary>Lê um EPC em hexadecimal. Devolve falso para outro tipo de EPC ou valor fora do padrão.</summary>
    public static bool TryParseHex(string? hex, out Sgtin96? epc)
    {
        epc = null;
        var valorHex = hex?.Trim();
        if (valorHex is null || valorHex.Length != TamanhoHex || !valorHex.All(char.IsAsciiHexDigit))
        {
            return false;
        }

        // O "0" à esquerda impede que o BigInteger leia o primeiro bit como sinal.
        var valor = BigInteger.Parse("0" + valorHex, NumberStyles.AllowHexSpecifier, CultureInfo.InvariantCulture);
        if ((int)(valor >> 88) != Cabecalho)
        {
            return false;
        }

        var filtro = (FiltroEpc)(int)((valor >> 85) & 0b111);
        var particao = (int)((valor >> 82) & 0b111);
        if (particao >= Particoes.Length)
        {
            return false;
        }

        var (bitsPrefixo, digitosPrefixo, bitsReferencia) = Particoes[particao];
        var digitosReferencia = 13 - digitosPrefixo;
        var prefixo = (valor >> (38 + bitsReferencia)) & ((BigInteger.One << bitsPrefixo) - 1);
        var referencia = (valor >> 38) & ((BigInteger.One << bitsReferencia) - 1);
        var serie = (long)(valor & SerieMaxima);

        if (prefixo >= BigInteger.Pow(10, digitosPrefixo) || referencia >= BigInteger.Pow(10, digitosReferencia))
        {
            return false;
        }

        epc = new Sgtin96(
            filtro,
            prefixo.ToString(CultureInfo.InvariantCulture).PadLeft(digitosPrefixo, '0'),
            referencia.ToString(CultureInfo.InvariantCulture).PadLeft(digitosReferencia, '0'),
            serie);
        return true;
    }

    /// <summary>Filtro que o padrão recomenda para cada embalagem.</summary>
    public static FiltroEpc FilterFor(TipoEmbalagem tipo) => tipo switch
    {
        TipoEmbalagem.Caixa => FiltroEpc.CaixaDeTransporte,
        TipoEmbalagem.Palete => FiltroEpc.CargaUnitaria,
        _ => FiltroEpc.ItemDeVenda,
    };
}

/// <summary>Filtro do EPC (3 bits): deixa o leitor ignorar etiquetas de outro nível de embalagem.</summary>
public enum FiltroEpc
{
    Outros = 0,
    ItemDeVenda = 1,
    CaixaDeTransporte = 2,
    Reservado3 = 3,
    AgrupamentoInterno = 4,
    Reservado5 = 5,
    CargaUnitaria = 6,
    UnidadeDentroDoItem = 7,
}
