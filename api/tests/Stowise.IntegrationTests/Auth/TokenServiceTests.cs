using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using Stowise.Infrastructure.Identity;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Auth;

public class TokenServiceTests
{
    private static readonly JwtOptions JwtConfig = new()
    {
        Issuer = "stowise-api",
        Audience = "stowise-clients",
        SigningKey = StowiseApiFactory.TestSigningKey,
        AccessTokenMinutes = 15,
    };

    private readonly TokenService _tokens = new(Options.Create(JwtConfig));

    [Fact]
    public async Task Access_token_carries_identity_and_perfis_and_expires_in_15_minutes()
    {
        var now = DateTimeOffset.UtcNow;
        var usuario = new Usuario("ana@stowise.dev", "Ana", now);

        var (token, expiresAt) = _tokens.CreateAccessToken(usuario, ["Gestor", "Operador"], now);

        var result = await new JsonWebTokenHandler().ValidateTokenAsync(token, new TokenValidationParameters
        {
            ValidIssuer = JwtConfig.Issuer,
            ValidAudience = JwtConfig.Audience,
            IssuerSigningKey = TokenService.CreateSigningKey(JwtConfig.SigningKey),
        });
        Assert.True(result.IsValid, result.Exception?.Message);

        var jwt = (JsonWebToken)result.SecurityToken;
        Assert.Equal(usuario.Id.ToString(), jwt.Subject);
        Assert.Equal("ana@stowise.dev", jwt.GetClaim("email").Value);
        Assert.Equal("Ana", jwt.GetClaim("name").Value);
        Assert.Equal(["Gestor", "Operador"], jwt.Claims.Where(c => c.Type == "role").Select(c => c.Value));
        Assert.Equal(now.AddMinutes(15), expiresAt);
        Assert.Equal(expiresAt.ToUnixTimeSeconds(), new DateTimeOffset(jwt.ValidTo).ToUnixTimeSeconds());
    }

    [Fact]
    public async Task Access_token_signed_with_another_key_is_rejected()
    {
        var (token, _) = _tokens.CreateAccessToken(new Usuario("ana@stowise.dev", "Ana", DateTimeOffset.UtcNow), [], DateTimeOffset.UtcNow);

        var result = await new JsonWebTokenHandler().ValidateTokenAsync(token, new TokenValidationParameters
        {
            ValidIssuer = JwtConfig.Issuer,
            ValidAudience = JwtConfig.Audience,
            IssuerSigningKey = TokenService.CreateSigningKey("another-signing-key-0123456789abcdef-xyz"),
        });

        Assert.False(result.IsValid);
    }

    [Fact]
    public void Refresh_tokens_are_random_and_only_the_hash_is_deterministic()
    {
        var first = TokenService.GenerateRefreshToken();
        var second = TokenService.GenerateRefreshToken();

        Assert.NotEqual(first, second);
        Assert.Equal(43, first.Length);
        Assert.Equal(TokenService.HashRefreshToken(first), TokenService.HashRefreshToken(first));
        Assert.NotEqual(TokenService.HashRefreshToken(first), TokenService.HashRefreshToken(second));
        Assert.Equal(RefreshToken.TokenHashLength, TokenService.HashRefreshToken(first).Length);
    }
}
