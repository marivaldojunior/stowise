namespace Stowise.Domain.Common;

internal static class Guard
{
    public static string Required(string? value, string campo, int maxLength)
    {
        var trimmed = value?.Trim();
        if (string.IsNullOrEmpty(trimmed))
        {
            throw new DomainException($"{campo} é obrigatório.");
        }

        if (trimmed.Length > maxLength)
        {
            throw new DomainException($"{campo} deve ter no máximo {maxLength} caracteres.");
        }

        return trimmed;
    }

    public static int InRange(int value, int min, int max, string campo)
    {
        if (value < min || value > max)
        {
            throw new DomainException($"{campo} deve estar entre {min} e {max}.");
        }

        return value;
    }

    public static decimal Positive(decimal value, string campo)
    {
        if (value <= 0)
        {
            throw new DomainException($"{campo} deve ser maior que zero.");
        }

        return value;
    }

    public static decimal NotNegative(decimal value, string campo)
    {
        if (value < 0)
        {
            throw new DomainException($"{campo} não pode ser negativo.");
        }

        return value;
    }
}
