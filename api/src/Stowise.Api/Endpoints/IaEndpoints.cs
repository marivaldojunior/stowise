using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Application.Ia;
using Stowise.Domain.Ia;

namespace Stowise.Api.Endpoints;

/// <summary>Uso da IA (ADR-0004): o registro de chamadas, base do painel de custo e de cota. Só Admin.</summary>
public static class IaEndpoints
{
    public static IEndpointRouteBuilder MapIaEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/ia")
            .WithTags("IA")
            .RequireAuthorization(Perfis.Admin)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        group.MapGet("/chamadas", ListChamadasAsync)
            .WithName("ListarChamadasIa")
            .WithSummary("Chamadas aos provedores de IA, mais recentes primeiro: modelo, tokens, custo estimado, latência e falhas.")
            .Produces<PagedResult<ChamadaIaDetalhe>>();

        return app;
    }

    private static async Task<IResult> ListChamadasAsync(
        IConsultaIaService consultas,
        FuncionalidadeIa? funcionalidade,
        Guid? usuarioId,
        bool? sucesso,
        DateTimeOffset? de,
        DateTimeOffset? ate,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        TypedResults.Ok(await consultas.ListChamadasAsync(new ChamadaIaFiltro(funcionalidade, usuarioId, sucesso, de, ate, pagina, tamanhoPagina), ct));
}
