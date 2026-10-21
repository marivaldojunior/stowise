using System.Security.Claims;
using Stowise.Api.Common;
using Stowise.Application.Common;
using Stowise.Application.Recebimentos;
using Stowise.Domain.Recebimentos;

namespace Stowise.Api.Endpoints;

/// <summary>Recebimentos das NF-e efetivadas e a conferência física (SPEC, 2.3). Qualquer perfil: o operador confere no app.</summary>
public static class RecebimentosEndpoints
{
    public static IEndpointRouteBuilder MapRecebimentosEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/recebimentos")
            .WithTags("Recebimentos")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        group.MapGet("/", async (IRecebimentoService recebimentos, StatusRecebimento? status, string? busca, int? pagina, int? tamanhoPagina, CancellationToken ct) =>
                TypedResults.Ok(await recebimentos.ListAsync(new RecebimentoFiltro(status, busca, pagina, tamanhoPagina), ct)))
            .WithName("ListarRecebimentos")
            .WithSummary("Mais recentes primeiro. Busca por parte da chave de acesso, pelo número da nota ou por parte da razão social do fornecedor.")
            .Produces<PagedResult<RecebimentoResumo>>();

        group.MapGet("/{id:guid}", async (Guid id, IRecebimentoService recebimentos, CancellationToken ct) =>
                (await recebimentos.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ObterRecebimento")
            .Produces<RecebimentoDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        group.MapPost("/{id:guid}/conferencia/inicio", async (Guid id, AlterarRecebimento comando, IRecebimentoService recebimentos, CancellationToken ct) =>
                (await recebimentos.StartConferenciaAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("IniciarConferenciaRecebimento")
            .WithSummary("A mercadoria chegou: marca a chegada e libera a contagem. Exige a versão lida (409 se mudou).")
            .Produces<RecebimentoDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPut("/{id:guid}/itens/{itemId:guid}/conferencia", async (Guid id, Guid itemId, ConferirItemRecebimento comando, IRecebimentoService recebimentos, ClaimsPrincipal user, CancellationToken ct) =>
                (await recebimentos.ConferirItemAsync(id, itemId, comando, user.GetUsuarioId(), ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ConferirItemRecebimento")
            .WithSummary("Registra ou corrige a contagem de um item, na unidade da nota, com os lotes. A diferença com a nota fica marcada como divergência.")
            .Produces<RecebimentoDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPost("/{id:guid}/conferencia/conclusao", async (Guid id, AlterarRecebimento comando, IRecebimentoService recebimentos, ClaimsPrincipal user, CancellationToken ct) =>
                (await recebimentos.FinishConferenciaAsync(id, comando, user.GetUsuarioId(), ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ConcluirConferenciaRecebimento")
            .WithSummary("Fecha a conferência quando todos os itens foram contados. Exige a versão lida (409 se mudou).")
            .Produces<RecebimentoDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        return app;
    }
}
