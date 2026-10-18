using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Npgsql;

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
    /// <param name="jobs">
    /// Sobe o servidor do Hangfire. Só para os testes que esperam um job: cada servidor mantém várias conexões
    /// abertas, e o PostgreSQL do contêiner tem limite de conexões.
    /// </param>
    public static StowiseApiFactory WithDatabase(PostgresFixture postgres, string adminEmail, string adminPassword, bool jobs = false) => new()
    {
        ConnectionString = postgres.CreateDatabaseConnectionString(),
        Settings =
        {
            ["Database:MigrateOnStartup"] = "true",
            ["Jobs:Enabled"] = jobs ? "true" : "false",
            ["Jobs:Workers"] = "1",
            ["Jobs:PollIntervalSeconds"] = "0.5",
            ["AdminBootstrap:Email"] = adminEmail,
            ["AdminBootstrap:Password"] = adminPassword,
        },
    };

    /// <summary>
    /// Fecha as conexões ociosas do banco deste teste. Cada teste usa um banco novo, então o pool de cada um
    /// ficaria aberto até o fim da execução e esgotaria o limite de conexões do PostgreSQL.
    /// </summary>
    public override async ValueTask DisposeAsync()
    {
        await base.DisposeAsync();
        using var conexao = new NpgsqlConnection(ConnectionString);
        NpgsqlConnection.ClearPool(conexao);
        GC.SuppressFinalize(this);
    }
}
