using System.Diagnostics.CodeAnalysis;

namespace Stowise.Domain.NotasFiscais;

/// <summary>
/// Chave de acesso da NF-e (44 caracteres): UF (2), ano e mês (4), CNPJ ou CPF do emitente (14, numérico ou alfanumérico),
/// modelo (2), série (3), número (9), tipo de emissão (1), código numérico (8) e dígito verificador (1).
/// O dígito é módulo 11 com pesos 2 a 9 da direita para a esquerda; o valor de cada caractere é o código ASCII menos 48,
/// como no CNPJ alfanumérico.
/// </summary>
public sealed record ChaveAcesso
{
    public const int Length = 44;

    private ChaveAcesso(string valor) => Valor = valor;

    public string Valor { get; }

    /// <summary>Código IBGE da UF do emitente.</summary>
    public string Uf => Valor[..2];

    /// <summary>Ano e mês da emissão (AAMM).</summary>
    public string AnoMes => Valor[2..6];

    /// <summary>CNPJ do emitente, ou o CPF com três zeros à esquerda (produtor rural).</summary>
    public string DocumentoEmitente => Valor[6..20];

    public string Modelo => Valor[20..22];

    public int Serie => int.Parse(Valor[22..25], System.Globalization.CultureInfo.InvariantCulture);

    public long Numero => long.Parse(Valor[25..34], System.Globalization.CultureInfo.InvariantCulture);

    public static bool TryParse(string? valor, [NotNullWhen(true)] out ChaveAcesso? chave)
    {
        chave = null;
        var texto = valor?.Trim().ToUpperInvariant();
        if (texto is null
            || texto.Length != Length
            || !texto[..6].All(char.IsAsciiDigit)
            || !texto[6..20].All(c => char.IsAsciiDigit(c) || char.IsAsciiLetterUpper(c))
            || !texto[20..].All(char.IsAsciiDigit)
            || texto[^1] - '0' != CheckDigit(texto.AsSpan(0, Length - 1)))
        {
            return false;
        }

        chave = new ChaveAcesso(texto);
        return true;
    }

    public static int CheckDigit(ReadOnlySpan<char> semDigito)
    {
        var soma = 0;
        var peso = 2;
        for (var i = semDigito.Length - 1; i >= 0; i--)
        {
            soma += (semDigito[i] - '0') * peso;
            peso = peso == 9 ? 2 : peso + 1;
        }

        var resto = soma % 11;
        return resto < 2 ? 0 : 11 - resto;
    }

    public override string ToString() => Valor;
}
