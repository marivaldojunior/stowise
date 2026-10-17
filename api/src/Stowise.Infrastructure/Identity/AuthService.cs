using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Stowise.Application.Auth;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Identity;

internal sealed partial class AuthService(
    UserManager<Usuario> users,
    StowiseDbContext db,
    TokenService tokens,
    TimeProvider time,
    ILogger<AuthService> logger) : IAuthService
{
    public async Task<AuthSession?> LoginAsync(string email, string senha, CancellationToken cancellationToken = default)
    {
        var usuario = await users.FindByEmailAsync(email);
        if (usuario is null || !usuario.Ativo)
        {
            return null;
        }

        if (await users.IsLockedOutAsync(usuario))
        {
            LogLockedOutLogin(logger, usuario.Id);
            return null;
        }

        if (!await users.CheckPasswordAsync(usuario, senha))
        {
            await users.AccessFailedAsync(usuario);
            return null;
        }

        await users.ResetAccessFailedCountAsync(usuario);
        return await IssueSessionAsync(usuario, familyId: Guid.CreateVersion7(), cancellationToken);
    }

    public async Task<AuthSession?> RefreshAsync(string refreshToken, CancellationToken cancellationToken = default)
    {
        var now = time.GetUtcNow();
        var hash = TokenService.HashRefreshToken(refreshToken);
        var token = await db.RefreshTokens.AsNoTracking().SingleOrDefaultAsync(t => t.TokenHash == hash, cancellationToken);
        if (token is null)
        {
            return null;
        }

        if (token.ConsumedAt is not null || token.RevokedAt is not null)
        {
            LogRefreshTokenReuse(logger, token.UsuarioId, token.FamilyId);
            await RevokeFamilyAsync(token.FamilyId, now, cancellationToken);
            return null;
        }

        if (token.ExpiresAt <= now)
        {
            return null;
        }

        // Consumo atômico: entre duas chamadas simultâneas com o mesmo token, só uma atualiza a linha.
        var consumed = await db.RefreshTokens
            .Where(t => t.Id == token.Id && t.ConsumedAt == null && t.RevokedAt == null)
            .ExecuteUpdateAsync(s => s.SetProperty(t => t.ConsumedAt, now), cancellationToken);
        if (consumed == 0)
        {
            LogRefreshTokenReuse(logger, token.UsuarioId, token.FamilyId);
            await RevokeFamilyAsync(token.FamilyId, now, cancellationToken);
            return null;
        }

        var usuario = await users.FindByIdAsync(token.UsuarioId.ToString());
        if (usuario is null || !usuario.Ativo || await users.IsLockedOutAsync(usuario))
        {
            await RevokeFamilyAsync(token.FamilyId, now, cancellationToken);
            return null;
        }

        return await IssueSessionAsync(usuario, token.FamilyId, cancellationToken);
    }

    public async Task LogoutAsync(string refreshToken, CancellationToken cancellationToken = default)
    {
        var hash = TokenService.HashRefreshToken(refreshToken);
        var familyId = await db.RefreshTokens
            .Where(t => t.TokenHash == hash)
            .Select(t => (Guid?)t.FamilyId)
            .SingleOrDefaultAsync(cancellationToken);

        if (familyId is not null)
        {
            await RevokeFamilyAsync(familyId.Value, time.GetUtcNow(), cancellationToken);
        }
    }

    public async Task<UsuarioResumo?> GetUsuarioAsync(Guid usuarioId, CancellationToken cancellationToken = default)
    {
        var usuario = await users.FindByIdAsync(usuarioId.ToString());
        if (usuario is null || !usuario.Ativo)
        {
            return null;
        }

        return ToResumo(usuario, await users.GetRolesAsync(usuario));
    }

    private async Task<AuthSession> IssueSessionAsync(Usuario usuario, Guid familyId, CancellationToken cancellationToken)
    {
        var now = time.GetUtcNow();
        var perfis = await users.GetRolesAsync(usuario);
        var (accessToken, accessExpiresAt) = tokens.CreateAccessToken(usuario, perfis, now);

        var refreshToken = TokenService.GenerateRefreshToken();
        var stored = new RefreshToken(
            usuario.Id,
            familyId,
            TokenService.HashRefreshToken(refreshToken),
            now,
            now.AddDays(tokens.Options.RefreshTokenDays));
        db.RefreshTokens.Add(stored);
        await db.SaveChangesAsync(cancellationToken);

        return new AuthSession(accessToken, accessExpiresAt, refreshToken, stored.ExpiresAt, ToResumo(usuario, perfis));
    }

    private Task<int> RevokeFamilyAsync(Guid familyId, DateTimeOffset now, CancellationToken cancellationToken) =>
        db.RefreshTokens
            .Where(t => t.FamilyId == familyId && t.RevokedAt == null)
            .ExecuteUpdateAsync(s => s.SetProperty(t => t.RevokedAt, now), cancellationToken);

    private static UsuarioResumo ToResumo(Usuario usuario, IList<string> perfis) =>
        new(usuario.Id, usuario.Nome, usuario.Email!, [.. perfis.Order(StringComparer.Ordinal)]);

    [LoggerMessage(Level = LogLevel.Warning, Message = "Login attempt for locked out user {UsuarioId}")]
    private static partial void LogLockedOutLogin(ILogger logger, Guid usuarioId);

    [LoggerMessage(Level = LogLevel.Warning, Message = "Refresh token reuse detected for user {UsuarioId}; revoking family {FamilyId}")]
    private static partial void LogRefreshTokenReuse(ILogger logger, Guid usuarioId, Guid familyId);
}
