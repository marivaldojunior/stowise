using Stowise.Domain.Catalogo;

namespace Stowise.Application.Catalogo;

/// <summary>
/// Validações de formato, com erro por campo (HTTP 400). Regras que dependem do estado do agregado
/// (embalagem repetida, unidade base) ficam no domínio; as que dependem do banco (SKU e GTIN únicos), no serviço.
/// </summary>
public static class CatalogoValidation
{
    public static IReadOnlyDictionary<string, string[]> Validate(SalvarCategoria comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(comando.Nome))
        {
            errors["nome"] = ["Informe o nome da categoria."];
        }
        else if (comando.Nome.Trim().Length > Categoria.NomeMaxLength)
        {
            errors["nome"] = [$"O nome deve ter no máximo {Categoria.NomeMaxLength} caracteres."];
        }

        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(CriarProduto comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (!Produto.IsValidSku(comando.Sku))
        {
            errors["sku"] = [$"Informe um SKU de até {Produto.SkuMaxLength} caracteres, com letras, números, hífen, sublinhado ou ponto."];
        }

        ValidateDados(
            errors,
            comando.Descricao,
            comando.UnidadeBase,
            comando.ClasseArmazenagem is not null,
            comando.ControlaLote,
            comando.ControlaValidade,
            comando.Ncm,
            comando.Cest);

        if (comando.EmbalagemBase is { } embalagem)
        {
            ValidateMedidas(errors, "embalagemBase.", embalagem.Gtin, embalagem.PesoKg, embalagem.AlturaCm, embalagem.LarguraCm, embalagem.ComprimentoCm);
        }

        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(AtualizarProduto comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        ValidateDados(
            errors,
            comando.Descricao,
            comando.UnidadeBase,
            comando.ClasseArmazenagem is not null,
            comando.ControlaLote,
            comando.ControlaValidade,
            comando.Ncm,
            comando.Cest);

        if (comando.Versao is null)
        {
            errors["versao"] = ["Informe a versão do produto lida antes da alteração."];
        }

        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(AdicionarEmbalagem comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (comando.Tipo is null or TipoEmbalagem.Unidade)
        {
            errors["tipo"] = ["Informe o tipo da embalagem: Caixa ou Palete."];
        }

        if (comando.FatorConversao is not > 1)
        {
            errors["fatorConversao"] = ["Informe quantas unidades base cabem na embalagem (maior que 1)."];
        }

        ValidateMedidas(errors, string.Empty, comando.Gtin, comando.PesoKg, comando.AlturaCm, comando.LarguraCm, comando.ComprimentoCm);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(EmbalagemMedidas comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        ValidateMedidas(errors, string.Empty, comando.Gtin, comando.PesoKg, comando.AlturaCm, comando.LarguraCm, comando.ComprimentoCm);
        return errors;
    }

    private static void ValidateDados(
        Dictionary<string, string[]> errors,
        string? descricao,
        string? unidadeBase,
        bool temClasse,
        bool controlaLote,
        bool controlaValidade,
        string? ncm,
        string? cest)
    {
        if (string.IsNullOrWhiteSpace(descricao) || descricao.Trim().Length > Produto.DescricaoMaxLength)
        {
            errors["descricao"] = [$"Informe a descrição (até {Produto.DescricaoMaxLength} caracteres)."];
        }

        if (!Produto.IsValidUnidadeBase(unidadeBase))
        {
            errors["unidadeBase"] = ["Informe a unidade base com até 6 letras ou números (ex.: UN, KG, L, M2)."];
        }

        if (!temClasse)
        {
            errors["classeArmazenagem"] = ["Informe a classe de armazenagem: Normal, Refrigerado, Inflamavel ou Fragil."];
        }

        if (controlaValidade && !controlaLote)
        {
            errors["controlaValidade"] = ["Produto que controla validade precisa controlar lote."];
        }

        var ncmNormalizado = CodigosFiscais.NormalizeNcm(ncm);
        if (ncmNormalizado is not null && !CodigosFiscais.IsValidNcm(ncmNormalizado))
        {
            errors["ncm"] = ["O NCM deve ter 8 dígitos."];
        }

        var cestNormalizado = CodigosFiscais.NormalizeCest(cest);
        if (cestNormalizado is not null && !CodigosFiscais.IsValidCest(cestNormalizado))
        {
            errors["cest"] = ["O CEST deve ter 7 dígitos."];
        }
    }

    private static void ValidateMedidas(
        Dictionary<string, string[]> errors,
        string prefix,
        string? gtin,
        decimal? pesoKg,
        decimal? alturaCm,
        decimal? larguraCm,
        decimal? comprimentoCm)
    {
        if (!string.IsNullOrWhiteSpace(gtin) && !Gtin.IsValid(gtin.Trim()))
        {
            errors[prefix + "gtin"] = ["GTIN inválido: use 8, 12, 13 ou 14 dígitos com dígito verificador correto."];
        }

        foreach (var (campo, valor) in new[] { ("pesoKg", pesoKg), ("alturaCm", alturaCm), ("larguraCm", larguraCm), ("comprimentoCm", comprimentoCm) })
        {
            if (valor is <= 0)
            {
                errors[prefix + campo] = ["Informe um valor maior que zero ou deixe em branco."];
            }
        }
    }
}
