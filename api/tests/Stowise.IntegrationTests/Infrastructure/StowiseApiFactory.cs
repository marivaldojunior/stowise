using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;

namespace Stowise.IntegrationTests.Infrastructure;

/// <summary>
/// API em memória no ambiente "Testing": sem migrations nem seed na inicialização.
/// Sem <see cref="ConnectionString"/> informada, usa uma que nunca é aberta.
/// </summary>
public class StowiseApiFactory : WebApplicationFactory<Program>
{
    public const string TestSigningKey = "test-only-signing-key-0123456789abcdef-0123";

    public string ConnectionString { get; init; } = "Host=localhost;Database=stowise_unused";

    /// <summary>Configurações extras, no formato <c>Secao:Chave</c>.</summary>
    public Dictionary<string, string?> Settings { get; init; } = [];

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment("Testing");
        builder.UseSetting("ConnectionStrings:Stowise", ConnectionString);
        builder.UseSetting("Jwt:SigningKey", TestSigningKey);

        foreach (var (key, value) in Settings)
        {
            builder.UseSetting(key, value);
        }
    }

    /// <summary>API ligada a um banco novo do contêiner, com migrations e um Admin criado na inicialização.</summary>
    public static StowiseApiFactory WithDatabase(PostgresFixture postgres, string adminEmail, string adminPassword) => new()
    {
        ConnectionString = postgres.CreateDatabaseConnectionString(),
        Settings =
        {
            ["Database:MigrateOnStartup"] = "true",
            ["AdminBootstrap:Email"] = adminEmail,
            ["AdminBootstrap:Password"] = adminPassword,
        },
    };
}
