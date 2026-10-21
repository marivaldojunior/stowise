using Stowise.Domain.Common;
using Stowise.Domain.Recebimentos;

namespace Stowise.UnitTests.Recebimentos;

public class RecebimentoTests
{
    private const string Chave = "35261011222333000181550010000012341123456787";
    private static readonly DateTimeOffset Agora = new(2026, 10, 21, 10, 0, 0, TimeSpan.Zero);

    [Fact]
    public void New_receipt_waits_for_the_physical_check()
    {
        var recebimento = Novo();

        Assert.Equal(StatusRecebimento.AguardandoConferencia, recebimento.Status);
        Assert.Equal(Chave, recebimento.ChaveAcesso);
        Assert.Null(recebimento.DataChegada);
    }

    [Fact]
    public void Item_keeps_the_invoice_values_and_the_converted_quantity()
    {
        var recebimento = Novo();

        var item = recebimento.AddItem(Dados(numeroItem: 1, quantidade: 10, fator: 12));

        Assert.Equal(120m, item.Quantidade);
        Assert.Equal(10m, item.QuantidadeNota);
        Assert.Equal("CX", item.UnidadeNota);
        Assert.Equal(recebimento.Id, item.RecebimentoId);
        Assert.Equal("L2610A", Assert.Single(item.Lotes).Numero);
    }

    [Fact]
    public void The_same_invoice_item_cannot_enter_twice()
    {
        var recebimento = Novo();
        recebimento.AddItem(Dados(numeroItem: 1));

        Assert.Throws<DomainException>(() => recebimento.AddItem(Dados(numeroItem: 1)));
    }

    [Theory]
    [InlineData(0, 10, 12, "5102")] // nItem fora da faixa
    [InlineData(1, 0, 12, "5102")] // sem quantidade
    [InlineData(1, 10, 0, "5102")] // sem fator
    [InlineData(1, 10, 12, "51X2")] // CFOP inválido
    public void Item_values_are_validated(int numeroItem, decimal quantidade, decimal fator, string cfop)
    {
        Assert.Throws<DomainException>(() => Novo().AddItem(Dados(numeroItem, quantidade, fator, cfop)));
    }

    [Fact]
    public void Receipt_needs_a_valid_access_key()
    {
        Assert.Throws<DomainException>(() =>
            Recebimento.Create(Guid.NewGuid(), "35261011222333000181550010000012341123456786", 1234, 1, Agora, Guid.NewGuid(), Agora));
    }

    private static Recebimento Novo() => Recebimento.Create(Guid.NewGuid(), Chave, 1234, 1, Agora.AddDays(-1), Guid.NewGuid(), Agora);

    private static DadosItemRecebido Dados(int numeroItem = 1, decimal quantidade = 10, decimal fator = 12, string cfop = "5102") =>
        new(
            numeroItem,
            Guid.NewGuid(),
            Guid.NewGuid(),
            Guid.NewGuid(),
            "REF-001",
            "REFRIGERANTE COLA 2L CX 12",
            "CX",
            quantidade,
            fator,
            cfop,
            95.4m,
            [new LoteRecebido("L2610A", 120, null, new DateOnly(2027, 4, 30))]);
}
