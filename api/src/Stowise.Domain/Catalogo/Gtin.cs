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
