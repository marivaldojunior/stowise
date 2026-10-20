namespace Stowise.Domain.Fornecedores;

/// <summary>
/// CNPJ numérico ou alfanumérico (Receita Federal, a partir de julho de 2026): 12 caracteres de 0-9 ou A-Z e 2 dígitos
/// verificadores em módulo 11. O valor de cada caractere é o código ASCII menos 48, o que mantém o cálculo dos CNPJs numéricos.
/// </summary>
public static class Cnpj
{
    public const int Length = 14;

    private static readonly int[] PesosPrimeiroDigito = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    private static readonly int[] PesosSegundoDigito = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    /// <summary>Tira pontos, barra, hífen e espaços e passa as letras para maiúsculas.</summary>
    public static string Normalize(string? value) =>
        new((value ?? string.Empty).Where(c => c is not ('.' or '/' or '-') && !char.IsWhiteSpace(c)).Select(char.ToUpperInvariant).ToArray());

    /// <summary>Confere um CNPJ já normalizado.</summary>
    public static bool IsValid(string? value)
    {
        if (value is null
            || value.Length != Length
            || !value[..12].All(c => char.IsAsciiDigit(c) || char.IsAsciiLetterUpper(c))
            || !value[12..].All(char.IsAsciiDigit)
            || value.All(c => c == value[0]))
        {
            return false;
        }

        var primeiro = CheckDigit(value.AsSpan(0, 12), PesosPrimeiroDigito);
        var segundo = CheckDigit(value.AsSpan(0, 13), PesosSegundoDigito);
        return value[12] - '0' == primeiro && value[13] - '0' == segundo;
    }

    /// <summary>Máscara de exibição, ex.: 12.ABC.345/01DE-35.</summary>
    public static string Format(string cnpj) =>
        cnpj.Length == Length ? $"{cnpj[..2]}.{cnpj[2..5]}.{cnpj[5..8]}/{cnpj[8..12]}-{cnpj[12..]}" : cnpj;

    private static int CheckDigit(ReadOnlySpan<char> caracteres, int[] pesos)
    {
        var soma = 0;
        for (var i = 0; i < caracteres.Length; i++)
        {
            soma += (caracteres[i] - '0') * pesos[i];
        }

        var resto = soma % 11;
        return resto < 2 ? 0 : 11 - resto;
    }
}
