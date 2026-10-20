using Stowise.Application.Common;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estrutura;

namespace Stowise.Application.Catalogo;

public interface IProdutoService
{
    Task<PagedResult<ProdutoResumo>> ListAsync(ProdutoFiltro filtro, CancellationToken cancellationToken = default);

    Task<Result<ProdutoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>Busca pelo código lido no app: GTIN de qualquer embalagem, EPC SGTIN-96 em hexadecimal ou SKU.</summary>
    Task<Result<ProdutoPorCodigo>> FindByCodigoAsync(string? codigo, CancellationToken cancellationToken = default);

    Task<Result<ProdutoDetalhe>> CreateAsync(CriarProduto comando, CancellationToken cancellationToken = default);

    /// <summary>Exige a <see cref="ProdutoDetalhe.Versao"/> lida; se o produto mudou desde então, devolve conflito.</summary>
    Task<Result<ProdutoDetalhe>> UpdateAsync(Guid id, AtualizarProduto comando, CancellationToken cancellationToken = default);

    Task<Result> DeactivateAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result> ReactivateAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result<ProdutoDetalhe>> AddEmbalagemAsync(Guid produtoId, AdicionarEmbalagem comando, CancellationToken cancellationToken = default);

    Task<Result<ProdutoDetalhe>> UpdateEmbalagemAsync(
        Guid produtoId,
        Guid embalagemId,
        EmbalagemMedidas comando,
        CancellationToken cancellationToken = default);

    Task<Result<ProdutoDetalhe>> RemoveEmbalagemAsync(Guid produtoId, Guid embalagemId, CancellationToken cancellationToken = default);
}

public sealed record ProdutoFiltro(string? Busca, Guid? CategoriaId, bool? Ativo, int? Pagina, int? TamanhoPagina);

public sealed record ProdutoResumo(
    Guid Id,
    string Sku,
    string Descricao,
    string UnidadeBase,
    ClasseArmazenagem ClasseArmazenagem,
    Guid? CategoriaId,
    bool Ativo);

public sealed record ProdutoDetalhe(
    Guid Id,
    string Sku,
    string Descricao,
    string UnidadeBase,
    ClasseArmazenagem ClasseArmazenagem,
    bool ControlaLote,
    bool ControlaValidade,
    string? Ncm,
    string? Cest,
    Guid? CategoriaId,
    bool Ativo,
    uint Versao,
    IReadOnlyList<EmbalagemDetalhe> Embalagens);

public sealed record EmbalagemDetalhe(
    Guid Id,
    TipoEmbalagem Tipo,
    decimal FatorConversao,
    bool UnidadeBase,
    string? Gtin,
    decimal? PesoKg,
    decimal? AlturaCm,
    decimal? LarguraCm,
    decimal? ComprimentoCm);

/// <param name="EmbalagemId">Embalagem do GTIN lido; quando a busca casou pelo SKU, é a unidade base.</param>
public sealed record ProdutoPorCodigo(ProdutoDetalhe Produto, Guid EmbalagemId);

/// <summary>GTIN, peso e medidas de uma embalagem. Nulos ficam para completar depois.</summary>
public sealed record EmbalagemMedidas(string? Gtin, decimal? PesoKg, decimal? AlturaCm, decimal? LarguraCm, decimal? ComprimentoCm);

public sealed record CriarProduto(
    string? Sku,
    string? Descricao,
    string? UnidadeBase,
    ClasseArmazenagem? ClasseArmazenagem,
    bool ControlaLote,
    bool ControlaValidade,
    string? Ncm,
    string? Cest,
    Guid? CategoriaId,
    EmbalagemMedidas? EmbalagemBase);

public sealed record AtualizarProduto(
    string? Descricao,
    string? UnidadeBase,
    ClasseArmazenagem? ClasseArmazenagem,
    bool ControlaLote,
    bool ControlaValidade,
    string? Ncm,
    string? Cest,
    Guid? CategoriaId,
    uint? Versao);

public sealed record AdicionarEmbalagem(
    TipoEmbalagem? Tipo,
    decimal? FatorConversao,
    string? Gtin,
    decimal? PesoKg,
    decimal? AlturaCm,
    decimal? LarguraCm,
    decimal? ComprimentoCm);
