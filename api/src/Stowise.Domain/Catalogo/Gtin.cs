namespace Stowise.Domain.Catalogo;

/// <summary>Código de barras GS1 (GTIN-8, 12, 13 ou 14) com dígito verificador módulo 10.</summary>
public static class Gtin
{
    private static readonly int[] ValidLengths = [8, 12, 13, 14];

    public static bool IsValid(string? value)
    {
        if (value is null || !ValidLengths.Contains(value.Length) || !value.All(char.IsAsciiDigit))
        {
            return false;
        }

        return value[^1] - '0' == CheckDigit(value.AsSpan(0, value.Length - 1));
    }

    /// <summary>GTIN-14 com zeros à esquerda (ex.: o GTIN-13 7891000315507 vira 07891000315507).</summary>
    public static string ToGtin14(string gtin) => gtin.PadLeft(14, '0');

    /// <summary>
    /// Formas do mesmo GTIN-14 que podem estar gravadas no cadastro: o próprio GTIN-14 e, se ele começa com zeros,
    /// o GTIN-13, o GTIN-12 e o GTIN-8.
    /// </summary>
    public static IReadOnlyList<string> Equivalents(string gtin14)
    {
        var formas = new List<string> { gtin14 };
        foreach (var tamanho in new[] { 13, 12, 8 })
        {
            if (gtin14[..(14 - tamanho)].All(c => c == '0'))
            {
                formas.Add(gtin14[(14 - tamanho)..]);
            }
        }

        return formas;
    }

    /// <summary>Dígito verificador GS1: pesos 3 e 1 alternados, da direita para a esquerda.</summary>
    public static int CheckDigit(ReadOnlySpan<char> withoutCheckDigit)
    {
        var sum = 0;
        for (var i = 0; i < withoutCheckDigit.Length; i++)
        {
            var digit = withoutCheckDigit[withoutCheckDigit.Length - 1 - i] - '0';
            sum += digit * (i % 2 == 0 ? 3 : 1);
        }

        return (10 - (sum % 10)) % 10;
    }
}
