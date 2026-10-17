using Stowise.Application.Common;
using Stowise.Domain.Estoque;

namespace Stowise.Application.Estoque;

/// <summary>
/// Único caminho para mudar o estoque (ADR-0001): cada operação grava uma Movimentacao e atualiza o Saldo
/// e a ocupação do endereço na mesma transação. Com <c>IdempotencyKey</c>, reenviar a mesma operação
/// devolve a original; conflitos de concorrência são repetidos com dados frescos (ADR-0006).
/// </summary>
public interface IMovimentacaoService
{
    Task<Result<MovimentacaoRegistrada>> RegistrarEntradaAsync(RegistrarEntrada comando, Guid usuarioId, CancellationToken cancellationToken = default);

    Task<Result<MovimentacaoRegistrada>> RegistrarSaidaAsync(RegistrarSaida comando, Guid usuarioId, CancellationToken cancellationToken = default);

    Task<Result<MovimentacaoRegistrada>> RegistrarAjusteAsync(RegistrarAjuste comando, Guid usuarioId, CancellationToken cancellationToken = default);

    Task<Result<MovimentacaoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);
}

/// <param name="Repetida">A chave de idempotência já tinha sido usada para esta operação: nada foi gravado de novo.</param>
public sealed record MovimentacaoRegistrada(MovimentacaoDetalhe Movimentacao, bool Repetida);

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
    DateTimeOffset? OcorridoEm,
    Guid? IdempotencyKey = null);

/// <param name="Lote">Número do lote, obrigatório para produtos que controlam lote.</param>
public sealed record RegistrarSaida(
    Guid? ProdutoId,
    Guid? EmbalagemId,
    Guid? EnderecoId,
    decimal? Quantidade,
    string? Lote,
    string? DocumentoReferencia,
    Guid? DispositivoId,
    DateTimeOffset? OcorridoEm,
    Guid? IdempotencyKey = null);

/// <param name="Quantidade">Na unidade base: positiva aumenta o saldo, negativa diminui.</param>
public sealed record RegistrarAjuste(
    Guid? ProdutoId,
    Guid? EnderecoId,
    decimal? Quantidade,
    string? Lote,
    string? Motivo,
    DateTimeOffset? OcorridoEm,
    Guid? IdempotencyKey = null);

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
    DateTimeOffset RecebidoEm,
    Guid? IdempotencyKey);
