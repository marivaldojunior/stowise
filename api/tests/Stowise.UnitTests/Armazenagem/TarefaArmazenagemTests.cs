using Stowise.Domain.Armazenagem;
using Stowise.Domain.Common;
using Stowise.Domain.Recebimentos;

namespace Stowise.UnitTests.Armazenagem;

public class TarefaArmazenagemTests
{
    private static readonly DateTimeOffset Agora = new(2026, 10, 21, 10, 0, 0, TimeSpan.FromHours(-3));
    private static readonly Guid Operador = Guid.NewGuid();
    private static readonly Guid Sugerido = Guid.NewGuid();
    private static readonly LoteRecebido Lote = new("L2610A", 120, null, new DateOnly(2027, 4, 30));
    private static readonly IReadOnlyDictionary<string, decimal> SemParametros = new Dictionary<string, decimal>();

    [Fact]
    public void New_task_keeps_the_suggestion_snapshot()
    {
        var notas = new[] { new NotaRegra(CodigosRegra.CurvaAbc, 3m, true, 1m, "Classe C: endereço a 30 m da expedição.") };

        var tarefa = Nova(new SugestaoEndereco(Sugerido, "A-02-01-1", 88.13m, notas));

        Assert.Equal(StatusTarefaArmazenagem.Pendente, tarefa.Status);
        Assert.Equal(Sugerido, tarefa.EnderecoSugeridoId);
        Assert.Equal(88.13m, tarefa.Pontuacao);
        Assert.Equal(notas, tarefa.Notas);
        Assert.Equal("L2610A", tarefa.LoteNumero);
        Assert.Equal(TimeSpan.Zero, tarefa.CriadoEm.Offset);
    }

    [Fact]
    public void Task_without_any_address_has_no_suggestion()
    {
        var tarefa = Nova(null);

        Assert.Null(tarefa.EnderecoSugeridoId);
        Assert.Empty(tarefa.Notas);
    }

    [Fact]
    public void Confirming_at_the_suggested_address_concludes_the_task()
    {
        var tarefa = Nova(Sugestao());
        var movimentacao = Guid.NewGuid();

        tarefa.Confirm(Sugerido, "ignorado", movimentacao, Operador, Agora);

        Assert.Equal(StatusTarefaArmazenagem.Concluida, tarefa.Status);
        Assert.Equal(Sugerido, tarefa.EnderecoConfirmadoId);
        Assert.Null(tarefa.MotivoDivergencia);
        Assert.Equal(movimentacao, tarefa.MovimentacaoId);
        Assert.Equal(Operador, tarefa.ConcluidoPor);
    }

    [Fact]
    public void Another_address_needs_a_reason_and_marks_the_divergence()
    {
        var tarefa = Nova(Sugestao());
        var outro = Guid.NewGuid();

        Assert.Throws<DomainException>(() => tarefa.EnsureConfirmavel(outro, "  "));
        tarefa.Confirm(outro, " Endereço sugerido com palete avariado ", Guid.NewGuid(), Operador, Agora);

        Assert.Equal(StatusTarefaArmazenagem.Divergente, tarefa.Status);
        Assert.Equal("Endereço sugerido com palete avariado", tarefa.MotivoDivergencia);
    }

    [Fact]
    public void Task_is_confirmed_only_once()
    {
        var tarefa = Nova(Sugestao());
        tarefa.Confirm(Sugerido, null, Guid.NewGuid(), Operador, Agora);

        Assert.Throws<DomainException>(() => tarefa.Confirm(Sugerido, null, Guid.NewGuid(), Operador, Agora));
    }

    [Fact]
    public void Rules_version_changes_with_the_weights_and_ignores_the_order()
    {
        ConfiguracaoRegra[] padrao =
        [
            new(CodigosRegra.Fefo, 2m, true, new Dictionary<string, decimal> { [RegraFefo.ToleranciaDias] = 0m }),
            new(CodigosRegra.CurvaAbc, 3m, true, SemParametros),
        ];

        var versao = TarefaArmazenagem.VersaoDe(padrao);

        Assert.Equal(TarefaArmazenagem.RegrasVersaoLength, versao.Length);
        Assert.Equal(versao, TarefaArmazenagem.VersaoDe(padrao.Reverse()));
        Assert.NotEqual(versao, TarefaArmazenagem.VersaoDe([padrao[0], padrao[1] with { Peso = 0m }]));
        Assert.NotEqual(versao, TarefaArmazenagem.VersaoDe([padrao[0] with { Parametros = new Dictionary<string, decimal> { [RegraFefo.ToleranciaDias] = 3m } }, padrao[1]]));
    }

    private static SugestaoEndereco Sugestao() => new(Sugerido, "A-02-01-1", 88.13m, []);

    private static TarefaArmazenagem Nova(SugestaoEndereco? sugestao)
    {
        var recebimento = Recebimento.Create(Guid.NewGuid(), "35261011222333000181550010000012341123456787", 1234, 1, Agora.AddDays(-1), Guid.NewGuid(), Agora);
        var item = recebimento.AddItem(new DadosItemRecebido(
            1, Guid.NewGuid(), Guid.NewGuid(), Guid.NewGuid(), "REF-001", "REFRIGERANTE COLA 2L CX 12", "CX", 10, 12, "5102", 95.4m, [Lote]));
        return TarefaArmazenagem.Create(item, Lote, 120m, sugestao, "abc123def456", Agora);
    }
}
