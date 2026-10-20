using System.Text;
using System.Xml.Linq;
using Stowise.Application.Common;
using Stowise.Infrastructure.NotasFiscais;

namespace Stowise.IntegrationTests.NotasFiscais;

/// <summary>Leitor do XML da NF-e 4.00: dados lidos, chave conferida e XML hostil recusado. Não usa banco.</summary>
public class LeitorNfeTests
{
    private const string Chave = "35261011222333000181550010000012341123456787";

    private readonly LeitorNfe _leitor = new();

    [Fact]
    public void Reads_an_authorized_invoice_with_its_items_and_batches()
    {
        var nota = Ler(NotaExemplo()).Value;

        Assert.Equal(Chave, nota.ChaveAcesso);
        Assert.Equal(1234, nota.Numero);
        Assert.Equal(1, nota.Serie);
        Assert.Equal(new DateTimeOffset(2026, 10, 20, 9, 30, 0, TimeSpan.FromHours(-3)), nota.DataEmissao);
        Assert.True(nota.Autorizada);
        Assert.Equal("11222333000181", nota.Emitente.Cnpj);
        Assert.Equal("Distribuidora Exemplo Ltda", nota.Emitente.RazaoSocial);

        var cola = nota.Itens[0];
        Assert.Equal(1, cola.NumeroItem);
        Assert.Equal("REF-001", cola.CodigoFornecedor);
        Assert.Equal("17891000315504", cola.Gtin);
        Assert.Equal("CX", cola.UnidadeComercial);
        Assert.Equal(10m, cola.QuantidadeComercial);
        Assert.Equal("UN", cola.UnidadeTributavel);
        Assert.Equal(120m, cola.QuantidadeTributavel);
        Assert.Equal("22021000", cola.Ncm);
        var lote = Assert.Single(cola.Lotes);
        Assert.Equal("L2610A", lote.Numero);
        Assert.Equal(new DateOnly(2027, 4, 30), lote.Validade);

        var semGtin = nota.Itens[1];
        Assert.Null(semGtin.Gtin);
        Assert.Null(semGtin.GtinTributavel);
        Assert.Empty(semGtin.Lotes);
    }

    [Fact]
    public void Invoice_without_protocol_is_read_but_not_authorized()
    {
        var nota = Ler(NotaExemplo(comProtocolo: false)).Value;

        Assert.False(nota.Autorizada);
    }

    [Theory]
    [InlineData("NFe35261011222333000181550010000012341123456786", "chave de acesso da nota é inválida")]
    [InlineData("NFe35261011222333000181550010000099991123456786", "não confere com a UF, a série ou o número")]
    public void Key_must_be_valid_and_match_the_invoice(string id, string mensagem)
    {
        AssertFalha(NotaExemplo(id: id), mensagem);
    }

    [Fact]
    public void Key_must_match_the_issuer()
    {
        AssertFalha(NotaExemplo(cnpj: "12ABC34501DE35"), "não confere com o CNPJ ou o CPF do emitente");
    }

    [Fact]
    public void Protocol_must_be_for_the_same_invoice()
    {
        AssertFalha(NotaExemplo(chaveProtocolo: "35261012ABC34501DE35550010000012341123456788"), "protocolo de autorização é de outra nota");
    }

    [Fact]
    public void Invoice_must_follow_the_official_schema()
    {
        var semCfopValido = NotaExemplo().Replace("<CFOP>5102</CFOP>", "<CFOP>51X2</CFOP>", StringComparison.Ordinal);

        AssertFalha(semCfopValido, "não segue o schema oficial da NF-e 4.00");
    }

    [Fact]
    public void Only_version_4_is_accepted()
    {
        AssertFalha(NotaExemplo(versao: "3.10"), "versão 4.00");
    }

    [Theory]
    [InlineData("<html><body>não é nota</body></html>", "não é uma NF-e")]
    [InlineData("isto não é XML", "não é um XML válido")]
    public void Other_documents_are_rejected(string conteudo, string mensagem)
    {
        AssertFalha(conteudo, mensagem);
    }

    [Fact]
    public void Dtd_and_external_entities_are_refused()
    {
        var xxe = """
            <?xml version="1.0"?>
            <!DOCTYPE nfeProc [<!ENTITY segredo SYSTEM "file:///etc/passwd">]>
            <nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">&segredo;</nfeProc>
            """;

        AssertFalha(xxe, "não é um XML válido");
    }

    private Result<Application.NotasFiscais.NotaFiscalLida> Ler(string xml)
    {
        using var stream = new MemoryStream(Encoding.UTF8.GetBytes(xml));
        return _leitor.Read(stream);
    }

    private void AssertFalha(string xml, string mensagem)
    {
        var resultado = Ler(xml);

        Assert.False(resultado.IsSuccess);
        Assert.Equal(ErrorType.Validation, resultado.Error!.Type);
        Assert.Contains(mensagem, resultado.Error.Fields!["xml"][0], StringComparison.Ordinal);
    }

    /// <summary>NF-e fictícia completa, válida pelo schema oficial (Exemplos/nfe-autorizada.xml), com alterações para cada caso.</summary>
    private static string NotaExemplo(
        string? id = null,
        string? cnpj = null,
        string? versao = null,
        bool comProtocolo = true,
        string? chaveProtocolo = null)
    {
        var xml = File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "NotasFiscais", "Exemplos", "nfe-autorizada.xml"));
        if (id is not null)
        {
            xml = xml.Replace($"Id=\"NFe{Chave}\"", $"Id=\"{id}\"", StringComparison.Ordinal);
        }

        if (cnpj is not null)
        {
            xml = xml.Replace("<CNPJ>11222333000181</CNPJ>", $"<CNPJ>{cnpj}</CNPJ>", StringComparison.Ordinal);
        }

        if (versao is not null)
        {
            xml = xml.Replace("<infNFe versao=\"4.00\"", $"<infNFe versao=\"{versao}\"", StringComparison.Ordinal);
        }

        if (chaveProtocolo is not null)
        {
            xml = xml.Replace($"<chNFe>{Chave}</chNFe>", $"<chNFe>{chaveProtocolo}</chNFe>", StringComparison.Ordinal);
        }

        if (!comProtocolo)
        {
            var nfe = XDocument.Parse(xml).Root!.Element(XName.Get("NFe", "http://www.portalfiscal.inf.br/nfe"))!;
            xml = nfe.ToString();
        }

        return xml;
    }
}
