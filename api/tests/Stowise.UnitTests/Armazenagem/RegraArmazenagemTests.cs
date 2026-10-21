using Stowise.Domain.Armazenagem;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;

namespace Stowise.UnitTests.Armazenagem;

public class RegraArmazenagemTests
{
    private static readonly DateTimeOffset Agora = new(2026, 10, 21, 10, 0, 0, TimeSpan.FromHours(-3));
    private static readonly Guid Gestor = Guid.NewGuid();

    [Fact]
    public void New_rule_starts_active_with_the_default_parameters()
    {
        var regra = RegraArmazenagem.Create(new RegraConsolidacao(), 2m);

        Assert.True(regra.Ativa);
        Assert.Equal(70m, regra.Parametros[RegraConsolidacao.MesmoProduto]);
        Assert.Equal(new ConfiguracaoRegra("consolidacao", 2m, true, regra.Parametros), regra.ToConfiguracao());
    }

    [Fact]
    public void Update_changes_weight_state_and_parameters_and_records_who_changed()
    {
        var fefo = new RegraFefo();
        var regra = RegraArmazenagem.Create(fefo, 2m);

        regra.Update(fefo, 5m, false, new Dictionary<string, decimal> { [RegraFefo.ToleranciaDias] = 7m }, Gestor, Agora);

        Assert.Equal(5m, regra.Peso);
        Assert.False(regra.Ativa);
        Assert.Equal(7m, regra.Parametros[RegraFefo.ToleranciaDias]);
        Assert.Equal(Gestor, regra.AtualizadoPor);
        Assert.Equal(TimeSpan.Zero, regra.AtualizadoEm!.Value.Offset);
    }

    [Theory]
    [InlineData(-1)]
    [InlineData(101)]
    public void Weight_must_be_between_0_and_100(decimal peso)
    {
        var fefo = new RegraFefo();
        var regra = RegraArmazenagem.Create(fefo, 2m);

        Assert.Throws<DomainException>(() => regra.Update(fefo, peso, true, new Dictionary<string, decimal>(), Gestor, Agora));
    }

    [Fact]
    public void Unknown_or_negative_parameters_are_rejected()
    {
        var capacidade = new RegraCapacidade();
        var regra = RegraArmazenagem.Create(capacidade, 1m);

        var desconhecido = Assert.Throws<DomainException>(() =>
            regra.Update(capacidade, 1m, true, new Dictionary<string, decimal> { ["altura"] = 1m }, Gestor, Agora));
        Assert.Contains("altura", desconhecido.Message, StringComparison.Ordinal);
        Assert.Throws<DomainException>(() =>
            regra.Update(capacidade, 1m, true, new Dictionary<string, decimal> { [RegraCapacidade.OcupacaoMaxima] = -5m }, Gestor, Agora));
    }

    [Fact]
    public void Rule_strategy_must_match_the_configuration()
    {
        var regra = RegraArmazenagem.Create(new RegraFefo(), 2m);

        Assert.Throws<ArgumentException>(() => regra.Update(new RegraZona(), 1m, true, new Dictionary<string, decimal>(), Gestor, Agora));
    }

    [Fact]
    public void Unit_measures_come_from_the_largest_package_with_the_data()
    {
        var produto = Produto.Create(
            "COLA-2L",
            new DadosProduto("Refrigerante Cola 2L", "UN", Domain.Estrutura.ClasseArmazenagem.Normal, false, false, null, null, null),
            new DadosEmbalagem(null, 2.1m, null, null, null));
        produto.AddEmbalagem(TipoEmbalagem.Caixa, 12m, new DadosEmbalagem(null, 24m, 30m, 40m, 20m));

        var medidas = MedidasUnitarias.From(produto.Embalagens);

        Assert.Equal(2m, medidas.PesoKg);
        Assert.Equal(2_000m, medidas.VolumeCm3);
        Assert.Equal(240m, medidas.PesoDe(120m));
    }

    [Fact]
    public void Unit_measures_are_null_without_data()
    {
        var produto = Produto.Create(
            "COPO-200",
            new DadosProduto("Copo 200ml", "UN", Domain.Estrutura.ClasseArmazenagem.Normal, false, false, null, null, null),
            new DadosEmbalagem(null, null, null, null, null));

        var medidas = MedidasUnitarias.From(produto.Embalagens);

        Assert.Null(medidas.PesoDe(10m));
        Assert.Null(medidas.VolumeDe(10m));
        Assert.Equal(ClasseAbc.C, produto.ClasseAbc);
    }
}
