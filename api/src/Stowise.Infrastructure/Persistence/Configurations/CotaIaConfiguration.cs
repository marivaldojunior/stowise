using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Application.Auth;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Identity;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class CotaIaConfiguration : IEntityTypeConfiguration<CotaIa>
{
    public const string PerfilUnicoIndex = "ix_cotas_ia_perfil_funcionalidade";
    public const string UsuarioUnicoIndex = "ix_cotas_ia_usuario_id_funcionalidade";

    /// <summary>Cotas iniciais (decisão da tarefa, ajustáveis pelo Admin). O Admin não tem linha: sem cota, sem limite.</summary>
    internal static readonly Guid CotaGestorId = Guid.Parse("0199f0a0-0000-7000-8000-00000000c001");
    internal static readonly Guid CotaOperadorId = Guid.Parse("0199f0a0-0000-7000-8000-00000000c002");

    public void Configure(EntityTypeBuilder<CotaIa> builder)
    {
        builder.ToTable("cotas_ia", t => t.HasCheckConstraint(
            "ck_cotas_ia_perfil_ou_usuario",
            "(perfil IS NULL) <> (usuario_id IS NULL)"));
        builder.Property(c => c.Perfil).HasMaxLength(CotaIa.PerfilMaxLength);
        builder.Property(c => c.Versao).IsRowVersion().HasColumnName("xmin");

        // Uma cota por perfil (ou usuário) e funcionalidade; NULLS NOT DISTINCT vale também para a cota geral.
        builder.HasIndex(c => new { c.Perfil, c.Funcionalidade })
            .IsUnique()
            .AreNullsDistinct(false)
            .HasFilter("perfil IS NOT NULL")
            .HasDatabaseName(PerfilUnicoIndex);
        builder.HasIndex(c => new { c.UsuarioId, c.Funcionalidade })
            .IsUnique()
            .AreNullsDistinct(false)
            .HasFilter("usuario_id IS NOT NULL")
            .HasDatabaseName(UsuarioUnicoIndex);

        // A exceção vai junto com o usuário.
        builder.HasOne<Usuario>().WithMany().HasForeignKey(c => c.UsuarioId).OnDelete(DeleteBehavior.Cascade);

        builder.HasData(
            new { Id = CotaGestorId, Perfil = Perfis.Gestor, LimiteChamadasDia = (int?)200, LimiteTokensMes = (long?)2_000_000 },
            new { Id = CotaOperadorId, Perfil = Perfis.Operador, LimiteChamadasDia = (int?)50, LimiteTokensMes = (long?)500_000 });
    }
}
