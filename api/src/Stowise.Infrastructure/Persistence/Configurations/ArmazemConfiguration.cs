using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Estrutura;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class ArmazemConfiguration : IEntityTypeConfiguration<Armazem>
{
    public void Configure(EntityTypeBuilder<Armazem> builder)
    {
        builder.Property(a => a.Codigo).HasMaxLength(Armazem.CodigoMaxLength);
        builder.Property(a => a.Nome).HasMaxLength(Armazem.NomeMaxLength);
        builder.HasIndex(a => a.Codigo).IsUnique();

        builder.HasMany(a => a.Zonas)
            .WithOne()
            .HasForeignKey(z => z.ArmazemId)
            .OnDelete(DeleteBehavior.Restrict);
        builder.Navigation(a => a.Zonas).HasField("_zonas").UsePropertyAccessMode(PropertyAccessMode.Field);
    }
}
