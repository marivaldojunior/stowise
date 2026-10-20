using Stowise.Application.Fornecedores;
using Stowise.Domain.Common;
using Stowise.Domain.Fornecedores;

namespace Stowise.UnitTests.Fornecedores;

public class FornecedorTests
{
    private static readonly DateTimeOffset Agora = new(2026, 10, 20, 12, 0, 0, TimeSpan.Zero);

    [Theory]
    [InlineData("11.222.333/0001-81", "11222333000181")] // numérico
    [InlineData("12.abc.345/01de-35", "12ABC34501DE35")] // alfanumérico, exemplo da Receita Federal
    [InlineData(" 12ABC34501DE35 ", "12ABC34501DE35")]
    public void Valid_cnpjs_are_normalized(string informado, string normalizado)
    {
        Assert.Equal(normalizado, Cnpj.Normalize(informado));
        Assert.True(Cnpj.IsValid(Cnpj.Normalize(informado)));
    }

    [Theory]
    [InlineData("11222333000182")] // segundo dígito errado
    [InlineData("12ABC34501DE36")]
    [InlineData("12ABC34501DEA5")] // dígito verificador com letra
    [InlineData("1222333000181")] // 13 caracteres
    [InlineData("00000000000000")] // todos iguais
    [InlineData("12abc34501de35")] // minúsculas sem normalizar
    [InlineData("")]
    [InlineData(null)]
    public void Invalid_cnpjs_are_rejected(string? cnpj)
    {
        Assert.False(Cnpj.IsValid(cnpj));
    }

    [Fact]
    public void Cnpj_is_formatted_with_the_mask()
    {
        Assert.Equal("12.ABC.345/01DE-35", Cnpj.Format("12ABC34501DE35"));
    }

    [Fact]
    public void Create_stores_the_normalized_cnpj_and_trims_names()
    {
        var fornecedor = Fornecedor.Create("11.222.333/0001-81", "  Distribuidora Exemplo Ltda ", "  ");

        Assert.Equal("11222333000181", fornecedor.Cnpj);
        Assert.Equal("Distribuidora Exemplo Ltda", fornecedor.RazaoSocial);
        Assert.Null(fornecedor.NomeFantasia);
    }

    [Fact]
    public void Create_rejects_an_invalid_cnpj()
    {
        Assert.Throws<DomainException>(() => Fornecedor.Create("11.222.333/0001-82", "Exemplo", null));
    }

    [Fact]
    public void Vinculo_keeps_who_confirmed_and_uppercases_the_unit()
    {
        var usuario = Guid.NewGuid();
        var vinculo = ProdutoFornecedor.Create(Guid.NewGuid(), " ABC-123 ", Guid.NewGuid(), Guid.NewGuid(), "cx", 12, usuario, Agora);

        Assert.Equal("ABC-123", vinculo.CodigoFornecedor);
        Assert.Equal("CX", vinculo.UnidadeFornecedor);
        Assert.Equal(12, vinculo.FatorConversao);
        Assert.Equal(usuario, vinculo.ConfirmadoPor);
        Assert.Equal(Agora, vinculo.ConfirmadoEm);
    }

    [Fact]
    public void Vinculo_requires_a_positive_factor_and_a_confirming_user()
    {
        Assert.Throws<DomainException>(() =>
            ProdutoFornecedor.Create(Guid.NewGuid(), "ABC", Guid.NewGuid(), Guid.NewGuid(), "CX", 0, Guid.NewGuid(), Agora));
        Assert.Throws<DomainException>(() =>
            ProdutoFornecedor.Create(Guid.NewGuid(), "ABC", Guid.NewGuid(), Guid.NewGuid(), "CX", 12, Guid.Empty, Agora));
    }

    [Fact]
    public void Validation_reports_every_field()
    {
        var erros = FornecedorValidation.Validate(new CriarProdutoFornecedor(" ", null, Guid.Empty, "CAIXAGRANDE", -1));

        Assert.Equal(["codigoFornecedor", "embalagemId", "fatorConversao", "produtoId", "unidadeFornecedor"], erros.Keys.Order());
        Assert.Equal(["cnpj", "razaoSocial"], FornecedorValidation.Validate(new CriarFornecedor("123", "", null)).Keys.Order());
    }
}
