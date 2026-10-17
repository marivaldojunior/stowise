using Microsoft.EntityFrameworkCore;
using Stowise.Domain.Estrutura;

namespace Stowise.Infrastructure.Persistence;

public sealed class StowiseDbContext(DbContextOptions<StowiseDbContext> options) : DbContext(options)
{
    public DbSet<Armazem> Armazens => Set<Armazem>();

    public DbSet<Zona> Zonas => Set<Zona>();

    public DbSet<Endereco> Enderecos => Set<Endereco>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasPostgresExtension("vector");
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(StowiseDbContext).Assembly);
    }

    protected override void ConfigureConventions(ModelConfigurationBuilder configurationBuilder)
    {
        // Enums gravados como texto: legíveis no banco e estáveis se a ordem dos membros mudar.
        configurationBuilder.Properties<Enum>().HaveConversion<string>().HaveMaxLength(30);

        // SPEC, decisão 2: quantidades e medidas em decimal(18,4).
        configurationBuilder.Properties<decimal>().HavePrecision(18, 4);
    }
}
