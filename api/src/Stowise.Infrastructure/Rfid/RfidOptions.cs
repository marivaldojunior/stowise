namespace Stowise.Infrastructure.Rfid;

public sealed class RfidOptions
{
    public const string SectionName = "Rfid";

    /// <summary>
    /// Dígitos do prefixo da empresa GS1 usados ao gerar EPCs quando o pedido não informa (6 a 12). O GTIN não diz o
    /// tamanho do prefixo; vazio obriga o pedido a informar.
    /// </summary>
    public int? TamanhoPrefixoEmpresaPadrao { get; set; }
}
