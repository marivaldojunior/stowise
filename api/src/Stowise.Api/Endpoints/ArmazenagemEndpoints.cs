using System.Security.Claims;
using Stowise.Api.Common;
using Stowise.Application.Armazenagem;
using Stowise.Application.Auth;

namespace Stowise.Api.Endpoints;

/// <summary>Motor de armazenagem (SPEC, 2.3): sugestão de endereços e pesos das regras. Algorítmico, sem LLM.</summary>
public static class ArmazenagemEndpoints
{
    public static IEndpointRouteBuilder MapArmazenagemEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/armazenagem")
            .WithTags("Armazenagem")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        // Qualquer perfil: o operador pede a sugestão no app. Só calcula; nada é gravado.
        group.MapPost("/sugestoes", async (PedidoSugestaoArmazenagem pedido, IArmazenagemService armazenagem, CancellationToken ct) =>
                (await armazenagem.SugerirAsync(pedido, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("SugerirEnderecos")
            .WithSummary("Endereços para guardar o produto, da maior para a menor pontuação, com a nota e a explicação de cada regra. Endereços recusados por zona ou capacidade vêm com os motivos.")
            .Produces<SugestaoArmazenagem>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        var regras = group.MapGroup("/regras").RequireAuthorization(Politicas.Gestao).ProducesProblem(StatusCodes.Status403Forbidden);

        regras.MapGet("/", async (IArmazenagemService armazenagem, CancellationToken ct) =>
                TypedResults.Ok(await armazenagem.ListRegrasAsync(ct)))
            .WithName("ListarRegrasArmazenagem")
            .Produces<IReadOnlyList<RegraArmazenagemDetalhe>>();

        regras.MapPut("/{codigo}", async (string codigo, AlterarRegraArmazenagem comando, IArmazenagemService armazenagem, ClaimsPrincipal user, CancellationToken ct) =>
                (await armazenagem.UpdateRegraAsync(codigo, comando, user.GetUsuarioId(), ct)).ToHttpResult(TypedResults.Ok))
            .WithName("AlterarRegraArmazenagem")
            .WithSummary("Muda peso, estado e parâmetros. Uma regra restritiva inativa continua recusando endereços. Exige a versão lida (409 se mudou).")
            .Produces<RegraArmazenagemDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        return app;
    }
}
