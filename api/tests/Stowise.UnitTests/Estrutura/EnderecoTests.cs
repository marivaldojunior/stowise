using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Estrutura;

public class EnderecoTests
{
    private static readonly Armazem Armazem = Armazem.Create("CD01", "Centro");
    private static readonly Zona Zona = Armazem.AddZona("SECO", ClasseArmazenagem.Normal);

    private static DimensoesEndereco Dimensoes(decimal capacidade = 1000m, decimal altura = 150m, decimal distancia = 12m) =>
        new(capacidade, altura, 120m, 100m, distancia);

    private static Endereco Create(string rua = "A", int modulo = 3, int nivel = 2, int posicao = 1, DimensoesEndereco? dimensoes = null) =>
        Endereco.Create(Zona, rua, modulo, nivel, posicao, dimensoes ?? Dimensoes());

    [Fact]
    public void Create_formats_codigo_and_takes_armazem_and_zona_from_the_zone()
    {
        var endereco = Create(rua: "a", modulo: 3, nivel: 2, posicao: 1);

        Assert.Equal("A-03-02-1", endereco.Codigo);
        Assert.Equal("A", endereco.Rua);
        Assert.Equal(Zona.Id, endereco.ZonaId);
        Assert.Equal(Armazem.Id, endereco.ArmazemId);
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
        Assert.Throws<DomainException>(() => Create(dimensoes: Dimensoes(capacidade: 0m)));
        Assert.Throws<DomainException>(() => Create(dimensoes: Dimensoes(altura: -1m)));
    }

    [Fact]
    public void Create_rejects_negative_distance_but_accepts_zero()
    {
        Assert.Throws<DomainException>(() => Create(dimensoes: Dimensoes(distancia: -0.5m)));
        Assert.Equal(0m, Create(dimensoes: Dimensoes(distancia: 0m)).DistanciaExpedicao);
    }

    [Fact]
    public void UpdateDimensoes_changes_measures_and_keeps_codigo()
    {
        var endereco = Create();

        endereco.UpdateDimensoes(new DimensoesEndereco(800m, 200m, 100m, 90m, 30m));

        Assert.Equal(800m, endereco.CapacidadePesoKg);
        Assert.Equal(30m, endereco.DistanciaExpedicao);
        Assert.Equal("A-03-02-1", endereco.Codigo);
    }

    [Theory]
    [InlineData("A", true)]
    [InlineData("aa", true)]
    [InlineData("ABC", true)]
    [InlineData("ABCD", false)]
    [InlineData("A1", false)]
    [InlineData(" ", false)]
    public void IsValidRua_accepts_one_to_three_letters(string rua, bool valid)
    {
        Assert.Equal(valid, Endereco.IsValidRua(rua));
    }
}
