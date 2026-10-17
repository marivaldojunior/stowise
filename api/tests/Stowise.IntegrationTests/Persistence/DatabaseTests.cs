using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
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
    public async Task Address_migration_backfills_the_warehouse_of_existing_rows()
    {
        await using var db = PostgresFixture.CreateDbContext(postgres.CreateDatabaseConnectionString());
        var migrator = db.GetService<IMigrator>();

        // Banco na versão anterior, com um endereço que ainda não tem armazem_id.
        await migrator.MigrateAsync("AddCatalogo");
        var armazemId = Guid.CreateVersion7();
        var zonaId = Guid.CreateVersion7();
        await db.Database.ExecuteSqlAsync($"INSERT INTO armazens (id, codigo, nome) VALUES ({armazemId}, 'CD09', 'Antigo')");
        await db.Database.ExecuteSqlAsync($"INSERT INTO zonas (id, armazem_id, codigo, classe_armazenagem) VALUES ({zonaId}, {armazemId}, 'SECO', 'Normal')");
        await db.Database.ExecuteSqlAsync(
            $"""
            INSERT INTO enderecos (id, zona_id, codigo, rua, modulo, nivel, posicao, capacidade_peso_kg, altura_cm, largura_cm, profundidade_cm, distancia_expedicao, status)
            VALUES ({Guid.CreateVersion7()}, {zonaId}, 'A-01-01-1', 'A', 1, 1, 1, 1000, 150, 120, 100, 4, 'Livre')
            """);

        await migrator.MigrateAsync();

        var endereco = await db.Enderecos.AsNoTracking().SingleAsync();
        Assert.Equal(armazemId, endereco.ArmazemId);
        Assert.Equal(zonaId, endereco.ZonaId);
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
