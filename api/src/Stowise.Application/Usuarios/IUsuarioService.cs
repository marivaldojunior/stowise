using Stowise.Application.Common;

namespace Stowise.Application.Usuarios;

/// <summary>Gestão de usuários e perfis, restrita ao perfil Admin.</summary>
public interface IUsuarioService
{
    Task<PagedResult<UsuarioDetalhe>> ListAsync(UsuarioFiltro filtro, CancellationToken cancellationToken = default);

    Task<Result<UsuarioDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result<UsuarioDetalhe>> CreateAsync(CriarUsuario comando, CancellationToken cancellationToken = default);

    /// <param name="executorId">Admin que executa a operação: ele não pode remover o próprio perfil Admin.</param>
    Task<Result<UsuarioDetalhe>> UpdateAsync(Guid id, AtualizarUsuario comando, Guid executorId, CancellationToken cancellationToken = default);

    /// <summary>Desativa o usuário e revoga as sessões dele. O Admin não pode desativar a própria conta.</summary>
    Task<Result> DeactivateAsync(Guid id, Guid executorId, CancellationToken cancellationToken = default);

    Task<Result> ReactivateAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>Define uma nova senha, desbloqueia o usuário e revoga as sessões dele.</summary>
    Task<Result> ResetPasswordAsync(Guid id, string? novaSenha, CancellationToken cancellationToken = default);
}

public sealed record UsuarioFiltro(string? Busca, string? Perfil, bool? Ativo, int? Pagina, int? TamanhoPagina);

public sealed record UsuarioDetalhe(
    Guid Id,
    string Nome,
    string Email,
    IReadOnlyList<string> Perfis,
    bool Ativo,
    bool Bloqueado,
    DateTimeOffset CriadoEm);

public sealed record CriarUsuario(string? Nome, string? Email, string? Senha, IReadOnlyList<string>? Perfis);

public sealed record AtualizarUsuario(string? Nome, IReadOnlyList<string>? Perfis);
