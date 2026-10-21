using Stowise.Domain.Common;
using Stowise.Domain.Recebimentos;

namespace Stowise.UnitTests.Recebimentos;

public class ConferenciaTests
{
    private const string Chave = "35261011222333000181550010000012341123456787";
    private static readonly DateTimeOffset Agora = new(2026, 10, 21, 10, 0, 0, TimeSpan.Zero);
    private static readonly Guid Operador = Guid.NewGuid();

    [Fact]
    public void Status_goes_from_waiting_to_checking_to_checked()
    {
        var (recebimento, item) = Novo();

        recebimento.StartConferencia(Agora.ToOffset(TimeSpan.FromHours(-3)));
        Assert.Equal(StatusRecebimento.EmConferencia, recebimento.Status);
        Assert.Equal(TimeSpan.Zero, recebimento.DataChegada!.Value.Offset);

        recebimento.ConferirItem(item.Id, 10, [new LoteConferido("L2610A", 10, null, new DateOnly(2027, 4, 30))], true, true, Operador, Agora);
        recebimento.FinishConferencia(Operador, Agora);

        Assert.Equal(StatusRecebimento.Conferido, recebimento.Status);
        Assert.Equal(Operador, recebimento.ConferidoPor);
        Assert.False(recebimento.TemDivergencia);
    }

    [Fact]
    public void Count_is_converted_to_the_base_unit()
    {
        var (recebimento, item) = Iniciado();

        recebimento.ConferirItem(item.Id, 10, [new LoteConferido("L2610A", 10, null, new DateOnly(2027, 4, 30))], true, true, Operador, Agora);

        Assert.Equal(120m, item.QuantidadeConferida);
        Assert.Equal(120m, Assert.Single(item.LotesConferidos).QuantidadeBase);
        Assert.False(item.Divergente);
    }

    [Fact]
    public void Missing_boxes_or_another_batch_are_divergences()
    {
        var (faltando, itemFaltando) = Iniciado();
        faltando.ConferirItem(itemFaltando.Id, 9, [new LoteConferido("L2610A", 9, null, new DateOnly(2027, 4, 30))], true, true, Operador, Agora);
        Assert.True(itemFaltando.Divergente);
        Assert.Equal(108m, itemFaltando.QuantidadeConferida);

        var (outroLote, itemOutroLote) = Iniciado();
        outroLote.ConferirItem(itemOutroLote.Id, 10, [new LoteConferido("L2611B", 10, null, new DateOnly(2027, 5, 31))], true, true, Operador, Agora);
        Assert.True(outroLote.TemDivergencia);
    }

    [Fact]
    public void A_count_can_be_corrected_while_checking()
    {
        var (recebimento, item) = Iniciado();
        recebimento.ConferirItem(item.Id, 9, [new LoteConferido("L2610A", 9, null, new DateOnly(2027, 4, 30))], true, true, Operador, Agora);

        recebimento.ConferirItem(item.Id, 10, [new LoteConferido("L2610A", 10, null, new DateOnly(2027, 4, 30))], true, true, Operador, Agora);

        Assert.False(item.Divergente);
    }

    [Theory]
    [InlineData(true, false, 10, 0, "controla lote")] // lote obrigatório e não informado
    [InlineData(true, true, 10, 9, "soma dos lotes")] // lotes não somam a quantidade
    public void Batches_follow_the_product_rules(bool controlaLote, bool comLote, decimal quantidade, decimal quantidadeLote, string mensagem)
    {
        var (recebimento, item) = Iniciado();
        LoteConferido[] lotes = comLote ? [new LoteConferido("L1", quantidadeLote, null, new DateOnly(2027, 1, 1))] : [];

        var erro = Assert.Throws<DomainException>(() => recebimento.ConferirItem(item.Id, quantidade, lotes, controlaLote, false, Operador, Agora));
        Assert.Contains(mensagem, erro.Message, StringComparison.Ordinal);
    }

    [Fact]
    public void Expiry_is_required_when_the_product_controls_it()
    {
        var (recebimento, item) = Iniciado();

        var erro = Assert.Throws<DomainException>(() =>
            recebimento.ConferirItem(item.Id, 10, [new LoteConferido("L1", 10, null, null)], true, true, Operador, Agora));
        Assert.Contains("validade", erro.Message, StringComparison.Ordinal);
    }

    [Fact]
    public void Zero_count_without_batch_is_a_full_shortage()
    {
        var (recebimento, item) = Iniciado();

        recebimento.ConferirItem(item.Id, 0, [], controlaLote: true, controlaValidade: true, Operador, Agora);

        Assert.Equal(0m, item.QuantidadeConferida);
        Assert.True(item.Divergente);
    }

    [Fact]
    public void Wrong_order_is_refused()
    {
        var (recebimento, item) = Novo();

        Assert.Throws<DomainException>(() => recebimento.ConferirItem(item.Id, 10, [], false, false, Operador, Agora));
        Assert.Throws<DomainException>(() => recebimento.FinishConferencia(Operador, Agora));

        recebimento.StartConferencia(Agora);
        Assert.Throws<DomainException>(() => recebimento.StartConferencia(Agora));

        var erro = Assert.Throws<DomainException>(() => recebimento.FinishConferencia(Operador, Agora));
        Assert.Contains("Faltam contar os itens 1", erro.Message, StringComparison.Ordinal);
    }

    private static (Recebimento Recebimento, RecebimentoItem Item) Iniciado()
    {
        var (recebimento, item) = Novo();
        recebimento.StartConferencia(Agora);
        return (recebimento, item);
    }

    private static (Recebimento Recebimento, RecebimentoItem Item) Novo()
    {
        var recebimento = Recebimento.Create(Guid.NewGuid(), Chave, 1234, 1, Agora.AddDays(-1), Guid.NewGuid(), Agora);
        var item = recebimento.AddItem(new DadosItemRecebido(
            1,
            Guid.NewGuid(),
            Guid.NewGuid(),
            Guid.NewGuid(),
            "REF-001",
            "REFRIGERANTE COLA 2L CX 12",
            "CX",
            10,
            12,
            "5102",
            95.4m,
            [new LoteRecebido("L2610A", 120, null, new DateOnly(2027, 4, 30))]));
        return (recebimento, item);
    }
}
