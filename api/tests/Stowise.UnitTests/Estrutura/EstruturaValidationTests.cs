using Stowise.Application.Estrutura;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Estrutura;

public class EstruturaValidationTests
{
    [Fact]
    public void Valid_endereco_has_no_errors()
    {
        var comando = new CriarEndereco(Guid.NewGuid(), "A", 3, 2, 1, 1000m, 150m, 120m, 100m, 0m);

        Assert.Empty(EstruturaValidation.Validate(comando));
    }

    [Fact]
    public void Endereco_reports_each_invalid_field()
    {
        var comando = new CriarEndereco(null, "A1", 0, 100, 10, 0m, null, -1m, 100m, -2m);

        Assert.Equal(
            ["alturaCm", "capacidadePesoKg", "distanciaExpedicao", "larguraCm", "modulo", "nivel", "posicao", "rua", "zonaId"],
            EstruturaValidation.Validate(comando).Keys.Order(StringComparer.Ordinal));
    }

    [Fact]
    public void Zona_requires_codigo_and_classe()
    {
        Assert.Equal(["classeArmazenagem", "codigo"], EstruturaValidation.Validate(new SalvarZona(" ", null)).Keys.Order(StringComparer.Ordinal));
        Assert.Empty(EstruturaValidation.Validate(new SalvarZona("SECO", ClasseArmazenagem.Normal)));
    }

    [Fact]
    public void Armazem_requires_codigo_and_nome_within_limits()
    {
        var longo = new string('x', Armazem.CodigoMaxLength + 1);

        Assert.Equal(["codigo", "nome"], EstruturaValidation.Validate(new CriarArmazem(longo, "")).Keys.Order(StringComparer.Ordinal));
        Assert.Equal(["nome"], EstruturaValidation.Validate(new RenomearArmazem(null)).Keys);
    }

    [Fact]
    public void Dimensoes_update_allows_zero_distance_only()
    {
        Assert.Empty(EstruturaValidation.Validate(new DimensoesEnderecoComando(1m, 1m, 1m, 1m, 0m)));
        Assert.Equal(["distanciaExpedicao"], EstruturaValidation.Validate(new DimensoesEnderecoComando(1m, 1m, 1m, 1m, null)).Keys);
    }
}
