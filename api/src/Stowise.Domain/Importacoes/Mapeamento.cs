using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using Stowise.Domain.Common;

namespace Stowise.Domain.Importacoes;

/// <summary>Liga um campo de destino (ex.: <c>sku</c>) a uma coluna do arquivo.</summary>
/// <param name="Coluna">Índice da coluna (<see cref="ColunaArquivo.Indice"/>).</param>
public sealed record MapeamentoColuna(string Campo, int Coluna);

/// <summary>Campo que a importação sabe preencher. O nome é o mesmo usado na API (camelCase).</summary>
public sealed record CampoImportacao(string Nome, string Descricao, bool Obrigatorio);

public static class CamposImportacao
{
    public static readonly IReadOnlyList<CampoImportacao> Produtos =
    [
        new("sku", "Código interno do produto (único).", true),
        new("descricao", "Descrição do produto.", true),
        new("unidadeBase", "Unidade base de estoque (ex.: UN, KG, CX).", true),
        new("gtin", "Código de barras da unidade (GTIN/EAN).", false),
        new("ncm", "NCM com 8 dígitos.", false),
        new("cest", "CEST com 7 dígitos.", false),
        new("categoria", "Nome da categoria.", false),
        new("classeArmazenagem", "Normal, Refrigerado, Inflamável ou Frágil. Vazio vale Normal.", false),
        new("controlaLote", "Se o produto controla lote (sim/não).", false),
        new("controlaValidade", "Se o produto controla validade (sim/não).", false),
        new("pesoKg", "Peso da unidade em kg.", false),
        new("alturaCm", "Altura da unidade em cm.", false),
        new("larguraCm", "Largura da unidade em cm.", false),
        new("comprimentoCm", "Comprimento da unidade em cm.", false),
    ];

    /// <summary>Campos de destino do tipo. Vazio para os tipos que ainda não têm importação por arquivo.</summary>
    public static IReadOnlyList<CampoImportacao> Para(TipoImportacao tipo) => tipo switch
    {
        TipoImportacao.Produtos => Produtos,
        _ => [],
    };

    /// <summary>Regras que o domínio não aceita quebrar: campo conhecido e único, coluna existente e obrigatórios presentes.</summary>
    internal static IReadOnlyList<MapeamentoColuna> Validate(TipoImportacao tipo, IReadOnlyList<MapeamentoColuna> mapeamento, int totalColunas)
    {
        ArgumentNullException.ThrowIfNull(mapeamento);

        var campos = Para(tipo);
        foreach (var item in mapeamento)
        {
            if (campos.All(c => c.Nome != item.Campo))
            {
                throw new DomainException($"O campo {item.Campo} não existe na importação de {tipo}.");
            }

            if (item.Coluna < 0 || item.Coluna >= totalColunas)
            {
                throw new DomainException($"A coluna {item.Coluna} não existe no arquivo.");
            }
        }

        if (mapeamento.GroupBy(m => m.Campo).FirstOrDefault(g => g.Count() > 1) is { } repetido)
        {
            throw new DomainException($"O campo {repetido.Key} foi mapeado mais de uma vez.");
        }

        var faltando = campos.Where(c => c.Obrigatorio && mapeamento.All(m => m.Campo != c.Nome)).Select(c => c.Nome).ToList();
        if (faltando.Count > 0)
        {
            throw new DomainException($"Mapeie os campos obrigatórios: {string.Join(", ", faltando)}.");
        }

        return [.. mapeamento.OrderBy(m => m.Coluna).ThenBy(m => m.Campo, StringComparer.Ordinal)];
    }
}

/// <summary>
/// Identifica arquivos com a mesma estrutura, para reaproveitar o template. Com cabeçalho, usa os nomes das
/// colunas normalizados (sem acento, caixa ou pontuação), na ordem. Sem cabeçalho, só o layout posicional tem
/// estrutura própria (as posições); um arquivo delimitado sem cabeçalho não tem fingerprint.
/// </summary>
public static class FingerprintLayout
{
    public const int Length = 64;

    public static string? Calculate(LayoutArquivo layout)
    {
        ArgumentNullException.ThrowIfNull(layout);

        string? assinatura = (layout.TemCabecalho, layout.Formato) switch
        {
            (true, _) => "cabecalho:" + string.Join('\u001f', layout.Colunas.Select(c => Normalize(c.Nome))),
            (false, FormatoArquivo.Posicional) => "posicional:" + string.Join(';', layout.Colunas.Select(c => $"{c.Inicio}+{c.Tamanho}")),
            _ => null,
        };

        return assinatura is null ? null : Convert.ToHexStringLower(SHA256.HashData(Encoding.UTF8.GetBytes(assinatura)));
    }

    /// <summary>"Preço Unit. (R$)" e "preco unit r" viram o mesmo nome.</summary>
    public static string Normalize(string nome)
    {
        ArgumentNullException.ThrowIfNull(nome);

        var builder = new StringBuilder(nome.Length);
        var espaco = false;
        foreach (var c in nome.Normalize(NormalizationForm.FormD))
        {
            if (CharUnicodeInfo.GetUnicodeCategory(c) == UnicodeCategory.NonSpacingMark)
            {
                continue;
            }

            if (char.IsLetterOrDigit(c))
            {
                if (espaco && builder.Length > 0)
                {
                    builder.Append(' ');
                }

                builder.Append(char.ToLowerInvariant(c));
                espaco = false;
            }
            else
            {
                espaco = true;
            }
        }

        return builder.ToString();
    }
}
