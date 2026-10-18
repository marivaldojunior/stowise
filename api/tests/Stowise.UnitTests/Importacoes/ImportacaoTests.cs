using Stowise.Application.Importacoes;
using Stowise.Domain.Common;
using Stowise.Domain.Importacoes;

namespace Stowise.UnitTests.Importacoes;

public class ImportacaoTests
{
    private static readonly DateTimeOffset Agora = new(2026, 10, 18, 12, 0, 0, TimeSpan.Zero);
    private static readonly string Hash = new('A', Importacao.HashArquivoLength);

    private static readonly LayoutArquivo Layout = new(
        FormatoArquivo.Delimitado, "utf-8", ";", ",", true, [new ColunaArquivo(0, "SKU"), new ColunaArquivo(1, "Descrição")]);

    [Fact]
    public void New_import_starts_as_received_with_the_detected_layout()
    {
        var importacao = Create(" produtos.csv ");

        Assert.Equal(StatusImportacao.Recebido, importacao.Status);
        Assert.Equal("produtos.csv", importacao.NomeArquivo);
        Assert.Equal(new string('a', Importacao.HashArquivoLength), importacao.HashArquivo);
        Assert.Equal(Layout, importacao.Layout);
        Assert.Equal(Agora, importacao.IniciadoEm);
        Assert.Null(importacao.ConcluidoEm);
    }

    [Fact]
    public void Import_needs_a_file_name_and_at_least_one_column()
    {
        Assert.Throws<DomainException>(() => Create(" "));
        Assert.Throws<DomainException>(() => Importacao.Create(
            TipoImportacao.Produtos, "a.csv", Hash, 10, Layout with { Colunas = [] }, [], 0, Guid.NewGuid(), Agora));
        Assert.Throws<ArgumentException>(() => Importacao.Create(
            TipoImportacao.Produtos, "a.csv", "abc", 10, Layout, [], 0, Guid.NewGuid(), Agora));
    }

    [Fact]
    public void Stored_file_must_match_the_import_size()
    {
        var importacao = Create("a.csv");

        Assert.Equal(importacao.Id, ArquivoImportacao.Create(importacao, new byte[10]).ImportacaoId);
        Assert.Throws<ArgumentException>(() => ArquivoImportacao.Create(importacao, new byte[9]));
    }

    [Fact]
    public void Upload_validation_reports_missing_empty_and_oversized_files()
    {
        static IEnumerable<string> Campos(ReceberArquivo comando) =>
            ImportacaoValidation.Validate(comando).Keys.Order(StringComparer.Ordinal);

        Assert.Equal(["arquivo"], Campos(new ReceberArquivo(TipoImportacao.Produtos, null, null)));
        Assert.Equal(["arquivo", "nomeArquivo"], Campos(new ReceberArquivo(TipoImportacao.Produtos, " ", [])));
        Assert.Equal(["arquivo"], Campos(new ReceberArquivo(TipoImportacao.Produtos, "a.csv", new byte[ImportacaoValidation.TamanhoMaximoBytes + 1])));
        Assert.Equal(["nomeArquivo"], Campos(new ReceberArquivo(TipoImportacao.Produtos, new string('a', 256), [1])));
        Assert.Empty(Campos(new ReceberArquivo(TipoImportacao.Produtos, "a.csv", [1])));
    }

    private static Importacao Create(string nome) =>
        Importacao.Create(TipoImportacao.Produtos, nome, Hash, 10, Layout, [["A1", "Caneta"]], 1, Guid.NewGuid(), Agora);
}
