using Stowise.Domain.Armazenagem;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Armazenagem;

public class MotorArmazenagemTests
{
    private static readonly Guid Produto = Guid.NewGuid();
    private static readonly Guid Lote = Guid.NewGuid();
    private static readonly DateOnly Validade = new(2027, 4, 30);
    private static readonly IReadOnlyDictionary<string, decimal> SemParametros = new Dictionary<string, decimal>();

    private static readonly IReadOnlyList<ConfiguracaoRegra> Padrao =
    [
        new(CodigosRegra.Zona, 0m, true, SemParametros),
        new(CodigosRegra.Capacidade, 1m, true, SemParametros),
        new(CodigosRegra.CurvaAbc, 2m, true, SemParametros),
        new(CodigosRegra.Fefo, 2m, true, SemParametros),
        new(CodigosRegra.Consolidacao, 1m, true, SemParametros),
    ];

    [Fact]
    public void Wrong_zone_and_overweight_addresses_are_discarded_with_the_reasons()
    {
        var item = Item(pesoKg: 300m);
        var candidatos = new[]
        {
            Candidato("A-01-01-1", 10m),
            Candidato("F-01-01-1", 5m, classe: ClasseArmazenagem.Inflamavel),
            Candidato("A-02-01-1", 20m, capacidadeKg: 200m),
        };

        var resultado = MotorArmazenagem.Padrao().Sugerir(item, candidatos, Padrao);

        Assert.Equal("A-01-01-1", Assert.Single(resultado.Sugestoes).Codigo);
        Assert.Equal(2, resultado.Descartados.Count);
        Assert.Contains("inflamáveis", Assert.Single(resultado.Descartados, d => d.Codigo == "F-01-01-1").Motivos[0], StringComparison.Ordinal);
        Assert.Contains("Peso excede", Assert.Single(resultado.Descartados, d => d.Codigo == "A-02-01-1").Motivos[0], StringComparison.Ordinal);
    }

    [Fact]
    public void Restrictions_apply_even_when_the_rule_is_inactive()
    {
        var configuracao = Padrao.Select(c => c with { Ativa = false }).ToList();

        var resultado = MotorArmazenagem.Padrao().Sugerir(
            Item(),
            [Candidato("F-01-01-1", 5m, classe: ClasseArmazenagem.Inflamavel)],
            configuracao);

        Assert.Empty(resultado.Sugestoes);
        Assert.Single(resultado.Descartados);
    }

    [Fact]
    public void Class_A_goes_near_the_dispatch_and_class_C_goes_far()
    {
        var candidatos = new[] { Candidato("A-01-01-1", 5m), Candidato("A-05-01-1", 25m), Candidato("A-09-01-1", 45m) };
        var soCurva = new[] { new ConfiguracaoRegra(CodigosRegra.CurvaAbc, 1m, true, SemParametros) };

        var a = MotorArmazenagem.Padrao().Sugerir(Item(abc: ClasseAbc.A), candidatos, soCurva);
        var b = MotorArmazenagem.Padrao().Sugerir(Item(abc: ClasseAbc.B), candidatos, soCurva);
        var c = MotorArmazenagem.Padrao().Sugerir(Item(abc: ClasseAbc.C), candidatos, soCurva);

        Assert.Equal(["A-01-01-1", "A-05-01-1", "A-09-01-1"], a.Sugestoes.Select(s => s.Codigo));
        Assert.Equal([100m, 50m, 0m], a.Sugestoes.Select(s => s.Pontuacao));
        Assert.Equal("A-05-01-1", b.Sugestoes[0].Codigo);
        Assert.Equal("A-09-01-1", c.Sugestoes[0].Codigo);
    }

    [Fact]
    public void Fefo_avoids_mixing_expiry_dates_of_the_same_product()
    {
        var outroLote = Ocupacao(Guid.NewGuid(), new DateOnly(2027, 1, 31));
        var candidatos = new[] { Candidato("A-01-01-1", 10m, ocupacao: [outroLote]), Candidato("A-02-01-1", 10m) };
        var soFefo = new[] { new ConfiguracaoRegra(CodigosRegra.Fefo, 1m, true, SemParametros) };

        var resultado = MotorArmazenagem.Padrao().Sugerir(Item(), candidatos, soFefo);

        Assert.Equal("A-02-01-1", resultado.Sugestoes[0].Codigo);
        var misturada = resultado.Sugestoes[1].Notas.Single(n => n.Codigo == CodigosRegra.Fefo);
        Assert.Equal(0m, misturada.Nota);
        Assert.Contains("31/01/2027", misturada.Explicacao, StringComparison.Ordinal);
    }

    [Fact]
    public void Fefo_tolerance_treats_close_dates_as_equal()
    {
        var candidatos = new[] { Candidato("A-01-01-1", 10m, ocupacao: [Ocupacao(Guid.NewGuid(), Validade.AddDays(-3))]) };
        var tolerante = new[] { new ConfiguracaoRegra(CodigosRegra.Fefo, 1m, true, new Dictionary<string, decimal> { [RegraFefo.ToleranciaDias] = 5m }) };

        var resultado = MotorArmazenagem.Padrao().Sugerir(Item(), candidatos, tolerante);

        Assert.Equal(100m, resultado.Sugestoes[0].Pontuacao);
    }

    [Fact]
    public void Rule_that_does_not_apply_leaves_the_score()
    {
        var candidatos = new[] { Candidato("A-01-01-1", 10m) };

        var resultado = MotorArmazenagem.Padrao().Sugerir(Item(semValidade: true, pesoKg: null), candidatos, Padrao);

        var sugestao = resultado.Sugestoes[0];
        Assert.Null(sugestao.Notas.Single(n => n.Codigo == CodigosRegra.Fefo).Nota);
        Assert.Null(sugestao.Notas.Single(n => n.Codigo == CodigosRegra.Capacidade).Nota);
        // Só contam a curva ABC (peso 2, nota 1) e a consolidação (peso 1, vazio = 0,4): (2 + 0,4) / 3.
        Assert.Equal(80m, sugestao.Pontuacao);
    }

    [Fact]
    public void Consolidation_prefers_the_same_lot_then_the_same_product_then_an_empty_address()
    {
        var candidatos = new[]
        {
            Candidato("A-01-01-1", 10m, ocupacao: [new OcupacaoEndereco(Guid.NewGuid(), null, null, 5m, null, null)]),
            Candidato("A-02-01-1", 10m),
            Candidato("A-03-01-1", 10m, ocupacao: [Ocupacao(Guid.NewGuid(), Validade)]),
            Candidato("A-04-01-1", 10m, ocupacao: [Ocupacao(Lote, Validade)]),
        };
        var soConsolidacao = new[] { new ConfiguracaoRegra(CodigosRegra.Consolidacao, 1m, true, SemParametros) };

        var resultado = MotorArmazenagem.Padrao().Sugerir(Item(), candidatos, soConsolidacao);

        Assert.Equal(["A-04-01-1", "A-03-01-1", "A-02-01-1", "A-01-01-1"], resultado.Sugestoes.Select(s => s.Codigo));
        Assert.Equal([100m, 70m, 40m, 0m], resultado.Sugestoes.Select(s => s.Pontuacao));
    }

    [Fact]
    public void Capacity_prefers_the_tightest_fit_and_respects_the_maximum_occupation()
    {
        var item = Item(pesoKg: 100m);
        var candidatos = new[] { Candidato("A-01-01-1", 10m, capacidadeKg: 1000m), Candidato("A-02-01-1", 10m, capacidadeKg: 120m) };
        var soCapacidade = new[] { new ConfiguracaoRegra(CodigosRegra.Capacidade, 1m, true, SemParametros) };
        var ate80 = new[] { new ConfiguracaoRegra(CodigosRegra.Capacidade, 1m, true, new Dictionary<string, decimal> { [RegraCapacidade.OcupacaoMaxima] = 80m }) };

        var justo = MotorArmazenagem.Padrao().Sugerir(item, candidatos, soCapacidade);
        var limitado = MotorArmazenagem.Padrao().Sugerir(item, candidatos, ate80);

        Assert.Equal("A-02-01-1", justo.Sugestoes[0].Codigo);
        Assert.Equal(83.33m, justo.Sugestoes[0].Pontuacao);
        Assert.Equal("A-01-01-1", Assert.Single(limitado.Sugestoes).Codigo);
        Assert.Equal("A-02-01-1", Assert.Single(limitado.Descartados).Codigo);
    }

    [Fact]
    public void Capacity_counts_the_volume_already_in_the_address()
    {
        // Endereço de 1 m³ (100 × 100 × 100 cm), com 0,7 m³ ocupado: a carga de 0,4 m³ não cabe.
        var cheio = Candidato("A-01-01-1", 10m, ocupacao: [new OcupacaoEndereco(Guid.NewGuid(), null, null, 1m, null, 700_000m)]);

        var resultado = MotorArmazenagem.Padrao().Sugerir(Item(volumeCm3: 400_000m), [cheio], Padrao);

        Assert.Contains("Volume excede", Assert.Single(resultado.Descartados).Motivos[0], StringComparison.Ordinal);
    }

    [Fact]
    public void Snapshot_keeps_every_rule_with_its_weight_and_explanation()
    {
        var resultado = MotorArmazenagem.Padrao().Sugerir(Item(), [Candidato("A-01-01-1", 10m)], Padrao);

        var notas = resultado.Sugestoes[0].Notas;
        Assert.Equal(
            [CodigosRegra.Zona, CodigosRegra.Capacidade, CodigosRegra.CurvaAbc, CodigosRegra.Fefo, CodigosRegra.Consolidacao],
            notas.Select(n => n.Codigo));
        Assert.All(notas, n => Assert.False(string.IsNullOrWhiteSpace(n.Explicacao)));
        Assert.Equal(2m, notas.Single(n => n.Codigo == CodigosRegra.Fefo).Peso);
    }

    [Fact]
    public void Ties_are_broken_by_distance_and_then_by_code()
    {
        var candidatos = new[] { Candidato("B-01-01-1", 10m), Candidato("A-01-01-1", 10m), Candidato("C-01-01-1", 5m) };

        var resultado = MotorArmazenagem.Padrao().Sugerir(Item(), candidatos, []);

        Assert.All(resultado.Sugestoes, s => Assert.Equal(0m, s.Pontuacao));
        Assert.Equal(["C-01-01-1", "A-01-01-1", "B-01-01-1"], resultado.Sugestoes.Select(s => s.Codigo));
    }

    [Fact]
    public void Duplicate_rule_codes_are_rejected()
    {
        Assert.Throws<ArgumentException>(() => new MotorArmazenagem([new RegraZona(), new RegraZona()]));
    }

    private static ItemArmazenagem Item(
        ClasseAbc abc = ClasseAbc.A,
        bool semValidade = false,
        decimal? pesoKg = 50m,
        decimal? volumeCm3 = null) =>
        new(Produto, ClasseArmazenagem.Normal, abc, Lote, semValidade ? null : Validade, 120m, pesoKg, volumeCm3);

    private static OcupacaoEndereco Ocupacao(Guid lote, DateOnly validade) => new(Produto, lote, validade, 60m, 25m, null);

    private static CandidatoEndereco Candidato(
        string codigo,
        decimal distancia,
        ClasseArmazenagem classe = ClasseArmazenagem.Normal,
        decimal capacidadeKg = 1000m,
        IReadOnlyList<OcupacaoEndereco>? ocupacao = null) =>
        new(Guid.NewGuid(), codigo, classe, capacidadeKg, 1_000_000m, distancia, ocupacao ?? []);
}
