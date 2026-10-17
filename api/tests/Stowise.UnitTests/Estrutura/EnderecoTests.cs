using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Estrutura;

public class EnderecoTests
{
    private static readonly Guid ZonaId = Guid.CreateVersion7();

    private static Endereco Create(
        string rua = "A",
        int modulo = 3,
        int nivel = 2,
        int posicao = 1,
        decimal capacidade = 1000m,
        decimal altura = 150m,
        decimal distancia = 12m) =>
        Endereco.Create(ZonaId, rua, modulo, nivel, posicao, capacidade, altura, 120m, 100m, distancia);

    [Fact]
    public void Create_formats_codigo_as_rua_modulo_nivel_posicao()
    {
        var endereco = Create(rua: "a", modulo: 3, nivel: 2, posicao: 1);

        Assert.Equal("A-03-02-1", endereco.Codigo);
        Assert.Equal("A", endereco.Rua);
        Assert.Equal(StatusEndereco.Livre, endereco.Status);
        Assert.Null(endereco.MotivoBloqueio);
    }

    [Theory]
    [InlineData("")]
    [InlineData("A1")]
    [InlineData("ABCD")]
    public void Create_rejects_invalid_rua(string rua)
    {
        Assert.Throws<DomainException>(() => Create(rua: rua));
    }

    [Theory]
    [InlineData(0, 1, 1)]
    [InlineData(100, 1, 1)]
    [InlineData(1, 0, 1)]
    [InlineData(1, 100, 1)]
    [InlineData(1, 1, 0)]
    [InlineData(1, 1, 10)]
    public void Create_rejects_out_of_range_coordinates(int modulo, int nivel, int posicao)
    {
        Assert.Throws<DomainException>(() => Create(modulo: modulo, nivel: nivel, posicao: posicao));
    }

    [Fact]
    public void Create_rejects_non_positive_capacity_and_dimensions()
    {
        Assert.Throws<DomainException>(() => Create(capacidade: 0m));
        Assert.Throws<DomainException>(() => Create(altura: -1m));
    }

    [Fact]
    public void Create_rejects_negative_distance_but_accepts_zero()
    {
        Assert.Throws<DomainException>(() => Create(distancia: -0.5m));
        Assert.Equal(0m, Create(distancia: 0m).DistanciaExpedicao);
    }

    [Fact]
    public void Create_requires_zona()
    {
        Assert.Throws<DomainException>(() =>
            Endereco.Create(Guid.Empty, "A", 1, 1, 1, 1000m, 150m, 120m, 100m, 0m));
    }
}
