using Stowise.Application.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.Application.Estrutura;

/// <summary>Armazéns e as zonas de cada armazém.</summary>
public interface IArmazemService
{
    Task<IReadOnlyList<ArmazemResumo>> ListAsync(CancellationToken cancellationToken = default);

    Task<Result<ArmazemDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result<ArmazemDetalhe>> CreateAsync(CriarArmazem comando, CancellationToken cancellationToken = default);

    /// <summary>Altera o nome. O código do armazém não muda.</summary>
    Task<Result<ArmazemDetalhe>> RenameAsync(Guid id, RenomearArmazem comando, CancellationToken cancellationToken = default);

    /// <summary>Exclui só armazéns sem zonas.</summary>
    Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result<ArmazemDetalhe>> AddZonaAsync(Guid armazemId, SalvarZona comando, CancellationToken cancellationToken = default);

    Task<Result<ArmazemDetalhe>> UpdateZonaAsync(Guid armazemId, Guid zonaId, SalvarZona comando, CancellationToken cancellationToken = default);

    /// <summary>Remove só zonas sem endereços.</summary>
    Task<Result<ArmazemDetalhe>> RemoveZonaAsync(Guid armazemId, Guid zonaId, CancellationToken cancellationToken = default);
}

public sealed record ArmazemResumo(Guid Id, string Codigo, string Nome, int Zonas, int Enderecos);

public sealed record ArmazemDetalhe(Guid Id, string Codigo, string Nome, IReadOnlyList<ZonaDetalhe> Zonas);

public sealed record ZonaDetalhe(Guid Id, string Codigo, ClasseArmazenagem ClasseArmazenagem, int Enderecos);

public sealed record CriarArmazem(string? Codigo, string? Nome);

public sealed record RenomearArmazem(string? Nome);

public sealed record SalvarZona(string? Codigo, ClasseArmazenagem? ClasseArmazenagem);
