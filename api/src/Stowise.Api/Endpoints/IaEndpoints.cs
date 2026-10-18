using System.Security.Claims;
using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Application.Ia;
using Stowise.Domain.Ia;

namespace Stowise.Api.Endpoints;

/// <summary>Uso da IA (ADR-0004): registro de chamadas e cotas. O consumo próprio vale para qualquer usuário; o resto, só Admin.</summary>
public static class IaEndpoints
{
    public static IEndpointRouteBuilder MapIaEndpoints(this IEndpointRouteBuilder app)
    {
        var ia = app.MapGroup("/ia")
            .WithTags("IA")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        ia.MapGet("/cota", GetMinhaCotaAsync)
            .WithName("ObterMinhaCotaIa")
            .WithSummary("Cota de IA que vale para o usuário logado na funcionalidade e o consumo de hoje e do mês.")
            .Produces<UsoCotaIa>()
            .ProducesValidationProblem();

        var admin = ia.MapGroup("/")
            .RequireAuthorization(Perfis.Admin)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        admin.MapGet("/chamadas", ListChamadasAsync)
            .WithName("ListarChamadasIa")
            .WithSummary("Chamadas aos provedores de IA, mais recentes primeiro: modelo, tokens, custo estimado, latência e falhas.")
            .Produces<PagedResult<ChamadaIaDetalhe>>();

        admin.MapGet("/cotas", async (ICotaIaService cotas, CancellationToken ct) => TypedResults.Ok(await cotas.ListAsync(ct)))
            .WithName("ListarCotasIa")
            .WithSummary("Cotas de IA por perfil e exceções por usuário. Limite vazio: sem limite. Perfil sem cota: sem limite.")
            .Produces<IReadOnlyList<CotaIaDetalhe>>();

        admin.MapPost("/cotas", async (SalvarCotaIa comando, ICotaIaService cotas, CancellationToken ct) =>
                (await cotas.CreateAsync(comando, ct)).ToHttpResult(c => TypedResults.Created($"/api/v1/ia/cotas/{c.Id}", c)))
            .WithName("CriarCotaIa")
            .Produces<CotaIaDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        admin.MapPut("/cotas/{id:guid}", async (Guid id, AlterarLimitesCotaIa comando, ICotaIaService cotas, CancellationToken ct) =>
                (await cotas.UpdateAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("AlterarLimitesCotaIa")
            .Produces<CotaIaDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        admin.MapDelete("/cotas/{id:guid}", async (Guid id, ICotaIaService cotas, CancellationToken ct) =>
                (await cotas.DeleteAsync(id, ct)).ToNoContent())
            .WithName("ExcluirCotaIa")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound);

        return app;
    }

    private static async Task<IResult> GetMinhaCotaAsync(FuncionalidadeIa? funcionalidade, ICotaIaService cotas, ClaimsPrincipal user, CancellationToken ct) =>
        funcionalidade is { } escolhida
            ? TypedResults.Ok(await cotas.GetUsoAsync(user.GetUsuarioId(), escolhida, ct))
            : AppError.Validation("funcionalidade", $"Informe a funcionalidade: {string.Join(", ", Enum.GetNames<FuncionalidadeIa>())}.").ToProblem();

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
