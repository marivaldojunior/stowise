using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Fornecedores;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class FornecedorConfiguration : IEntityTypeConfiguration<Fornecedor>
{
    public void Configure(EntityTypeBuilder<Fornecedor> builder)
    {
        builder.ToTable("fornecedores");
        builder.Property(f => f.Cnpj).HasMaxLength(Cnpj.Length);
        builder.Property(f => f.RazaoSocial).HasMaxLength(Fornecedor.RazaoSocialMaxLength);
        builder.Property(f => f.NomeFantasia).HasMaxLength(Fornecedor.NomeFantasiaMaxLength);
        builder.HasIndex(f => f.Cnpj).IsUnique();

        // Concorrência otimista pela coluna de sistema xmin (SPEC, decisão 4).
        builder.Property(f => f.Versao).IsRowVersion().HasColumnName("xmin");
    }
}

internal sealed class ProdutoFornecedorConfiguration : IEntityTypeConfiguration<ProdutoFornecedor>
{
    public void Configure(EntityTypeBuilder<ProdutoFornecedor> builder)
    {
        builder.ToTable("produto_fornecedores");
        builder.Property(v => v.CodigoFornecedor).HasMaxLength(ProdutoFornecedor.CodigoFornecedorMaxLength);
        builder.Property(v => v.UnidadeFornecedor).HasMaxLength(ProdutoFornecedor.UnidadeFornecedorMaxLength);

        // Um código do fornecedor aponta para um só produto (o cProd da NF-e).
        builder.HasIndex(v => new { v.FornecedorId, v.CodigoFornecedor }).IsUnique();
        builder.HasIndex(v => v.ProdutoId);

        builder.Property(v => v.Versao).IsRowVersion().HasColumnName("xmin");

        // Restrict: o fornecedor, o produto e a embalagem não somem enquanto houver vínculo.
        builder.HasOne<Fornecedor>().WithMany().HasForeignKey(v => v.FornecedorId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Produto>().WithMany().HasForeignKey(v => v.ProdutoId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<ProdutoEmbalagem>().WithMany().HasForeignKey(v => v.EmbalagemId).OnDelete(DeleteBehavior.Restrict);
    }
}
