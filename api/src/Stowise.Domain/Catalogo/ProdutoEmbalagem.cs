using Stowise.Domain.Common;

namespace Stowise.Domain.Catalogo;

/// <summary>Medidas e peso de uma embalagem. Valores nulos ficam para completar depois (ex.: produto vindo de NF-e).</summary>
public sealed record DadosEmbalagem(
    string? Gtin,
    decimal? PesoKg,
    decimal? AlturaCm,
    decimal? LarguraCm,
    decimal? ComprimentoCm);

/// <summary>
/// Forma física do produto (unidade, caixa, palete). Peso, medidas e GTIN ficam aqui, e não no produto:
/// uma caixa e um palete do mesmo SKU ocupam espaços diferentes.
/// </summary>
public sealed class ProdutoEmbalagem : Entity
{
    private ProdutoEmbalagem()
    {
    }

    internal ProdutoEmbalagem(Guid produtoId, TipoEmbalagem tipo, decimal fatorConversao, bool unidadeBase, DadosEmbalagem dados)
    {
        ProdutoId = produtoId;
        Tipo = tipo;
        FatorConversao = fatorConversao;
        UnidadeBase = unidadeBase;
        Apply(dados);
    }

    public Guid ProdutoId { get; private set; }

    public TipoEmbalagem Tipo { get; private set; }

    /// <summary>Quantas unidades base cabem nesta embalagem (ex.: caixa com 12 → 12).</summary>
    public decimal FatorConversao { get; private set; }

    public bool UnidadeBase { get; private set; }

    public string? Gtin { get; private set; }

    public decimal? PesoKg { get; private set; }

    public decimal? AlturaCm { get; private set; }

    public decimal? LarguraCm { get; private set; }

    public decimal? ComprimentoCm { get; private set; }

    public bool TemMedidasCompletas => PesoKg is not null && AlturaCm is not null && LarguraCm is not null && ComprimentoCm is not null;

    internal void Apply(DadosEmbalagem dados)
    {
        var gtin = string.IsNullOrWhiteSpace(dados.Gtin) ? null : dados.Gtin.Trim();
        if (gtin is not null && !Catalogo.Gtin.IsValid(gtin))
        {
            throw new DomainException($"GTIN inválido: {gtin}. Use 8, 12, 13 ou 14 dígitos com dígito verificador correto.");
        }

        Gtin = gtin;
        PesoKg = Guard.PositiveOrNull(dados.PesoKg, "Peso");
        AlturaCm = Guard.PositiveOrNull(dados.AlturaCm, "Altura");
        LarguraCm = Guard.PositiveOrNull(dados.LarguraCm, "Largura");
        ComprimentoCm = Guard.PositiveOrNull(dados.ComprimentoCm, "Comprimento");
    }
}
