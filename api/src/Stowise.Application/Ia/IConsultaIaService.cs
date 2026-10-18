using Stowise.Application.Common;
using Stowise.Domain.Ia;

namespace Stowise.Application.Ia;

/// <summary>Consulta do registro de chamadas de IA (ADR-0004): custo, latência e falhas por funcionalidade.</summary>
public interface IConsultaIaService
{
    /// <summary>Chamadas mais recentes primeiro.</summary>
    Task<PagedResult<ChamadaIaDetalhe>> ListChamadasAsync(ChamadaIaFiltro filtro, CancellationToken cancellationToken = default);
}

public sealed record ChamadaIaFiltro(
    FuncionalidadeIa? Funcionalidade,
    Guid? UsuarioId,
    bool? Sucesso,
    DateTimeOffset? De,
    DateTimeOffset? Ate,
    int? Pagina,
    int? TamanhoPagina);

public sealed record ChamadaIaDetalhe(
    Guid Id,
    FuncionalidadeIa Funcionalidade,
    Guid? UsuarioId,
    string Provedor,
    string Modelo,
    string PromptVersao,
    int? TokensEntrada,
    int? TokensSaida,
    decimal? CustoEstimado,
    int LatenciaMs,
    int Tentativas,
    bool UsouFallback,
    bool Sucesso,
    string? Erro,
    string? CorrelacaoId,
    DateTimeOffset CriadaEm);
