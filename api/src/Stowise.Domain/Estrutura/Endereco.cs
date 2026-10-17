using System.Globalization;
using Stowise.Domain.Common;

namespace Stowise.Domain.Estrutura;

/// <summary>Posição física de armazenagem, identificada por rua, módulo, nível e posição (ex.: A-03-02-1).</summary>
public sealed class Endereco : Entity
{
    public const int CodigoMaxLength = 20;
    public const int RuaMaxLength = 3;
    public const int MotivoBloqueioMaxLength = 250;

    private Endereco()
    {
    }

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

    public static Endereco Create(
        Guid zonaId,
        string rua,
        int modulo,
        int nivel,
        int posicao,
        decimal capacidadePesoKg,
        decimal alturaCm,
        decimal larguraCm,
        decimal profundidadeCm,
        decimal distanciaExpedicao)
    {
        if (zonaId == Guid.Empty)
        {
            throw new DomainException("A zona do endereço é obrigatória.");
        }

        var ruaNormalizada = Guard.Required(rua, "Rua", RuaMaxLength).ToUpperInvariant();
        if (!ruaNormalizada.All(char.IsAsciiLetterUpper))
        {
            throw new DomainException("Rua deve conter apenas letras (ex.: A, B, AA).");
        }

        var endereco = new Endereco
        {
            ZonaId = zonaId,
            Rua = ruaNormalizada,
            Modulo = Guard.InRange(modulo, 1, 99, "Módulo"),
            Nivel = Guard.InRange(nivel, 1, 99, "Nível"),
            Posicao = Guard.InRange(posicao, 1, 9, "Posição"),
            CapacidadePesoKg = Guard.Positive(capacidadePesoKg, "Capacidade de peso"),
            AlturaCm = Guard.Positive(alturaCm, "Altura"),
            LarguraCm = Guard.Positive(larguraCm, "Largura"),
            ProfundidadeCm = Guard.Positive(profundidadeCm, "Profundidade"),
            DistanciaExpedicao = Guard.NotNegative(distanciaExpedicao, "Distância até a expedição"),
            Status = StatusEndereco.Livre,
        };
        endereco.Codigo = FormatCodigo(endereco.Rua, endereco.Modulo, endereco.Nivel, endereco.Posicao);
        return endereco;
    }

    public static string FormatCodigo(string rua, int modulo, int nivel, int posicao) =>
        string.Create(CultureInfo.InvariantCulture, $"{rua}-{modulo:00}-{nivel:00}-{posicao}");
}
