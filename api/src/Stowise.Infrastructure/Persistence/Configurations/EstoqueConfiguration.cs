using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;
using Stowise.Infrastructure.Identity;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class LoteConfiguration : IEntityTypeConfiguration<Lote>
{
    public void Configure(EntityTypeBuilder<Lote> builder)
    {
        builder.ToTable("lotes");
        builder.Property(l => l.Numero).HasMaxLength(Lote.NumeroMaxLength);
        builder.HasIndex(l => new { l.ProdutoId, l.Numero }).IsUnique();
        builder.HasOne<Produto>().WithMany().HasForeignKey(l => l.ProdutoId).OnDelete(DeleteBehavior.Restrict);
    }
}

internal sealed class SaldoConfiguration : IEntityTypeConfiguration<Saldo>
{
    public void Configure(EntityTypeBuilder<Saldo> builder)
    {
        builder.ToTable("saldos");

        // Um saldo por endereço + produto + lote; NULLS NOT DISTINCT cobre os produtos sem lote.
        builder.HasIndex(s => new { s.EnderecoId, s.ProdutoId, s.LoteId }).IsUnique().AreNullsDistinct(false);
        builder.HasIndex(s => s.ProdutoId);
        builder.Ignore(s => s.QuantidadeDisponivel);
        builder.ToTable(t => t.HasCheckConstraint("ck_saldos_quantidades", "quantidade >= 0 AND quantidade_reservada >= 0 AND quantidade_reservada <= quantidade"));

        builder.HasOne<Endereco>().WithMany().HasForeignKey(s => s.EnderecoId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Produto>().WithMany().HasForeignKey(s => s.ProdutoId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Lote>().WithMany().HasForeignKey(s => s.LoteId).OnDelete(DeleteBehavior.Restrict);
    }
}

internal sealed class MovimentacaoConfiguration : IEntityTypeConfiguration<Movimentacao>
{
    public void Configure(EntityTypeBuilder<Movimentacao> builder)
    {
        builder.ToTable("movimentacoes");
        builder.Property(m => m.DocumentoReferencia).HasMaxLength(Movimentacao.DocumentoReferenciaMaxLength);
        builder.Property(m => m.Observacao).HasMaxLength(Movimentacao.ObservacaoMaxLength);
        builder.ToTable(t => t.HasCheckConstraint("ck_movimentacoes_quantidade", "quantidade > 0"));

        builder.HasIndex(m => new { m.ProdutoId, m.OcorridoEm });
        builder.HasIndex(m => m.EnderecoOrigemId);
        builder.HasIndex(m => m.EnderecoDestinoId);
        builder.HasIndex(m => m.LoteId);

        builder.HasOne<Produto>().WithMany().HasForeignKey(m => m.ProdutoId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Lote>().WithMany().HasForeignKey(m => m.LoteId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Endereco>().WithMany().HasForeignKey(m => m.EnderecoOrigemId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Endereco>().WithMany().HasForeignKey(m => m.EnderecoDestinoId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Usuario>().WithMany().HasForeignKey(m => m.UsuarioId).OnDelete(DeleteBehavior.Restrict);
    }
}
