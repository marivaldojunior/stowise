using Stowise.Application.Common;
using Stowise.Domain.Estoque;

namespace Stowise.Application.Estoque;

/// <summary>
/// Único caminho para mudar o estoque (ADR-0001): cada operação grava uma Movimentacao e atualiza o Saldo
/// e a ocupação do endereço na mesma transação.
/// </summary>
public interface IMovimentacaoService
{
    Task<Result<MovimentacaoDetalhe>> RegistrarEntradaAsync(RegistrarEntrada comando, Guid usuarioId, CancellationToken cancellationToken = default);

    Task<Result<MovimentacaoDetalhe>> RegistrarSaidaAsync(RegistrarSaida comando, Guid usuarioId, CancellationToken cancellationToken = default);

    Task<Result<MovimentacaoDetalhe>> RegistrarAjusteAsync(RegistrarAjuste comando, Guid usuarioId, CancellationToken cancellationToken = default);

    Task<Result<MovimentacaoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);
}

/// <summary>Lote informado na entrada. Se o número já existe para o produto, o lote existente é usado.</summary>
public sealed record LoteInformado(string? Numero, DateOnly? Fabricacao, DateOnly? Validade);

/// <param name="EmbalagemId">Embalagem lida; a quantidade é convertida para a unidade base pelo fator. Sem ela, a quantidade já está na unidade base.</param>
/// <param name="OcorridoEm">Hora do aparelho. Sem ela, vale a hora do servidor.</param>
public sealed record RegistrarEntrada(
    Guid? ProdutoId,
    Guid? EmbalagemId,
    Guid? EnderecoId,
    decimal? Quantidade,
    LoteInformado? Lote,
    string? DocumentoReferencia,
    Guid? DispositivoId,
    DateTimeOffset? OcorridoEm);

/// <param name="Lote">Número do lote, obrigatório para produtos que controlam lote.</param>
public sealed record RegistrarSaida(
    Guid? ProdutoId,
    Guid? EmbalagemId,
    Guid? EnderecoId,
    decimal? Quantidade,
    string? Lote,
    string? DocumentoReferencia,
    Guid? DispositivoId,
    DateTimeOffset? OcorridoEm);

/// <param name="Quantidade">Na unidade base: positiva aumenta o saldo, negativa diminui.</param>
public sealed record RegistrarAjuste(
    Guid? ProdutoId,
    Guid? EnderecoId,
    decimal? Quantidade,
    string? Lote,
    string? Motivo,
    DateTimeOffset? OcorridoEm);

public sealed record MovimentacaoDetalhe(
    Guid Id,
    TipoMovimentacao Tipo,
    Guid ProdutoId,
    Guid? LoteId,
    string? LoteNumero,
    Guid? EnderecoOrigemId,
    Guid? EnderecoDestinoId,
    decimal Quantidade,
    string? DocumentoReferencia,
    string? Observacao,
    Guid UsuarioId,
    Guid? DispositivoId,
    DateTimeOffset OcorridoEm,
    DateTimeOffset RecebidoEm);
