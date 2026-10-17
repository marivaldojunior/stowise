using Microsoft.Extensions.Options;
using Stowise.Infrastructure.Identity;

namespace Stowise.IntegrationTests.Infrastructure;

/// <summary>Access tokens válidos para a <see cref="StowiseApiFactory"/>, sem passar pelo banco.</summary>
public static class TestTokens
{
    private static readonly TokenService Tokens = new(Options.Create(new JwtOptions
    {
        Issuer = "stowise-api",
        Audience = "stowise-clients",
        SigningKey = StowiseApiFactory.TestSigningKey,
    }));

    public static string ForPerfis(params string[] perfis)
    {
        var now = DateTimeOffset.UtcNow;
        return Tokens.CreateAccessToken(new Usuario("teste@stowise.test", "Usuário de teste", now), perfis, now).Token;
    }
}
