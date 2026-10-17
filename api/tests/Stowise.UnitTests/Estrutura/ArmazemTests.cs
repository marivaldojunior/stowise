using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Estrutura;

public class ArmazemTests
{
    [Fact]
    public void Create_normalizes_codigo_and_trims_nome()
    {
        var armazem = Armazem.Create(" cd01 ", "  Centro de Distribuição  ");

        Assert.Equal("CD01", armazem.Codigo);
        Assert.Equal("Centro de Distribuição", armazem.Nome);
        Assert.NotEqual(Guid.Empty, armazem.Id);
    }

    [Theory]
    [InlineData("", "Nome")]
    [InlineData("CD01", " ")]
    [InlineData("CODIGO-MUITO-LONGO-DEMAIS", "Nome")]
    public void Create_rejects_invalid_values(string codigo, string nome)
    {
        Assert.Throws<DomainException>(() => Armazem.Create(codigo, nome));
    }

    [Fact]
    public void AddZona_links_zona_to_armazem()
    {
        var armazem = Armazem.Create("CD01", "Centro");

        var zona = armazem.AddZona("frio", ClasseArmazenagem.Refrigerado);

        Assert.Equal(armazem.Id, zona.ArmazemId);
        Assert.Equal("FRIO", zona.Codigo);
        Assert.Equal(ClasseArmazenagem.Refrigerado, zona.ClasseArmazenagem);
        Assert.Single(armazem.Zonas);
    }

    [Fact]
    public void AddZona_rejects_duplicated_codigo()
    {
        var armazem = Armazem.Create("CD01", "Centro");
        armazem.AddZona("SECO", ClasseArmazenagem.Normal);

        var ex = Assert.Throws<DomainException>(() => armazem.AddZona("seco", ClasseArmazenagem.Fragil));
        Assert.Contains("SECO", ex.Message, StringComparison.Ordinal);
    }
}
