using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Stowise.Domain.Armazenagem;

namespace Stowise.Infrastructure.Persistence.Configurations;

internal sealed class RegraArmazenagemConfiguration : IEntityTypeConfiguration<RegraArmazenagem>
{
    public void Configure(EntityTypeBuilder<RegraArmazenagem> builder)
    {
        builder.ToTable("regras_armazenagem");
        builder.Property(r => r.Codigo).HasMaxLength(RegraArmazenagem.CodigoMaxLength);
        builder.HasIndex(r => r.Codigo).IsUnique();
        builder.Property(r => r.Parametros).HasJsonConversion();
        builder.Property(r => r.Versao).IsRowVersion().HasColumnName("xmin");

        // Pesos iniciais (decisão da tarefa, ajustáveis pela Gestão): a zona só restringe, então não pontua.
        builder.HasData(
            Regra("0199f0a0-0000-7000-8000-0000000a0001", CodigosRegra.Zona, 0m, new RegraZona()),
            Regra("0199f0a0-0000-7000-8000-0000000a0002", CodigosRegra.Capacidade, 1m, new RegraCapacidade()),
            Regra("0199f0a0-0000-7000-8000-0000000a0003", CodigosRegra.CurvaAbc, 3m, new RegraCurvaAbc()),
            Regra("0199f0a0-0000-7000-8000-0000000a0004", CodigosRegra.Fefo, 2m, new RegraFefo()),
            Regra("0199f0a0-0000-7000-8000-0000000a0005", CodigosRegra.Consolidacao, 2m, new RegraConsolidacao()));
    }

    private static object Regra(string id, string codigo, decimal peso, IRegraArmazenagem regra) => new
    {
        Id = Guid.Parse(id),
        Codigo = codigo,
        Peso = peso,
        Ativa = true,
        Parametros = new Dictionary<string, decimal>(regra.ParametrosPadrao),
    };
}
