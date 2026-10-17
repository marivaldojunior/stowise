using Stowise.Application.Common;
using Stowise.Domain.Estoque;

namespace Stowise.Application.Estoque;

/// <summary>Consultas de estoque, só leitura: saldos (projeção), extrato e saldo numa data (livro-razão).</summary>
public interface IConsultaEstoqueService
{
    /// <summary>Saldos atuais, com o disponível já descontado das reservas. Ordenados por produto, validade e endereço.</summary>
    Task<PagedResult<SaldoItem>> ListSaldosAsync(SaldoFiltro filtro, CancellationToken cancellationToken = default);

    /// <summary>Total do produto em todos os endereços, com a divisão por lote.</summary>
    Task<Result<ResumoSaldoProduto>> GetResumoProdutoAsync(Guid produtoId, CancellationToken cancellationToken = default);

    /// <summary>
    /// Saldo numa data, calculado só pelo livro-razão (ADR-0001): o que chegou a cada endereço menos o que saiu,
    /// com <c>OcorridoEm</c> até a data. Não depende da tabela de saldos.
    /// </summary>
    Task<Result<PagedResult<SaldoNaData>>> GetSaldoNaDataAsync(SaldoNaDataFiltro filtro, CancellationToken cancellationToken = default);

    /// <summary>Movimentações do mais recente para o mais antigo. O filtro de endereço vale como origem ou destino.</summary>
    Task<Result<PagedResult<ExtratoItem>>> GetExtratoAsync(ExtratoFiltro filtro, CancellationToken cancellationToken = default);
}

/// <param name="IncluirZerados">Saldos zerados continuam na tabela; por padrão ficam fora da consulta.</param>
public sealed record SaldoFiltro(
    Guid? ProdutoId,
    Guid? EnderecoId,
    Guid? LoteId,
    Guid? ArmazemId,
    Guid? ZonaId,
    bool IncluirZerados,
    int? Pagina,
    int? TamanhoPagina);

public sealed record SaldoItem(
    Guid EnderecoId,
    string EnderecoCodigo,
    Guid ArmazemId,
    Guid ZonaId,
    Guid ProdutoId,
    string Sku,
    string Descricao,
    string UnidadeBase,
    Guid? LoteId,
    string? LoteNumero,
    DateOnly? Validade,
    decimal Quantidade,
    decimal QuantidadeReservada,
    decimal QuantidadeDisponivel);

public sealed record ResumoSaldoProduto(
    Guid ProdutoId,
    string Sku,
    string Descricao,
    string UnidadeBase,
    decimal Quantidade,
    decimal QuantidadeReservada,
    decimal QuantidadeDisponivel,
    int Enderecos,
    IReadOnlyList<ResumoSaldoLote> Lotes);

public sealed record ResumoSaldoLote(Guid? LoteId, string? Numero, DateOnly? Validade, decimal Quantidade, decimal QuantidadeReservada);

public sealed record SaldoNaDataFiltro(
    DateTimeOffset? Data,
    Guid? ProdutoId,
    Guid? EnderecoId,
    Guid? ArmazemId,
    int? Pagina,
    int? TamanhoPagina);

public sealed record SaldoNaData(
    Guid EnderecoId,
    string EnderecoCodigo,
    Guid ProdutoId,
    string Sku,
    Guid? LoteId,
    string? LoteNumero,
    decimal Quantidade);

public sealed record ExtratoFiltro(
    Guid? ProdutoId,
    Guid? EnderecoId,
    Guid? LoteId,
    TipoMovimentacao? Tipo,
    DateTimeOffset? De,
    DateTimeOffset? Ate,
    int? Pagina,
    int? TamanhoPagina);

public sealed record ExtratoItem(
    Guid Id,
    TipoMovimentacao Tipo,
    DateTimeOffset OcorridoEm,
    DateTimeOffset RecebidoEm,
    Guid ProdutoId,
    string Sku,
    string? LoteNumero,
    string? EnderecoOrigemCodigo,
    string? EnderecoDestinoCodigo,
    decimal Quantidade,
    string? DocumentoReferencia,
    string? Observacao,
    Guid UsuarioId);
