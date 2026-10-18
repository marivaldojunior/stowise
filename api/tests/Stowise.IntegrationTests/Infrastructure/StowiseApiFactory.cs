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

    /// <summary>Porta 1: a conexão falha na hora, sem depender de um PostgreSQL local.</summary>
    public string ConnectionString { get; init; } = "Host=127.0.0.1;Port=1;Database=stowise_unused;Timeout=2";

    /// <summary>Configurações extras, no formato <c>Secao:Chave</c>.</summary>
    public Dictionary<string, string?> Settings { get; init; } = [];

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment("Testing");
        builder.UseSetting("ConnectionStrings:Stowise", ConnectionString);
        builder.UseSetting("Jwt:SigningKey", TestSigningKey);
        builder.UseSetting("Serilog:MinimumLevel:Default", "Warning");

        // Sem banco, o servidor de jobs não sobe (ele conecta no PostgreSQL na partida).
        builder.UseSetting("Jobs:Enabled", "false");

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
            ["Jobs:Enabled"] = "true",
            ["Jobs:PollIntervalSeconds"] = "0.5",
            ["AdminBootstrap:Email"] = adminEmail,
            ["AdminBootstrap:Password"] = adminPassword,
        },
    };
}
