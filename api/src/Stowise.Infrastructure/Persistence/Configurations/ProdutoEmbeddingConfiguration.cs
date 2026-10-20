using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Catalogo;
using Stowise.Infrastructure.Catalogo;
using Stowise.Infrastructure.Ia;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class ProdutoEmbeddingConfiguration : IEntityTypeConfiguration<ProdutoEmbedding>
{
    public void Configure(EntityTypeBuilder<ProdutoEmbedding> builder)
    {
        builder.ToTable("produto_embeddings");
        builder.HasKey(e => e.ProdutoId);
        builder.Property(e => e.Vetor).HasColumnType($"vector({EmbeddingsIaOptions.Dimensoes})");
        builder.Property(e => e.Modelo).HasMaxLength(140);
        builder.Property(e => e.Texto).HasMaxLength(Produto.DescricaoMaxLength);

        // Busca de similares por distância de cosseno (ADR-0011).
        builder.HasIndex(e => e.Vetor).HasMethod("hnsw").HasOperators("vector_cosine_ops");

        builder.HasOne<Produto>().WithOne().HasForeignKey<ProdutoEmbedding>(e => e.ProdutoId).OnDelete(DeleteBehavior.Cascade);
    }
}
