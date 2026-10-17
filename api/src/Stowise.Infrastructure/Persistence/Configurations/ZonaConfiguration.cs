using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Estrutura;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class ZonaConfiguration : IEntityTypeConfiguration<Zona>
{
    public void Configure(EntityTypeBuilder<Zona> builder)
    {
        builder.Property(z => z.Codigo).HasMaxLength(Zona.CodigoMaxLength);
        builder.HasIndex(z => new { z.ArmazemId, z.Codigo }).IsUnique();
    }
}
