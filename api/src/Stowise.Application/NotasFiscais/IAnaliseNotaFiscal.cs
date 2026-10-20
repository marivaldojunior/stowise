using Stowise.Application.Catalogo;
using Stowise.Application.Common;
using Stowise.Domain.Catalogo;

namespace Stowise.Application.NotasFiscais;

/// <summary>
/// Lê a NF-e e casa cada item com o catálogo, nesta ordem: de-para do fornecedor, GTIN, similaridade da descrição
/// (SPEC, 2.2). Não grava nada: o resultado é a proposta que uma pessoa revisa antes da efetivação.
/// </summary>
public interface IAnaliseNotaFiscal
{
    Task<Result<AnaliseNotaFiscal>> AnalyzeAsync(Stream xml, CancellationToken cancellationToken = default);
}

/// <summary>Como o item da nota foi ligado ao catálogo.</summary>
public enum OrigemCasamento
{
    /// <summary>O código do fornecedor (cProd) já tem vínculo confirmado.</summary>
    DePara,

    /// <summary>O GTIN da nota é o de uma embalagem do catálogo. Ainda falta confirmar o vínculo.</summary>
    Gtin,

    /// <summary>Só há candidatos parecidos pela descrição: uma pessoa escolhe (IA só sugere).</summary>
    Similaridade,

    /// <summary>Nenhum candidato: o produto provavelmente é novo no catálogo.</summary>
    SemCandidato,
}

/// <param name="Autorizada">A nota traz o protocolo de autorização (cStat 100 ou 150).</param>
public sealed record AnaliseNotaFiscal(
    string ChaveAcesso,
    int Numero,
    int Serie,
    DateTimeOffset DataEmissao,
    bool Autorizada,
    FornecedorDaNota Fornecedor,
    IReadOnlyList<ItemAnalisado> Itens);

/// <param name="FornecedorId">Fornecedor cadastrado com o CNPJ do emitente; nulo quando é novo.</param>
public sealed record FornecedorDaNota(Guid? FornecedorId, string? Cnpj, string? Cpf, string RazaoSocial, string? NomeFantasia);

/// <param name="Casamento">Produto e embalagem ligados por de-para ou GTIN; nulo na similaridade e sem candidato.</param>
/// <param name="Sugestoes">Candidatos pela descrição, só quando não houve de-para nem GTIN.</param>
/// <param name="RequerConfirmacao">Falso só no de-para (já confirmado antes); os outros casos esperam uma pessoa.</param>
public sealed record ItemAnalisado(
    ItemNota Item,
    OrigemCasamento Origem,
    CasamentoItem? Casamento,
    MetodoSimilaridade? MetodoSugestoes,
    IReadOnlyList<ProdutoSimilar> Sugestoes,
    bool RequerConfirmacao);

/// <param name="ProdutoFornecedorId">Vínculo usado, no casamento por de-para.</param>
/// <param name="FatorConversao">Do de-para (unidades base por unidade do fornecedor) ou da embalagem do GTIN.</param>
public sealed record CasamentoItem(
    Guid ProdutoId,
    string Sku,
    string Descricao,
    Guid EmbalagemId,
    TipoEmbalagem TipoEmbalagem,
    decimal FatorConversao,
    Guid? ProdutoFornecedorId);
