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
        db.Enderecos.AddRange(CreateEnderecos(seco, "A", modulos: 3, niveis: 3));
        db.Enderecos.AddRange(CreateEnderecos(frio, "R", modulos: 2, niveis: 2));

        await db.SaveChangesAsync(cancellationToken);
        return true;
    }

    private static IEnumerable<Endereco> CreateEnderecos(Zona zona, string rua, int modulos, int niveis)
    {
        for (var modulo = 1; modulo <= modulos; modulo++)
        {
            for (var nivel = 1; nivel <= niveis; nivel++)
            {
                yield return Endereco.Create(
                    zona.Id,
                    rua,
                    modulo,
                    nivel,
                    posicao: 1,
                    capacidadePesoKg: 1000m,
                    alturaCm: 150m,
                    larguraCm: 120m,
                    profundidadeCm: 100m,
                    distanciaExpedicao: modulo * 4m);
            }
        }
    }
}
