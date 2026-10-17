using Stowise.Application.Estrutura;
using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Estrutura;

public class GeradorEnderecosTests
{
    private static readonly Zona Zona = Armazem.Create("CD01", "Centro").AddZona("SECO", ClasseArmazenagem.Normal);

    private static PlanoGeracaoEnderecos Plano(
        string[]? ruas = null,
        Faixa? modulos = null,
        Faixa? niveis = null,
        Faixa? posicoes = null,
        decimal distanciaBase = 5m,
        decimal distanciaPorModulo = 2.5m) =>
        new(ruas ?? ["A", "B"], modulos ?? new Faixa(1, 3), niveis ?? new Faixa(1, 2), posicoes ?? new Faixa(1, 1), 1000m, 150m, 120m, 100m, distanciaBase, distanciaPorModulo);

    [Fact]
    public void Generates_every_combination_in_rua_modulo_nivel_posicao_order()
    {
        var enderecos = GeradorEnderecos.Gerar(Zona, Plano());

        Assert.Equal(12, enderecos.Count);
        Assert.Equal(
            ["A-01-01-1", "A-01-02-1", "A-02-01-1", "A-02-02-1", "A-03-01-1", "A-03-02-1"],
            enderecos.Take(6).Select(e => e.Codigo));
        Assert.Equal("B-03-02-1", enderecos[^1].Codigo);
        Assert.All(enderecos, e => Assert.Equal(Zona.Id, e.ZonaId));
    }

    [Fact]
    public void Distance_grows_by_module_from_the_base()
    {
        var enderecos = GeradorEnderecos.Gerar(Zona, Plano(modulos: new Faixa(4, 6)));

        Assert.Equal(5m, enderecos.First(e => e.Modulo == 4).DistanciaExpedicao);
        Assert.Equal(7.5m, enderecos.First(e => e.Modulo == 5).DistanciaExpedicao);
        Assert.Equal(10m, enderecos.First(e => e.Modulo == 6).DistanciaExpedicao);
    }

    [Fact]
    public void Positions_multiply_the_lot()
    {
        var plano = Plano(ruas: ["A"], modulos: new Faixa(1, 1), niveis: new Faixa(1, 1), posicoes: new Faixa(1, 3));

        Assert.Equal(["A-01-01-1", "A-01-01-2", "A-01-01-3"], GeradorEnderecos.Gerar(Zona, plano).Select(e => e.Codigo));
        Assert.Equal(3, plano.Total);
    }

    [Fact]
    public void Rejects_inverted_range_empty_ruas_and_lots_above_the_limit()
    {
        Assert.Throws<DomainException>(() => GeradorEnderecos.Gerar(Zona, Plano(modulos: new Faixa(5, 1))));
        Assert.Throws<DomainException>(() => GeradorEnderecos.Gerar(Zona, Plano(ruas: [])));
        Assert.Throws<DomainException>(() => GeradorEnderecos.Gerar(Zona, Plano(
            ruas: ["A", "B", "C", "D", "E", "F"], modulos: new Faixa(1, 99), niveis: new Faixa(1, 9), posicoes: new Faixa(1, 2))));
    }

    [Fact]
    public void Validation_reports_ranges_and_limit_per_field()
    {
        var invertida = new GerarEnderecos(Guid.NewGuid(), ["A", "a"], 5, 1, 1, 100, null, 1, 1m, 1m, 1m, 1m, -1m, null);
        Assert.Equal(
            ["distanciaBase", "moduloFinal", "nivelFinal", "posicaoInicial", "ruas"],
            EstruturaValidation.Validate(invertida).Keys.Order(StringComparer.Ordinal));

        var grande = new GerarEnderecos(Guid.NewGuid(), ["A", "B", "C", "D", "E", "F"], 1, 99, 1, 9, 1, 2, 1m, 1m, 1m, 1m, 0m, 0m);
        Assert.Equal(["lote"], EstruturaValidation.Validate(grande).Keys);

        var valida = new GerarEnderecos(Guid.NewGuid(), ["A"], 1, 10, 1, 5, 1, 1, 1000m, 150m, 120m, 100m, null, null);
        Assert.Empty(EstruturaValidation.Validate(valida));
        Assert.Equal(50, EstruturaValidation.ToPlano(valida).Total);
    }
}
