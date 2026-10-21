using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Armazenagem;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;
using Stowise.Domain.Recebimentos;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class TarefaArmazenagemConfiguration : IEntityTypeConfiguration<TarefaArmazenagem>
{
    public void Configure(EntityTypeBuilder<TarefaArmazenagem> builder)
    {
        builder.ToTable("tarefas_armazenagem");
        builder.Property(t => t.LoteNumero).HasMaxLength(RecebimentoItem.LoteNumeroMaxLength);
        builder.Property(t => t.MotivoDivergencia).HasMaxLength(TarefaArmazenagem.MotivoDivergenciaMaxLength);
        builder.Property(t => t.RegrasVersao).HasMaxLength(TarefaArmazenagem.RegrasVersaoLength).IsFixedLength();
        builder.Property(t => t.Notas).HasJsonConversion();
        builder.Property(t => t.Versao).IsRowVersion().HasColumnName("xmin");

        // Fila do operador e tela de divergências (SPEC, 2.4 e 2.5).
        builder.HasIndex(t => new { t.Status, t.CriadoEm });
        builder.HasIndex(t => t.RecebimentoId);
        builder.HasIndex(t => t.RecebimentoItemId);

        builder.HasOne<Recebimento>().WithMany().HasForeignKey(t => t.RecebimentoId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<RecebimentoItem>().WithMany().HasForeignKey(t => t.RecebimentoItemId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Produto>().WithMany().HasForeignKey(t => t.ProdutoId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Movimentacao>().WithMany().HasForeignKey(t => t.MovimentacaoId).OnDelete(DeleteBehavior.Restrict);

        // A exclusão de endereço não conhece as tarefas; a entrada no estoque já guarda o endereço da confirmação.
        builder.HasOne<Endereco>().WithMany().HasForeignKey(t => t.EnderecoSugeridoId).OnDelete(DeleteBehavior.SetNull);
        builder.HasOne<Endereco>().WithMany().HasForeignKey(t => t.EnderecoConfirmadoId).OnDelete(DeleteBehavior.SetNull);
    }
}
