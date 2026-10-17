using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Catalogo;

namespace Stowise.Api.Endpoints;

public static class CategoriasEndpoints
{
    private const string ObterCategoriaRoute = "ObterCategoria";

    public static IEndpointRouteBuilder MapCategoriasEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/categorias")
            .WithTags("Catálogo")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        group.MapGet("/", async (ICategoriaService categorias, CancellationToken ct) => TypedResults.Ok(await categorias.ListAsync(ct)))
            .WithName("ListarCategorias");

        group.MapGet("/{id:guid}", GetAsync)
            .WithName(ObterCategoriaRoute)
            .Produces<CategoriaDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        var escrita = group.MapGroup("/")
            .RequireAuthorization(Politicas.Gestao)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        escrita.MapPost("/", CreateAsync)
            .WithName("CriarCategoria")
            .Produces<CategoriaDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        escrita.MapPut("/{id:guid}", UpdateAsync)
            .WithName("AtualizarCategoria")
            .Produces<CategoriaDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        escrita.MapDelete("/{id:guid}", DeleteAsync)
            .WithName("ExcluirCategoria")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        return app;
    }

    private static async Task<IResult> GetAsync(Guid id, ICategoriaService categorias, CancellationToken ct)
    {
        var categoria = (await categorias.ListAsync(ct)).FirstOrDefault(c => c.Id == id);
        return categoria is null
            ? TypedResults.Problem(title: "Categoria não encontrada.", statusCode: StatusCodes.Status404NotFound)
            : TypedResults.Ok(categoria);
    }

    private static async Task<IResult> CreateAsync(SalvarCategoria comando, ICategoriaService categorias, CancellationToken ct) =>
        (await categorias.CreateAsync(comando, ct))
            .ToHttpResult(c => TypedResults.CreatedAtRoute(c, ObterCategoriaRoute, new { id = c.Id }));

    private static async Task<IResult> UpdateAsync(Guid id, SalvarCategoria comando, ICategoriaService categorias, CancellationToken ct) =>
        (await categorias.UpdateAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> DeleteAsync(Guid id, ICategoriaService categorias, CancellationToken ct) =>
        (await categorias.DeleteAsync(id, ct)).ToNoContent();
}
