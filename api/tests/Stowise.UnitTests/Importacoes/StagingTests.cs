using System.Text;
using Stowise.Application.Importacoes;
using Stowise.Domain.Common;
using Stowise.Domain.Importacoes;

namespace Stowise.UnitTests.Importacoes;

public class StagingTests
{
    private static readonly DateTimeOffset Agora = new(2026, 10, 18, 12, 0, 0, TimeSpan.Zero);
    private static readonly Guid Usuario = Guid.NewGuid();

    private static readonly IReadOnlyList<MapeamentoColuna> Basico = [new("sku", 0), new("descricao", 1), new("unidadeBase", 2)];

    private static readonly IReadOnlyList<MapeamentoColuna> Completo =
    [
        new("sku", 0), new("descricao", 1), new("unidadeBase", 2), new("gtin", 3), new("ncm", 4), new("cest", 5),
        new("categoria", 6), new("classeArmazenagem", 7), new("controlaLote", 8), new("controlaValidade", 9), new("pesoKg", 10),
    ];

    [Fact]
    public void Import_walks_the_states_from_mapping_to_completion()
    {
        var importacao = NovaImportacao();

        Assert.Throws<InvalidOperationException>(() => importacao.ReportProgress(1));
        importacao.ConfirmMapeamento(Basico, Usuario, Agora);
        Assert.Equal(StatusImportacao.Validando, importacao.Status);
        importacao.ReportProgress(5);
        Assert.Equal(5, importacao.LinhasProcessadas);
        importacao.ReportProgress(99);
        Assert.Equal(importacao.TotalLinhas, importacao.LinhasProcessadas);
        importacao.CompleteValidacao(validas: 8, comErro: 1, possivelDuplicata: 1);
        Assert.Equal(10, importacao.LinhasProcessadas);
        Assert.Equal((StatusImportacao.AguardandoRevisao, 8, 1, 1), (importacao.Status, importacao.LinhasValidas, importacao.LinhasComErro, importacao.LinhasPossivelDuplicata));

        importacao.ConfirmMapeamento(Basico, Usuario, Agora);
        Assert.Equal((StatusImportacao.Validando, 0), (importacao.Status, importacao.LinhasValidas));
        importacao.CompleteValidacao(10, 0, 0);

        importacao.StartEfetivacao();
        Assert.Throws<DomainException>(() => importacao.ConfirmMapeamento(Basico, Usuario, Agora));
        importacao.Complete(Agora.AddMinutes(1));

        Assert.Equal((StatusImportacao.Concluido, Agora.AddMinutes(1)), (importacao.Status, importacao.ConcluidoEm));
        Assert.Throws<DomainException>(() => importacao.Fail("tarde demais", Agora));
    }

    [Fact]
    public void Import_without_valid_lines_cannot_be_committed_and_can_fail_with_a_reason()
    {
        var importacao = NovaImportacao();
        Assert.Throws<InvalidOperationException>(() => importacao.CompleteValidacao(1, 0, 0));
        Assert.Throws<DomainException>(importacao.StartEfetivacao);

        importacao.ConfirmMapeamento(Basico, Usuario, Agora);
        importacao.CompleteValidacao(0, 3, 0);
        Assert.Throws<DomainException>(importacao.StartEfetivacao);

        importacao.Fail(new string('x', 600), Agora);
        Assert.Equal((StatusImportacao.Falhou, Importacao.MotivoFalhaMaxLength, Agora), (importacao.Status, importacao.MotivoFalha!.Length, importacao.ConcluidoEm));
    }

    [Fact]
    public void Line_status_and_action_follow_errors_gtin_and_sku_matches()
    {
        Guid existente = Guid.NewGuid(), outro = Guid.NewGuid();
        ImportacaoLinha Linha(IReadOnlyList<ErroLinha> erros, Guid? mesmoSku, Guid? mesmoGtin) =>
            ImportacaoLinha.Create(Guid.NewGuid(), 1, ["A1"], new Dictionary<string, string?>(), erros, mesmoSku, mesmoGtin);

        var comErro = Linha([new ErroLinha("gtin", "inválido")], existente, null);
        var duplicata = Linha([], null, outro);
        var atualizar = Linha([], existente, existente);
        var criar = Linha([], null, null);

        Assert.Equal((StatusLinha.Erro, AcaoLinha.Ignorar), (comErro.Status, comErro.Acao));
        Assert.Equal((StatusLinha.PossivelDuplicata, AcaoLinha.Ignorar, outro, 1m), (duplicata.Status, duplicata.Acao, duplicata.ProdutoCorrespondenteId, duplicata.Similaridade));
        Assert.Equal((StatusLinha.Valida, AcaoLinha.Atualizar, existente), (atualizar.Status, atualizar.Acao, atualizar.ProdutoCorrespondenteId));
        Assert.Equal((StatusLinha.Valida, AcaoLinha.Criar, (Guid?)null), (criar.Status, criar.Acao, criar.ProdutoCorrespondenteId));
    }

    [Fact]
    public void Valid_row_becomes_canonical_text()
    {
        var linha = NormalizadorProdutos.Normalize(
            ["can-01", "  Caneta   azul  ", "unidade", "789-1000-100103", "8471.30.12", "28.038.00", "Papelaria", "Inflamável", "Sim", "x", "1.234,5"],
            Completo,
            ",");

        Assert.Empty(linha.Erros);
        Assert.Equal("CAN-01", linha.Dados["sku"]);
        Assert.Equal("Caneta azul", linha.Dados["descricao"]);
        Assert.Equal("UN", linha.Dados["unidadeBase"]);
        Assert.Equal("7891000100103", linha.Dados["gtin"]);
        Assert.Equal(("84713012", "2803800"), (linha.Dados["ncm"], linha.Dados["cest"]));
        Assert.Equal(("Papelaria", "Inflamavel"), (linha.Dados["categoria"], linha.Dados["classeArmazenagem"]));
        Assert.Equal(("true", "true", "1234.5"), (linha.Dados["controlaLote"], linha.Dados["controlaValidade"], linha.Dados["pesoKg"]));
    }

    [Fact]
    public void Unmapped_optional_fields_take_defaults_and_empty_codes_are_null()
    {
        var linha = NormalizadorProdutos.Normalize(["A1", "Arroz 5kg", "kg", "", ""], [.. Basico, new("gtin", 3), new("ncm", 4)], ",");

        Assert.Empty(linha.Erros);
        Assert.Equal(("KG", null, null), (linha.Dados["unidadeBase"], linha.Dados["gtin"], linha.Dados["ncm"]));
        Assert.Equal(("Normal", "false", "false"), (linha.Dados["classeArmazenagem"], linha.Dados["controlaLote"], linha.Dados["controlaValidade"]));
        Assert.False(linha.Dados.ContainsKey("pesoKg"));
    }

    [Fact]
    public void Each_invalid_value_is_reported_on_its_field()
    {
        var linha = NormalizadorProdutos.Normalize(
            ["A 1", "", "UNIDADE GRANDE", "7891000100104", "8471", "123", "", "Congelado", "talvez", "sim", "0"],
            Completo,
            ",");

        string[] esperados = ["cest", "classeArmazenagem", "controlaLote", "descricao", "gtin", "ncm", "pesoKg", "sku", "unidadeBase"];
        Assert.Equal(esperados, linha.Erros.Select(e => e.Campo).Order(StringComparer.Ordinal));
    }

    [Theory]
    [InlineData("1.234,56", ",", "1234.56")]
    [InlineData("12,5", ",", "12.5")]
    [InlineData("1,234.56", ".", "1234.56")]
    [InlineData("0.75", ".", "0.75")]
    [InlineData("1,5", ".", null)]
    [InlineData("12.34.5", ",", null)]
    [InlineData("abc", ",", null)]
    public void Measures_use_the_confirmed_decimal_separator_and_reject_ambiguous_numbers(string valor, string separador, string? esperado)
    {
        var linha = NormalizadorProdutos.Normalize(["A1", "Arroz", "UN", valor], [.. Basico, new("pesoKg", 3)], separador);

        Assert.Equal(esperado, linha.Dados["pesoKg"]);
        Assert.Equal(esperado is null, linha.Erros.Any(e => e.Campo == "pesoKg"));
    }

    [Fact]
    public void Expiry_control_needs_lot_control()
    {
        var linha = NormalizadorProdutos.Normalize(["A1", "Iogurte", "UN", "não", "sim"], [.. Basico, new("controlaLote", 3), new("controlaValidade", 4)], ",");

        Assert.Equal("controlaValidade", Assert.Single(linha.Erros).Campo);
    }

    [Fact]
    public void Stored_rows_are_read_back_with_the_detected_layout()
    {
        var texto = "SKU;Descrição\nA1;\"Arroz; tipo 1\"\n\nB2;Feijão\n";
        var conteudo = Encoding.UTF8.GetBytes(texto);
        var detectado = DetectorLayout.Detect(conteudo).Value;

        var linhas = DetectorLayout.ReadRows(conteudo, detectado.Layout).ToList();

        Assert.Equal(detectado.TotalLinhas, linhas.Count);
        Assert.Equal(["A1", "Arroz; tipo 1"], linhas[0]);
        Assert.Equal(["B2", "Feijão"], linhas[1]);
    }

    [Fact]
    public void Positional_rows_are_sliced_with_the_stored_columns()
    {
        var conteudo = Encoding.UTF8.GetBytes(string.Join('\n', [$"{"SKU",-8}DESCRICAO", $"{"A1",-8}ARROZ 5KG", $"{"B2",-8}FEIJAO"]));
        var layout = DetectorLayout.Detect(conteudo).Value.Layout;

        Assert.Equal([["A1", "ARROZ 5KG"], ["B2", "FEIJAO"]], DetectorLayout.ReadRows(conteudo, layout));
    }

    private static Importacao NovaImportacao() =>
        Importacao.Create(
            TipoImportacao.Produtos,
            "produtos.csv",
            new string('a', Importacao.HashArquivoLength),
            10,
            new LayoutArquivo(FormatoArquivo.Delimitado, "utf-8", ";", ",", true, [new(0, "SKU"), new(1, "Descrição"), new(2, "Unidade")]),
            [],
            10,
            Usuario,
            Agora);
}
