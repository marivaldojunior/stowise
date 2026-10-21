using Stowise.Domain.Armazenagem;
using Stowise.Domain.Catalogo;

namespace Stowise.UnitTests.Armazenagem;

public class CurvaAbcTests
{
    [Fact]
    public void Products_are_split_by_the_cumulative_share_of_the_turnover()
    {
        // Giros 50, 25, 10, 8, 4, 3 (total 100). Acumulado antes de cada um: 0, 50, 75, 85, 93, 97.
        var ids = Enumerable.Range(0, 7).Select(_ => Guid.NewGuid()).ToList();
        var giro = new Dictionary<Guid, decimal>
        {
            [ids[0]] = 50,
            [ids[1]] = 25,
            [ids[2]] = 10,
            [ids[3]] = 8,
            [ids[4]] = 4,
            [ids[5]] = 3,
        };

        var classes = CurvaAbc.Classificar(giro, ids);

        Assert.Equal(
            [ClasseAbc.A, ClasseAbc.A, ClasseAbc.A, ClasseAbc.B, ClasseAbc.B, ClasseAbc.C, ClasseAbc.C],
            ids.Select(id => classes[id]));
    }

    [Fact]
    public void A_single_dominant_product_is_A()
    {
        var dominante = Guid.NewGuid();
        var outro = Guid.NewGuid();

        var classes = CurvaAbc.Classificar(new Dictionary<Guid, decimal> { [dominante] = 99, [outro] = 1 }, [dominante, outro]);

        Assert.Equal(ClasseAbc.A, classes[dominante]);
        Assert.Equal(ClasseAbc.C, classes[outro]);
    }

    [Fact]
    public void Without_turnover_everything_is_C_and_unknown_products_are_ignored()
    {
        var produto = Guid.NewGuid();

        var classes = CurvaAbc.Classificar(new Dictionary<Guid, decimal> { [Guid.NewGuid()] = 10 }, [produto]);

        Assert.Equal(ClasseAbc.C, Assert.Single(classes).Value);
    }

    [Fact]
    public void Ties_are_stable_and_limits_are_validated()
    {
        var a = new Guid("00000000-0000-0000-0000-000000000001");
        var b = new Guid("00000000-0000-0000-0000-000000000002");
        var giro = new Dictionary<Guid, decimal> { [b] = 10, [a] = 10 };

        var classes = CurvaAbc.Classificar(giro, [a, b], limiteA: 50, limiteB: 50);

        Assert.Equal(ClasseAbc.A, classes[a]);
        Assert.Equal(ClasseAbc.C, classes[b]);
        Assert.Throws<ArgumentException>(() => CurvaAbc.Classificar(giro, [a], limiteA: 90, limiteB: 80));
    }
}
