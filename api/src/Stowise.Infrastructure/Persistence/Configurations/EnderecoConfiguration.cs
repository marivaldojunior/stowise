using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Estrutura;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class EnderecoConfiguration : IEntityTypeConfiguration<Endereco>
{
    public void Configure(EntityTypeBuilder<Endereco> builder)
    {
        builder.Property(e => e.Codigo).HasMaxLength(Endereco.CodigoMaxLength);
        builder.Property(e => e.Rua).HasMaxLength(Endereco.RuaMaxLength);
        builder.Property(e => e.MotivoBloqueio).HasMaxLength(Endereco.MotivoBloqueioMaxLength);

        // O código (A-03-02-1) é único no armazém, e não só na zona.
        builder.HasIndex(e => new { e.ArmazemId, e.Codigo }).IsUnique();
        builder.HasIndex(e => e.ZonaId);
        builder.HasIndex(e => e.Status);

        builder.HasOne<Armazem>()
            .WithMany()
            .HasForeignKey(e => e.ArmazemId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne<Zona>()
            .WithMany()
            .HasForeignKey(e => e.ZonaId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
