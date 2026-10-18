using Stowise.Application.Importacoes;
using Stowise.Domain.Common;
using Stowise.Domain.Importacoes;

namespace Stowise.UnitTests.Importacoes;

public class SugestaoMapeamentoTests
{
    private static readonly DateTimeOffset Agora = new(2026, 10, 18, 12, 0, 0, TimeSpan.Zero);
    private static readonly Guid Usuario = Guid.NewGuid();

    private static readonly IReadOnlyList<MapeamentoColuna> Basico = [new("sku", 0), new("descricao", 1), new("unidadeBase", 2)];

    [Fact]
    public void Suggestion_is_cleaned_before_it_becomes_the_proposal()
    {
        var importacao = NovaImportacao();
        importacao.StartSugestao();

        importacao.ApplySugestao(new SugestaoIa(
            [
                new("sku", 0, 0.9m), new("sku", 1, 0.4m), new("descricao", 1, 1.7m), new("gtin", 9, 0.8m), new("fabricante", 2, 1m),
                new("unidadeBase", 2, -0.2m),
            ],
            new RegrasNormalizacao(";", [new("Saco", "sc"), new("Fardo", "fardo grande"), new(" ", "UN")], ["Ativo", "Sim"], ["sim", "Inativo"]),
            "Coluna de unidade com textos livres.",
            Guid.NewGuid()));

        Assert.Equal(StatusImportacao.AguardandoConfirmacao, importacao.Status);
        Assert.True(importacao.MapeamentoSugeridoPorIa);
        Assert.Null(importacao.MapeamentoConfirmadoPor);
        Assert.Equal(Basico, importacao.Mapeamento);
        Assert.Equal([0.9m, 1m, 0m], importacao.SugestaoIa!.Colunas.Select(c => c.Confianca));
        var regras = importacao.Regras!;
        Assert.Null(regras.SeparadorDecimal);
        Assert.Equal([new UnidadeDePara("Saco", "SC")], regras.Unidades);
        Assert.Equal(["Ativo"], regras.ValoresVerdadeiros);
        Assert.Equal(["sim", "Inativo"], regras.ValoresFalsos);
    }

    [Fact]
    public void Without_any_usable_column_the_suggestion_fails_and_the_import_goes_back()
    {
        var importacao = NovaImportacao();
        importacao.StartSugestao();

        importacao.ApplySugestao(new SugestaoIa([new("gtin", 7, 1m)], RegrasNormalizacao.Vazias, null, null));

        Assert.Equal(StatusImportacao.Recebido, importacao.Status);
        Assert.Contains("nenhuma coluna", importacao.MotivoSemSugestao, StringComparison.Ordinal);
        Assert.Null(importacao.Mapeamento);
    }

    [Fact]
    public void Failed_suggestion_keeps_the_template_proposal_and_states_are_checked()
    {
        var importacao = NovaImportacao();
        Assert.Throws<InvalidOperationException>(() => importacao.FailSugestao("x"));

        importacao.StartSugestao();
        importacao.ApplySugestao(new SugestaoIa([new("sku", 0, 1m)], RegrasNormalizacao.Vazias, null, null));
        importacao.StartSugestao();
        importacao.FailSugestao("Cota de IA atingida.");

        Assert.Equal((StatusImportacao.AguardandoConfirmacao, "Cota de IA atingida."), (importacao.Status, importacao.MotivoSemSugestao));
        importacao.ConfirmMapeamento(Basico, null, Usuario, Agora);
        Assert.Throws<DomainException>(importacao.StartSugestao);
    }

    [Fact]
    public void Confirmed_rules_replace_the_detected_decimal_separator_and_the_template_learns_them()
    {
        var importacao = NovaImportacao();
        var regras = new RegrasNormalizacao(".", [new("Saco", "SC")], [], []);

        importacao.ConfirmMapeamento(Basico, regras, Usuario, Agora);
        var template = TemplateImportacao.Create(importacao, "Fornecedor A", sugeridoPorIa: true, Usuario, Agora);

        Assert.Equal(".", importacao.SeparadorDecimal);
        Assert.True(regras.SameAs(template.Regras));
        Assert.True(template.SugeridoPorIa);

        var proxima = NovaImportacao();
        proxima.ApplyTemplate(template);
        Assert.True(regras.SameAs(proxima.Regras));
        Assert.False(proxima.MapeamentoSugeridoPorIa);
    }

    [Fact]
    public void Template_takes_new_rules_when_the_person_changes_them()
    {
        var primeira = NovaImportacao();
        primeira.ConfirmMapeamento(Basico, null, Usuario, Agora);
        var template = TemplateImportacao.Create(primeira, "A", sugeridoPorIa: false, Usuario, Agora);

        var segunda = NovaImportacao();
        segunda.ConfirmMapeamento(Basico, new RegrasNormalizacao(null, [new("Saco", "SC")], [], []), Usuario, Agora.AddDays(1));
        template.RegisterUse(segunda, novoUso: true, sugeridoPorIa: false, Usuario, Agora.AddDays(1));

        Assert.Equal([new UnidadeDePara("Saco", "SC")], template.Regras.Unidades);
        Assert.Equal(Agora.AddDays(1), template.ConfirmadoEm);
    }

    [Theory]
    [InlineData(";", null, "vírgula ou ponto")]
    [InlineData(null, "UNIDADE GRANDE", "Regra de unidade inválida")]
    public void Invalid_rules_from_a_person_are_refused(string? separador, string? destino, string trecho)
    {
        var regras = new RegrasNormalizacao(separador, destino is null ? [] : [new("Saco", destino)], [], []);

        var erro = Assert.Throws<DomainException>(() => regras.Validate());

        Assert.Contains(trecho, erro.Message, StringComparison.Ordinal);
        Assert.Throws<DomainException>(() => new RegrasNormalizacao(null, [], ["sim"], ["SIM"]).Validate());
    }

    [Fact]
    public void Normalizer_applies_the_confirmed_unit_and_yes_no_rules_before_the_defaults()
    {
        var regras = new RegrasNormalizacao(null, [new("Saco", "SC")], ["Ativo"], ["Inativo"]);
        IReadOnlyList<MapeamentoColuna> mapeamento = [.. Basico, new("controlaLote", 3)];

        var com = NormalizadorProdutos.Normalize(["A1", "Arroz 5kg", "saco", "ativo"], mapeamento, ",", regras);
        var sem = NormalizadorProdutos.Normalize(["A1", "Arroz 5kg", "saco", "ativo"], mapeamento, ",");

        Assert.Empty(com.Erros);
        Assert.Equal(("SC", "true"), (com.Dados["unidadeBase"], com.Dados["controlaLote"]));
        Assert.Equal("SACO", sem.Dados["unidadeBase"]);
        Assert.Equal("controlaLote", Assert.Single(sem.Erros).Campo);
    }

    private static Importacao NovaImportacao() =>
        Importacao.Create(
            TipoImportacao.Produtos,
            "produtos.csv",
            new string('a', Importacao.HashArquivoLength),
            10,
            new LayoutArquivo(FormatoArquivo.Delimitado, "utf-8", ";", ",", true, [new(0, "SKU"), new(1, "Descrição"), new(2, "Unidade"), new(3, "Lote")]),
            [],
            1,
            Usuario,
            Agora);
}
