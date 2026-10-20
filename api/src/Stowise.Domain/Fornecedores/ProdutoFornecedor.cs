using Stowise.Domain.Common;

namespace Stowise.Domain.Fornecedores;

/// <summary>
/// De-para do código do fornecedor (cProd da NF-e) para um produto e uma embalagem do catálogo. Único por fornecedor e
/// código. Só existe depois da confirmação de uma pessoa (SPEC, decisão 7): guarda quem confirmou e quando.
/// </summary>
public sealed class ProdutoFornecedor : Entity
{
    /// <summary>Tamanho do cProd na NF-e 4.00.</summary>
    public const int CodigoFornecedorMaxLength = 60;

    /// <summary>Tamanho do uCom na NF-e 4.00.</summary>
    public const int UnidadeFornecedorMaxLength = 6;

    private ProdutoFornecedor()
    {
    }

    public Guid FornecedorId { get; private set; }

    public string CodigoFornecedor { get; private set; } = null!;

    public Guid ProdutoId { get; private set; }

    public Guid EmbalagemId { get; private set; }

    /// <summary>Unidade comercial do fornecedor (ex.: CX, FD, UN), como vem na nota.</summary>
    public string UnidadeFornecedor { get; private set; } = null!;

    /// <summary>Unidades base do produto em 1 unidade do fornecedor (ex.: caixa com 12 → 12).</summary>
    public decimal FatorConversao { get; private set; }

    public Guid ConfirmadoPor { get; private set; }

    public DateTimeOffset ConfirmadoEm { get; private set; }

    /// <summary>Versão para concorrência otimista (coluna xmin do PostgreSQL).</summary>
    public uint Versao { get; private set; }

    public static ProdutoFornecedor Create(
        Guid fornecedorId,
        string codigoFornecedor,
        Guid produtoId,
        Guid embalagemId,
        string unidadeFornecedor,
        decimal fatorConversao,
        Guid confirmadoPor,
        DateTimeOffset confirmadoEm)
    {
        var vinculo = new ProdutoFornecedor
        {
            FornecedorId = fornecedorId,
            CodigoFornecedor = Guard.Required(codigoFornecedor, "Código do fornecedor", CodigoFornecedorMaxLength),
        };
        vinculo.Update(produtoId, embalagemId, unidadeFornecedor, fatorConversao, confirmadoPor, confirmadoEm);
        return vinculo;
    }

    /// <summary>Troca o produto ou a conversão. Uma nova confirmação substitui a anterior.</summary>
    public void Update(
        Guid produtoId,
        Guid embalagemId,
        string unidadeFornecedor,
        decimal fatorConversao,
        Guid confirmadoPor,
        DateTimeOffset confirmadoEm)
    {
        if (produtoId == Guid.Empty || embalagemId == Guid.Empty)
        {
            throw new DomainException("Informe o produto e a embalagem do catálogo.");
        }

        if (confirmadoPor == Guid.Empty)
        {
            throw new DomainException("O vínculo precisa da confirmação de um usuário.");
        }

        ProdutoId = produtoId;
        EmbalagemId = embalagemId;
        UnidadeFornecedor = Guard.Required(unidadeFornecedor, "Unidade do fornecedor", UnidadeFornecedorMaxLength).ToUpperInvariant();
        FatorConversao = Guard.Positive(fatorConversao, "Fator de conversão");
        ConfirmadoPor = confirmadoPor;
        ConfirmadoEm = confirmadoEm;
    }
}
