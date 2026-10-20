using System.Text;
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

    private static string NotaExemplo(
        string id = "NFe" + Chave,
        string cnpj = "11222333000181",
        string versao = "4.00",
        bool comProtocolo = true,
        string chaveProtocolo = Chave)
    {
        var nfe = $"""
            <NFe xmlns="http://www.portalfiscal.inf.br/nfe">
              <infNFe versao="{versao}" Id="{id}">
                <ide>
                  <cUF>35</cUF><cNF>12345678</cNF><natOp>Venda</natOp><mod>55</mod><serie>1</serie><nNF>1234</nNF>
                  <dhEmi>2026-10-20T09:30:00-03:00</dhEmi><tpNF>1</tpNF><tpEmis>1</tpEmis><cDV>7</cDV>
                </ide>
                <emit><CNPJ>{cnpj}</CNPJ><xNome>Distribuidora Exemplo Ltda</xNome><xFant>Exemplo</xFant></emit>
                <det nItem="1">
                  <prod>
                    <cProd>REF-001</cProd><cEAN>17891000315504</cEAN><xProd>REFRIGERANTE COLA 2L CX 12</xProd>
                    <NCM>22021000</NCM><CEST>0300700</CEST><CFOP>5102</CFOP><uCom>CX</uCom><qCom>10.0000</qCom>
                    <vUnCom>95.4000000000</vUnCom><vProd>954.00</vProd><cEANTrib>7891000315507</cEANTrib><uTrib>UN</uTrib>
                    <qTrib>120.0000</qTrib><vUnTrib>7.9500000000</vUnTrib><indTot>1</indTot>
                    <rastro><nLote>L2610A</nLote><qLote>10.000</qLote><dFab>2026-10-01</dFab><dVal>2027-04-30</dVal></rastro>
                  </prod>
                </det>
                <det nItem="2">
                  <prod>
                    <cProd>REF-077</cProd><cEAN>SEM GTIN</cEAN><xProd>COPO DESCARTAVEL 200ML</xProd><NCM>39241000</NCM>
                    <CFOP>5102</CFOP><uCom>PCT</uCom><qCom>5</qCom><vUnCom>12.5</vUnCom><vProd>62.50</vProd>
                    <cEANTrib>SEM GTIN</cEANTrib><uTrib>UN</uTrib><qTrib>500</qTrib><vUnTrib>0.125</vUnTrib><indTot>1</indTot>
                  </prod>
                </det>
              </infNFe>
            </NFe>
            """;

        return comProtocolo
            ? $"""
                <nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
                {nfe}
                <protNFe versao="4.00"><infProt><tpAmb>1</tpAmb><chNFe>{chaveProtocolo}</chNFe><cStat>100</cStat><xMotivo>Autorizado o uso da NF-e</xMotivo></infProt></protNFe>
                </nfeProc>
                """
            : nfe;
    }
}
