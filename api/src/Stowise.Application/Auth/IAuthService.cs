namespace Stowise.Application.Auth;

/// <summary>Login, renovação e encerramento de sessão (ADR-0005).</summary>
public interface IAuthService
{
    /// <returns>A sessão criada, ou <c>null</c> se as credenciais forem inválidas, o usuário estiver inativo ou bloqueado.</returns>
    Task<AuthSession?> LoginAsync(string email, string senha, CancellationToken cancellationToken = default);

    /// <summary>Consome o refresh token e emite um novo da mesma família.</summary>
    /// <returns>A nova sessão, ou <c>null</c> se o token for desconhecido, expirado, revogado ou já usado.</returns>
    Task<AuthSession?> RefreshAsync(string refreshToken, CancellationToken cancellationToken = default);

    /// <summary>Revoga a família do refresh token. Não falha se o token for desconhecido.</summary>
    Task LogoutAsync(string refreshToken, CancellationToken cancellationToken = default);

    Task<UsuarioResumo?> GetUsuarioAsync(Guid usuarioId, CancellationToken cancellationToken = default);
}

public sealed record AuthSession(
    string AccessToken,
    DateTimeOffset AccessTokenExpiresAt,
    string RefreshToken,
    DateTimeOffset RefreshTokenExpiresAt,
    UsuarioResumo Usuario);

public sealed record UsuarioResumo(Guid Id, string Nome, string Email, IReadOnlyList<string> Perfis);
