using System.Text;
using Stowise.Application.Importacoes;
using Stowise.Domain.Importacoes;

namespace Stowise.UnitTests.Importacoes;

public class DetectorLayoutTests
{
    private static readonly Encoding Windows1252 = CodePagesEncodingProvider.Instance.GetEncoding(1252)!;

    [Fact]
    public void Semicolon_file_with_header_and_comma_decimals()
    {
        var arquivo = Detect("SKU;Descrição;Preço;Unidade\nCAN-01;Caneta azul;1,50;UN\nLAP-02;Lápis preto;0,75;UN\n");

        Assert.Equal(FormatoArquivo.Delimitado, arquivo.Layout.Formato);
        Assert.Equal("utf-8", arquivo.Layout.Encoding);
        Assert.Equal(";", arquivo.Layout.Delimitador);
        Assert.Equal(",", arquivo.Layout.SeparadorDecimal);
        Assert.True(arquivo.Layout.TemCabecalho);
        Assert.Equal(["SKU", "Descrição", "Preço", "Unidade"], arquivo.Layout.Colunas.Select(c => c.Nome));
        Assert.Equal([0, 1, 2, 3], arquivo.Layout.Colunas.Select(c => c.Indice));
        Assert.All(arquivo.Layout.Colunas, c => Assert.Null(c.Inicio));
        Assert.Equal(2, arquivo.TotalLinhas);
        Assert.Equal(["LAP-02", "Lápis preto", "0,75", "UN"], arquivo.Amostra[1]);
    }

    [Fact]
    public void Quoted_fields_keep_delimiters_doubled_quotes_and_line_breaks()
    {
        var arquivo = Detect("sku,descricao,preco\r\n\"CAN-01\",\"Caneta, azul \"\"fina\"\"\",1.50\r\nLAP-02,\"Lápis\r\npreto\",0.75\r\n");

        Assert.Equal(",", arquivo.Layout.Delimitador);
        Assert.Equal(".", arquivo.Layout.SeparadorDecimal);
        Assert.Equal(2, arquivo.TotalLinhas);
        Assert.Equal(["CAN-01", "Caneta, azul \"fina\"", "1.50"], arquivo.Amostra[0]);
        Assert.Equal("Lápis\r\npreto", arquivo.Amostra[1][1]);
    }

    [Theory]
    [InlineData('\t', "\t")]
    [InlineData('|', "|")]
    public void Tab_and_pipe_files_are_detected(char separador, string esperado)
    {
        var arquivo = Detect(string.Join('\n', [
            string.Join(separador, "gtin", "descricao", "ncm"),
            string.Join(separador, "7891000100103", "Leite integral 1L", "04012010"),
            string.Join(separador, "7891000053508", "Achocolatado 400g", "18069000"),
        ]));

        Assert.Equal(esperado, arquivo.Layout.Delimitador);
        Assert.Equal(3, arquivo.Layout.Colunas.Count);
    }

    [Fact]
    public void First_row_with_values_is_data_and_columns_get_generic_names()
    {
        var arquivo = Detect("7891000100103;Leite integral 1L;4,99\n7891000053508;Achocolatado 400g;8,49\n");

        Assert.False(arquivo.Layout.TemCabecalho);
        Assert.Equal(["Coluna 1", "Coluna 2", "Coluna 3"], arquivo.Layout.Colunas.Select(c => c.Nome));
        Assert.Equal(2, arquivo.TotalLinhas);
        Assert.Equal("7891000100103", arquivo.Amostra[0][0]);
    }

    [Fact]
    public void Repeated_or_empty_names_are_not_a_header()
    {
        Assert.False(Detect("Nome;Nome;Preço\nA;B;1,00\n").Layout.TemCabecalho);
        Assert.False(Detect("Nome;;Preço\nA;B;1,00\n").Layout.TemCabecalho);
    }

    [Fact]
    public void Invalid_utf8_falls_back_to_windows_1252()
    {
        var arquivo = DetectBytes(Windows1252.GetBytes("SKU;Descrição\nA1;Pão de açúcar\nA2;Café\n"));

        Assert.Equal("windows-1252", arquivo.Layout.Encoding);
        Assert.Equal("Descrição", arquivo.Layout.Colunas[1].Nome);
        Assert.Equal("Pão de açúcar", arquivo.Amostra[0][1]);
    }

    [Fact]
    public void Byte_order_marks_set_the_encoding_and_are_not_part_of_the_first_column()
    {
        const string texto = "SKU;Descrição\nA1;Pão\n";

        var utf8 = DetectBytes([.. Encoding.UTF8.GetPreamble(), .. Encoding.UTF8.GetBytes(texto)]);
        var utf16 = DetectBytes([.. Encoding.Unicode.GetPreamble(), .. Encoding.Unicode.GetBytes(texto)]);
        var utf16Be = DetectBytes([.. Encoding.BigEndianUnicode.GetPreamble(), .. Encoding.BigEndianUnicode.GetBytes(texto)]);

        Assert.Equal(("utf-8", "SKU"), (utf8.Layout.Encoding, utf8.Layout.Colunas[0].Nome));
        Assert.Equal(("utf-16le", "SKU"), (utf16.Layout.Encoding, utf16.Layout.Colunas[0].Nome));
        Assert.Equal(("utf-16be", "Pão"), (utf16Be.Layout.Encoding, utf16Be.Amostra[0][1]));
    }

    [Fact]
    public void Fixed_width_file_becomes_positional_with_start_and_length()
    {
        var arquivo = Detect(string.Join("\r\n", [
            $"{"SKU",-8}{"DESCRICAO",-20}QTD",
            $"{"CAN-01",-8}{"CANETA AZUL",-20} 10",
            $"{"LAP-02",-8}{"LAPIS PRETO",-20}  5",
        ]));

        Assert.Equal(FormatoArquivo.Posicional, arquivo.Layout.Formato);
        Assert.Null(arquivo.Layout.Delimitador);
        Assert.True(arquivo.Layout.TemCabecalho);
        Assert.Equal(
            [new ColunaArquivo(0, "SKU", 0, 8), new ColunaArquivo(1, "DESCRICAO", 8, 20), new ColunaArquivo(2, "QTD", 28, 3)],
            arquivo.Layout.Colunas);
        Assert.Equal(["LAP-02", "LAPIS PRETO", "5"], arquivo.Amostra[1]);
    }

    [Fact]
    public void Text_without_delimiters_or_aligned_columns_is_a_single_column()
    {
        var arquivo = Detect("Caneta azul\nLápis preto\nBorracha\n");

        Assert.Equal(FormatoArquivo.Delimitado, arquivo.Layout.Formato);
        Assert.Null(arquivo.Layout.Delimitador);
        Assert.Single(arquivo.Layout.Colunas);
    }

    [Theory]
    [InlineData("SKU;Preço\nA;1.234,56\nB;2.000,10\n", ",")]
    [InlineData("SKU;Preço\nA;1,234.56\nB;12.50\n", ".")]
    [InlineData("SKU;Peso\nA;1.234\nB;2.500\n", ",")]
    [InlineData("SKU,Peso\nA,1.234\nB,2.500\n", ".")]
    [InlineData("SKU;NCM;Preço\nA;8471.30.12;12,5\n", ",")]
    public void Decimal_separator_follows_unambiguous_numbers(string texto, string esperado)
    {
        Assert.Equal(esperado, Detect(texto).Layout.SeparadorDecimal);
    }

    [Fact]
    public void Sample_has_ten_rows_and_blank_lines_are_not_counted()
    {
        var linhas = Enumerable.Range(1, 25).Select(i => $"P{i:000};Produto {i};{i},90").ToList();
        linhas.Insert(5, "   ");

        var arquivo = Detect("SKU;Descricao;Preco\n" + string.Join('\n', linhas) + "\n\n\n");

        Assert.Equal(25, arquivo.TotalLinhas);
        Assert.Equal(DetectorLayout.LinhasAmostra, arquivo.Amostra.Count);
        Assert.Equal("P010", arquivo.Amostra[^1][0]);
    }

    [Theory]
    [InlineData(new byte[] { 0x50, 0x4B, 0x03, 0x04, 0x14, 0x00 }, "Excel")]
    [InlineData(new byte[] { 0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1 }, "Excel")]
    [InlineData(new byte[] { 0x89, 0x50, 0x4E, 0x47, 0x00, 0x00 }, "não é texto")]
    [InlineData(new byte[] { 0x20, 0x0A, 0x0D, 0x0A }, "não tem linhas")]
    [InlineData(new byte[0], "vazio")]
    public void Unreadable_files_are_rejected_on_the_file_field(byte[] conteudo, string trecho)
    {
        var resultado = DetectorLayout.Detect(conteudo);

        Assert.False(resultado.IsSuccess);
        var erro = Assert.Single(resultado.Error!.Fields!);
        Assert.Equal("arquivo", erro.Key);
        Assert.Contains(trecho, erro.Value.Single(), StringComparison.Ordinal);
    }

    private static ArquivoDetectado Detect(string texto) => DetectBytes(Encoding.UTF8.GetBytes(texto));

    private static ArquivoDetectado DetectBytes(byte[] conteudo)
    {
        var resultado = DetectorLayout.Detect(conteudo);
        Assert.True(resultado.IsSuccess, resultado.Error?.Fields?.Values.SelectMany(v => v).FirstOrDefault());
        return resultado.Value;
    }
}
