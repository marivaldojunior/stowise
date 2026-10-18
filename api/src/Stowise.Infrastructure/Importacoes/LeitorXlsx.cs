using System.Globalization;
using System.Xml;
using MiniExcelLibs;
using MiniExcelLibs.OpenXml;
using Stowise.Application.Common;
using Stowise.Application.Importacoes;
using Stowise.Domain.Importacoes;

namespace Stowise.Infrastructure.Importacoes;

/// <summary>
/// Lê a primeira aba de um <c>.xlsx</c> com o MiniExcel (leitura em fluxo) e converte cada célula em texto.
/// Números saem na cultura invariante (ponto decimal) e datas em ISO 8601, para a normalização ser única.
/// </summary>
internal static class LeitorXlsx
{
    /// <summary>Sem cache em disco das strings compartilhadas: o arquivo já está em memória e tem no máximo 20 MB.</summary>
    private static readonly OpenXmlConfiguration Configuracao = new() { EnableSharedStringCache = false, FillMergedCells = false };

    public static Result<ArquivoDetectado> Detect(byte[] conteudo)
    {
        ArgumentNullException.ThrowIfNull(conteudo);

        try
        {
            using var stream = new MemoryStream(conteudo, writable: false);
            var planilha = MiniExcel.GetSheetNames(stream, Configuracao).FirstOrDefault();
            if (planilha is null)
            {
                return Erro("A planilha não tem abas.");
            }

            stream.Position = 0;
            var linhas = MiniExcel.Query(stream, useHeaderRow: false, sheetName: planilha, excelType: ExcelType.XLSX, configuration: Configuracao)
                .Cast<IDictionary<string, object?>>()
                .Select(ToRow)
                .Take(Importacao.MaxLinhas + 2)
                .ToList();

            return linhas.All(l => l.Length == 0)
                ? Erro($"A primeira aba da planilha ({planilha}) está vazia.")
                : DetectorLayout.DetectPlanilha(planilha, linhas);
        }
        catch (Exception e) when (e is InvalidDataException or XmlException or InvalidOperationException or KeyNotFoundException or FormatException or IndexOutOfRangeException or ArgumentException)
        {
            // Arquivo corrompido ou ZIP que não é planilha: a mensagem do leitor não ajuda o usuário.
            return Erro("O arquivo não é uma planilha .xlsx válida. Abra no Excel, salve de novo e envie.");
        }
    }

    /// <summary>Células em ordem de coluna (A, B, ...), sem as vazias no fim da linha.</summary>
    private static string[] ToRow(IDictionary<string, object?> celulas)
    {
        var valores = celulas.Values.Select(ToText).ToList();
        var fim = valores.FindLastIndex(v => v.Length > 0);
        return [.. valores.Take(fim + 1)];
    }

    private static string ToText(object? valor) => valor switch
    {
        null => string.Empty,
        string texto => texto.Trim(),
        DateTime data when data.TimeOfDay == TimeSpan.Zero => data.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture),
        DateTime data => data.ToString("yyyy-MM-ddTHH:mm:ss", CultureInfo.InvariantCulture),
        double numero when double.IsInteger(numero) && Math.Abs(numero) < 1e15 => ((long)numero).ToString(CultureInfo.InvariantCulture),
        bool logico => logico ? "true" : "false",
        IFormattable formatavel => formatavel.ToString(null, CultureInfo.InvariantCulture),
        _ => valor.ToString()?.Trim() ?? string.Empty,
    };

    private static AppError Erro(string mensagem) => AppError.Validation("arquivo", mensagem);
}
