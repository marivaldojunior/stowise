using System.ComponentModel.DataAnnotations;

namespace Stowise.Infrastructure.Identity;

public sealed class JwtOptions
{
    public const string SectionName = "Jwt";

    [Required]
    public string Issuer { get; set; } = null!;

    [Required]
    public string Audience { get; set; } = null!;

    /// <summary>Chave HS256. Em produção, vem de variável de ambiente (<c>Jwt__SigningKey</c>).</summary>
    [Required]
    [MinLength(32)]
    public string SigningKey { get; set; } = null!;

    [Range(1, 60)]
    public int AccessTokenMinutes { get; set; } = 15;

    [Range(1, 90)]
    public int RefreshTokenDays { get; set; } = 14;
}
