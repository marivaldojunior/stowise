using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
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
        builder.Property(i => i.SeparadorDecimal).HasMaxLength(1);
        builder.Property(i => i.Colunas).HasJsonConversion();
        builder.Property(i => i.Amostra).HasJsonConversion();
        builder.Ignore(i => i.Layout);

        // O mesmo arquivo não entra duas vezes, a não ser que a importação anterior tenha falhado.
        builder.HasIndex(i => new { i.Tipo, i.HashArquivo })
            .IsUnique()
            .HasFilter("status <> 'Falhou'")
            .HasDatabaseName(ArquivoUnicoIndex);
        builder.HasIndex(i => i.IniciadoEm);

        builder.HasOne<Usuario>().WithMany().HasForeignKey(i => i.UsuarioId).OnDelete(DeleteBehavior.Restrict);
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

    public static PropertyBuilder<T> HasJsonConversion<T>(this PropertyBuilder<T> property)
        where T : class
    {
        var comparer = new ValueComparer<T>(
            (a, b) => Serialize(a) == Serialize(b),
            v => Serialize(v).GetHashCode(StringComparison.Ordinal),
            v => Deserialize<T>(Serialize(v)));

        return property
            .HasConversion(v => Serialize(v), v => Deserialize<T>(v), comparer)
            .HasColumnType("jsonb");
    }

    private static string Serialize<T>(T? value) => JsonSerializer.Serialize(value, Options);

    private static T Deserialize<T>(string json) =>
        JsonSerializer.Deserialize<T>(json, Options) ?? throw new InvalidOperationException("Null JSON column value.");
}
