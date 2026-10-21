using Stowise.Application.Common;
using Stowise.Domain.Armazenagem;

namespace Stowise.Application.Armazenagem;

/// <summary>
/// Tarefas de armazenagem criadas na conclusão da conferência (SPEC, 2.3). A confirmação faz a entrada no estoque
/// pelo serviço de movimentação, com o id da tarefa como chave de idempotência: repetir a confirmação não duplica a entrada.
/// </summary>
public interface ITarefaArmazenagemService
{
    Task<PagedResult<TarefaArmazenagemResumo>> ListAsync(TarefaArmazenagemFiltro filtro, CancellationToken cancellationToken = default);

    Task<Result<TarefaArmazenagemDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result<TarefaArmazenagemDetalhe>> ConfirmAsync(
        Guid id,
        ConfirmarTarefaArmazenagem comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default);
}

/// <param name="Status">Ex.: Pendente para a fila do operador, Divergente para a tela de divergências.</param>
public sealed record TarefaArmazenagemFiltro(StatusTarefaArmazenagem? Status, Guid? RecebimentoId, int? Pagina, int? TamanhoPagina);

/// <param name="Quantidade">Na unidade base.</param>
public sealed record TarefaArmazenagemResumo(
    Guid Id,
    Guid RecebimentoId,
    int NumeroNota,
    Guid ProdutoId,
    string Sku,
    string Descricao,
    string UnidadeBase,
    string? LoteNumero,
    DateOnly? LoteValidade,
    decimal Quantidade,
    Guid? EnderecoSugeridoId,
    string? EnderecoSugerido,
    decimal? Pontuacao,
    StatusTarefaArmazenagem Status,
    string? EnderecoConfirmado,
    string? MotivoDivergencia,
    DateTimeOffset CriadoEm,
    DateTimeOffset? ConcluidoEm);

/// <param name="Notas">Snapshot da sugestão: nota, peso e explicação de cada regra para o endereço sugerido.</param>
/// <param name="RegrasVersao">Resumo da configuração das regras no momento da sugestão.</param>
public sealed record TarefaArmazenagemDetalhe(
    TarefaArmazenagemResumo Tarefa,
    IReadOnlyList<NotaRegra> Notas,
    string RegrasVersao,
    Guid? EnderecoConfirmadoId,
    Guid? MovimentacaoId,
    Guid? ConcluidoPor);

/// <param name="EnderecoId">Endereço bipado. Fora do sugerido, o motivo é obrigatório e a tarefa fica Divergente.</param>
/// <param name="OcorridoEm">Hora do aparelho. Sem ela, vale a hora do servidor.</param>
public sealed record ConfirmarTarefaArmazenagem(Guid? EnderecoId, string? MotivoDivergencia, Guid? DispositivoId, DateTimeOffset? OcorridoEm);
