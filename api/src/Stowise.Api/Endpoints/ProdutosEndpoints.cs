using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Catalogo;
using Stowise.Application.Common;

namespace Stowise.Api.Endpoints;

public static class ProdutosEndpoints
{
    private const string ObterProdutoRoute = "ObterProduto";

    public static IEndpointRouteBuilder MapProdutosEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/produtos")
            .WithTags("Catálogo")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        group.MapGet("/", ListAsync)
            .WithName("ListarProdutos")
            .Produces<PagedResult<ProdutoResumo>>();

        group.MapGet("/{id:guid}", GetAsync)
            .WithName(ObterProdutoRoute)
            .Produces<ProdutoDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        group.MapGet("/codigo/{codigo}", FindByCodigoAsync)
            .WithName("ObterProdutoPorCodigo")
            .WithSummary("Busca pelo código lido no app: GTIN de qualquer embalagem ou SKU.")
            .Produces<ProdutoPorCodigo>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        var escrita = group.MapGroup("/")
            .RequireAuthorization(Politicas.Gestao)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        escrita.MapPost("/", CreateAsync)
            .WithName("CriarProduto")
            .Produces<ProdutoDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict);

        escrita.MapPut("/{id:guid}", UpdateAsync)
            .WithName("AtualizarProduto")
            .WithSummary("Exige a versão lida. Se o produto mudou desde então, responde 409.")
            .Produces<ProdutoDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict);

        escrita.MapPost("/{id:guid}/desativar", DeactivateAsync)
            .WithName("DesativarProduto")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound);

        escrita.MapPost("/{id:guid}/reativar", ReactivateAsync)
            .WithName("ReativarProduto")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound);

        escrita.MapPost("/{id:guid}/embalagens", AddEmbalagemAsync)
            .WithName("AdicionarEmbalagem")
            .Produces<ProdutoDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        escrita.MapPut("/{id:guid}/embalagens/{embalagemId:guid}", UpdateEmbalagemAsync)
            .WithName("AtualizarEmbalagem")
            .Produces<ProdutoDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        escrita.MapDelete("/{id:guid}/embalagens/{embalagemId:guid}", RemoveEmbalagemAsync)
            .WithName("RemoverEmbalagem")
            .Produces<ProdutoDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        return app;
    }

    private static async Task<IResult> ListAsync(
        IProdutoService produtos,
        string? busca,
        Guid? categoriaId,
        bool? ativo,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        TypedResults.Ok(await produtos.ListAsync(new ProdutoFiltro(busca, categoriaId, ativo, pagina, tamanhoPagina), ct));

    private static async Task<IResult> GetAsync(Guid id, IProdutoService produtos, CancellationToken ct) =>
        (await produtos.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> FindByCodigoAsync(string codigo, IProdutoService produtos, CancellationToken ct) =>
        (await produtos.FindByCodigoAsync(codigo, ct)).ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> CreateAsync(CriarProduto comando, IProdutoService produtos, CancellationToken ct) =>
        (await produtos.CreateAsync(comando, ct))
            .ToHttpResult(p => TypedResults.CreatedAtRoute(p, ObterProdutoRoute, new { id = p.Id }));

    private static async Task<IResult> UpdateAsync(Guid id, AtualizarProduto comando, IProdutoService produtos, CancellationToken ct) =>
        (await produtos.UpdateAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> DeactivateAsync(Guid id, IProdutoService produtos, CancellationToken ct) =>
        (await produtos.DeactivateAsync(id, ct)).ToNoContent();

    private static async Task<IResult> ReactivateAsync(Guid id, IProdutoService produtos, CancellationToken ct) =>
        (await produtos.ReactivateAsync(id, ct)).ToNoContent();

    private static async Task<IResult> AddEmbalagemAsync(Guid id, AdicionarEmbalagem comando, IProdutoService produtos, CancellationToken ct) =>
        (await produtos.AddEmbalagemAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> UpdateEmbalagemAsync(
        Guid id,
        Guid embalagemId,
        EmbalagemMedidas comando,
        IProdutoService produtos,
        CancellationToken ct) =>
        (await produtos.UpdateEmbalagemAsync(id, embalagemId, comando, ct)).ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> RemoveEmbalagemAsync(Guid id, Guid embalagemId, IProdutoService produtos, CancellationToken ct) =>
        (await produtos.RemoveEmbalagemAsync(id, embalagemId, ct)).ToHttpResult(TypedResults.Ok);
}
