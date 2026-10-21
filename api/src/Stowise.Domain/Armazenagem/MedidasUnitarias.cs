using Stowise.Domain.Catalogo;

namespace Stowise.Domain.Armazenagem;

/// <summary>
/// Peso e volume de uma unidade base, vindos da maior embalagem que tem o dado (ex.: a caixa de 12 com 6 kg dá 0,5 kg
/// por unidade). A maior embalagem é a mais próxima do que vai para a estante. Nulos quando nenhuma embalagem tem o dado.
/// </summary>
public sealed record MedidasUnitarias(decimal? PesoKg, decimal? VolumeCm3)
{
    public static MedidasUnitarias From(IEnumerable<ProdutoEmbalagem> embalagens)
    {
        ArgumentNullException.ThrowIfNull(embalagens);
        var porFator = embalagens.OrderByDescending(e => e.FatorConversao).ToList();
        var comPeso = porFator.FirstOrDefault(e => e.PesoKg is not null);
        var comMedidas = porFator.FirstOrDefault(e => e.AlturaCm is not null && e.LarguraCm is not null && e.ComprimentoCm is not null);
        return new MedidasUnitarias(
            comPeso?.PesoKg / comPeso?.FatorConversao,
            comMedidas is null ? null : comMedidas.AlturaCm * comMedidas.LarguraCm * comMedidas.ComprimentoCm / comMedidas.FatorConversao);
    }

    public decimal? PesoDe(decimal quantidade) => PesoKg * quantidade;

    public decimal? VolumeDe(decimal quantidade) => VolumeCm3 * quantidade;
}
