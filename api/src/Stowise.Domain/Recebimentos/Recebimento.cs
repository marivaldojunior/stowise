using Stowise.Domain.Common;
using Stowise.Domain.NotasFiscais;

namespace Stowise.Domain.Recebimentos;

/// <summary>Andamento do recebimento: efetivação da nota → conferência física (app) → armazenagem.</summary>
public enum StatusRecebimento
{
    /// <summary>Nota efetivada; a mercadoria ainda não chegou ou não começou a ser conferida.</summary>
    AguardandoConferencia,

    /// <summary>A mercadoria chegou e está sendo contada, item a item.</summary>
    EmConferencia,

    /// <summary>Todos os itens foram contados; o próximo passo é a armazenagem.</summary>
    Conferido,
}

/// <summary>Lote contado na conferência, na unidade da nota (ex.: 6 CX do lote L1).</summary>
public sealed record LoteConferido(string? Numero, decimal Quantidade, DateOnly? Fabricacao, DateOnly? Validade);

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

    /// <summary>Quem concluiu a conferência.</summary>
    public Guid? ConferidoPor { get; private set; }

    public DateTimeOffset? ConferidoEm { get; private set; }

    /// <summary>Versão para concorrência otimista (coluna xmin do PostgreSQL).</summary>
    public uint Versao { get; private set; }

    public IReadOnlyCollection<RecebimentoItem> Itens => _itens.AsReadOnly();

    /// <summary>Algum item conferido difere da nota (quantidade ou lotes).</summary>
    public bool TemDivergencia => _itens.Exists(i => i.Divergente);

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
            // A nota traz o fuso do emitente (ex.: -03:00); o banco guarda instantes em UTC. O fuso original fica no XML.
            DataEmissao = dataEmissao.ToUniversalTime(),
            Status = StatusRecebimento.AguardandoConferencia,
            CriadoPor = criadoPor,
            CriadoEm = agora.ToUniversalTime(),
        };
    }

    /// <summary>A mercadoria chegou: começa a contagem. A data de chegada é a deste momento.</summary>
    public void StartConferencia(DateTimeOffset agora)
    {
        if (Status != StatusRecebimento.AguardandoConferencia)
        {
            throw new DomainException("A conferência deste recebimento já começou.");
        }

        Status = StatusRecebimento.EmConferencia;
        DataChegada = agora.ToUniversalTime();
    }

    /// <summary>Registra (ou corrige) a contagem de um item. Só durante a conferência.</summary>
    /// <param name="quantidade">Quantidade contada na unidade da nota (uCom).</param>
    /// <param name="controlaLote">O produto exige lote.</param>
    /// <param name="controlaValidade">O produto exige validade em cada lote.</param>
    public RecebimentoItem ConferirItem(
        Guid itemId,
        decimal quantidade,
        IReadOnlyList<LoteConferido> lotes,
        bool controlaLote,
        bool controlaValidade,
        Guid usuarioId,
        DateTimeOffset agora)
    {
        if (Status != StatusRecebimento.EmConferencia)
        {
            throw new DomainException("Inicie a conferência antes de contar os itens.");
        }

        var item = _itens.Find(i => i.Id == itemId) ?? throw new DomainException("O item não é deste recebimento.");
        item.Conferir(quantidade, lotes, controlaLote, controlaValidade, usuarioId, agora);
        return item;
    }

    /// <summary>Fecha a conferência quando todos os itens foram contados. Divergências ficam registradas nos itens.</summary>
    public void FinishConferencia(Guid usuarioId, DateTimeOffset agora)
    {
        if (Status != StatusRecebimento.EmConferencia)
        {
            throw new DomainException("A conferência deste recebimento não está em andamento.");
        }

        var faltando = _itens.Where(i => !i.Conferido).Select(i => i.NumeroItem).Order().ToList();
        if (faltando.Count > 0)
        {
            throw new DomainException($"Faltam contar os itens {string.Join(", ", faltando)}.");
        }

        Status = StatusRecebimento.Conferido;
        ConferidoPor = usuarioId;
        ConferidoEm = agora.ToUniversalTime();
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

    /// <summary>Tamanho do nLote na NF-e 4.00.</summary>
    public const int LoteNumeroMaxLength = 20;

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

    /// <summary>Quantidade contada na conferência, na unidade base; nula até a contagem.</summary>
    public decimal? QuantidadeConferida { get; private set; }

    /// <summary>Lotes contados, na unidade base.</summary>
    public IReadOnlyList<LoteRecebido> LotesConferidos { get; private set; } = [];

    /// <summary>A contagem difere da nota: quantidade, ou número e quantidade dos lotes.</summary>
    public bool Divergente { get; private set; }

    public Guid? ConferidoPor { get; private set; }

    public DateTimeOffset? ConferidoEm { get; private set; }

    public bool Conferido => QuantidadeConferida is not null;

    internal void Conferir(
        decimal quantidade,
        IReadOnlyList<LoteConferido> lotes,
        bool controlaLote,
        bool controlaValidade,
        Guid usuarioId,
        DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(lotes);
        Guard.NotNegative(quantidade, "Quantidade contada");

        if (controlaLote && quantidade > 0 && lotes.Count == 0)
        {
            throw new DomainException($"O produto do item {NumeroItem} controla lote: informe os lotes contados.");
        }

        if (lotes.Count > 0 && lotes.Sum(l => l.Quantidade) != quantidade)
        {
            throw new DomainException($"A soma dos lotes do item {NumeroItem} deve ser igual à quantidade contada.");
        }

        var conferidos = new List<LoteRecebido>(lotes.Count);
        foreach (var lote in lotes)
        {
            var numero = Guard.Required(lote.Numero, "Número do lote", LoteNumeroMaxLength);
            Guard.Positive(lote.Quantidade, "Quantidade do lote");
            if (controlaValidade && lote.Validade is null)
            {
                throw new DomainException($"O produto do item {NumeroItem} controla validade: informe a validade do lote {numero}.");
            }

            if (conferidos.Exists(c => string.Equals(c.Numero, numero, StringComparison.OrdinalIgnoreCase)))
            {
                throw new DomainException($"O lote {numero} aparece duas vezes no item {NumeroItem}.");
            }

            conferidos.Add(new LoteRecebido(numero, ParaBase(lote.Quantidade), lote.Fabricacao, lote.Validade));
        }

        QuantidadeConferida = ParaBase(quantidade);
        LotesConferidos = conferidos;
        Divergente = QuantidadeConferida != Quantidade || (Lotes.Count > 0 && !MesmosLotes(Lotes, conferidos));
        ConferidoPor = usuarioId;
        ConferidoEm = agora.ToUniversalTime();
    }


    private decimal ParaBase(decimal quantidadeNota) => Math.Round(quantidadeNota * FatorConversao, 4, MidpointRounding.AwayFromZero);

    private static bool MesmosLotes(IReadOnlyList<LoteRecebido> nota, List<LoteRecebido> contados) =>
        nota.Count == contados.Count
        && nota.All(n => contados.Any(c => string.Equals(c.Numero, n.Numero, StringComparison.OrdinalIgnoreCase) && c.QuantidadeBase == n.QuantidadeBase));
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
