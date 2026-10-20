using System.Security.Claims;
using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Application.Fornecedores;

namespace Stowise.Api.Endpoints;

/// <summary>Fornecedores e o de-para dos códigos deles (cProd da NF-e). Leitura para todos; escrita para Admin e Gestor.</summary>
public static class FornecedoresEndpoints
{
    private const string ObterFornecedorRoute = "ObterFornecedor";

    public static IEndpointRouteBuilder MapFornecedoresEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/fornecedores")
            .WithTags("Fornecedores")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        group.MapGet("/", async (IFornecedorService fornecedores, string? busca, int? pagina, int? tamanhoPagina, CancellationToken ct) =>
                TypedResults.Ok(await fornecedores.ListAsync(new FornecedorFiltro(busca, pagina, tamanhoPagina), ct)))
            .WithName("ListarFornecedores")
            .WithSummary("Busca por parte do CNPJ (com ou sem máscara), da razão social ou do nome fantasia.")
            .Produces<PagedResult<FornecedorResumo>>();

        group.MapGet("/{id:guid}", async (Guid id, IFornecedorService fornecedores, CancellationToken ct) =>
                (await fornecedores.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok))
            .WithName(ObterFornecedorRoute)
            .Produces<FornecedorDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        group.MapGet("/{id:guid}/produtos", async (Guid id, IFornecedorService fornecedores, string? busca, int? pagina, int? tamanhoPagina, CancellationToken ct) =>
                (await fornecedores.ListProdutosAsync(id, new ProdutoFornecedorFiltro(busca, pagina, tamanhoPagina), ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ListarProdutosDoFornecedor")
            .WithSummary("De-para do fornecedor. Busca por parte do código do fornecedor, do SKU ou da descrição.")
            .Produces<PagedResult<ProdutoFornecedorDetalhe>>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        group.MapGet("/{id:guid}/produtos/codigo/{codigo}", async (Guid id, string codigo, IFornecedorService fornecedores, CancellationToken ct) =>
                (await fornecedores.FindProdutoByCodigoAsync(id, codigo, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ObterProdutoDoFornecedorPorCodigo")
            .WithSummary("Produto do catálogo vinculado ao código do fornecedor (cProd da NF-e).")
            .Produces<ProdutoFornecedorDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        var escrita = group.MapGroup("/")
            .RequireAuthorization(Politicas.Gestao)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        escrita.MapPost("/", async (CriarFornecedor comando, IFornecedorService fornecedores, CancellationToken ct) =>
                (await fornecedores.CreateAsync(comando, ct)).ToHttpResult(f => TypedResults.CreatedAtRoute(f, ObterFornecedorRoute, new { id = f.Id })))
            .WithName("CriarFornecedor")
            .WithSummary("CNPJ numérico ou alfanumérico, com ou sem máscara. CNPJ repetido: 409.")
            .Produces<FornecedorDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict);

        escrita.MapPut("/{id:guid}", async (Guid id, AtualizarFornecedor comando, IFornecedorService fornecedores, CancellationToken ct) =>
                (await fornecedores.UpdateAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("AtualizarFornecedor")
            .WithSummary("Exige a versão lida. O CNPJ não muda. Se o fornecedor mudou desde então, responde 409.")
            .Produces<FornecedorDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict);

        escrita.MapDelete("/{id:guid}", async (Guid id, IFornecedorService fornecedores, CancellationToken ct) =>
                (await fornecedores.DeleteAsync(id, ct)).ToNoContent())
            .WithName("ExcluirFornecedor")
            .WithSummary("Só exclui fornecedor sem produtos vinculados (senão, 422).")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        escrita.MapPost("/{id:guid}/produtos", async (Guid id, CriarProdutoFornecedor comando, IFornecedorService fornecedores, ClaimsPrincipal user, CancellationToken ct) =>
                (await fornecedores.CreateProdutoAsync(id, comando, user.GetUsuarioId(), ct))
                    .ToHttpResult(v => TypedResults.Created($"/api/v1/fornecedores/{id}/produtos/codigo/{Uri.EscapeDataString(v.CodigoFornecedor)}", v)))
            .WithName("VincularProdutoAoFornecedor")
            .WithSummary("Confirma o de-para do código do fornecedor para um produto e uma embalagem. Sem fator, vale o da embalagem.")
            .Produces<ProdutoFornecedorDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        escrita.MapPut("/{id:guid}/produtos/{vinculoId:guid}", async (Guid id, Guid vinculoId, AtualizarProdutoFornecedor comando, IFornecedorService fornecedores, ClaimsPrincipal user, CancellationToken ct) =>
                (await fornecedores.UpdateProdutoAsync(id, vinculoId, comando, user.GetUsuarioId(), ct)).ToHttpResult(TypedResults.Ok))
            .WithName("AtualizarProdutoDoFornecedor")
            .WithSummary("Exige a versão lida. A nova confirmação fica com o usuário logado.")
            .Produces<ProdutoFornecedorDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        escrita.MapDelete("/{id:guid}/produtos/{vinculoId:guid}", async (Guid id, Guid vinculoId, IFornecedorService fornecedores, CancellationToken ct) =>
                (await fornecedores.DeleteProdutoAsync(id, vinculoId, ct)).ToNoContent())
            .WithName("DesvincularProdutoDoFornecedor")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound);

        return app;
    }
}
