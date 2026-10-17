using Stowise.Application.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.Application.Estrutura;

public interface IEnderecoService
{
    Task<PagedResult<EnderecoDetalhe>> ListAsync(EnderecoFiltro filtro, CancellationToken cancellationToken = default);

    Task<Result<EnderecoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>Busca pelo código lido no app (ex.: A-03-02-1), dentro de um armazém.</summary>
    Task<Result<EnderecoDetalhe>> FindByCodigoAsync(Guid armazemId, string? codigo, CancellationToken cancellationToken = default);

    Task<Result<EnderecoDetalhe>> CreateAsync(CriarEndereco comando, CancellationToken cancellationToken = default);

    /// <summary>Altera capacidade, medidas e distância. As coordenadas (e o código) não mudam.</summary>
    Task<Result<EnderecoDetalhe>> UpdateAsync(Guid id, DimensoesEnderecoComando comando, CancellationToken cancellationToken = default);

    /// <summary>Exclui o endereço, desde que ele não esteja ocupado.</summary>
    Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default);
}

/// <param name="Codigo">Prefixo do código (ex.: "A-03" traz o módulo 3 da rua A).</param>
public sealed record EnderecoFiltro(
    Guid? ArmazemId,
    Guid? ZonaId,
    string? Codigo,
    StatusEndereco? Status,
    int? Pagina,
    int? TamanhoPagina);

public sealed record EnderecoDetalhe(
    Guid Id,
    Guid ArmazemId,
    Guid ZonaId,
    string Codigo,
    string Rua,
    int Modulo,
    int Nivel,
    int Posicao,
    decimal CapacidadePesoKg,
    decimal AlturaCm,
    decimal LarguraCm,
    decimal ProfundidadeCm,
    decimal DistanciaExpedicao,
    StatusEndereco Status,
    string? MotivoBloqueio);

public sealed record DimensoesEnderecoComando(
    decimal? CapacidadePesoKg,
    decimal? AlturaCm,
    decimal? LarguraCm,
    decimal? ProfundidadeCm,
    decimal? DistanciaExpedicao);

public sealed record CriarEndereco(
    Guid? ZonaId,
    string? Rua,
    int? Modulo,
    int? Nivel,
    int? Posicao,
    decimal? CapacidadePesoKg,
    decimal? AlturaCm,
    decimal? LarguraCm,
    decimal? ProfundidadeCm,
    decimal? DistanciaExpedicao);
