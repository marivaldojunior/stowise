using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;
using Stowise.Infrastructure.Persistence;

namespace Stowise.IntegrationTests.Persistence;

public class ModelTests
{
    private static StowiseDbContext CreateContext() => new DesignTimeDbContextFactory().CreateDbContext([]);

    [Fact]
    public void Model_has_no_changes_missing_from_migrations()
    {
        using var db = CreateContext();

        Assert.False(
            db.Database.HasPendingModelChanges(),
            "O modelo mudou sem migration. Rode: dotnet ef migrations add <Nome> -p src/Stowise.Infrastructure -s src/Stowise.Infrastructure -o Persistence/Migrations");
    }

    [Fact]
    public void Domain_entity_ids_are_never_generated_by_ef()
    {
        using var db = CreateContext();

        var generated = db.Model.GetEntityTypes()
            .Where(e => typeof(Entity).IsAssignableFrom(e.ClrType))
            .Where(e => e.FindProperty(nameof(Entity.Id))!.ValueGenerated != ValueGenerated.Never)
            .Select(e => e.ClrType.Name)
            .ToList();

        Assert.Empty(generated);
    }

    [Theory]
    [InlineData(typeof(Saldo))]
    [InlineData(typeof(Endereco))]
    [InlineData(typeof(Produto))]
    public void Concurrency_version_is_the_xmin_system_column(Type entityType)
    {
        using var db = CreateContext();

        var versao = db.Model.FindEntityType(entityType)!.FindProperty("Versao")!;

        Assert.Equal("xmin", versao.GetColumnName());
        Assert.True(versao.IsConcurrencyToken);
        Assert.Equal(ValueGenerated.OnAddOrUpdate, versao.ValueGenerated);
    }

    [Fact]
    public void Idempotency_key_is_unique_in_the_ledger()
    {
        using var db = CreateContext();

        var index = db.Model.FindEntityType(typeof(Movimentacao))!.GetIndexes()
            .Single(i => i.Properties.Select(p => p.Name).SequenceEqual([nameof(Movimentacao.IdempotencyKey)]));

        Assert.True(index.IsUnique);
        Assert.Equal("ix_movimentacoes_idempotency_key", index.GetDatabaseName());
    }

    [Fact]
    public void Package_added_to_a_tracked_product_is_inserted_not_updated()
    {
        using var db = CreateContext();
        var produto = Produto.Create(
            "COLA-2L",
            new DadosProduto("Cola 2L", "UN", ClasseArmazenagem.Normal, false, false, null, null, null),
            new DadosEmbalagem(null, null, null, null, null));
        db.Attach(produto);

        var caixa = produto.AddEmbalagem(TipoEmbalagem.Caixa, 6m, new DadosEmbalagem(null, null, null, null, null));
        db.ChangeTracker.DetectChanges();

        Assert.Equal(EntityState.Added, db.Entry(caixa).State);
        Assert.Equal(EntityState.Unchanged, db.Entry(produto.EmbalagemBase).State);
    }

    [Fact]
    public void Zone_added_to_a_tracked_warehouse_is_inserted_not_updated()
    {
        using var db = CreateContext();
        var armazem = Armazem.Create("CD01", "Centro");
        db.Attach(armazem);

        var zona = armazem.AddZona("SECO", ClasseArmazenagem.Normal);
        db.ChangeTracker.DetectChanges();

        Assert.Equal(EntityState.Added, db.Entry(zona).State);
    }
}
