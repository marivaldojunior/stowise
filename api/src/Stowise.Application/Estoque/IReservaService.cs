using Stowise.Application.Common;
using Stowise.Domain.Estoque;

namespace Stowise.Application.Estoque;

/// <summary>
/// Reservas comprometem parte de um saldo sem movimentar estoque. A baixa acontece pela saída que consome
/// a reserva (<see cref="IMovimentacaoService.ConsumirReservaAsync"/>).
/// </summary>
public interface IReservaService
{
    Task<Result<ReservaDetalhe>> CreateAsync(CriarReserva comando, Guid usuarioId, CancellationToken cancellationToken = default);

    /// <summary>Cancela uma reserva ativa e devolve a quantidade ao disponível.</summary>
    Task<Result<ReservaDetalhe>> CancelAsync(Guid id, Guid usuarioId, CancellationToken cancellationToken = default);

    Task<Result<ReservaDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>Reservas mais recentes primeiro.</summary>
    Task<PagedResult<ReservaDetalhe>> ListAsync(ReservaFiltro filtro, CancellationToken cancellationToken = default);
}

public sealed record ReservaFiltro(Guid? ProdutoId, Guid? EnderecoId, StatusReserva? Status, int? Pagina, int? TamanhoPagina);

/// <param name="Quantidade">Na unidade base.</param>
/// <param name="Lote">Número do lote, obrigatório para produtos que controlam lote.</param>
public sealed record CriarReserva(
    Guid? ProdutoId,
    Guid? EnderecoId,
    string? Lote,
    decimal? Quantidade,
    string? DocumentoReferencia);

public sealed record ReservaDetalhe(
    Guid Id,
    Guid EnderecoId,
    Guid ProdutoId,
    Guid? LoteId,
    string? LoteNumero,
    decimal Quantidade,
    string? DocumentoReferencia,
    StatusReserva Status,
    Guid CriadaPor,
    DateTimeOffset CriadaEm,
    Guid? EncerradaPor,
    DateTimeOffset? EncerradaEm,
    Guid? MovimentacaoId);
