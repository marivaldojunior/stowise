using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Stowise.Infrastructure.Identity;

namespace Stowise.Infrastructure.Persistence.Configurations;

/// <summary>Nomes de tabela do Identity em português e os perfis fixos como dados de referência.</summary>
internal static class IdentityConfiguration
{
    public static void Configure(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Usuario>(b =>
        {
            b.ToTable("usuarios");
            b.Property(u => u.Nome).HasMaxLength(Usuario.NomeMaxLength);
        });

        modelBuilder.Entity<Perfil>(b =>
        {
            b.ToTable("perfis");
            b.HasData(Perfil.Padrao);
        });

        modelBuilder.Entity<IdentityUserRole<Guid>>().ToTable("usuario_perfis");
        modelBuilder.Entity<IdentityUserClaim<Guid>>().ToTable("usuario_claims");
        modelBuilder.Entity<IdentityUserLogin<Guid>>().ToTable("usuario_logins");
        modelBuilder.Entity<IdentityUserToken<Guid>>().ToTable("usuario_tokens");
        modelBuilder.Entity<IdentityRoleClaim<Guid>>().ToTable("perfil_claims");
    }
}
