using System.Security.Claims;

namespace Stowise.Api.Common;

public static class ClaimsPrincipalExtensions
{
    /// <summary>Id do usuário autenticado (claim <c>sub</c>, ADR-0005).</summary>
    public static Guid GetUsuarioId(this ClaimsPrincipal user)
    {
        ArgumentNullException.ThrowIfNull(user);

        return Guid.TryParse(user.FindFirstValue("sub"), out var id)
            ? id
            : throw new InvalidOperationException("The authenticated user has no valid 'sub' claim.");
    }
}
