using System.Security.Claims;
using Stowise.Api.Common;
using Stowise.Application.Estoque;

namespace Stowise.Api.Endpoints;

/// <summary>Reservas: comprometem parte de um saldo sem movimentar estoque; a saída que consome a reserva baixa o saldo.</summary>
public static class ReservasEndpoints
{
    private const string ObterReservaRoute = "ObterReserva";

    public static IEndpointRouteBuilder MapReservasEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/reservas")
            .WithTags("Estoque")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        group.MapGet("/{id:guid}", async (Guid id, IReservaService reservas, CancellationToken ct) =>
                (await reservas.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok))
            .WithName(ObterReservaRoute)
            .Produces<ReservaDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        group.MapPost("/", async (CriarReserva comando, IReservaService reservas, ClaimsPrincipal user, CancellationToken ct) =>
                (await reservas.CreateAsync(comando, user.GetUsuarioId(), ct))
                    .ToHttpResult(r => TypedResults.CreatedAtRoute(r, ObterReservaRoute, new { id = r.Id })))
            .WithName("CriarReserva")
            .WithSummary("Reserva parte do saldo disponível de um endereço (unidade base).")
            .Produces<ReservaDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPost("/{id:guid}/cancelar", async (Guid id, IReservaService reservas, ClaimsPrincipal user, CancellationToken ct) =>
                (await reservas.CancelAsync(id, user.GetUsuarioId(), ct)).ToHttpResult(TypedResults.Ok))
            .WithName("CancelarReserva")
            .Produces<ReservaDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPost("/{id:guid}/consumir", async (Guid id, ConsumirReserva comando, IMovimentacaoService movimentacoes, ClaimsPrincipal user, HttpContext http, CancellationToken ct) =>
                MovimentacoesEndpoints.Registrada(await movimentacoes.ConsumirReservaAsync(id, comando, user.GetUsuarioId(), ct), http))
            .WithName("ConsumirReserva")
            .WithSummary("Saída que consome a reserva: baixa o saldo e encerra a reserva na mesma transação.")
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status201Created)
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status200OK)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        return app;
    }
}
