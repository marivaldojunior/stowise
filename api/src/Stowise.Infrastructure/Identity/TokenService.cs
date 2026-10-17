using System.Buffers.Text;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;

namespace Stowise.Infrastructure.Identity;

internal sealed class TokenService(IOptions<JwtOptions> options)
{
    public JwtOptions Options => options.Value;

    public (string Token, DateTimeOffset ExpiresAt) CreateAccessToken(Usuario usuario, IEnumerable<string> perfis, DateTimeOffset now)
    {
        var expiresAt = now.AddMinutes(Options.AccessTokenMinutes);
        var descriptor = new SecurityTokenDescriptor
        {
            Issuer = Options.Issuer,
            Audience = Options.Audience,
            IssuedAt = now.UtcDateTime,
            NotBefore = now.UtcDateTime,
            Expires = expiresAt.UtcDateTime,
            SigningCredentials = new SigningCredentials(CreateSigningKey(Options.SigningKey), SecurityAlgorithms.HmacSha256),
            Claims = new Dictionary<string, object>
            {
                [JwtRegisteredClaimNames.Sub] = usuario.Id.ToString(),
                [JwtRegisteredClaimNames.Email] = usuario.Email!,
                [JwtRegisteredClaimNames.Name] = usuario.Nome,
                [JwtRegisteredClaimNames.Jti] = Guid.NewGuid().ToString(),
                [ClaimTypes.Role] = perfis.ToArray(),
            },
        };

        return (new JsonWebTokenHandler().CreateToken(descriptor), expiresAt);
    }

    public static SymmetricSecurityKey CreateSigningKey(string signingKey) => new(Encoding.UTF8.GetBytes(signingKey));

    /// <summary>256 bits aleatórios em Base64Url (43 caracteres).</summary>
    public static string GenerateRefreshToken() => Base64Url.EncodeToString(RandomNumberGenerator.GetBytes(32));

    public static string HashRefreshToken(string refreshToken) =>
        Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes(refreshToken)));

    /// <summary>Nomes de claim usados no token e na validação (sem o mapeamento legado do .NET).</summary>
    public static class ClaimTypes
    {
        public const string Role = "role";
        public const string Name = JwtRegisteredClaimNames.Name;
        public const string Subject = JwtRegisteredClaimNames.Sub;
    }
}
