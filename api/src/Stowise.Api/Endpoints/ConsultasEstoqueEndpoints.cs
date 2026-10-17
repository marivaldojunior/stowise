using Stowise.Api.Common;
using Stowise.Application.Common;
using Stowise.Application.Estoque;
using Stowise.Domain.Estoque;

namespace Stowise.Api.Endpoints;

/// <summary>Consultas de estoque, só leitura, para qualquer usuário autenticado.</summary>
public static class ConsultasEstoqueEndpoints
{
    public static IEndpointRouteBuilder MapConsultasEstoqueEndpoints(this IEndpointRouteBuilder app)
    {
        var saldos = app.MapGroup("/saldos")
            .WithTags("Estoque")
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        saldos.MapGet("/", ListSaldosAsync)
            .WithName("ListarSaldos")
            .WithSummary("Saldos atuais com reservado e disponível. Filtros por produto, endereço, lote, armazém e zona.")
            .Produces<PagedResult<SaldoItem>>();

        saldos.MapGet("/produtos/{produtoId:guid}", async (Guid produtoId, IConsultaEstoqueService consultas, CancellationToken ct) =>
                (await consultas.GetResumoProdutoAsync(produtoId, ct)).ToHttpResult(TypedResults.Ok))
            .WithName("ObterResumoSaldoProduto")
            .WithSummary("Total do produto em todos os endereços, com a divisão por lote.")
            .Produces<ResumoSaldoProduto>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        saldos.MapGet("/em-data", GetSaldoNaDataAsync)
            .WithName("ObterSaldoNaData")
            .WithSummary("Saldo numa data, calculado pelo livro-razão (OcorridoEm até a data).")
            .Produces<PagedResult<SaldoNaData>>()
            .ProducesValidationProblem();

        app.MapGet("/movimentacoes", GetExtratoAsync)
            .WithTags("Estoque")
            .WithName("ObterExtrato")
            .WithSummary("Extrato de movimentações, do mais recente para o mais antigo. O endereço vale como origem ou destino.")
            .Produces<PagedResult<ExtratoItem>>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        app.MapGet("/reservas", ListReservasAsync)
            .WithTags("Estoque")
            .WithName("ListarReservas")
            .Produces<PagedResult<ReservaDetalhe>>()
            .ProducesProblem(StatusCodes.Status401Unauthorized);

        return app;
    }

    private static async Task<IResult> ListSaldosAsync(
        IConsultaEstoqueService consultas,
        Guid? produtoId,
        Guid? enderecoId,
        Guid? loteId,
        Guid? armazemId,
        Guid? zonaId,
        bool? incluirZerados,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        TypedResults.Ok(await consultas.ListSaldosAsync(
            new SaldoFiltro(produtoId, enderecoId, loteId, armazemId, zonaId, incluirZerados ?? false, pagina, tamanhoPagina),
            ct));

    private static async Task<IResult> GetSaldoNaDataAsync(
        IConsultaEstoqueService consultas,
        DateTimeOffset? data,
        Guid? produtoId,
        Guid? enderecoId,
        Guid? armazemId,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        (await consultas.GetSaldoNaDataAsync(new SaldoNaDataFiltro(data, produtoId, enderecoId, armazemId, pagina, tamanhoPagina), ct))
            .ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> GetExtratoAsync(
        IConsultaEstoqueService consultas,
        Guid? produtoId,
        Guid? enderecoId,
        Guid? loteId,
        TipoMovimentacao? tipo,
        DateTimeOffset? de,
        DateTimeOffset? ate,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        (await consultas.GetExtratoAsync(new ExtratoFiltro(produtoId, enderecoId, loteId, tipo, de, ate, pagina, tamanhoPagina), ct))
            .ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> ListReservasAsync(
        IReservaService reservas,
        Guid? produtoId,
        Guid? enderecoId,
        StatusReserva? status,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct) =>
        TypedResults.Ok(await reservas.ListAsync(new ReservaFiltro(produtoId, enderecoId, status, pagina, tamanhoPagina), ct));
}
