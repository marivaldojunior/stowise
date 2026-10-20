using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Application.NotasFiscais;

namespace Stowise.Api.Endpoints;

/// <summary>NF-e de entrada (SPEC, 2.2). A análise não grava nada; a efetivação, com a revisão, vem depois. Só Admin e Gestor.</summary>
public static class NotasFiscaisEndpoints
{
    /// <summary>Uma NF-e com 990 itens fica bem abaixo disso.</summary>
    public const long TamanhoMaximoBytes = 5 * 1024 * 1024;

    public static IEndpointRouteBuilder MapNotasFiscaisEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/notas-fiscais")
            .WithTags("Notas fiscais")
            .RequireAuthorization(Politicas.Gestao)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        // Sem antiforgery: a API autentica pelo cabeçalho Authorization, não por cookie.
        group.MapPost("/analise", AnalyzeAsync)
            .DisableAntiforgery()
            .WithName("AnalisarNotaFiscal")
            .WithSummary("Lê o XML da NF-e 4.00 (schema, chave e protocolo) e casa cada item: de-para do fornecedor, GTIN e similaridade da descrição. Não grava nada.")
            .Produces<AnaliseNotaFiscal>()
            .ProducesValidationProblem();

        return app;
    }

    private static async Task<IResult> AnalyzeAsync(IFormFile? arquivo, IAnaliseNotaFiscal analise, CancellationToken ct)
    {
        if (arquivo is null || arquivo.Length == 0)
        {
            return AppError.Validation("arquivo", "Envie o XML da NF-e.").ToProblem();
        }

        if (arquivo.Length > TamanhoMaximoBytes)
        {
            return AppError.Validation("arquivo", $"O XML deve ter no máximo {TamanhoMaximoBytes / 1024 / 1024} MB.").ToProblem();
        }

        await using var xml = arquivo.OpenReadStream();
        return (await analise.AnalyzeAsync(xml, ct)).ToHttpResult(TypedResults.Ok);
    }
}
