using Microsoft.EntityFrameworkCore;
using Stowise.Domain.Estrutura;
using Stowise.Infrastructure.Persistence.Seed;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Persistence;

[Collection(PostgresTestGroup.Name)]
public class DatabaseTests(PostgresFixture postgres)
{
    [DockerFact]
    public async Task Migrations_create_schema_with_pgvector_extension()
    {
        await using var db = PostgresFixture.CreateDbContext(postgres.CreateDatabaseConnectionString());

        await db.Database.MigrateAsync();

        var extensions = await db.Database
            .SqlQueryRaw<string>("SELECT extname AS \"Value\" FROM pg_extension")
            .ToListAsync();
        Assert.Contains("vector", extensions);
        Assert.Empty(await db.Database.GetPendingMigrationsAsync());
    }

    [DockerFact]
    public async Task Seed_creates_sample_warehouse_only_once()
    {
        var connectionString = postgres.CreateDatabaseConnectionString();
        await using (var db = PostgresFixture.CreateDbContext(connectionString))
        {
            await db.Database.MigrateAsync();
            Assert.True(await SampleDataSeeder.SeedAsync(db));
            Assert.False(await SampleDataSeeder.SeedAsync(db));
        }

        await using var check = PostgresFixture.CreateDbContext(connectionString);
        var armazem = await check.Armazens.Include(a => a.Zonas).SingleAsync();
        Assert.Equal(SampleDataSeeder.CodigoArmazem, armazem.Codigo);
        Assert.Equal(["FRIO", "SECO"], armazem.Zonas.Select(z => z.Codigo).Order());

        var enderecos = await check.Enderecos.ToListAsync();
        Assert.Equal(13, enderecos.Count);
        Assert.All(enderecos, e => Assert.Equal(StatusEndereco.Livre, e.Status));
        Assert.Contains(enderecos, e => e.Codigo == "A-03-03-1");
    }
}
