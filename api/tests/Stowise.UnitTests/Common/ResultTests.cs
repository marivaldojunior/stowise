using Stowise.Application.Common;

namespace Stowise.UnitTests.Common;

public class ResultTests
{
    [Fact]
    public void Value_converts_to_successful_result()
    {
        Result<int> result = 42;

        Assert.True(result.IsSuccess);
        Assert.Null(result.Error);
        Assert.Equal(42, result.Value);
    }

    [Fact]
    public void Error_converts_to_failed_result_without_value()
    {
        Result<int> result = AppError.NotFound("Não encontrado.");

        Assert.False(result.IsSuccess);
        Assert.Equal(ErrorType.NotFound, result.Error!.Type);
        Assert.Throws<InvalidOperationException>(() => result.Value);
    }

    [Fact]
    public void Single_field_validation_error_keeps_field_and_message()
    {
        var error = AppError.Validation("senha", "Informe a senha.");

        Assert.Equal(ErrorType.Validation, error.Type);
        Assert.Equal(["Informe a senha."], error.Fields!["senha"]);
    }

    [Theory]
    [InlineData(null, null, 1, 20)]
    [InlineData(0, 0, 1, 1)]
    [InlineData(-3, 500, 1, 100)]
    [InlineData(4, 50, 4, 50)]
    public void Paging_normalizes_page_and_size(int? pagina, int? tamanho, int paginaEsperada, int tamanhoEsperado)
    {
        Assert.Equal((paginaEsperada, tamanhoEsperado), Paging.Normalize(pagina, tamanho));
    }

    [Fact]
    public void PagedResult_computes_total_pages()
    {
        Assert.Equal(3, new PagedResult<int>([], 1, 20, 41).TotalPaginas);
        Assert.Equal(0, new PagedResult<int>([], 1, 20, 0).TotalPaginas);
    }
}
