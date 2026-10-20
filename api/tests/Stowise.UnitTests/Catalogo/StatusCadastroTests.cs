using Stowise.Domain.Catalogo;
using Stowise.Domain.Estrutura;

namespace Stowise.UnitTests.Catalogo;

public class StatusCadastroTests
{
    private static readonly DadosProduto Dados = new("Refrigerante Cola 2L", "UN", ClasseArmazenagem.Normal, false, false, null, null, null);

    [Fact]
    public void Product_without_measures_starts_incomplete_and_lists_what_is_missing()
    {
        // Como vem de uma NF-e: só o GTIN, sem peso nem medidas.
        var produto = Produto.Create("COLA-2L", Dados, new DadosEmbalagem("7891000315507", null, 33m, null, null));

        Assert.Equal(StatusCadastro.Incompleto, produto.StatusCadastro);
        Assert.Equal(["pesoKg", "larguraCm", "comprimentoCm"], produto.EmbalagemBase.MedidasFaltando);
    }

    [Fact]
    public void Status_follows_every_package_change()
    {
        var produto = Produto.Create("COLA-2L", Dados, new DadosEmbalagem("7891000315507", 2.1m, 33m, 10m, 10m));
        Assert.Equal(StatusCadastro.Completo, produto.StatusCadastro);

        var caixa = produto.AddEmbalagem(TipoEmbalagem.Caixa, 6m, new DadosEmbalagem("17891000315504", null, null, null, null));
        Assert.Equal(StatusCadastro.Incompleto, produto.StatusCadastro);

        produto.UpdateEmbalagem(caixa.Id, new DadosEmbalagem("17891000315504", 13m, 34m, 31m, 21m));
        Assert.Equal(StatusCadastro.Completo, produto.StatusCadastro);

        produto.UpdateEmbalagem(caixa.Id, new DadosEmbalagem("17891000315504", 13m, null, 31m, 21m));
        Assert.Equal(StatusCadastro.Incompleto, produto.StatusCadastro);

        produto.RemoveEmbalagem(caixa.Id);
        Assert.Equal(StatusCadastro.Completo, produto.StatusCadastro);
    }
}
