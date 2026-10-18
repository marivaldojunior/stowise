using Stowise.Application.Importacoes;
using Stowise.Domain.Common;
using Stowise.Domain.Importacoes;

namespace Stowise.UnitTests.Importacoes;

public class TemplateImportacaoTests
{
    private static readonly DateTimeOffset Agora = new(2026, 10, 18, 12, 0, 0, TimeSpan.Zero);
    private static readonly Guid Usuario = Guid.NewGuid();

    private static readonly IReadOnlyList<MapeamentoColuna> Mapeamento =
        [new("descricao", 1), new("sku", 0), new("unidadeBase", 2)];

    [Fact]
    public void Header_fingerprint_ignores_case_accents_and_punctuation_but_not_order()
    {
        var original = FingerprintLayout.Calculate(Layout(true, "SKU", "Descrição", "Preço Unit. (R$)"));

        Assert.Equal(original, FingerprintLayout.Calculate(Layout(true, " sku ", "DESCRICAO", "preco unit r")));
        Assert.NotEqual(original, FingerprintLayout.Calculate(Layout(true, "Descrição", "SKU", "Preço Unit. (R$)")));
        Assert.Equal(FingerprintLayout.Length, original!.Length);
        Assert.Equal("preco unit r", FingerprintLayout.Normalize("Preço Unit. (R$)"));
    }

    [Fact]
    public void Only_positional_files_without_header_have_a_structural_fingerprint()
    {
        var semCabecalho = Layout(false, "Coluna 1", "Coluna 2");
        var posicional = semCabecalho with
        {
            Formato = FormatoArquivo.Posicional,
            Colunas = [new ColunaArquivo(0, "Coluna 1", 0, 8), new ColunaArquivo(1, "Coluna 2", 8, 20)],
        };
        var outrasPosicoes = posicional with
        {
            Colunas = [new ColunaArquivo(0, "Coluna 1", 0, 10), new ColunaArquivo(1, "Coluna 2", 10, 20)],
        };

        Assert.Null(FingerprintLayout.Calculate(semCabecalho));
        Assert.NotNull(FingerprintLayout.Calculate(posicional));
        Assert.NotEqual(FingerprintLayout.Calculate(posicional), FingerprintLayout.Calculate(outrasPosicoes));
    }

    [Fact]
    public void Confirmed_mapping_is_ordered_by_column_and_checked_against_the_file()
    {
        var importacao = NovaImportacao();

        importacao.ConfirmMapeamento(Mapeamento, null, Usuario, Agora);

        Assert.Equal([new("sku", 0), new("descricao", 1), new MapeamentoColuna("unidadeBase", 2)], importacao.Mapeamento);
        Assert.Equal((Usuario, Agora), (importacao.MapeamentoConfirmadoPor, importacao.MapeamentoConfirmadoEm));

        Assert.Equal(StatusImportacao.Validando, importacao.Status);

        IReadOnlyList<MapeamentoColuna>[] invalidos =
        [
            [.. Mapeamento, new("gtin", 3)],
            [.. Mapeamento, new("fabricante", 0)],
            [.. Mapeamento, new("sku", 1)],
            [new("sku", 0)],
        ];
        Assert.All(invalidos, m =>
        {
            var nova = NovaImportacao();
            Assert.Throws<DomainException>(() => nova.ConfirmMapeamento(m, null, Usuario, Agora));
            Assert.Equal(StatusImportacao.Recebido, nova.Status);
        });
    }

    [Fact]
    public void Template_is_created_only_from_a_confirmed_mapping_with_a_fingerprint()
    {
        var importacao = NovaImportacao();
        Assert.Throws<DomainException>(() => TemplateImportacao.Create(importacao, "Fornecedor A", false, Usuario, Agora));

        importacao.ConfirmMapeamento(Mapeamento, null, Usuario, Agora);
        var template = TemplateImportacao.Create(importacao, " Fornecedor A ", false, Usuario, Agora);

        Assert.Equal(("Fornecedor A", 1, importacao.Fingerprint), (template.Nome, template.VezesUsado, template.Fingerprint));
        Assert.Equal(importacao.Mapeamento, template.Mapeamento);
        Assert.Equal((FormatoArquivo.Delimitado, ";", ","), (template.Formato, template.Delimitador, template.SeparadorDecimal));

        var semCabecalho = NovaImportacao(Layout(false, "Coluna 1", "Coluna 2", "Coluna 3"));
        semCabecalho.ConfirmMapeamento(Mapeamento, null, Usuario, Agora);
        Assert.Throws<DomainException>(() => TemplateImportacao.Create(semCabecalho, "X", false, Usuario, Agora));
    }

    [Fact]
    public void Recognized_file_gets_the_template_mapping_as_a_suggestion_and_its_decimal_separator()
    {
        var primeira = NovaImportacao(Layout(true, "SKU", "Descrição", "Unidade") with { SeparadorDecimal = "." });
        primeira.ConfirmMapeamento(Mapeamento, null, Usuario, Agora);
        var template = TemplateImportacao.Create(primeira, "Fornecedor A", false, Usuario, Agora);

        var segunda = NovaImportacao(Layout(true, "sku", "descricao", "unidade"));
        segunda.ApplyTemplate(template);

        Assert.Equal(template.Id, segunda.TemplateId);
        Assert.Equal(template.Mapeamento, segunda.Mapeamento);
        Assert.Null(segunda.MapeamentoConfirmadoPor);
        Assert.Equal(".", segunda.SeparadorDecimal);
        Assert.Throws<InvalidOperationException>(() => NovaImportacao(Layout(true, "A", "B", "C")).ApplyTemplate(template));
    }

    [Fact]
    public void Each_new_confirmation_counts_once_and_a_changed_mapping_replaces_the_old_one()
    {
        var primeira = NovaImportacao();
        primeira.ConfirmMapeamento(Mapeamento, null, Usuario, Agora);
        var template = TemplateImportacao.Create(primeira, "Fornecedor A", false, Usuario, Agora);

        var segunda = NovaImportacao();
        segunda.ConfirmMapeamento(Mapeamento, null, Usuario, Agora.AddDays(1));
        template.RegisterUse(segunda, novoUso: true, sugeridoPorIa: false, Usuario, Agora.AddDays(1));
        template.RegisterUse(segunda, novoUso: false, sugeridoPorIa: false, Usuario, Agora.AddDays(1));
        Assert.Equal((2, Agora), (template.VezesUsado, template.ConfirmadoEm));

        var outro = Guid.NewGuid();
        segunda.CompleteValidacao(1, 0, 0);
        segunda.ConfirmMapeamento([new("sku", 0), new("descricao", 2), new("unidadeBase", 1)], null, outro, Agora.AddDays(2));
        template.RegisterUse(segunda, novoUso: false, sugeridoPorIa: true, outro, Agora.AddDays(2));

        Assert.Equal(new MapeamentoColuna("unidadeBase", 1), template.Mapeamento[1]);
        Assert.Equal((2, outro, true, Agora.AddDays(2)), (template.VezesUsado, template.ConfirmadoPor, template.SugeridoPorIa, template.UltimoUsoEm));
    }

    [Fact]
    public void Mapping_request_validation_reports_each_problem_by_field()
    {
        var comando = new ConfirmarMapeamento([new("sku", 0), new("sku", 1), new("fabricante", -1)], null, true, new string('x', 101));

        Assert.Equal(
            ["colunas", "colunas[1].campo", "colunas[2].campo", "colunas[2].coluna", "nomeTemplate", "versao"],
            ImportacaoValidation.Validate(comando, TipoImportacao.Produtos).Keys.Order(StringComparer.Ordinal));
        Assert.Empty(ImportacaoValidation.Validate(new ConfirmarMapeamento(Mapeamento, 1), TipoImportacao.Produtos));
        Assert.Equal(["colunas"], ImportacaoValidation.Validate(new ConfirmarMapeamento([], 1), TipoImportacao.Produtos).Keys);
        Assert.Equal(["nome", "versao"], ImportacaoValidation.Validate(new RenomearTemplate(" ", null)).Keys.Order(StringComparer.Ordinal));
    }

    private static LayoutArquivo Layout(bool temCabecalho, params string[] nomes) =>
        new(FormatoArquivo.Delimitado, "utf-8", ";", ",", temCabecalho, [.. nomes.Select((n, i) => new ColunaArquivo(i, n))]);

    private static Importacao NovaImportacao(LayoutArquivo? layout = null) =>
        Importacao.Create(
            TipoImportacao.Produtos,
            "produtos.csv",
            new string('a', Importacao.HashArquivoLength),
            10,
            layout ?? Layout(true, "SKU", "Descrição", "Unidade"),
            [],
            1,
            Usuario,
            Agora);
}
