using System.Globalization;
using System.Text.RegularExpressions;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estrutura;
using Stowise.Domain.Importacoes;

namespace Stowise.Application.Importacoes;

/// <summary>Valores de uma linha por campo, já normalizados, e os problemas encontrados.</summary>
public sealed record LinhaNormalizada(IReadOnlyDictionary<string, string?> Dados, IReadOnlyList<ErroLinha> Erros);

/// <summary>
/// Validações determinísticas de uma linha de produto: as mesmas regras do cadastro (SKU, GTIN, NCM, CEST,
/// unidade), mais a leitura de números com o separador decimal confirmado e de "sim/não". Não consulta o banco:
/// SKU e GTIN existentes e categoria ficam com o serviço de staging.
/// </summary>
public static partial class NormalizadorProdutos
{
    /// <summary>Formas comuns de escrever as unidades (sem acento e em minúsculas) e o código usado no cadastro.</summary>
    private static readonly Dictionary<string, string> SinonimosUnidade = new(StringComparer.Ordinal)
    {
        ["u"] = "UN",
        ["und"] = "UN",
        ["unid"] = "UN",
        ["unidade"] = "UN",
        ["unidades"] = "UN",
        ["pc"] = "PC",
        ["pca"] = "PC",
        ["peca"] = "PC",
        ["pecas"] = "PC",
        ["kg"] = "KG",
        ["kgs"] = "KG",
        ["kilo"] = "KG",
        ["quilo"] = "KG",
        ["quilograma"] = "KG",
        ["g"] = "G",
        ["gr"] = "G",
        ["grs"] = "G",
        ["grama"] = "G",
        ["gramas"] = "G",
        ["l"] = "L",
        ["lt"] = "L",
        ["lts"] = "L",
        ["litro"] = "L",
        ["litros"] = "L",
        ["ml"] = "ML",
        ["mililitro"] = "ML",
        ["m"] = "M",
        ["mt"] = "M",
        ["metro"] = "M",
        ["metros"] = "M",
        ["cx"] = "CX",
        ["caixa"] = "CX",
        ["caixas"] = "CX",
        ["pct"] = "PCT",
        ["pacote"] = "PCT",
        ["pacotes"] = "PCT",
        ["fd"] = "FD",
        ["fardo"] = "FD",
        ["dz"] = "DZ",
        ["duzia"] = "DZ",
        ["par"] = "PAR",
    };

    private static readonly HashSet<string> Verdadeiro = new(StringComparer.Ordinal) { "sim", "s", "yes", "y", "true", "1", "x" };
    private static readonly HashSet<string> Falso = new(StringComparer.Ordinal) { "nao", "n", "no", "false", "0" };

    /// <param name="regras">Regras confirmadas (de-para de unidades e textos de sim/não), aplicadas antes das padrão.</param>
    public static LinhaNormalizada Normalize(
        IReadOnlyList<string> linha,
        IReadOnlyList<MapeamentoColuna> mapeamento,
        string separadorDecimal,
        RegrasNormalizacao? regras = null)
    {
        ArgumentNullException.ThrowIfNull(linha);
        ArgumentNullException.ThrowIfNull(mapeamento);
        regras ??= RegrasNormalizacao.Vazias;

        var valores = mapeamento.ToDictionary(m => m.Campo, m => m.Coluna < linha.Count ? linha[m.Coluna].Trim() : string.Empty, StringComparer.Ordinal);
        var dados = new Dictionary<string, string?>(StringComparer.Ordinal);
        var erros = new List<ErroLinha>();

        string Valor(string campo) => valores.GetValueOrDefault(campo, string.Empty);
        void Erro(string campo, string mensagem) => erros.Add(new ErroLinha(campo, mensagem));

        var sku = Valor("sku").ToUpperInvariant();
        dados["sku"] = sku;
        if (sku.Length == 0)
        {
            Erro("sku", "Informe o SKU.");
        }
        else if (!Produto.IsValidSku(sku))
        {
            Erro("sku", $"SKU {sku} inválido: até {Produto.SkuMaxLength} caracteres, com letras, números, hífen, sublinhado ou ponto.");
        }

        var descricao = EspacosRegex().Replace(Valor("descricao"), " ");
        dados["descricao"] = descricao;
        if (descricao.Length == 0)
        {
            Erro("descricao", "Informe a descrição.");
        }
        else if (descricao.Length > Produto.DescricaoMaxLength)
        {
            Erro("descricao", $"A descrição deve ter no máximo {Produto.DescricaoMaxLength} caracteres.");
        }

        var unidade = Unidade(Valor("unidadeBase"), regras);
        dados["unidadeBase"] = unidade;
        if (unidade is null)
        {
            Erro("unidadeBase", Valor("unidadeBase").Length == 0 ? "Informe a unidade base." : $"Unidade {Valor("unidadeBase")} não reconhecida. Use até 6 letras ou números (ex.: UN, KG, CX).");
        }

        if (valores.ContainsKey("gtin"))
        {
            var gtin = string.Concat(Valor("gtin").Where(c => c is not (' ' or '-' or '.')));
            dados["gtin"] = gtin.Length == 0 ? null : gtin;
            if (gtin.Length > 0 && !Gtin.IsValid(gtin))
            {
                Erro("gtin", $"GTIN {gtin} inválido: deve ter 8, 12, 13 ou 14 dígitos e o dígito verificador correto.");
            }
        }

        if (valores.ContainsKey("ncm"))
        {
            var ncm = CodigosFiscais.NormalizeNcm(Valor("ncm"));
            dados["ncm"] = ncm;
            if (ncm is not null && !CodigosFiscais.IsValidNcm(ncm))
            {
                Erro("ncm", $"NCM {ncm} inválido: deve ter {CodigosFiscais.NcmLength} dígitos.");
            }
        }

        if (valores.ContainsKey("cest"))
        {
            var cest = CodigosFiscais.NormalizeCest(Valor("cest"));
            dados["cest"] = cest;
            if (cest is not null && !CodigosFiscais.IsValidCest(cest))
            {
                Erro("cest", $"CEST {cest} inválido: deve ter {CodigosFiscais.CestLength} dígitos.");
            }
        }

        if (valores.ContainsKey("categoria"))
        {
            dados["categoria"] = Valor("categoria").Length == 0 ? null : EspacosRegex().Replace(Valor("categoria"), " ");
        }

        var classe = Valor("classeArmazenagem");
        var classeLida = classe.Length == 0
            ? ClasseArmazenagem.Normal
            : Enum.GetValues<ClasseArmazenagem>().Cast<ClasseArmazenagem?>().FirstOrDefault(c => FingerprintLayout.Normalize(c.ToString()!) == FingerprintLayout.Normalize(classe));
        dados["classeArmazenagem"] = classeLida?.ToString();
        if (classeLida is null)
        {
            Erro("classeArmazenagem", $"Classe {classe} não reconhecida. Use {string.Join(", ", Enum.GetNames<ClasseArmazenagem>())}.");
        }

        var lote = Booleano("controlaLote", Valor("controlaLote"), regras, dados, Erro);
        var validade = Booleano("controlaValidade", Valor("controlaValidade"), regras, dados, Erro);
        if (validade == true && lote == false)
        {
            Erro("controlaValidade", "Produto que controla validade precisa controlar lote.");
        }

        foreach (var medida in (string[])["pesoKg", "alturaCm", "larguraCm", "comprimentoCm"])
        {
            if (valores.ContainsKey(medida))
            {
                Medida(medida, Valor(medida), separadorDecimal, dados, Erro);
            }
        }

        return new LinhaNormalizada(dados, erros);
    }

    private static string? Unidade(string valor, RegrasNormalizacao regras)
    {
        if (valor.Length == 0)
        {
            return null;
        }

        var deParaConfirmado = regras.Unidades.FirstOrDefault(u => FingerprintLayout.Normalize(u.Origem) == FingerprintLayout.Normalize(valor));
        if (deParaConfirmado is not null)
        {
            return deParaConfirmado.Destino;
        }

        if (SinonimosUnidade.TryGetValue(FingerprintLayout.Normalize(valor), out var codigo))
        {
            return codigo;
        }

        var maiuscula = valor.ToUpperInvariant();
        return Produto.IsValidUnidadeBase(maiuscula) ? maiuscula : null;
    }

    private static bool? Booleano(string campo, string valor, RegrasNormalizacao regras, Dictionary<string, string?> dados, Action<string, string> erro)
    {
        var normalizado = FingerprintLayout.Normalize(valor);
        bool Em(IEnumerable<string> extras) => extras.Any(e => FingerprintLayout.Normalize(e) == normalizado);
        bool? lido = normalizado.Length == 0 || Falso.Contains(normalizado) || Em(regras.ValoresFalsos)
            ? false
            : Verdadeiro.Contains(normalizado) || Em(regras.ValoresVerdadeiros) ? true : null;
        dados[campo] = lido is null ? null : lido.Value ? "true" : "false";
        if (lido is null)
        {
            erro(campo, $"Valor {valor} não reconhecido. Use sim ou não.");
        }

        return lido;
    }

    /// <summary>
    /// Com o separador decimal confirmado, o outro sinal só vale como separador de milhar em grupos de três
    /// dígitos (<c>1.234,5</c>). Fora disso o número é ambíguo e vira erro, em vez de um valor errado em silêncio.
    /// </summary>
    private static void Medida(string campo, string valor, string separadorDecimal, Dictionary<string, string?> dados, Action<string, string> erro)
    {
        if (valor.Length == 0)
        {
            dados[campo] = null;
            return;
        }

        var milhar = separadorDecimal == "," ? "." : ",";
        var padrao = $@"^\d{{1,3}}(\{milhar}\d{{3}})*(\{separadorDecimal}\d+)?$|^\d+(\{separadorDecimal}\d+)?$";
        var compacto = valor.Replace(" ", string.Empty, StringComparison.Ordinal);
        if (!Regex.IsMatch(compacto, padrao)
            || !decimal.TryParse(
                compacto.Replace(milhar, string.Empty, StringComparison.Ordinal).Replace(separadorDecimal, ".", StringComparison.Ordinal),
                NumberStyles.AllowDecimalPoint,
                CultureInfo.InvariantCulture,
                out var numero))
        {
            dados[campo] = null;
            erro(campo, $"Número {valor} inválido. O separador decimal do arquivo é \"{separadorDecimal}\".");
            return;
        }

        dados[campo] = numero.ToString(CultureInfo.InvariantCulture);
        if (numero <= 0)
        {
            erro(campo, "A medida deve ser maior que zero.");
        }
    }

    [GeneratedRegex(@"\s+")]
    private static partial Regex EspacosRegex();
}
