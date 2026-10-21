using Stowise.Application.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.Application.NotasFiscais;

/// <summary>
/// Efetiva a NF-e revisada (SPEC, 2.2): refaz a análise no servidor (não confia no cliente), aplica a decisão de uma
/// pessoa para cada item e grava, numa só operação, o fornecedor novo, os produtos novos, os de-para confirmados, o
/// recebimento com os itens e o XML original.
/// </summary>
public interface IEfetivacaoNotaFiscal
{
    /// <param name="usuarioId">Quem revisou: fica como quem confirmou os de-para e quem efetivou a nota.</param>
    Task<Result<NotaFiscalEfetivada>> EfetivarAsync(EfetivarNotaFiscal comando, Guid usuarioId, CancellationToken cancellationToken = default);
}

/// <summary>O que fazer com um item da nota.</summary>
public enum AcaoItemNota
{
    /// <summary>Aceita o casamento da análise (de-para ou GTIN).</summary>
    Confirmar,

    /// <summary>Liga o item a um produto e uma embalagem escolhidos (ex.: um candidato da similaridade).</summary>
    Vincular,

    /// <summary>Cria um produto novo com os dados da nota. Ele entra como Incompleto: a nota não traz peso nem medidas.</summary>
    CriarProduto,
}

/// <param name="Xml">O XML da NF-e, o mesmo enviado à análise.</param>
/// <param name="Itens">Uma decisão por item da nota.</param>
public sealed record EfetivarNotaFiscal(string? Xml, IReadOnlyList<DecisaoItemNota>? Itens);

/// <param name="NumeroItem">nItem da nota.</param>
/// <param name="ProdutoId">Obrigatório em <see cref="AcaoItemNota.Vincular"/>.</param>
/// <param name="EmbalagemId">Obrigatório em <see cref="AcaoItemNota.Vincular"/>; deve ser do produto.</param>
/// <param name="FatorConversao">Unidades base em 1 unidade comercial. Vazio: o fator inferido; obrigatório quando a análise não achou fator.</param>
/// <param name="NovoProduto">Obrigatório em <see cref="AcaoItemNota.CriarProduto"/>.</param>
public sealed record DecisaoItemNota(
    int NumeroItem,
    AcaoItemNota Acao,
    Guid? ProdutoId = null,
    Guid? EmbalagemId = null,
    decimal? FatorConversao = null,
    NovoProdutoNota? NovoProduto = null);

/// <param name="Descricao">Vazio: a descrição da nota (xProd).</param>
/// <param name="ClasseArmazenagem">Vazio: Normal.</param>
public sealed record NovoProdutoNota(string? Sku, string? Descricao, Guid? CategoriaId, ClasseArmazenagem? ClasseArmazenagem);

public sealed record NotaFiscalEfetivada(
    Guid RecebimentoId,
    Guid FornecedorId,
    bool FornecedorCriado,
    int ProdutosCriados,
    int VinculosCriados,
    int VinculosAtualizados,
    IReadOnlyList<ItemEfetivado> Itens);

/// <param name="Quantidade">Quantidade esperada na unidade base.</param>
public sealed record ItemEfetivado(int NumeroItem, Guid ProdutoId, Guid EmbalagemId, Guid ProdutoFornecedorId, decimal FatorConversao, decimal Quantidade);
