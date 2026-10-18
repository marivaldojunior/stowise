using System.Security.Claims;
using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Application.Importacoes;
using Stowise.Domain.Importacoes;

namespace Stowise.Api.Endpoints;

/// <summary>Importação de arquivos (SPEC, módulo 5). Só Admin e Gestor, porque a importação altera o cadastro.</summary>
public static class ImportacoesEndpoints
{
    private const string ObterImportacaoRoute = "ObterImportacao";

    public static IEndpointRouteBuilder MapImportacoesEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/importacoes")
            .WithTags("Importação")
            .RequireAuthorization(Politicas.Gestao)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        group.MapGet("/", ListAsync)
            .WithName("ListarImportacoes")
            .Produces<PagedResult<ImportacaoResumo>>();

        group.MapGet("/{id:guid}", async (Guid id, IImportacaoService importacoes, CancellationToken ct) =>
                (await importacoes.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok))
            .WithName(ObterImportacaoRoute)
            .Produces<ImportacaoDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        // Sem antiforgery: a API autentica pelo cabeçalho Authorization, não por cookie.
        group.MapPost("/produtos", ImportarProdutosAsync)
            .DisableAntiforgery()
            .WithName("ImportarProdutos")
            .WithSummary("Envia um arquivo de produtos (CSV ou TXT, delimitado ou posicional). Detecta o layout e guarda o original.")
            .Produces<ImportacaoDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        return app;
    }

    private static async Task<IResult> ImportarProdutosAsync(
        IFormFile? arquivo,
        IImportacaoService importacoes,
        ClaimsPrincipal user,
        CancellationToken ct)
    {
        if (arquivo is not null && arquivo.Length > ImportacaoValidation.TamanhoMaximoBytes)
        {
            return AppError.Validation("arquivo", ImportacaoValidation.MensagemTamanhoMaximo).ToProblem();
        }

        byte[]? conteudo = null;
        if (arquivo is not null)
        {
            await using var stream = arquivo.OpenReadStream();
            using var buffer = new MemoryStream((int)arquivo.Length);
            await stream.CopyToAsync(buffer, ct);
            conteudo = buffer.ToArray();
        }

        var comando = new ReceberArquivo(TipoImportacao.Produtos, arquivo?.FileName, conteudo);
        return (await importacoes.ReceberAsync(comando, user.GetUsuarioId(), ct))
            .ToHttpResult(i => TypedResults.CreatedAtRoute(i, ObterImportacaoRoute, new { id = i.Id }));
    }

    private static async Task<IResult> ListAsync(
        IImportacaoService importacoes,
        TipoImportacao? tipo,
        StatusImportacao? status,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        TypedResults.Ok(await importacoes.ListAsync(new ImportacaoFiltro(tipo, status, pagina, tamanhoPagina), ct));
}
