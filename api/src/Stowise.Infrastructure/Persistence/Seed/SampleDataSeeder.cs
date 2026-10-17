using Microsoft.EntityFrameworkCore;
using Stowise.Domain.Estrutura;

namespace Stowise.Infrastructure.Persistence.Seed;

/// <summary>Armazém de exemplo para desenvolvimento e demonstração. Idempotente.</summary>
public static class SampleDataSeeder
{
    public const string CodigoArmazem = "CD01";

    /// <returns><c>true</c> se o armazém foi criado; <c>false</c> se ele já existia.</returns>
    public static async Task<bool> SeedAsync(StowiseDbContext db, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(db);

        if (await db.Armazens.AnyAsync(a => a.Codigo == CodigoArmazem, cancellationToken))
        {
            return false;
        }

        var armazem = Armazem.Create(CodigoArmazem, "Centro de Distribuição Exemplo");
        var seco = armazem.AddZona("SECO", ClasseArmazenagem.Normal);
        var frio = armazem.AddZona("FRIO", ClasseArmazenagem.Refrigerado);

        db.Armazens.Add(armazem);
        db.Enderecos.AddRange(GeradorEnderecos.Gerar(seco, Plano("A", modulos: 3, niveis: 3)));
        db.Enderecos.AddRange(GeradorEnderecos.Gerar(frio, Plano("R", modulos: 2, niveis: 2)));

        await db.SaveChangesAsync(cancellationToken);
        return true;
    }

    private static PlanoGeracaoEnderecos Plano(string rua, int modulos, int niveis) =>
        new(
            [rua],
            new Faixa(1, modulos),
            new Faixa(1, niveis),
            new Faixa(1, 1),
            CapacidadePesoKg: 1000m,
            AlturaCm: 150m,
            LarguraCm: 120m,
            ProfundidadeCm: 100m,
            DistanciaBase: 4m,
            DistanciaPorModulo: 4m);
}
