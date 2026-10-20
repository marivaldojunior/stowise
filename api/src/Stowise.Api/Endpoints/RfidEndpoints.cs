using Stowise.Api.Common;
using Stowise.Application.Rfid;

namespace Stowise.Api.Endpoints;

/// <summary>Etiquetas RFID em SGTIN-96 (ADR-0010): leitura em lote e geração de EPCs para gravar. Vale para qualquer perfil.</summary>
public static class RfidEndpoints
{
    public static IEndpointRouteBuilder MapRfidEndpoints(this IEndpointRouteBuilder app)
    {
        var rfid = app.MapGroup("/rfid")
            .WithTags("RFID")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        rfid.MapPost("/leituras", async (ResolverLeiturasRfid comando, IRfidService servico, CancellationToken ct) =>
                (await servico.ResolveAsync(comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ResolverLeiturasRfid")
            .WithSummary("Resolve EPCs lidos (até 1000, repetidos contam uma vez) em produtos, embalagens e quantidades. Não grava nada.")
            .Produces<LeiturasRfidResolvidas>()
            .ProducesValidationProblem();

        rfid.MapPost("/etiquetas", async (GerarEtiquetasRfid comando, IRfidService servico, CancellationToken ct) =>
                (await servico.GenerateAsync(comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("GerarEtiquetasRfid")
            .WithSummary("Gera EPCs SGTIN-96 (até 500) para gravar nas etiquetas de uma embalagem com GTIN, com séries únicas.")
            .Produces<EtiquetasRfidGeradas>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        return app;
    }
}
