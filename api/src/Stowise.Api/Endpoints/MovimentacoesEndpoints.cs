using System.Security.Claims;
using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Estoque;

namespace Stowise.Api.Endpoints;

/// <summary>Movimentações de estoque: único caminho para alterar o saldo (ADR-0001).</summary>
public static class MovimentacoesEndpoints
{
    private const string ObterMovimentacaoRoute = "ObterMovimentacao";

    public static IEndpointRouteBuilder MapMovimentacoesEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/movimentacoes")
            .WithTags("Estoque")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        group.MapGet("/{id:guid}", async (Guid id, IMovimentacaoService movimentacoes, CancellationToken ct) =>
                (await movimentacoes.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok))
            .WithName(ObterMovimentacaoRoute)
            .Produces<MovimentacaoDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        group.MapPost("/entradas", async (RegistrarEntrada comando, IMovimentacaoService movimentacoes, ClaimsPrincipal user, CancellationToken ct) =>
                Created(await movimentacoes.RegistrarEntradaAsync(comando, user.GetUsuarioId(), ct)))
            .WithName("RegistrarEntrada")
            .WithSummary("Entrada num endereço. Quantidade na embalagem informada (ou na unidade base).")
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPost("/saidas", async (RegistrarSaida comando, IMovimentacaoService movimentacoes, ClaimsPrincipal user, CancellationToken ct) =>
                Created(await movimentacoes.RegistrarSaidaAsync(comando, user.GetUsuarioId(), ct)))
            .WithName("RegistrarSaida")
            .WithSummary("Saída de um endereço. Exige saldo disponível.")
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPost("/ajustes", async (RegistrarAjuste comando, IMovimentacaoService movimentacoes, ClaimsPrincipal user, CancellationToken ct) =>
                Created(await movimentacoes.RegistrarAjusteAsync(comando, user.GetUsuarioId(), ct)))
            .WithName("RegistrarAjuste")
            .WithSummary("Correção do saldo com motivo. Só Admin e Gestor.")
            .RequireAuthorization(Politicas.Gestao)
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        return app;
    }

    private static IResult Created(Application.Common.Result<MovimentacaoDetalhe> result) =>
        result.ToHttpResult(m => TypedResults.CreatedAtRoute(m, ObterMovimentacaoRoute, new { id = m.Id }));
}
