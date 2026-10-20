using System.Globalization;
using System.Xml;
using System.Xml.Linq;
using Stowise.Application.Common;
using Stowise.Application.NotasFiscais;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Fornecedores;
using Stowise.Domain.NotasFiscais;

namespace Stowise.Infrastructure.NotasFiscais;

/// <summary>
/// Leitor do XML da NF-e 4.00. O XML vem do usuário: DTD e entidades externas ficam bloqueadas (XXE) e o tamanho é
/// limitado. A nota pode ser o <c>NFe</c> sozinho ou o <c>nfeProc</c> (nota + protocolo de autorização).
/// </summary>
internal sealed class LeitorNfe : ILeitorNfe
{
    /// <summary>Limite do documento: uma NF-e com 990 itens fica bem abaixo disso.</summary>
    public const long MaxCaracteres = 10 * 1024 * 1024;

    private static readonly XNamespace Ns = "http://www.portalfiscal.inf.br/nfe";

    private static readonly XmlReaderSettings Seguro = new()
    {
        DtdProcessing = DtdProcessing.Prohibit,
        XmlResolver = null,
        MaxCharactersInDocument = MaxCaracteres,
        IgnoreComments = true,
    };

    public Result<NotaFiscalLida> Read(Stream xml)
    {
        ArgumentNullException.ThrowIfNull(xml);

        XDocument documento;
        try
        {
            using var reader = XmlReader.Create(xml, Seguro);
            documento = XDocument.Load(reader);
        }
        catch (XmlException e)
        {
            return Falha($"O arquivo não é um XML válido: {e.Message}");
        }

        try
        {
            return Read(documento);
        }
        catch (FormatException e)
        {
            return Falha(e.Message);
        }
    }

    private static Result<NotaFiscalLida> Read(XDocument documento)
    {
        var raiz = documento.Root!;
        var nfe = raiz.Name == Ns + "NFe" ? raiz : raiz.Name == Ns + "nfeProc" ? raiz.Element(Ns + "NFe") : null;
        var infNfe = nfe?.Element(Ns + "infNFe");
        if (infNfe is null)
        {
            return Falha("O XML não é uma NF-e: falta o elemento NFe/infNFe do Portal da NF-e.");
        }

        if ((string?)infNfe.Attribute("versao") != "4.00")
        {
            return Falha($"Só a NF-e versão 4.00 é aceita; este XML é da versão {(string?)infNfe.Attribute("versao") ?? "desconhecida"}.");
        }

        var id = (string?)infNfe.Attribute("Id") ?? string.Empty;
        if (!id.StartsWith("NFe", StringComparison.Ordinal) || !ChaveAcesso.TryParse(id[3..], out var chave))
        {
            return Falha("A chave de acesso da nota é inválida (formato ou dígito verificador).");
        }

        var ide = Obrigatorio(infNfe, "ide");
        if (Texto(ide, "mod") != "55" || chave.Modelo != "55")
        {
            return Falha("Só a NF-e modelo 55 é aceita.");
        }

        var numero = Inteiro(ide, "nNF");
        var serie = Inteiro(ide, "serie");
        if (Texto(ide, "cUF") != chave.Uf || numero != chave.Numero || serie != chave.Serie)
        {
            return Falha("A chave de acesso não confere com a UF, a série ou o número da nota.");
        }

        var emitente = Emitente(Obrigatorio(infNfe, "emit"));
        var documentoEmitente = emitente.Cnpj ?? emitente.Cpf!.PadLeft(14, '0');
        if (documentoEmitente != chave.DocumentoEmitente)
        {
            return Falha("A chave de acesso não confere com o CNPJ ou o CPF do emitente.");
        }

        var protocolo = raiz.Element(Ns + "protNFe")?.Element(Ns + "infProt");
        if (protocolo is not null && Texto(protocolo, "chNFe") != chave.Valor)
        {
            return Falha("A chave do protocolo de autorização é de outra nota.");
        }

        var itens = infNfe.Elements(Ns + "det").Select(Item).ToList();
        if (itens.Count == 0)
        {
            return Falha("A nota não tem itens.");
        }

        var autorizada = protocolo is not null && Texto(protocolo, "cStat") is "100" or "150";
        var dataEmissao = DateTimeOffset.TryParse(Texto(ide, "dhEmi"), CultureInfo.InvariantCulture, DateTimeStyles.None, out var dhEmi)
            ? dhEmi
            : throw new FormatException("A nota não traz a data de emissão (dhEmi) no formato AAAA-MM-DDThh:mm:ssTZD.");

        return new NotaFiscalLida(chave.Valor, numero, serie, dataEmissao, emitente, itens, autorizada);
    }

    private static EmitenteNota Emitente(XElement emit)
    {
        var cnpj = Texto(emit, "CNPJ");
        var cpf = Texto(emit, "CPF");
        if (cnpj is not null && !Cnpj.IsValid(Cnpj.Normalize(cnpj)))
        {
            throw new FormatException($"O CNPJ do emitente ({cnpj}) é inválido.");
        }

        if (cnpj is null && (cpf is null || cpf.Length != 11 || !cpf.All(char.IsAsciiDigit)))
        {
            throw new FormatException("A nota não traz o CNPJ nem o CPF do emitente.");
        }

        return new EmitenteNota(
            cnpj is null ? null : Cnpj.Normalize(cnpj),
            cnpj is null ? cpf : null,
            Texto(emit, "xNome") ?? throw new FormatException("A nota não traz a razão social do emitente (xNome)."),
            Texto(emit, "xFant"));
    }

    private static ItemNota Item(XElement det)
    {
        var numeroItem = int.Parse((string?)det.Attribute("nItem") ?? "0", CultureInfo.InvariantCulture);
        var prod = Obrigatorio(det, "prod");
        var lotes = prod.Elements(Ns + "rastro")
            .Select(r => new LoteNota(
                Texto(r, "nLote") ?? throw new FormatException($"O item {numeroItem} tem rastro sem nLote."),
                Decimal(r, "qLote"),
                Data(r, "dFab"),
                Data(r, "dVal")))
            .ToList();

        return new ItemNota(
            numeroItem,
            Texto(prod, "cProd") ?? throw new FormatException($"O item {numeroItem} não traz o código do produto (cProd)."),
            GtinOuNulo(Texto(prod, "cEAN")),
            Texto(prod, "xProd") ?? throw new FormatException($"O item {numeroItem} não traz a descrição (xProd)."),
            Texto(prod, "NCM"),
            Texto(prod, "CEST"),
            Texto(prod, "CFOP") ?? throw new FormatException($"O item {numeroItem} não traz o CFOP."),
            Texto(prod, "uCom") ?? throw new FormatException($"O item {numeroItem} não traz a unidade comercial (uCom)."),
            Decimal(prod, "qCom"),
            Decimal(prod, "vUnCom"),
            GtinOuNulo(Texto(prod, "cEANTrib")),
            Texto(prod, "uTrib") ?? throw new FormatException($"O item {numeroItem} não traz a unidade tributável (uTrib)."),
            Decimal(prod, "qTrib"),
            lotes);
    }

    /// <summary>"SEM GTIN", vazio ou dígito errado viram nulo: o casamento por GTIN só usa código válido.</summary>
    private static string? GtinOuNulo(string? valor) => Gtin.IsValid(valor) ? valor : null;

    private static XElement Obrigatorio(XElement pai, string nome) =>
        pai.Element(Ns + nome) ?? throw new FormatException($"A nota não traz o grupo {nome}.");

    private static string? Texto(XElement pai, string nome)
    {
        var valor = pai.Element(Ns + nome)?.Value.Trim();
        return string.IsNullOrEmpty(valor) ? null : valor;
    }

    private static int Inteiro(XElement pai, string nome) =>
        int.TryParse(Texto(pai, nome), NumberStyles.None, CultureInfo.InvariantCulture, out var valor)
            ? valor
            : throw new FormatException($"O campo {nome} da nota não é um número inteiro.");

    private static decimal Decimal(XElement pai, string nome) =>
        decimal.TryParse(Texto(pai, nome), NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture, out var valor)
            ? valor
            : throw new FormatException($"O campo {nome} da nota não é um número válido.");

    private static DateOnly? Data(XElement pai, string nome) =>
        Texto(pai, nome) is not { } texto
            ? null
            : DateOnly.TryParseExact(texto, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out var data)
                ? data
                : throw new FormatException($"O campo {nome} da nota não é uma data (AAAA-MM-DD).");

    private static AppError Falha(string mensagem) => AppError.Validation("xml", mensagem);
}
