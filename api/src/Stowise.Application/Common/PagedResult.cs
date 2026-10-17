namespace Stowise.Application.Common;

public sealed record PagedResult<T>(IReadOnlyList<T> Itens, int Pagina, int TamanhoPagina, int Total)
{
    public int TotalPaginas => TamanhoPagina == 0 ? 0 : (int)Math.Ceiling(Total / (double)TamanhoPagina);
}

public static class Paging
{
    public const int DefaultPageSize = 20;
    public const int MaxPageSize = 100;

    /// <summary>Página mínima 1; tamanho entre 1 e <see cref="MaxPageSize"/>, padrão <see cref="DefaultPageSize"/>.</summary>
    public static (int Pagina, int TamanhoPagina) Normalize(int? pagina, int? tamanhoPagina) =>
        (Math.Max(pagina ?? 1, 1), Math.Clamp(tamanhoPagina ?? DefaultPageSize, 1, MaxPageSize));
}
