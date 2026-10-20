using System.Xml;
using System.Xml.Linq;
using System.Xml.Schema;

namespace Stowise.Infrastructure.NotasFiscais;

/// <summary>
/// Valida o elemento <c>NFe</c> pelos schemas oficiais da NF-e 4.00 (pasta Schemas, recurso embutido). Os schemas se
/// referenciam pelo nome do arquivo; o resolvedor só entrega esses recursos e nunca abre arquivo nem rede.
/// </summary>
internal static class ValidadorSchemaNfe
{
    /// <summary>Erros listados na mensagem; um XML muito fora do padrão gera centenas.</summary>
    private const int MaxErros = 5;

    private static readonly Lazy<XmlSchemaSet> Schemas = new(Load);

    /// <summary>Erros de schema do elemento NFe, com a linha quando o XML foi lido com informação de linha.</summary>
    public static IReadOnlyList<string> Validate(XElement nfe)
    {
        var erros = new List<string>();
        new XDocument(new XElement(nfe)).Validate(Schemas.Value, (_, e) =>
        {
            if (erros.Count < MaxErros)
            {
                erros.Add(e.Exception?.LineNumber > 0 ? $"linha {e.Exception.LineNumber}: {e.Message}" : e.Message);
            }
        });
        return erros;
    }

    private static XmlSchemaSet Load()
    {
        var resolver = new ResolvedorEmbutido();
        var schemas = new XmlSchemaSet { XmlResolver = resolver };
        var settings = new XmlReaderSettings { XmlResolver = resolver, DtdProcessing = DtdProcessing.Prohibit };
        using (var reader = XmlReader.Create(ResolvedorEmbutido.Open("nfe_v4.00.xsd"), settings, "embedded:///nfe_v4.00.xsd"))
        {
            schemas.Add(null, reader);
        }

        schemas.Compile();
        return schemas;
    }

    private sealed class ResolvedorEmbutido : XmlResolver
    {
        private static readonly System.Reflection.Assembly Assembly = typeof(ValidadorSchemaNfe).Assembly;

        public static Stream Open(string arquivo) =>
            Assembly.GetManifestResourceStream($"Schemas.{arquivo}")
            ?? throw new InvalidOperationException($"NF-e schema '{arquivo}' is not embedded in the assembly.");

        public override Uri ResolveUri(Uri? baseUri, string? relativeUri) => new($"embedded:///{Path.GetFileName(relativeUri)}");

        public override object? GetEntity(Uri absoluteUri, string? role, Type? ofObjectToReturn) =>
            absoluteUri.Scheme == "embedded"
                ? Open(Path.GetFileName(absoluteUri.AbsolutePath))
                : throw new XmlException($"Only the embedded NF-e schemas can be loaded, not {absoluteUri}.");
    }
}
