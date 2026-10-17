namespace Stowise.Domain.Catalogo;

/// <summary>NCM (8 dígitos) e CEST (7 dígitos). Pontos e espaços são removidos na normalização.</summary>
public static class CodigosFiscais
{
    public const int NcmLength = 8;
    public const int CestLength = 7;

    public static string? NormalizeNcm(string? value) => Normalize(value);

    public static string? NormalizeCest(string? value) => Normalize(value);

    public static bool IsValidNcm(string? normalized) => IsDigits(normalized, NcmLength);

    public static bool IsValidCest(string? normalized) => IsDigits(normalized, CestLength);

    private static string? Normalize(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        return string.Concat(value.Where(c => c is not ('.' or ' ' or '-')));
    }

    private static bool IsDigits(string? value, int length) =>
        value is not null && value.Length == length && value.All(char.IsAsciiDigit);
}
