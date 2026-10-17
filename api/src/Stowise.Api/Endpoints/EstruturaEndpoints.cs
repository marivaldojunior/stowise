using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Application.Estrutura;
using Stowise.Domain.Estrutura;

namespace Stowise.Api.Endpoints;

/// <summary>Estrutura física: armazéns, zonas e endereços.</summary>
public static class EstruturaEndpoints
{
    private const string ObterArmazemRoute = "ObterArmazem";
    private const string ObterEnderecoRoute = "ObterEndereco";

    public static IEndpointRouteBuilder MapEstruturaEndpoints(this IEndpointRouteBuilder app)
    {
        MapArmazens(app);
        MapEnderecos(app);
        return app;
    }

    private static void MapArmazens(IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/armazens")
            .WithTags("Estrutura física")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        group.MapGet("/", async (IArmazemService armazens, CancellationToken ct) => TypedResults.Ok(await armazens.ListAsync(ct)))
            .WithName("ListarArmazens");

        group.MapGet("/{id:guid}", async (Guid id, IArmazemService armazens, CancellationToken ct) =>
                (await armazens.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok))
            .WithName(ObterArmazemRoute)
            .Produces<ArmazemDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        group.MapGet("/{id:guid}/enderecos/codigo/{codigo}", async (Guid id, string codigo, IEnderecoService enderecos, CancellationToken ct) =>
                (await enderecos.FindByCodigoAsync(id, codigo, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ObterEnderecoPorCodigo")
            .WithSummary("Busca pelo código lido no app (ex.: A-03-02-1), dentro do armazém.")
            .Produces<EnderecoDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        var escrita = group.MapGroup("/")
            .RequireAuthorization(Politicas.Gestao)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        escrita.MapPost("/", async (CriarArmazem comando, IArmazemService armazens, CancellationToken ct) =>
                (await armazens.CreateAsync(comando, ct)).ToHttpResult(a => TypedResults.CreatedAtRoute(a, ObterArmazemRoute, new { id = a.Id })))
            .WithName("CriarArmazem")
            .Produces<ArmazemDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict);

        escrita.MapPut("/{id:guid}", async (Guid id, RenomearArmazem comando, IArmazemService armazens, CancellationToken ct) =>
                (await armazens.RenameAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("RenomearArmazem")
            .Produces<ArmazemDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound);

        escrita.MapDelete("/{id:guid}", async (Guid id, IArmazemService armazens, CancellationToken ct) =>
                (await armazens.DeleteAsync(id, ct)).ToNoContent())
            .WithName("ExcluirArmazem")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        escrita.MapPost("/{id:guid}/zonas", async (Guid id, SalvarZona comando, IArmazemService armazens, CancellationToken ct) =>
                (await armazens.AddZonaAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("AdicionarZona")
            .Produces<ArmazemDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict);

        escrita.MapPut("/{id:guid}/zonas/{zonaId:guid}", async (Guid id, Guid zonaId, SalvarZona comando, IArmazemService armazens, CancellationToken ct) =>
                (await armazens.UpdateZonaAsync(id, zonaId, comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("AtualizarZona")
            .Produces<ArmazemDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict);

        escrita.MapDelete("/{id:guid}/zonas/{zonaId:guid}", async (Guid id, Guid zonaId, IArmazemService armazens, CancellationToken ct) =>
                (await armazens.RemoveZonaAsync(id, zonaId, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("RemoverZona")
            .Produces<ArmazemDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);
    }

    private static void MapEnderecos(IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/enderecos")
            .WithTags("Estrutura física")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        group.MapGet("/", ListEnderecosAsync)
            .WithName("ListarEnderecos")
            .Produces<PagedResult<EnderecoDetalhe>>();

        group.MapGet("/{id:guid}", async (Guid id, IEnderecoService enderecos, CancellationToken ct) =>
                (await enderecos.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok))
            .WithName(ObterEnderecoRoute)
            .Produces<EnderecoDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        var escrita = group.MapGroup("/")
            .RequireAuthorization(Politicas.Gestao)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        escrita.MapPost("/", async (CriarEndereco comando, IEnderecoService enderecos, CancellationToken ct) =>
                (await enderecos.CreateAsync(comando, ct)).ToHttpResult(e => TypedResults.CreatedAtRoute(e, ObterEnderecoRoute, new { id = e.Id })))
            .WithName("CriarEndereco")
            .Produces<EnderecoDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict);

        escrita.MapPut("/{id:guid}", async (Guid id, DimensoesEnderecoComando comando, IEnderecoService enderecos, CancellationToken ct) =>
                (await enderecos.UpdateAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("AtualizarEndereco")
            .WithSummary("Altera capacidade, medidas e distância. As coordenadas e o código não mudam.")
            .Produces<EnderecoDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound);

        escrita.MapDelete("/{id:guid}", async (Guid id, IEnderecoService enderecos, CancellationToken ct) =>
                (await enderecos.DeleteAsync(id, ct)).ToNoContent())
            .WithName("ExcluirEndereco")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);
    }

    private static async Task<IResult> ListEnderecosAsync(
        IEnderecoService enderecos,
        Guid? armazemId,
        Guid? zonaId,
        string? codigo,
        StatusEndereco? status,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        TypedResults.Ok(await enderecos.ListAsync(new EnderecoFiltro(armazemId, zonaId, codigo, status, pagina, tamanhoPagina), ct));
}
