namespace Stowise.Infrastructure.Identity;

/// <summary>
/// Refresh token rotativo (ADR-0005). O banco guarda só o hash. Tokens da mesma sessão
/// compartilham a família: o reuso de um token consumido revoga a família inteira.
/// </summary>
public sealed class RefreshToken
{
    public const int TokenHashLength = 64;

    private RefreshToken()
    {
    }

    public RefreshToken(Guid usuarioId, Guid familyId, string tokenHash, DateTimeOffset createdAt, DateTimeOffset expiresAt)
    {
        UsuarioId = usuarioId;
        FamilyId = familyId;
        TokenHash = tokenHash;
        CreatedAt = createdAt;
        ExpiresAt = expiresAt;
    }

    public Guid Id { get; private set; } = Guid.CreateVersion7();

    public Guid UsuarioId { get; private set; }

    public Guid FamilyId { get; private set; }

    public string TokenHash { get; private set; } = null!;

    public DateTimeOffset CreatedAt { get; private set; }

    public DateTimeOffset ExpiresAt { get; private set; }

    public DateTimeOffset? ConsumedAt { get; private set; }

    public DateTimeOffset? RevokedAt { get; private set; }
}
