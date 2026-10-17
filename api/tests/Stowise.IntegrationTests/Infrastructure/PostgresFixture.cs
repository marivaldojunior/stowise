using Microsoft.EntityFrameworkCore;
using Npgsql;
using Stowise.Infrastructure.Persistence;
using Testcontainers.PostgreSql;

namespace Stowise.IntegrationTests.Infrastructure;

/// <summary>Um contêiner PostgreSQL + pgvector compartilhado; cada teste usa um banco novo.</summary>
public sealed class PostgresFixture : IAsyncLifetime
{
    public const string Image = "pgvector/pgvector:pg17";

    private PostgreSqlContainer? _container;

    public async Task InitializeAsync()
    {
        if (!DockerEnvironment.IsAvailable && !DockerEnvironment.IsRequired)
        {
            return;
        }

        _container = new PostgreSqlBuilder(Image).Build();
        await _container.StartAsync();
    }

    public async Task DisposeAsync()
    {
        if (_container is not null)
        {
            await _container.DisposeAsync();
        }
    }

    /// <summary>Connection string de um banco ainda inexistente; <c>MigrateAsync</c> cria o banco.</summary>
    public string CreateDatabaseConnectionString()
    {
        if (_container is null)
        {
            throw new InvalidOperationException("O contêiner PostgreSQL não foi iniciado.");
        }

        var builder = new NpgsqlConnectionStringBuilder(_container.GetConnectionString())
        {
            Database = $"stowise_test_{Guid.NewGuid():N}",
        };
        return builder.ConnectionString;
    }

    public static StowiseDbContext CreateDbContext(string connectionString)
    {
        var builder = new DbContextOptionsBuilder<StowiseDbContext>();
        builder.UseStowiseNpgsql(connectionString);
        return new StowiseDbContext(builder.Options);
    }
}

[CollectionDefinition(Name)]
public sealed class PostgresTestGroup : ICollectionFixture<PostgresFixture>
{
    public const string Name = "Postgres";
}
