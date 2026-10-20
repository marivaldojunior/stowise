using Stowise.Application.Common;
using Stowise.Domain.Catalogo;

namespace Stowise.Application.Rfid;

/// <summary>Etiquetas RFID em SGTIN-96 (ADR-0010): o RFID conta unidades da embalagem do GTIN, sem rastrear cada unidade.</summary>
public interface IRfidService
{
    /// <summary>Resolve um lote de EPCs lidos em produtos, embalagens e quantidades. EPCs repetidos contam uma vez.</summary>
    Task<Result<LeiturasRfidResolvidas>> ResolveAsync(ResolverLeiturasRfid comando, CancellationToken cancellationToken = default);

    /// <summary>Gera EPCs para gravar nas etiquetas de uma embalagem com GTIN, com séries únicas.</summary>
    Task<Result<EtiquetasRfidGeradas>> GenerateAsync(GerarEtiquetasRfid comando, CancellationToken cancellationToken = default);
}

/// <summary>Limites dos lotes de RFID.</summary>
public static class LimitesRfid
{
    public const int LeiturasPorLote = 1000;

    public const int EtiquetasPorPedido = 500;
}

/// <param name="Epcs">EPCs em hexadecimal, como o leitor entrega.</param>
public sealed record ResolverLeiturasRfid(IReadOnlyList<string>? Epcs);

/// <param name="Leituras">Uma por EPC distinto, na ordem de chegada.</param>
/// <param name="Produtos">Total por embalagem reconhecida.</param>
/// <param name="NaoReconhecidas">EPCs que não são SGTIN-96 ou cujo GTIN não está no catálogo.</param>
public sealed record LeiturasRfidResolvidas(IReadOnlyList<LeituraRfid> Leituras, IReadOnlyList<ContagemRfid> Produtos, int NaoReconhecidas);

/// <param name="Gtin">GTIN-14 do EPC; nulo quando o EPC não é SGTIN-96.</param>
/// <param name="Serie">Série do EPC; nula quando o EPC não é SGTIN-96.</param>
/// <param name="EmbalagemId">Embalagem do catálogo com esse GTIN; nula quando não existe.</param>
public sealed record LeituraRfid(string Epc, string? Gtin, long? Serie, Guid? ProdutoId, Guid? EmbalagemId);

/// <param name="Etiquetas">EPCs distintos lidos desta embalagem.</param>
/// <param name="QuantidadeBase">Etiquetas × fator de conversão da embalagem, na unidade base.</param>
public sealed record ContagemRfid(
    Guid ProdutoId,
    string Sku,
    string Descricao,
    string UnidadeBase,
    Guid EmbalagemId,
    TipoEmbalagem Tipo,
    decimal FatorConversao,
    int Etiquetas,
    decimal QuantidadeBase);

/// <param name="TamanhoPrefixoEmpresa">Dígitos do prefixo da empresa GS1 do GTIN (6 a 12). Vazio: vale a configuração.</param>
public sealed record GerarEtiquetasRfid(Guid? EmbalagemId, int? Quantidade, int? TamanhoPrefixoEmpresa);

public sealed record EtiquetasRfidGeradas(Guid ProdutoId, Guid EmbalagemId, string Gtin, IReadOnlyList<EtiquetaRfid> Etiquetas);

/// <param name="Epc">EPC em hexadecimal (24 caracteres), para gravar no banco EPC da etiqueta.</param>
/// <param name="EpcUri">URI de identidade pura, para mostrar e conferir.</param>
public sealed record EtiquetaRfid(string Epc, string EpcUri, long Serie);
