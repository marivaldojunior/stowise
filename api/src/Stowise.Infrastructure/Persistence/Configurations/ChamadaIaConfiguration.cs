using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Identity;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class ChamadaIaConfiguration : IEntityTypeConfiguration<ChamadaIa>
{
    public void Configure(EntityTypeBuilder<ChamadaIa> builder)
    {
        builder.ToTable("chamadas_ia");
        builder.Property(c => c.Provedor).HasMaxLength(ChamadaIa.ProvedorMaxLength);
        builder.Property(c => c.Modelo).HasMaxLength(ChamadaIa.ModeloMaxLength);
        builder.Property(c => c.PromptVersao).HasMaxLength(ChamadaIa.PromptVersaoMaxLength);
        builder.Property(c => c.Erro).HasMaxLength(ChamadaIa.ErroMaxLength);
        builder.Property(c => c.CorrelacaoId).HasMaxLength(ChamadaIa.CorrelacaoIdMaxLength);
        builder.Property(c => c.CustoEstimado).HasPrecision(18, 6);

        // Consultas de custo e de cota: por funcionalidade e período, e por usuário e período.
        builder.HasIndex(c => new { c.Funcionalidade, c.CriadaEm });
        builder.HasIndex(c => new { c.UsuarioId, c.CriadaEm });
        builder.HasOne<Usuario>().WithMany().HasForeignKey(c => c.UsuarioId).OnDelete(DeleteBehavior.Restrict);
    }
}
