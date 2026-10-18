using System.IO.Compression;
using MiniExcelLibs;
using Stowise.Application.Importacoes;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Importacoes;

namespace Stowise.IntegrationTests.Importacoes;

/// <summary>Leitura de <c>.xlsx</c> reais, criados em memória com o MiniExcel.</summary>
public class LeitorXlsxTests
{
    [Fact]
    public void Cells_become_invariant_text_from_the_first_sheet()
    {
        var conteudo = Planilhas.Xlsx(
            ("Produtos", [
                ["SKU", "Descrição", "Preço", "GTIN", "Validade"],
                ["CAN-01", "Caneta azul", 1.5, 7891000100103L, new DateTime(2026, 10, 18)],
                ["LAP-02", "Lápis preto", 12m, null, new DateTime(2026, 10, 18, 9, 30, 0)],
            ]),
            ("Outra aba", [["Ignorada"]]));

        var arquivo = Detect(conteudo);

        Assert.Equal((FormatoArquivo.Excel, "Produtos", "."), (arquivo.Layout.Formato, arquivo.Layout.Planilha, arquivo.Layout.SeparadorDecimal));
        Assert.Null(arquivo.Layout.Encoding);
        Assert.True(arquivo.Layout.TemCabecalho);
        Assert.Equal(["SKU", "Descrição", "Preço", "GTIN", "Validade"], arquivo.Layout.Colunas.Select(c => c.Nome));
        Assert.Equal(["CAN-01", "Caneta azul", "1.5", "7891000100103", "2026-10-18"], arquivo.Amostra[0]);
        Assert.Equal(["LAP-02", "Lápis preto", "12", "", "2026-10-18T09:30:00"], arquivo.Amostra[1]);
        Assert.Equal(2, arquivo.TotalLinhas);
    }

    [Fact]
    public void Blank_rows_and_an_empty_first_column_are_ignored()
    {
        var conteudo = Planilhas.Xlsx(("Plan1", [
            [null, "SKU", "Descricao"],
            [null, null, null],
            [null, "A1", "Arroz 5kg"],
        ]));

        var arquivo = Detect(conteudo);

        Assert.Equal(["SKU", "Descricao"], arquivo.Layout.Colunas.Select(c => c.Nome));
        Assert.Equal(["A1", "Arroz 5kg"], Assert.Single(arquivo.Amostra));
    }

    [Fact]
    public void Empty_first_sheet_is_reported_by_name()
    {
        var resultado = LeitorXlsx.Detect(Planilhas.Xlsx(("Vazia", [[null]])));

        Assert.Equal("A primeira aba da planilha (Vazia) está vazia.", Assert.Single(resultado.Error!.Fields!["arquivo"]));
    }

    [Fact]
    public void Zip_that_is_not_a_spreadsheet_is_rejected()
    {
        using var zip = new MemoryStream();
        using (var arquivo = new ZipArchive(zip, ZipArchiveMode.Create, leaveOpen: true))
        {
            using var writer = new StreamWriter(arquivo.CreateEntry("leia-me.txt").Open());
            writer.Write("não é planilha");
        }

        byte[] corrompido = [0x50, 0x4B, 0x03, 0x04, 0x14, 0x00, 0x00, 0x00, 0xFF, 0xFF];

        Assert.All([zip.ToArray(), corrompido], conteudo => Assert.Equal(
            "O arquivo não é uma planilha .xlsx válida. Abra no Excel, salve de novo e envie.",
            Assert.Single(LeitorXlsx.Detect(conteudo).Error!.Fields!["arquivo"])));
    }

    private static ArquivoDetectado Detect(byte[] conteudo)
    {
        var resultado = LeitorXlsx.Detect(conteudo);
        Assert.True(resultado.IsSuccess, resultado.Error?.Fields?.Values.SelectMany(v => v).FirstOrDefault());
        return resultado.Value;
    }
}

/// <summary>Monta um <c>.xlsx</c> em memória, uma lista de linhas por aba.</summary>
internal static class Planilhas
{
    public static byte[] Xlsx(params (string Nome, object?[][] Linhas)[] abas)
    {
        var sheets = abas.ToDictionary(
            a => a.Nome,
            a => (object)a.Linhas
                .Select(linha => linha.Select((valor, i) => (Coluna: ((char)('A' + i)).ToString(), Valor: valor))
                    .ToDictionary(c => c.Coluna, c => c.Valor))
                .ToList());

        using var stream = new MemoryStream();
        MiniExcel.SaveAs(stream, sheets, printHeader: false);
        return stream.ToArray();
    }
}
