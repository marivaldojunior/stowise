using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Catalogo;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class CategoriaConfiguration : IEntityTypeConfiguration<Categoria>
{
    public void Configure(EntityTypeBuilder<Categoria> builder)
    {
        builder.ToTable("categorias");
        builder.Property(c => c.Nome).HasMaxLength(Categoria.NomeMaxLength);

        // Nome único entre irmãs; NULLS NOT DISTINCT também vale para as categorias raiz.
        builder.HasIndex(c => new { c.ParentId, c.Nome }).IsUnique().AreNullsDistinct(false);

        builder.HasOne<Categoria>()
            .WithMany()
            .HasForeignKey(c => c.ParentId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}

internal sealed class ProdutoConfiguration : IEntityTypeConfiguration<Produto>
{
    public void Configure(EntityTypeBuilder<Produto> builder)
    {
        builder.ToTable("produtos");
        builder.Property(p => p.Sku).HasMaxLength(Produto.SkuMaxLength);
        builder.Property(p => p.Descricao).HasMaxLength(Produto.DescricaoMaxLength);
        builder.Property(p => p.UnidadeBase).HasMaxLength(Produto.UnidadeBaseMaxLength);
        builder.Property(p => p.Ncm).HasMaxLength(CodigosFiscais.NcmLength);
        builder.Property(p => p.Cest).HasMaxLength(CodigosFiscais.CestLength);
        builder.HasIndex(p => p.Sku).IsUnique();
        builder.HasIndex(p => p.CategoriaId);

        // Fila de cadastros incompletos (SPEC, 2.1).
        builder.HasIndex(p => new { p.StatusCadastro, p.Ativo });

        // Concorrência otimista pela coluna de sistema xmin (SPEC, decisão 4). Nome explícito por causa do snake_case.
        builder.Property(p => p.Versao).IsRowVersion().HasColumnName("xmin");

        builder.HasOne<Categoria>()
            .WithMany()
            .HasForeignKey(p => p.CategoriaId)
            .OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(p => p.Embalagens)
            .WithOne()
            .HasForeignKey(e => e.ProdutoId)
            .OnDelete(DeleteBehavior.Cascade);
        builder.Navigation(p => p.Embalagens).HasField("_embalagens").UsePropertyAccessMode(PropertyAccessMode.Field);

        builder.Ignore(p => p.EmbalagemBase);
    }
}

internal sealed class ProdutoEmbalagemConfiguration : IEntityTypeConfiguration<ProdutoEmbalagem>
{
    public void Configure(EntityTypeBuilder<ProdutoEmbalagem> builder)
    {
        builder.ToTable("produto_embalagens");
        builder.Property(e => e.Gtin).HasMaxLength(14);
        builder.HasIndex(e => e.Gtin).IsUnique();
        builder.HasIndex(e => new { e.ProdutoId, e.Tipo, e.FatorConversao }).IsUnique();
        builder.Ignore(e => e.TemMedidasCompletas);
        builder.Ignore(e => e.MedidasFaltando);
    }
}
