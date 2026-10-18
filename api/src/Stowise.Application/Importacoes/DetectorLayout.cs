using System.Text;
using System.Text.RegularExpressions;
using Stowise.Application.Common;
using Stowise.Domain.Importacoes;

namespace Stowise.Application.Importacoes;

/// <param name="Amostra">Primeiras <see cref="DetectorLayout.LinhasAmostra"/> linhas de dados, sem o cabeçalho.</param>
/// <param name="TotalLinhas">Linhas de dados, sem o cabeçalho e sem linhas em branco.</param>
public sealed record ArquivoDetectado(LayoutArquivo Layout, IReadOnlyList<IReadOnlyList<string>> Amostra, int TotalLinhas);

/// <summary>
/// Lê um arquivo de texto sem saber nada dele antes: encoding, delimitador, separador decimal, cabeçalho e,
/// sem delimitador, as colunas de largura fixa. É determinístico; a IA só entra depois, no mapeamento.
/// </summary>
public static partial class DetectorLayout
{
    public const int LinhasAmostra = 10;

    /// <summary>Linhas usadas para decidir o layout. O arquivo inteiro é lido só para contar as linhas.</summary>
    private const int LinhasAnalise = 200;

    /// <summary>Fração mínima das linhas com a mesma quantidade de delimitadores.</summary>
    private const double ConsistenciaMinima = 0.8;

    private const int NomeColunaMaxLength = 100;

    private static readonly char[] Delimitadores = [';', ',', '\t', '|'];

    private static readonly UTF8Encoding Utf8Estrito = new(encoderShouldEmitUTF8Identifier: false, throwOnInvalidBytes: true);

    private static ReadOnlySpan<byte> BomUtf8 => [0xEF, 0xBB, 0xBF];

    private static ReadOnlySpan<byte> BomUtf16Le => [0xFF, 0xFE];

    private static ReadOnlySpan<byte> BomUtf16Be => [0xFE, 0xFF];

    private static ReadOnlySpan<byte> AssinaturaOle => [0xD0, 0xCF, 0x11, 0xE0];

    public static Result<ArquivoDetectado> Detect(byte[] conteudo)
    {
        ArgumentNullException.ThrowIfNull(conteudo);

        if (conteudo.Length == 0)
        {
            return Erro("O arquivo está vazio.");
        }

        if (conteudo.AsSpan().StartsWith(AssinaturaOle))
        {
            return Erro("Arquivos .xls (Excel 97-2003) não são aceitos. Salve a planilha como .xlsx ou CSV e envie de novo.");
        }

        if (IsZip(conteudo))
        {
            return Erro("Arquivo compactado não é texto. Envie um arquivo CSV, TXT ou uma planilha .xlsx.");
        }

        if (Decode(conteudo) is not { } decodificado)
        {
            return Erro("O arquivo não é texto. Envie um arquivo CSV ou TXT.");
        }

        var (texto, encoding) = decodificado;

        var linhas = texto.Split(["\r\n", "\r", "\n"], StringSplitOptions.None)
            .Where(l => !string.IsNullOrWhiteSpace(l))
            .ToList();
        if (linhas.Count == 0)
        {
            return Erro("O arquivo não tem linhas com dados.");
        }

        var delimitador = DetectDelimiter([.. LogicalLines(texto).Take(LinhasAnalise)]);
        var posicoes = delimitador is null ? DetectPositional([.. linhas.Take(LinhasAnalise)]) : null;

        var registros = posicoes is null
            ? [.. ParseDelimited(texto, delimitador).Where(r => r.Any(c => c.Length > 0))]
            : linhas.Select(l => Slice(l, posicoes)).ToList();

        var organizado = Organize(registros, posicoes?.Count ?? registros.Take(LinhasAnalise).DefaultIfEmpty([]).Max(r => r.Length), posicoes);
        if (!organizado.IsSuccess)
        {
            return organizado.Error!;
        }

        var (temCabecalho, colunas, dados) = organizado.Value;
        var layout = new LayoutArquivo(
            posicoes is null ? FormatoArquivo.Delimitado : FormatoArquivo.Posicional,
            encoding,
            delimitador?.ToString(),
            DetectDecimalSeparator(dados.Take(LinhasAnalise), delimitador).ToString(),
            temCabecalho,
            colunas);

        return new ArquivoDetectado(layout, [.. dados.Take(LinhasAmostra)], dados.Count);
    }

    /// <summary>
    /// Planilha já lida como texto (uma linha por registro, uma célula por campo). Aplica as mesmas regras de
    /// cabeçalho e de colunas do arquivo de texto e descarta as colunas vazias à esquerda.
    /// </summary>
    public static Result<ArquivoDetectado> DetectPlanilha(string planilha, IEnumerable<string[]> linhas)
    {
        ArgumentNullException.ThrowIfNull(planilha);
        ArgumentNullException.ThrowIfNull(linhas);

        var registros = linhas.Where(r => r.Any(c => c.Length > 0)).ToList();
        var primeira = registros.Count == 0 ? 0 : registros.Min(r => Array.FindIndex(r, c => c.Length > 0));
        if (primeira > 0)
        {
            registros = [.. registros.Select(r => r[primeira..])];
        }

        var organizado = Organize(registros, registros.DefaultIfEmpty([]).Max(r => r.Length), posicoes: null);
        if (!organizado.IsSuccess)
        {
            return organizado.Error!;
        }

        var (temCabecalho, colunas, dados) = organizado.Value;
        var layout = new LayoutArquivo(
            FormatoArquivo.Excel,
            Encoding: null,
            Delimitador: null,
            SeparadorDecimal: ".",
            temCabecalho,
            colunas,
            planilha.Length <= Importacao.PlanilhaMaxLength ? planilha : planilha[..Importacao.PlanilhaMaxLength]);

        return new ArquivoDetectado(layout, [.. dados.Take(LinhasAmostra)], dados.Count);
    }

    /// <summary>ZIP (<c>PK\3\4</c>): o formato do <c>.xlsx</c>.</summary>
    public static bool IsZip(ReadOnlySpan<byte> conteudo) => conteudo.StartsWith("PK\u0003\u0004"u8);

    /// <summary>Limites, cabeçalho e nomes das colunas: a parte comum ao texto e à planilha.</summary>
    private static Result<(bool TemCabecalho, List<ColunaArquivo> Colunas, List<string[]> Dados)> Organize(
        List<string[]> registros,
        int totalColunas,
        List<(int Inicio, int Tamanho)>? posicoes)
    {
        if (registros.Count == 0)
        {
            return Erro("O arquivo não tem linhas com dados.");
        }

        if (totalColunas > Importacao.MaxColunas)
        {
            return Erro($"O arquivo tem {totalColunas} colunas. O limite é {Importacao.MaxColunas}.");
        }

        var temCabecalho = IsHeader(registros[0], totalColunas);
        var dados = temCabecalho ? registros.Skip(1).ToList() : registros;
        if (dados.Count > Importacao.MaxLinhas)
        {
            return Erro($"O arquivo tem mais de {Importacao.MaxLinhas} linhas. Divida o arquivo e envie as partes.");
        }

        var colunas = Enumerable.Range(0, totalColunas)
            .Select(i => new ColunaArquivo(
                i,
                temCabecalho ? Truncate(registros[0][i]) : $"Coluna {i + 1}",
                posicoes?[i].Inicio,
                posicoes?[i].Tamanho))
            .ToList();

        return (temCabecalho, colunas, dados);
    }

    private static AppError Erro(string mensagem) => AppError.Validation("arquivo", mensagem);

    /// <summary>
    /// BOM primeiro; sem BOM, UTF-8 estrito; se houver byte inválido em UTF-8, Windows-1252 (o padrão dos
    /// sistemas brasileiros antigos, que cobre o ISO-8859-1). Nulo se o conteúdo parecer binário.
    /// </summary>
    private static (string Texto, string Encoding)? Decode(byte[] conteudo)
    {
        var bytes = conteudo.AsSpan();
        if (bytes.StartsWith(BomUtf8))
        {
            return (Encoding.UTF8.GetString(bytes[3..]), "utf-8");
        }

        if (bytes.StartsWith(BomUtf16Le))
        {
            return (Encoding.Unicode.GetString(bytes[2..]), "utf-16le");
        }

        if (bytes.StartsWith(BomUtf16Be))
        {
            return (Encoding.BigEndianUnicode.GetString(bytes[2..]), "utf-16be");
        }

        if (bytes.Contains((byte)0))
        {
            return null;
        }

        try
        {
            return (Utf8Estrito.GetString(bytes), "utf-8");
        }
        catch (DecoderFallbackException)
        {
            return (CodePagesEncodingProvider.Instance.GetEncoding(1252)!.GetString(bytes), "windows-1252");
        }
    }

    /// <summary>
    /// O candidato que aparece o mesmo número de vezes (fora de aspas) em pelo menos 80% das linhas.
    /// No empate, vence o que aparece mais vezes por linha.
    /// </summary>
    private static char? DetectDelimiter(List<string> linhas)
    {
        char? melhor = null;
        (double Consistencia, int Vezes) melhorPontuacao = (0, 0);

        foreach (var candidato in Delimitadores)
        {
            var contagens = linhas.Select(l => CountOutsideQuotes(l, candidato)).ToList();
            var moda = contagens.GroupBy(c => c).OrderByDescending(g => g.Count()).ThenByDescending(g => g.Key).First();
            if (moda.Key == 0)
            {
                continue;
            }

            var pontuacao = ((double)moda.Count() / contagens.Count, moda.Key);
            if (pontuacao.Item1 >= ConsistenciaMinima && pontuacao.CompareTo(melhorPontuacao) > 0)
            {
                melhor = candidato;
                melhorPontuacao = pontuacao;
            }
        }

        return melhor;
    }

    /// <summary>Linhas não vazias, sem quebrar nas quebras de linha que estão entre aspas.</summary>
    private static IEnumerable<string> LogicalLines(string texto)
    {
        var inicio = 0;
        var aspas = false;
        for (var i = 0; i <= texto.Length; i++)
        {
            if (i < texto.Length && texto[i] == '"')
            {
                aspas = !aspas;
            }
            else if (i == texto.Length || (!aspas && texto[i] is '\n' or '\r'))
            {
                if (!string.IsNullOrWhiteSpace(texto[inicio..i]))
                {
                    yield return texto[inicio..i];
                }

                inicio = i + 1;
            }
        }
    }

    private static int CountOutsideQuotes(string linha, char delimitador)
    {
        var total = 0;
        var aspas = false;
        foreach (var c in linha)
        {
            if (c == '"')
            {
                aspas = !aspas;
            }
            else if (c == delimitador && !aspas)
            {
                total++;
            }
        }

        return total;
    }

    /// <summary>
    /// Largura fixa: as posições em branco em todas as linhas separam as colunas. Precisa de pelo menos duas
    /// linhas e duas colunas; a primeira coluna começa na posição 0 e cada uma vai até o início da seguinte.
    /// </summary>
    private static List<(int Inicio, int Tamanho)>? DetectPositional(List<string> linhas)
    {
        if (linhas.Count < 2)
        {
            return null;
        }

        var largura = linhas.Max(l => l.Length);
        var ocupada = new bool[largura];
        foreach (var linha in linhas)
        {
            for (var i = 0; i < linha.Length; i++)
            {
                ocupada[i] |= !char.IsWhiteSpace(linha[i]);
            }
        }

        var inicios = new List<int>();
        for (var i = 0; i < largura; i++)
        {
            if (ocupada[i] && (i == 0 || !ocupada[i - 1]))
            {
                inicios.Add(inicios.Count == 0 ? 0 : i);
            }
        }

        if (inicios.Count < 2)
        {
            return null;
        }

        return [.. inicios.Select((inicio, k) => (inicio, (k + 1 < inicios.Count ? inicios[k + 1] : largura) - inicio))];
    }

    private static string[] Slice(string linha, List<(int Inicio, int Tamanho)> posicoes) =>
        [.. posicoes.Select(p => p.Inicio >= linha.Length
            ? string.Empty
            : linha.Substring(p.Inicio, Math.Min(p.Tamanho, linha.Length - p.Inicio)).Trim())];

    /// <summary>
    /// CSV conforme a RFC 4180: campos entre aspas podem ter o delimitador, quebras de linha e aspas dobradas
    /// (<c>""</c>). Sem delimitador, cada linha é um campo.
    /// </summary>
    private static IEnumerable<string[]> ParseDelimited(string texto, char? delimitador)
    {
        var campos = new List<string>();
        var atual = new StringBuilder();
        var aspas = false;

        for (var i = 0; i < texto.Length; i++)
        {
            var c = texto[i];
            if (aspas)
            {
                if (c != '"')
                {
                    atual.Append(c);
                }
                else if (i + 1 < texto.Length && texto[i + 1] == '"')
                {
                    atual.Append('"');
                    i++;
                }
                else
                {
                    aspas = false;
                }
            }
            else if (c == '"' && atual.Length == 0)
            {
                aspas = true;
            }
            else if (c == delimitador)
            {
                campos.Add(atual.ToString().Trim());
                atual.Clear();
            }
            else if (c is '\n' or '\r')
            {
                if (c == '\r' && i + 1 < texto.Length && texto[i + 1] == '\n')
                {
                    i++;
                }

                campos.Add(atual.ToString().Trim());
                atual.Clear();
                yield return [.. campos];
                campos.Clear();
            }
            else
            {
                atual.Append(c);
            }
        }

        if (campos.Count > 0 || atual.Length > 0)
        {
            campos.Add(atual.ToString().Trim());
            yield return [.. campos];
        }
    }

    /// <summary>Cabeçalho: todos os campos preenchidos, distintos e nenhum com cara de valor (número, data ou código).</summary>
    private static bool IsHeader(string[] primeira, int totalColunas) =>
        primeira.Length == totalColunas
        && primeira.All(c => c.Length > 0 && !ValorRegex().IsMatch(c))
        && primeira.Distinct(StringComparer.OrdinalIgnoreCase).Count() == primeira.Length;

    /// <summary>
    /// Votação nos números com um único separador sem ambiguidade: <c>1.234,56</c> e <c>12,5</c> votam na
    /// vírgula; <c>1,234.56</c> e <c>12.50</c> votam no ponto. <c>1.234</c> e <c>1,234</c> não votam.
    /// Sem votos, vale a vírgula, exceto em arquivo separado por vírgula.
    /// </summary>
    private static char DetectDecimalSeparator(IEnumerable<string[]> registros, char? delimitador)
    {
        int virgula = 0, ponto = 0;
        foreach (var campo in registros.SelectMany(r => r))
        {
            if (!NumeroRegex().IsMatch(campo))
            {
                continue;
            }

            var ultimaVirgula = campo.LastIndexOf(',');
            var ultimoPonto = campo.LastIndexOf('.');
            if (ultimaVirgula >= 0 && ultimoPonto >= 0 && ultimaVirgula > ultimoPonto)
            {
                virgula++;
            }
            else if (ultimaVirgula >= 0 && ultimoPonto >= 0)
            {
                ponto++;
            }
            else if (ultimaVirgula >= 0 && ultimaVirgula == campo.IndexOf(',') && campo.Length - ultimaVirgula - 1 != 3)
            {
                virgula++;
            }
            else if (ultimoPonto >= 0 && ultimoPonto == campo.IndexOf('.') && campo.Length - ultimoPonto - 1 != 3)
            {
                ponto++;
            }
        }

        if (virgula != ponto)
        {
            return virgula > ponto ? ',' : '.';
        }

        return delimitador == ',' ? '.' : ',';
    }

    private static string Truncate(string nome) => nome.Length <= NomeColunaMaxLength ? nome : nome[..NomeColunaMaxLength];

    [GeneratedRegex(@"^[+-]?\d[\d.,]*$")]
    private static partial Regex NumeroRegex();

    [GeneratedRegex(@"^[\d\s.,:/+\-]+$")]
    private static partial Regex ValorRegex();
}
