using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Fornecedores;
using Stowise.Domain.NotasFiscais;
using Stowise.Domain.Recebimentos;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class RecebimentoConfiguration : IEntityTypeConfiguration<Recebimento>
{
    public void Configure(EntityTypeBuilder<Recebimento> builder)
    {
        builder.ToTable("recebimentos");
        builder.Property(r => r.ChaveAcesso).HasMaxLength(ChaveAcesso.Length).IsFixedLength();

        // A mesma nota não entra duas vezes (SPEC, seção 4).
        builder.HasIndex(r => r.ChaveAcesso).IsUnique();
        builder.HasIndex(r => new { r.Status, r.CriadoEm });
        builder.HasIndex(r => r.FornecedorId);

        builder.Property(r => r.Versao).IsRowVersion().HasColumnName("xmin");

        builder.HasOne<Fornecedor>().WithMany().HasForeignKey(r => r.FornecedorId).OnDelete(DeleteBehavior.Restrict);

        builder.HasMany(r => r.Itens).WithOne().HasForeignKey(i => i.RecebimentoId).OnDelete(DeleteBehavior.Cascade);
        builder.Navigation(r => r.Itens).HasField("_itens").UsePropertyAccessMode(PropertyAccessMode.Field);
        builder.Ignore(r => r.TemDivergencia);
    }
}

internal sealed class RecebimentoItemConfiguration : IEntityTypeConfiguration<RecebimentoItem>
{
    public void Configure(EntityTypeBuilder<RecebimentoItem> builder)
    {
        builder.ToTable("recebimento_itens");
        builder.Property(i => i.CodigoFornecedor).HasMaxLength(ProdutoFornecedor.CodigoFornecedorMaxLength);
        builder.Property(i => i.DescricaoNota).HasMaxLength(RecebimentoItem.DescricaoNotaMaxLength);
        builder.Property(i => i.UnidadeNota).HasMaxLength(RecebimentoItem.UnidadeNotaMaxLength);
        builder.Property(i => i.Cfop).HasMaxLength(RecebimentoItem.CfopLength).IsFixedLength();
        builder.Property(i => i.Lotes).HasJsonConversion();
        builder.Property(i => i.LotesConferidos).HasJsonConversion();
        builder.Ignore(i => i.Conferido);
        builder.HasIndex(i => new { i.RecebimentoId, i.NumeroItem }).IsUnique();
        builder.HasIndex(i => i.ProdutoId);

        builder.HasOne<Produto>().WithMany().HasForeignKey(i => i.ProdutoId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<ProdutoEmbalagem>().WithMany().HasForeignKey(i => i.EmbalagemId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<ProdutoFornecedor>().WithMany().HasForeignKey(i => i.ProdutoFornecedorId).OnDelete(DeleteBehavior.Restrict);
    }
}

internal sealed class XmlRecebimentoConfiguration : IEntityTypeConfiguration<XmlRecebimento>
{
    public void Configure(EntityTypeBuilder<XmlRecebimento> builder)
    {
        builder.ToTable("recebimento_xmls");
        builder.HasIndex(x => x.RecebimentoId).IsUnique();
        builder.HasOne<Recebimento>().WithOne().HasForeignKey<XmlRecebimento>(x => x.RecebimentoId).OnDelete(DeleteBehavior.Cascade);
    }
}
