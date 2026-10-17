using Stowise.Application.Estoque;

namespace Stowise.UnitTests.Estoque;

public class EstoqueValidationTests
{
    private static readonly DateTimeOffset Agora = new(2026, 10, 18, 12, 0, 0, TimeSpan.Zero);

    [Fact]
    public void Entrada_reports_missing_fields_and_bad_lot_dates()
    {
        var comando = new RegistrarEntrada(
            null, null, null, 0m, new LoteInformado(" ", new DateOnly(2026, 6, 1), new DateOnly(2026, 1, 1)), null, null, null);

        Assert.Equal(
            ["enderecoId", "lote.numero", "lote.validade", "produtoId", "quantidade"],
            EstoqueValidation.Validate(comando, Agora).Keys.Order(StringComparer.Ordinal));
    }

    [Fact]
    public void Device_time_in_the_future_is_rejected_beyond_the_tolerance()
    {
        RegistrarSaida Saida(DateTimeOffset ocorridoEm) => new(Guid.NewGuid(), null, Guid.NewGuid(), 1m, null, null, null, ocorridoEm);

        Assert.Empty(EstoqueValidation.Validate(Saida(Agora.AddMinutes(4)), Agora));
        Assert.Equal(["ocorridoEm"], EstoqueValidation.Validate(Saida(Agora.AddMinutes(10)), Agora).Keys);
        Assert.Empty(EstoqueValidation.Validate(Saida(Agora.AddDays(-2)), Agora));
    }

    [Fact]
    public void Ajuste_needs_a_non_zero_delta_and_a_reason()
    {
        var semMotivo = new RegistrarAjuste(Guid.NewGuid(), Guid.NewGuid(), 0m, null, " ", null);

        Assert.Equal(["motivo", "quantidade"], EstoqueValidation.Validate(semMotivo, Agora).Keys.Order(StringComparer.Ordinal));
        Assert.Empty(EstoqueValidation.Validate(semMotivo with { Quantidade = -3m, Motivo = "Avaria" }, Agora));
    }
}
