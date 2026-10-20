using Stowise.Application.Common;

namespace Stowise.Application.NotasFiscais;

/// <summary>Lê o XML da NF-e 4.00 (modelo 55), com ou sem o protocolo de autorização (nfeProc).</summary>
public interface ILeitorNfe
{
    /// <summary>
    /// Confere a estrutura, a versão, a chave de acesso (dígito e coerência com a nota e o protocolo) e devolve os dados que
    /// o recebimento usa. Erro de formato ou de conteúdo: <see cref="ErrorType.Validation"/> no campo "xml".
    /// </summary>
    Result<NotaFiscalLida> Read(Stream xml);
}

/// <param name="ChaveAcesso">44 caracteres, sem o prefixo "NFe".</param>
/// <param name="Autorizada">Verdadeiro quando o XML traz o protocolo com cStat 100 (autorizada) ou 150 (autorizada fora de prazo).</param>
public sealed record NotaFiscalLida(
    string ChaveAcesso,
    int Numero,
    int Serie,
    DateTimeOffset DataEmissao,
    EmitenteNota Emitente,
    IReadOnlyList<ItemNota> Itens,
    bool Autorizada);

/// <param name="Cnpj">CNPJ sem máscara; nulo quando o emitente é pessoa física.</param>
/// <param name="Cpf">CPF do produtor rural; nulo quando o emitente tem CNPJ.</param>
public sealed record EmitenteNota(string? Cnpj, string? Cpf, string RazaoSocial, string? NomeFantasia);

/// <param name="NumeroItem">nItem da nota (1 a 990).</param>
/// <param name="Gtin">cEAN; nulo quando a nota traz "SEM GTIN" ou um código inválido.</param>
/// <param name="UnidadeComercial">uCom, a unidade em que o fornecedor vendeu (ex.: CX).</param>
/// <param name="GtinTributavel">cEANTrib; nulo como em <paramref name="Gtin"/>.</param>
/// <param name="UnidadeTributavel">uTrib, em geral a menor unidade (ex.: UN).</param>
public sealed record ItemNota(
    int NumeroItem,
    string CodigoFornecedor,
    string? Gtin,
    string Descricao,
    string? Ncm,
    string? Cest,
    string Cfop,
    string UnidadeComercial,
    decimal QuantidadeComercial,
    decimal ValorUnitarioComercial,
    string? GtinTributavel,
    string UnidadeTributavel,
    decimal QuantidadeTributavel,
    IReadOnlyList<LoteNota> Lotes);

/// <param name="Quantidade">qLote, na unidade comercial do item.</param>
public sealed record LoteNota(string Numero, decimal Quantidade, DateOnly? Fabricacao, DateOnly? Validade);
