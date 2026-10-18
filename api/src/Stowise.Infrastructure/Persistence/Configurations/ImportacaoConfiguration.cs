using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Identity;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class ImportacaoConfiguration : IEntityTypeConfiguration<Importacao>
{
    public const string ArquivoUnicoIndex = "ix_importacoes_tipo_hash_arquivo";

    public void Configure(EntityTypeBuilder<Importacao> builder)
    {
        builder.ToTable("importacoes");
        builder.Property(i => i.NomeArquivo).HasMaxLength(Importacao.NomeArquivoMaxLength);
        builder.Property(i => i.HashArquivo).HasMaxLength(Importacao.HashArquivoLength).IsFixedLength();
        builder.Property(i => i.Encoding).HasMaxLength(30);
        builder.Property(i => i.Delimitador).HasMaxLength(1);
        builder.Property(i => i.Planilha).HasMaxLength(Importacao.PlanilhaMaxLength);
        builder.Property(i => i.SeparadorDecimal).HasMaxLength(1);
        builder.Property(i => i.Colunas).HasJsonConversion();
        builder.Property(i => i.Amostra).HasJsonConversion();
        builder.Property(i => i.Mapeamento).HasJsonConversion();
        builder.Property(i => i.Fingerprint).HasMaxLength(FingerprintLayout.Length).IsFixedLength();
        builder.Property(i => i.Versao).IsRowVersion().HasColumnName("xmin");
        builder.Property(i => i.MotivoFalha).HasMaxLength(Importacao.MotivoFalhaMaxLength);
        builder.Ignore(i => i.Layout);

        // O mesmo arquivo não entra duas vezes, a não ser que a importação anterior tenha falhado.
        builder.HasIndex(i => new { i.Tipo, i.HashArquivo })
            .IsUnique()
            .HasFilter("status <> 'Falhou'")
            .HasDatabaseName(ArquivoUnicoIndex);
        builder.HasIndex(i => i.IniciadoEm);

        builder.HasOne<Usuario>().WithMany().HasForeignKey(i => i.UsuarioId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<Usuario>().WithMany().HasForeignKey(i => i.MapeamentoConfirmadoPor).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne<TemplateImportacao>().WithMany().HasForeignKey(i => i.TemplateId).OnDelete(DeleteBehavior.SetNull);
    }
}

internal sealed class ImportacaoLinhaConfiguration : IEntityTypeConfiguration<ImportacaoLinha>
{
    public void Configure(EntityTypeBuilder<ImportacaoLinha> builder)
    {
        builder.ToTable("importacao_linhas");
        builder.Property(l => l.DadosBrutos).HasJsonConversion();
        builder.Property(l => l.DadosNormalizados).HasJsonConversion();
        builder.Property(l => l.Erros).HasJsonConversion();

        builder.HasIndex(l => new { l.ImportacaoId, l.NumeroLinha }).IsUnique();
        builder.HasIndex(l => new { l.ImportacaoId, l.Status });
        builder.HasOne<Importacao>().WithMany().HasForeignKey(l => l.ImportacaoId).OnDelete(DeleteBehavior.Cascade);
        builder.HasOne<Produto>().WithMany().HasForeignKey(l => l.ProdutoCorrespondenteId).OnDelete(DeleteBehavior.SetNull);
    }
}

internal sealed class TemplateImportacaoConfiguration : IEntityTypeConfiguration<TemplateImportacao>
{
    public const string FingerprintUnicoIndex = "ix_importacao_templates_tipo_fingerprint";

    public void Configure(EntityTypeBuilder<TemplateImportacao> builder)
    {
        builder.ToTable("importacao_templates");
        builder.Property(t => t.Nome).HasMaxLength(TemplateImportacao.NomeMaxLength);
        builder.Property(t => t.Fingerprint).HasMaxLength(FingerprintLayout.Length).IsFixedLength();
        builder.Property(t => t.Encoding).HasMaxLength(30);
        builder.Property(t => t.Delimitador).HasMaxLength(1);
        builder.Property(t => t.SeparadorDecimal).HasMaxLength(1);
        builder.Property(t => t.Mapeamento).HasJsonConversion();
        builder.Property(t => t.Versao).IsRowVersion().HasColumnName("xmin");

        builder.HasIndex(t => new { t.Tipo, t.Fingerprint }).IsUnique().HasDatabaseName(FingerprintUnicoIndex);
        builder.HasOne<Usuario>().WithMany().HasForeignKey(t => t.ConfirmadoPor).OnDelete(DeleteBehavior.Restrict);
    }
}

internal sealed class ArquivoImportacaoConfiguration : IEntityTypeConfiguration<ArquivoImportacao>
{
    public void Configure(EntityTypeBuilder<ArquivoImportacao> builder)
    {
        builder.ToTable("importacao_arquivos");
        builder.HasOne<Importacao>().WithOne().HasForeignKey<ArquivoImportacao>(a => a.ImportacaoId).OnDelete(DeleteBehavior.Cascade);
    }
}

/// <summary>Valores imutáveis gravados como <c>jsonb</c>; a comparação usa o JSON, para o EF detectar mudanças.</summary>
internal static class JsonColumn
{
    private static readonly JsonSerializerOptions Options = new(JsonSerializerDefaults.Web);

    /// <remarks>Aceita propriedades anuláveis: o EF não passa nulo para o conversor e grava NULL direto.</remarks>
    public static PropertyBuilder<T> HasJsonConversion<T>(this PropertyBuilder<T> property)
        where T : class?
    {
        var comparer = new ValueComparer<T>(
            (a, b) => Serialize(a) == Serialize(b),
            v => Serialize(v).GetHashCode(StringComparison.Ordinal),
            v => Deserialize<T>(Serialize(v)));

        return property
            .HasConversion(v => Serialize(v), v => Deserialize<T>(v), comparer)
            .HasColumnType("jsonb");
    }

    /// <summary>O mesmo JSON das colunas, para quem grava sem o EF (COPY em lote).</summary>
    public static string Serialize<T>(T? value) => JsonSerializer.Serialize(value, Options);

    private static T Deserialize<T>(string json) =>
        JsonSerializer.Deserialize<T>(json, Options) ?? throw new InvalidOperationException("Null JSON column value.");
}
