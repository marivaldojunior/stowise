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
            .WithSummary("Envia um arquivo de produtos (CSV ou TXT, delimitado ou posicional, ou planilha .xlsx). Detecta o layout e guarda o original.")
            .Produces<ImportacaoDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapGet("/produtos/campos", () => TypedResults.Ok(CamposImportacao.Produtos))
            .WithName("ListarCamposImportacaoProdutos")
            .WithSummary("Campos de destino da importação de produtos, para montar o mapeamento.")
            .Produces<IReadOnlyList<CampoImportacao>>();

        group.MapPut("/{id:guid}/mapeamento", async (Guid id, ConfirmarMapeamento comando, IImportacaoService importacoes, ClaimsPrincipal user, CancellationToken ct) =>
                (await importacoes.ConfirmarMapeamentoAsync(id, comando, user.GetUsuarioId(), ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ConfirmarMapeamentoImportacao")
            .WithSummary("Confirma qual coluna preenche cada campo e valida as linhas (staging). Com salvarTemplate, o próximo arquivo igual já chega mapeado.")
            .Produces<ImportacaoDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapGet("/{id:guid}/linhas", ListLinhasAsync)
            .WithName("ListarLinhasImportacao")
            .WithSummary("Linhas do staging na ordem do arquivo, com valores normalizados, erros e a ação prevista.")
            .Produces<PagedResult<ImportacaoLinhaDetalhe>>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        MapTemplates(group.MapGroup("/templates"));
        return app;
    }

    private static void MapTemplates(RouteGroupBuilder templates)
    {
        templates.MapGet("/", async (ITemplateImportacaoService servico, TipoImportacao? tipo, int? pagina, int? tamanhoPagina, CancellationToken ct) =>
                TypedResults.Ok(await servico.ListAsync(new TemplateFiltro(tipo, pagina, tamanhoPagina), ct)))
            .WithName("ListarTemplatesImportacao")
            .Produces<PagedResult<TemplateDetalhe>>();

        templates.MapGet("/{id:guid}", async (Guid id, ITemplateImportacaoService servico, CancellationToken ct) =>
                (await servico.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ObterTemplateImportacao")
            .Produces<TemplateDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        templates.MapPut("/{id:guid}", async (Guid id, RenomearTemplate comando, ITemplateImportacaoService servico, CancellationToken ct) =>
                (await servico.RenameAsync(id, comando, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("RenomearTemplateImportacao")
            .Produces<TemplateDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status409Conflict)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        templates.MapDelete("/{id:guid}", async (Guid id, ITemplateImportacaoService servico, CancellationToken ct) =>
                (await servico.DeleteAsync(id, ct)).ToNoContent())
            .WithName("ExcluirTemplateImportacao")
            .WithSummary("Exclui o template. As importações que o usaram mantêm o mapeamento confirmado.")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound);
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

    private static async Task<IResult> ListLinhasAsync(
        Guid id,
        IImportacaoService importacoes,
        StatusLinha? status,
        AcaoLinha? acao,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        (await importacoes.ListLinhasAsync(id, new LinhaFiltro(status, acao, pagina, tamanhoPagina), ct)).ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> ListAsync(
        IImportacaoService importacoes,
        TipoImportacao? tipo,
        StatusImportacao? status,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        TypedResults.Ok(await importacoes.ListAsync(new ImportacaoFiltro(tipo, status, pagina, tamanhoPagina), ct));
}
