using Stowise.Application.Common;
using Stowise.Domain.Recebimentos;

namespace Stowise.Application.Recebimentos;

/// <summary>
/// Recebimentos criados pela efetivação da NF-e e a conferência física (SPEC, 2.3). A conferência não mexe no saldo:
/// a entrada no estoque acontece na armazenagem, pelo serviço de movimentação.
/// </summary>
public interface IRecebimentoService
{
    Task<PagedResult<RecebimentoResumo>> ListAsync(RecebimentoFiltro filtro, CancellationToken cancellationToken = default);

    Task<Result<RecebimentoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>A mercadoria chegou: começa a contagem. Exige a versão lida.</summary>
    Task<Result<RecebimentoDetalhe>> StartConferenciaAsync(Guid id, AlterarRecebimento comando, CancellationToken cancellationToken = default);

    /// <summary>Registra ou corrige a contagem de um item. Dois itens podem ser contados ao mesmo tempo.</summary>
    Task<Result<RecebimentoDetalhe>> ConferirItemAsync(
        Guid id,
        Guid itemId,
        ConferirItemRecebimento comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default);

    /// <summary>Fecha a conferência quando todos os itens foram contados. Exige a versão lida.</summary>
    Task<Result<RecebimentoDetalhe>> FinishConferenciaAsync(Guid id, AlterarRecebimento comando, Guid usuarioId, CancellationToken cancellationToken = default);
}

/// <param name="Busca">Parte da chave de acesso, o número da nota ou parte da razão social do fornecedor.</param>
public sealed record RecebimentoFiltro(StatusRecebimento? Status, string? Busca, int? Pagina, int? TamanhoPagina);

public sealed record RecebimentoResumo(
    Guid Id,
    int Numero,
    int Serie,
    string ChaveAcesso,
    Guid FornecedorId,
    string Fornecedor,
    DateTimeOffset DataEmissao,
    StatusRecebimento Status,
    int Itens,
    int ItensConferidos,
    bool TemDivergencia,
    DateTimeOffset CriadoEm);

public sealed record RecebimentoDetalhe(
    Guid Id,
    int Numero,
    int Serie,
    string ChaveAcesso,
    Guid FornecedorId,
    string Fornecedor,
    DateTimeOffset DataEmissao,
    StatusRecebimento Status,
    DateTimeOffset? DataChegada,
    Guid? ConferidoPor,
    DateTimeOffset? ConferidoEm,
    bool TemDivergencia,
    uint Versao,
    IReadOnlyList<RecebimentoItemDetalhe> Itens);

/// <param name="Quantidade">Esperada pela nota, na unidade base.</param>
/// <param name="QuantidadeConferida">Contada, na unidade base; nula até a contagem.</param>
public sealed record RecebimentoItemDetalhe(
    Guid Id,
    int NumeroItem,
    Guid ProdutoId,
    string Sku,
    string Descricao,
    string UnidadeBase,
    bool ControlaLote,
    bool ControlaValidade,
    Guid EmbalagemId,
    string CodigoFornecedor,
    string DescricaoNota,
    string UnidadeNota,
    decimal QuantidadeNota,
    decimal FatorConversao,
    decimal Quantidade,
    IReadOnlyList<LoteRecebido> Lotes,
    decimal? QuantidadeConferida,
    IReadOnlyList<LoteRecebido> LotesConferidos,
    bool Divergente,
    Guid? ConferidoPor,
    DateTimeOffset? ConferidoEm);

/// <param name="Versao">Versão lida do recebimento.</param>
public sealed record AlterarRecebimento(uint? Versao);

/// <param name="Quantidade">Contada na unidade da nota (ex.: 10 CX).</param>
/// <param name="Lotes">Lotes contados, também na unidade da nota; a soma deve ser a quantidade.</param>
public sealed record ConferirItemRecebimento(decimal? Quantidade, IReadOnlyList<LoteConferido>? Lotes);
