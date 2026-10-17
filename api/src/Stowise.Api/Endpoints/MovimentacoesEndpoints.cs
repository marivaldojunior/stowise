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

        group.MapPost("/entradas", async (RegistrarEntrada comando, IMovimentacaoService movimentacoes, ClaimsPrincipal user, HttpContext http, CancellationToken ct) =>
                Registrada(await movimentacoes.RegistrarEntradaAsync(comando, user.GetUsuarioId(), ct), http))
            .WithName("RegistrarEntrada")
            .WithSummary("Entrada num endereço. Quantidade na embalagem informada (ou na unidade base).")
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status201Created)
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPost("/saidas", async (RegistrarSaida comando, IMovimentacaoService movimentacoes, ClaimsPrincipal user, HttpContext http, CancellationToken ct) =>
                Registrada(await movimentacoes.RegistrarSaidaAsync(comando, user.GetUsuarioId(), ct), http))
            .WithName("RegistrarSaida")
            .WithSummary("Saída de um endereço. Exige saldo disponível.")
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status201Created)
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPost("/ajustes", async (RegistrarAjuste comando, IMovimentacaoService movimentacoes, ClaimsPrincipal user, HttpContext http, CancellationToken ct) =>
                Registrada(await movimentacoes.RegistrarAjusteAsync(comando, user.GetUsuarioId(), ct), http))
            .WithName("RegistrarAjuste")
            .WithSummary("Correção do saldo com motivo. Só Admin e Gestor.")
            .RequireAuthorization(Politicas.Gestao)
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status201Created)
            .Produces<MovimentacaoDetalhe>(StatusCodes.Status200OK)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status403Forbidden)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        return app;
    }

    /// <summary>Cabeçalho que marca o reenvio de uma operação já gravada (ADR-0006).</summary>
    public const string ReplayHeader = "Idempotent-Replayed";

    /// <summary>201 para uma operação nova; 200 com o cabeçalho de reenvio quando a chave de idempotência já foi usada.</summary>
    private static IResult Registrada(Application.Common.Result<MovimentacaoRegistrada> result, HttpContext http) =>
        result.ToHttpResult(r =>
        {
            if (!r.Repetida)
            {
                return TypedResults.CreatedAtRoute(r.Movimentacao, ObterMovimentacaoRoute, new { id = r.Movimentacao.Id });
            }

            http.Response.Headers[ReplayHeader] = "true";
            return TypedResults.Ok(r.Movimentacao);
        });
}
