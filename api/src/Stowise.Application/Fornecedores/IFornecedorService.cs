using Stowise.Application.Common;
using Stowise.Domain.Catalogo;

namespace Stowise.Application.Fornecedores;

/// <summary>Fornecedores e o de-para dos códigos deles (cProd da NF-e) para os produtos do catálogo.</summary>
public interface IFornecedorService
{
    Task<PagedResult<FornecedorResumo>> ListAsync(FornecedorFiltro filtro, CancellationToken cancellationToken = default);

    Task<Result<FornecedorDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result<FornecedorDetalhe>> CreateAsync(CriarFornecedor comando, CancellationToken cancellationToken = default);

    /// <summary>Exige a <see cref="FornecedorDetalhe.Versao"/> lida; se o fornecedor mudou desde então, devolve conflito.</summary>
    Task<Result<FornecedorDetalhe>> UpdateAsync(Guid id, AtualizarFornecedor comando, CancellationToken cancellationToken = default);

    /// <summary>Só exclui fornecedor sem produtos vinculados.</summary>
    Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default);

    Task<Result<PagedResult<ProdutoFornecedorDetalhe>>> ListProdutosAsync(
        Guid fornecedorId,
        ProdutoFornecedorFiltro filtro,
        CancellationToken cancellationToken = default);

    /// <summary>Vínculo pelo código do fornecedor (cProd), como a NF-e traz.</summary>
    Task<Result<ProdutoFornecedorDetalhe>> FindProdutoByCodigoAsync(Guid fornecedorId, string? codigo, CancellationToken cancellationToken = default);

    /// <summary>Grava o vínculo confirmado por <paramref name="usuarioId"/>.</summary>
    Task<Result<ProdutoFornecedorDetalhe>> CreateProdutoAsync(
        Guid fornecedorId,
        CriarProdutoFornecedor comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default);

    /// <summary>Exige a versão lida. A nova confirmação passa a ser de <paramref name="usuarioId"/>.</summary>
    Task<Result<ProdutoFornecedorDetalhe>> UpdateProdutoAsync(
        Guid fornecedorId,
        Guid vinculoId,
        AtualizarProdutoFornecedor comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default);

    Task<Result> DeleteProdutoAsync(Guid fornecedorId, Guid vinculoId, CancellationToken cancellationToken = default);
}

/// <param name="Busca">Parte do CNPJ (com ou sem máscara), da razão social ou do nome fantasia.</param>
public sealed record FornecedorFiltro(string? Busca, int? Pagina, int? TamanhoPagina);

/// <param name="Cnpj">CNPJ sem máscara (14 caracteres).</param>
public sealed record FornecedorResumo(Guid Id, string Cnpj, string RazaoSocial, string? NomeFantasia, int ProdutosVinculados);

public sealed record FornecedorDetalhe(Guid Id, string Cnpj, string RazaoSocial, string? NomeFantasia, int ProdutosVinculados, uint Versao);

/// <param name="Cnpj">Numérico ou alfanumérico, com ou sem máscara.</param>
public sealed record CriarFornecedor(string? Cnpj, string? RazaoSocial, string? NomeFantasia);

/// <summary>O CNPJ não muda: para outro CNPJ, cadastre outro fornecedor.</summary>
public sealed record AtualizarFornecedor(string? RazaoSocial, string? NomeFantasia, uint? Versao);

/// <param name="Busca">Parte do código do fornecedor, do SKU ou da descrição do produto.</param>
public sealed record ProdutoFornecedorFiltro(string? Busca, int? Pagina, int? TamanhoPagina);

/// <param name="FatorConversao">Unidades base do produto em 1 unidade do fornecedor.</param>
public sealed record ProdutoFornecedorDetalhe(
    Guid Id,
    Guid FornecedorId,
    string CodigoFornecedor,
    Guid ProdutoId,
    string Sku,
    string Descricao,
    string UnidadeBase,
    Guid EmbalagemId,
    TipoEmbalagem TipoEmbalagem,
    string UnidadeFornecedor,
    decimal FatorConversao,
    Guid ConfirmadoPor,
    DateTimeOffset ConfirmadoEm,
    uint Versao);

/// <param name="CodigoFornecedor">Código do produto no fornecedor (cProd da NF-e).</param>
/// <param name="UnidadeFornecedor">Unidade comercial do fornecedor (uCom), ex.: CX.</param>
/// <param name="FatorConversao">Unidades base em 1 unidade do fornecedor. Vazio: o fator da embalagem.</param>
public sealed record CriarProdutoFornecedor(
    string? CodigoFornecedor,
    Guid? ProdutoId,
    Guid? EmbalagemId,
    string? UnidadeFornecedor,
    decimal? FatorConversao);

/// <param name="FatorConversao">Unidades base em 1 unidade do fornecedor. Vazio: o fator da embalagem.</param>
public sealed record AtualizarProdutoFornecedor(
    Guid? ProdutoId,
    Guid? EmbalagemId,
    string? UnidadeFornecedor,
    decimal? FatorConversao,
    uint? Versao);
