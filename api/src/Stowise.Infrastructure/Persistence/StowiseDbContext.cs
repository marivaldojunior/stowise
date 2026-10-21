using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;
using Stowise.Domain.Fornecedores;
using Stowise.Domain.Ia;
using Stowise.Domain.Importacoes;
using Stowise.Domain.Recebimentos;
using Stowise.Domain.Rfid;
using Stowise.Infrastructure.Catalogo;
using Stowise.Infrastructure.Identity;
using Stowise.Infrastructure.Persistence.Configurations;
using Stowise.Infrastructure.Rfid;

namespace Stowise.Infrastructure.Persistence;

public sealed class StowiseDbContext(DbContextOptions<StowiseDbContext> options)
    : IdentityDbContext<Usuario, Perfil, Guid>(options)
{
    public DbSet<Armazem> Armazens => Set<Armazem>();

    public DbSet<Zona> Zonas => Set<Zona>();

    public DbSet<Endereco> Enderecos => Set<Endereco>();

    public DbSet<Categoria> Categorias => Set<Categoria>();

    public DbSet<Produto> Produtos => Set<Produto>();

    public DbSet<ProdutoEmbalagem> ProdutoEmbalagens => Set<ProdutoEmbalagem>();

    public DbSet<Fornecedor> Fornecedores => Set<Fornecedor>();

    internal DbSet<ProdutoEmbedding> ProdutoEmbeddings => Set<ProdutoEmbedding>();

    public DbSet<ProdutoFornecedor> ProdutoFornecedores => Set<ProdutoFornecedor>();

    public DbSet<Recebimento> Recebimentos => Set<Recebimento>();

    public DbSet<XmlRecebimento> XmlsRecebimento => Set<XmlRecebimento>();

    public DbSet<Lote> Lotes => Set<Lote>();

    public DbSet<Movimentacao> Movimentacoes => Set<Movimentacao>();

    public DbSet<Saldo> Saldos => Set<Saldo>();

    public DbSet<Reserva> Reservas => Set<Reserva>();

    public DbSet<Importacao> Importacoes => Set<Importacao>();

    public DbSet<ArquivoImportacao> ArquivosImportacao => Set<ArquivoImportacao>();

    public DbSet<TemplateImportacao> TemplatesImportacao => Set<TemplateImportacao>();

    public DbSet<ImportacaoLinha> ImportacaoLinhas => Set<ImportacaoLinha>();

    public DbSet<ChamadaIa> ChamadasIa => Set<ChamadaIa>();

    public DbSet<CotaIa> CotasIa => Set<CotaIa>();

    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.HasPostgresExtension("vector");
        builder.HasPostgresExtension("pg_trgm");

        // ADR-0010: séries únicas dos EPCs SGTIN-96 gerados (38 bits).
        builder.HasSequence<long>(RfidService.SerialSequence).StartsAt(1).HasMax(Sgtin96.SerieMaxima);
        IdentityConfiguration.Configure(builder);
        builder.ApplyConfigurationsFromAssembly(typeof(StowiseDbContext).Assembly);

        // O domínio gera os ids (Guid v7) ao criar a entidade. Sem isto, o EF trata uma entidade nova encontrada
        // numa coleção (ex.: Produto.AddEmbalagem) como já existente e faz UPDATE em vez de INSERT.
        foreach (var entity in builder.Model.GetEntityTypes().Where(e => typeof(Entity).IsAssignableFrom(e.ClrType)))
        {
            builder.Entity(entity.ClrType).Property(nameof(Entity.Id)).ValueGeneratedNever();
        }
    }

    protected override void ConfigureConventions(ModelConfigurationBuilder configurationBuilder)
    {
        // Enums gravados como texto: legíveis no banco e estáveis se a ordem dos membros mudar.
        configurationBuilder.Properties<Enum>().HaveConversion<string>().HaveMaxLength(30);

        // SPEC, decisão 2: quantidades e medidas em decimal(18,4).
        configurationBuilder.Properties<decimal>().HavePrecision(18, 4);
    }
}
