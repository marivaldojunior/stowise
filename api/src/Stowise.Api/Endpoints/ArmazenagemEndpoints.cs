using System.Security.Claims;
using Stowise.Api.Common;
using Stowise.Application.Armazenagem;
using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Domain.Armazenagem;

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

        // Fila do operador e tela de divergências: qualquer perfil.
        var tarefas = group.MapGroup("/tarefas");

        tarefas.MapGet("/", async (ITarefaArmazenagemService servico, StatusTarefaArmazenagem? status, Guid? recebimentoId, int? pagina, int? tamanhoPagina, CancellationToken ct) =>
                TypedResults.Ok(await servico.ListAsync(new TarefaArmazenagemFiltro(status, recebimentoId, pagina, tamanhoPagina), ct)))
            .WithName("ListarTarefasArmazenagem")
            .WithSummary("Mais antigas primeiro. Tarefas nascem na conclusão da conferência, uma por item e lote contados.")
            .Produces<PagedResult<TarefaArmazenagemResumo>>();

        tarefas.MapGet("/{id:guid}", async (Guid id, ITarefaArmazenagemService servico, CancellationToken ct) =>
                (await servico.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ObterTarefaArmazenagem")
            .WithSummary("A tarefa com o snapshot da sugestão: nota, peso e explicação de cada regra.")
            .Produces<TarefaArmazenagemDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        tarefas.MapPost("/{id:guid}/confirmacao", async (Guid id, ConfirmarTarefaArmazenagem comando, ITarefaArmazenagemService servico, ClaimsPrincipal user, CancellationToken ct) =>
                (await servico.ConfirmAsync(id, comando, user.GetUsuarioId(), ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ConfirmarTarefaArmazenagem")
            .WithSummary("Registra onde a mercadoria foi guardada e faz a entrada no estoque. Fora do endereço sugerido, o motivo é obrigatório e a tarefa fica Divergente. Repetir a mesma confirmação não duplica a entrada.")
            .Produces<TarefaArmazenagemDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
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

        group.MapPost("/curva-abc", async (ICurvaAbcService curva, CancellationToken ct) => TypedResults.Ok(await curva.RecalcularAsync(ct)))
            .RequireAuthorization(Politicas.Gestao)
            .WithName("RecalcularCurvaAbc")
            .WithSummary("Recalcula agora a curva ABC (o job roda todo dia às 3h UTC): giro = número de saídas de cada produto nos últimos 90 dias. A até 80% do giro acumulado, B até 95%, o resto C.")
            .Produces<ResumoCurvaAbc>()
            .ProducesProblem(StatusCodes.Status403Forbidden);

        return app;
    }
}
