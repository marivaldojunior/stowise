using System.Globalization;
using Stowise.Domain.Common;

namespace Stowise.Domain.Estrutura;

/// <summary>Capacidade, medidas internas e distância até a expedição de um endereço.</summary>
/// <param name="DistanciaExpedicao">Em metros. Alimenta a regra de curva ABC.</param>
public sealed record DimensoesEndereco(
    decimal CapacidadePesoKg,
    decimal AlturaCm,
    decimal LarguraCm,
    decimal ProfundidadeCm,
    decimal DistanciaExpedicao);

/// <summary>
/// Posição física de armazenagem, identificada por rua, módulo, nível e posição (ex.: A-03-02-1).
/// O código é único no armazém e não muda: para mudar as coordenadas, exclua e crie outro endereço.
/// </summary>
public sealed class Endereco : Entity
{
    public const int CodigoMaxLength = 20;
    public const int RuaMaxLength = 3;
    public const int ModuloMax = 99;
    public const int NivelMax = 99;
    public const int PosicaoMax = 9;
    public const int MotivoBloqueioMaxLength = 250;

    private Endereco()
    {
    }

    public Guid ArmazemId { get; private set; }

    public Guid ZonaId { get; private set; }

    public string Codigo { get; private set; } = null!;

    public string Rua { get; private set; } = null!;

    public int Modulo { get; private set; }

    public int Nivel { get; private set; }

    public int Posicao { get; private set; }

    public decimal CapacidadePesoKg { get; private set; }

    public decimal AlturaCm { get; private set; }

    public decimal LarguraCm { get; private set; }

    public decimal ProfundidadeCm { get; private set; }

    /// <summary>Distância até a expedição, em metros. Alimenta a regra de curva ABC.</summary>
    public decimal DistanciaExpedicao { get; private set; }

    public StatusEndereco Status { get; private set; }

    public string? MotivoBloqueio { get; private set; }

    public static Endereco Create(Zona zona, string rua, int modulo, int nivel, int posicao, DimensoesEndereco dimensoes)
    {
        ArgumentNullException.ThrowIfNull(zona);

        var ruaNormalizada = Guard.Required(rua, "Rua", RuaMaxLength).ToUpperInvariant();
        if (!IsValidRua(ruaNormalizada))
        {
            throw new DomainException("Rua deve conter apenas letras (ex.: A, B, AA).");
        }

        var endereco = new Endereco
        {
            ArmazemId = zona.ArmazemId,
            ZonaId = zona.Id,
            Rua = ruaNormalizada,
            Modulo = Guard.InRange(modulo, 1, ModuloMax, "Módulo"),
            Nivel = Guard.InRange(nivel, 1, NivelMax, "Nível"),
            Posicao = Guard.InRange(posicao, 1, PosicaoMax, "Posição"),
            Status = StatusEndereco.Livre,
        };
        endereco.UpdateDimensoes(dimensoes);
        endereco.Codigo = FormatCodigo(endereco.Rua, endereco.Modulo, endereco.Nivel, endereco.Posicao);
        return endereco;
    }

    public void UpdateDimensoes(DimensoesEndereco dimensoes)
    {
        ArgumentNullException.ThrowIfNull(dimensoes);

        CapacidadePesoKg = Guard.Positive(dimensoes.CapacidadePesoKg, "Capacidade de peso");
        AlturaCm = Guard.Positive(dimensoes.AlturaCm, "Altura");
        LarguraCm = Guard.Positive(dimensoes.LarguraCm, "Largura");
        ProfundidadeCm = Guard.Positive(dimensoes.ProfundidadeCm, "Profundidade");
        DistanciaExpedicao = Guard.NotNegative(dimensoes.DistanciaExpedicao, "Distância até a expedição");
    }

    /// <summary>De 1 a 3 letras (A, B, AA...).</summary>
    public static bool IsValidRua(string? rua)
    {
        var trimmed = rua?.Trim();
        return !string.IsNullOrEmpty(trimmed) && trimmed.Length <= RuaMaxLength && trimmed.All(char.IsAsciiLetter);
    }

    public static string FormatCodigo(string rua, int modulo, int nivel, int posicao) =>
        string.Create(CultureInfo.InvariantCulture, $"{rua}-{modulo:00}-{nivel:00}-{posicao}");
}
