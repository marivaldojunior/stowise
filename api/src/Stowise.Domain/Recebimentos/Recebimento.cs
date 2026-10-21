using Stowise.Domain.Common;
using Stowise.Domain.NotasFiscais;

namespace Stowise.Domain.Recebimentos;

/// <summary>Andamento do recebimento: a conferência física (app) e a armazenagem vêm depois da efetivação da nota.</summary>
public enum StatusRecebimento
{
    /// <summary>Nota efetivada; a mercadoria ainda não foi conferida.</summary>
    AguardandoConferencia,
}

/// <summary>Lote informado na nota (rastro), com a quantidade já na unidade base. Imutável.</summary>
public sealed record LoteRecebido(string Numero, decimal QuantidadeBase, DateOnly? Fabricacao, DateOnly? Validade);

/// <summary>
/// Recebimento criado a partir de uma NF-e (SPEC, seção 4). A chave de acesso é única: a mesma nota não entra duas
/// vezes. Os itens guardam o que veio na nota separado do que foi convertido, para conferir divergências.
/// </summary>
public sealed class Recebimento : Entity
{
    private readonly List<RecebimentoItem> _itens = [];

    private Recebimento()
    {
    }

    public Guid FornecedorId { get; private set; }

    public string ChaveAcesso { get; private set; } = null!;

    public int Numero { get; private set; }

    public int Serie { get; private set; }

    public DateTimeOffset DataEmissao { get; private set; }

    public StatusRecebimento Status { get; private set; }

    /// <summary>Quando a mercadoria chegou ao armazém; preenchida na conferência.</summary>
    public DateTimeOffset? DataChegada { get; private set; }

    public Guid CriadoPor { get; private set; }

    public DateTimeOffset CriadoEm { get; private set; }

    /// <summary>Versão para concorrência otimista (coluna xmin do PostgreSQL).</summary>
    public uint Versao { get; private set; }

    public IReadOnlyCollection<RecebimentoItem> Itens => _itens.AsReadOnly();

    public static Recebimento Create(
        Guid fornecedorId,
        string chaveAcesso,
        int numero,
        int serie,
        DateTimeOffset dataEmissao,
        Guid criadoPor,
        DateTimeOffset agora)
    {
        if (!NotasFiscais.ChaveAcesso.TryParse(chaveAcesso, out var chave))
        {
            throw new DomainException("A chave de acesso da nota é inválida.");
        }

        if (fornecedorId == Guid.Empty || criadoPor == Guid.Empty)
        {
            throw new DomainException("O recebimento precisa do fornecedor e de quem efetivou a nota.");
        }

        if (numero <= 0)
        {
            throw new DomainException("O número da nota deve ser maior que zero.");
        }

        return new Recebimento
        {
            FornecedorId = fornecedorId,
            ChaveAcesso = chave.Valor,
            Numero = numero,
            Serie = serie,
            DataEmissao = dataEmissao,
            Status = StatusRecebimento.AguardandoConferencia,
            CriadoPor = criadoPor,
            CriadoEm = agora,
        };
    }

    /// <summary>Um item por nItem da nota.</summary>
    public RecebimentoItem AddItem(DadosItemRecebido dados)
    {
        ArgumentNullException.ThrowIfNull(dados);

        if (_itens.Exists(i => i.NumeroItem == dados.NumeroItem))
        {
            throw new DomainException($"O item {dados.NumeroItem} da nota já está no recebimento.");
        }

        var item = new RecebimentoItem(Id, dados);
        _itens.Add(item);
        return item;
    }
}

/// <param name="FatorConversao">Unidades base em 1 unidade comercial da nota.</param>
public sealed record DadosItemRecebido(
    int NumeroItem,
    Guid ProdutoId,
    Guid ProdutoFornecedorId,
    Guid EmbalagemId,
    string CodigoFornecedor,
    string DescricaoNota,
    string UnidadeNota,
    decimal QuantidadeNota,
    decimal FatorConversao,
    string Cfop,
    decimal ValorUnitario,
    IReadOnlyList<LoteRecebido> Lotes);

/// <summary>Item do recebimento: o produto do catálogo e a quantidade convertida, com o que veio na nota.</summary>
public sealed class RecebimentoItem : Entity
{
    public const int DescricaoNotaMaxLength = 120;
    public const int UnidadeNotaMaxLength = 6;
    public const int CfopLength = 4;

    private RecebimentoItem()
    {
    }

    internal RecebimentoItem(Guid recebimentoId, DadosItemRecebido dados)
    {
        if (dados.NumeroItem is < 1 or > 990)
        {
            throw new DomainException("O número do item da nota vai de 1 a 990.");
        }

        if (dados.ProdutoId == Guid.Empty || dados.EmbalagemId == Guid.Empty || dados.ProdutoFornecedorId == Guid.Empty)
        {
            throw new DomainException($"O item {dados.NumeroItem} precisa do produto, da embalagem e do vínculo do fornecedor.");
        }

        RecebimentoId = recebimentoId;
        NumeroItem = dados.NumeroItem;
        ProdutoId = dados.ProdutoId;
        ProdutoFornecedorId = dados.ProdutoFornecedorId;
        EmbalagemId = dados.EmbalagemId;
        CodigoFornecedor = Guard.Required(dados.CodigoFornecedor, "Código do fornecedor", 60);
        DescricaoNota = Guard.Required(dados.DescricaoNota, "Descrição da nota", DescricaoNotaMaxLength);
        UnidadeNota = Guard.Required(dados.UnidadeNota, "Unidade da nota", UnidadeNotaMaxLength);
        QuantidadeNota = Guard.Positive(dados.QuantidadeNota, "Quantidade da nota");
        FatorConversao = Guard.Positive(dados.FatorConversao, "Fator de conversão");
        Quantidade = Math.Round(QuantidadeNota * FatorConversao, 4, MidpointRounding.AwayFromZero);
        Cfop = dados.Cfop.Length == CfopLength && dados.Cfop.All(char.IsAsciiDigit)
            ? dados.Cfop
            : throw new DomainException($"O CFOP do item {dados.NumeroItem} deve ter 4 dígitos.");
        ValorUnitario = Guard.NotNegative(dados.ValorUnitario, "Valor unitário");
        Lotes = [.. dados.Lotes];
    }

    public Guid RecebimentoId { get; private set; }

    /// <summary>nItem da nota.</summary>
    public int NumeroItem { get; private set; }

    public Guid ProdutoId { get; private set; }

    public Guid ProdutoFornecedorId { get; private set; }

    public Guid EmbalagemId { get; private set; }

    public string CodigoFornecedor { get; private set; } = null!;

    public string DescricaoNota { get; private set; } = null!;

    /// <summary>uCom da nota.</summary>
    public string UnidadeNota { get; private set; } = null!;

    /// <summary>qCom da nota.</summary>
    public decimal QuantidadeNota { get; private set; }

    public decimal FatorConversao { get; private set; }

    /// <summary>Quantidade esperada na unidade base (qCom × fator).</summary>
    public decimal Quantidade { get; private set; }

    public string Cfop { get; private set; } = null!;

    /// <summary>vUnCom da nota.</summary>
    public decimal ValorUnitario { get; private set; }

    public IReadOnlyList<LoteRecebido> Lotes { get; private set; } = [];
}

/// <summary>XML original da NF-e, guardado para auditoria (SPEC, seção 4), numa tabela própria.</summary>
public sealed class XmlRecebimento : Entity
{
    private XmlRecebimento()
    {
    }

    public Guid RecebimentoId { get; private set; }

    public byte[] Conteudo { get; private set; } = [];

    public static XmlRecebimento Create(Recebimento recebimento, byte[] conteudo)
    {
        ArgumentNullException.ThrowIfNull(recebimento);
        ArgumentNullException.ThrowIfNull(conteudo);

        return conteudo.Length == 0
            ? throw new DomainException("O XML da nota está vazio.")
            : new XmlRecebimento { RecebimentoId = recebimento.Id, Conteudo = conteudo };
    }
}
