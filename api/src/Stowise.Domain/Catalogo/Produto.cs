using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.Domain.Catalogo;

/// <summary>Dados cadastrais do produto. Quantidades são sempre na unidade base (SPEC, decisão 2).</summary>
public sealed record DadosProduto(
    string Descricao,
    string UnidadeBase,
    ClasseArmazenagem ClasseArmazenagem,
    bool ControlaLote,
    bool ControlaValidade,
    string? Ncm,
    string? Cest,
    Guid? CategoriaId);

/// <summary>Agregado do catálogo: o produto é dono das embalagens. O SKU é único e não muda.</summary>
public sealed class Produto : Entity
{
    public const int SkuMaxLength = 40;
    public const int DescricaoMaxLength = 200;
    public const int UnidadeBaseMaxLength = 6;

    private readonly List<ProdutoEmbalagem> _embalagens = [];

    private Produto()
    {
    }

    public string Sku { get; private set; } = null!;

    public string Descricao { get; private set; } = null!;

    /// <summary>Sigla da unidade base (UN, KG, L, M...). Saldos e movimentações usam esta unidade.</summary>
    public string UnidadeBase { get; private set; } = null!;

    public ClasseArmazenagem ClasseArmazenagem { get; private set; }

    public bool ControlaLote { get; private set; }

    public bool ControlaValidade { get; private set; }

    public string? Ncm { get; private set; }

    public string? Cest { get; private set; }

    public Guid? CategoriaId { get; private set; }

    public bool Ativo { get; private set; }

    /// <summary>Recalculado a cada mudança das embalagens: completo quando todas têm peso e as três medidas.</summary>
    public StatusCadastro StatusCadastro { get; private set; }

    /// <summary>Versão para concorrência otimista (<c>xmin</c> do PostgreSQL).</summary>
    public uint Versao { get; private set; }

    public IReadOnlyCollection<ProdutoEmbalagem> Embalagens => _embalagens.AsReadOnly();

    public ProdutoEmbalagem EmbalagemBase => _embalagens.Single(e => e.UnidadeBase);

    /// <summary>Cria o produto com a embalagem da unidade base (tipo Unidade, fator 1).</summary>
    public static Produto Create(string sku, DadosProduto dados, DadosEmbalagem unidadeBase)
    {
        ArgumentNullException.ThrowIfNull(dados);
        ArgumentNullException.ThrowIfNull(unidadeBase);

        var produto = new Produto { Sku = NormalizeSku(sku), Ativo = true };
        produto.Update(dados);
        produto._embalagens.Add(new ProdutoEmbalagem(produto.Id, TipoEmbalagem.Unidade, 1m, unidadeBase: true, unidadeBase));
        produto.RefreshStatusCadastro();
        return produto;
    }

    public void Update(DadosProduto dados)
    {
        ArgumentNullException.ThrowIfNull(dados);

        if (dados.ControlaValidade && !dados.ControlaLote)
        {
            throw new DomainException("Produto que controla validade precisa controlar lote.");
        }

        var ncm = CodigosFiscais.NormalizeNcm(dados.Ncm);
        if (ncm is not null && !CodigosFiscais.IsValidNcm(ncm))
        {
            throw new DomainException("NCM deve ter 8 dígitos.");
        }

        var cest = CodigosFiscais.NormalizeCest(dados.Cest);
        if (cest is not null && !CodigosFiscais.IsValidCest(cest))
        {
            throw new DomainException("CEST deve ter 7 dígitos.");
        }

        Descricao = Guard.Required(dados.Descricao, "Descrição", DescricaoMaxLength);
        UnidadeBase = NormalizeUnidade(dados.UnidadeBase);
        ClasseArmazenagem = dados.ClasseArmazenagem;
        ControlaLote = dados.ControlaLote;
        ControlaValidade = dados.ControlaValidade;
        Ncm = ncm;
        Cest = cest;
        CategoriaId = dados.CategoriaId;
    }

    public ProdutoEmbalagem AddEmbalagem(TipoEmbalagem tipo, decimal fatorConversao, DadosEmbalagem dados)
    {
        ArgumentNullException.ThrowIfNull(dados);

        if (tipo == TipoEmbalagem.Unidade)
        {
            throw new DomainException("O produto já tem a embalagem da unidade base. Use Caixa ou Palete.");
        }

        if (fatorConversao <= 1)
        {
            throw new DomainException("O fator de conversão de caixa ou palete deve ser maior que 1.");
        }

        if (_embalagens.Exists(e => e.Tipo == tipo && e.FatorConversao == fatorConversao))
        {
            throw new DomainException($"O produto já tem uma embalagem {tipo} com fator {fatorConversao:0.####}.");
        }

        var embalagem = new ProdutoEmbalagem(Id, tipo, fatorConversao, unidadeBase: false, dados);
        EnsureGtinNotRepeated(embalagem.Gtin, except: null);
        _embalagens.Add(embalagem);
        RefreshStatusCadastro();
        return embalagem;
    }

    public void UpdateEmbalagem(Guid embalagemId, DadosEmbalagem dados)
    {
        var embalagem = FindEmbalagem(embalagemId);
        var gtin = string.IsNullOrWhiteSpace(dados.Gtin) ? null : dados.Gtin.Trim();
        EnsureGtinNotRepeated(gtin, except: embalagem);
        embalagem.Apply(dados);
        RefreshStatusCadastro();
    }

    public void RemoveEmbalagem(Guid embalagemId)
    {
        var embalagem = FindEmbalagem(embalagemId);
        if (embalagem.UnidadeBase)
        {
            throw new DomainException("A embalagem da unidade base não pode ser removida.");
        }

        _embalagens.Remove(embalagem);
        RefreshStatusCadastro();
    }

    private void RefreshStatusCadastro() =>
        StatusCadastro = _embalagens.TrueForAll(e => e.TemMedidasCompletas) ? StatusCadastro.Completo : StatusCadastro.Incompleto;

    public void Deactivate() => Ativo = false;

    public void Reactivate() => Ativo = true;

    /// <summary>Até 40 caracteres: letras, números, hífen, sublinhado e ponto.</summary>
    public static bool IsValidSku(string? sku)
    {
        var trimmed = sku?.Trim();
        return !string.IsNullOrEmpty(trimmed)
            && trimmed.Length <= SkuMaxLength
            && trimmed.All(c => char.IsAsciiLetterOrDigit(c) || c is '-' or '_' or '.');
    }

    /// <summary>Até 6 letras ou números (ex.: UN, KG, L, M2).</summary>
    public static bool IsValidUnidadeBase(string? unidade)
    {
        var trimmed = unidade?.Trim();
        return !string.IsNullOrEmpty(trimmed) && trimmed.Length <= UnidadeBaseMaxLength && trimmed.All(char.IsAsciiLetterOrDigit);
    }

    public static string NormalizeSku(string? sku)
    {
        var normalized = Guard.Required(sku, "SKU", SkuMaxLength).ToUpperInvariant();
        if (!IsValidSku(normalized))
        {
            throw new DomainException("SKU aceita apenas letras, números, hífen, sublinhado e ponto.");
        }

        return normalized;
    }

    private static string NormalizeUnidade(string? unidade)
    {
        var normalized = Guard.Required(unidade, "Unidade base", UnidadeBaseMaxLength).ToUpperInvariant();
        if (!IsValidUnidadeBase(normalized))
        {
            throw new DomainException("Unidade base aceita apenas letras e números (ex.: UN, KG, L, M2).");
        }

        return normalized;
    }

    private ProdutoEmbalagem FindEmbalagem(Guid embalagemId) =>
        _embalagens.Find(e => e.Id == embalagemId)
        ?? throw new DomainException("Embalagem não encontrada neste produto.");

    private void EnsureGtinNotRepeated(string? gtin, ProdutoEmbalagem? except)
    {
        if (gtin is not null && _embalagens.Exists(e => e != except && e.Gtin == gtin))
        {
            throw new DomainException($"O GTIN {gtin} já está em outra embalagem deste produto.");
        }
    }
}
