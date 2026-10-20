using Stowise.Domain.Fornecedores;

namespace Stowise.Application.Fornecedores;

/// <summary>
/// Validações de formato, com erro por campo (HTTP 400). CNPJ e código repetidos dependem do banco e ficam no serviço.
/// </summary>
public static class FornecedorValidation
{
    public static IReadOnlyDictionary<string, string[]> Validate(CriarFornecedor comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (!Cnpj.IsValid(Cnpj.Normalize(comando.Cnpj)))
        {
            errors["cnpj"] = ["Informe um CNPJ válido (numérico ou alfanumérico)."];
        }

        ValidateNomes(errors, comando.RazaoSocial, comando.NomeFantasia);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(AtualizarFornecedor comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        ValidateNomes(errors, comando.RazaoSocial, comando.NomeFantasia);
        if (comando.Versao is null)
        {
            errors["versao"] = ["Informe a versão lida do fornecedor."];
        }

        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(CriarProdutoFornecedor comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(comando.CodigoFornecedor))
        {
            errors["codigoFornecedor"] = ["Informe o código do produto no fornecedor."];
        }
        else if (comando.CodigoFornecedor.Trim().Length > ProdutoFornecedor.CodigoFornecedorMaxLength)
        {
            errors["codigoFornecedor"] = [$"O código deve ter no máximo {ProdutoFornecedor.CodigoFornecedorMaxLength} caracteres."];
        }

        ValidateVinculo(errors, comando.ProdutoId, comando.EmbalagemId, comando.UnidadeFornecedor, comando.FatorConversao);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(AtualizarProdutoFornecedor comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        ValidateVinculo(errors, comando.ProdutoId, comando.EmbalagemId, comando.UnidadeFornecedor, comando.FatorConversao);
        if (comando.Versao is null)
        {
            errors["versao"] = ["Informe a versão lida do vínculo."];
        }

        return errors;
    }

    private static void ValidateNomes(Dictionary<string, string[]> errors, string? razaoSocial, string? nomeFantasia)
    {
        if (string.IsNullOrWhiteSpace(razaoSocial))
        {
            errors["razaoSocial"] = ["Informe a razão social."];
        }
        else if (razaoSocial.Trim().Length > Fornecedor.RazaoSocialMaxLength)
        {
            errors["razaoSocial"] = [$"A razão social deve ter no máximo {Fornecedor.RazaoSocialMaxLength} caracteres."];
        }

        if (nomeFantasia?.Trim().Length > Fornecedor.NomeFantasiaMaxLength)
        {
            errors["nomeFantasia"] = [$"O nome fantasia deve ter no máximo {Fornecedor.NomeFantasiaMaxLength} caracteres."];
        }
    }

    private static void ValidateVinculo(
        Dictionary<string, string[]> errors,
        Guid? produtoId,
        Guid? embalagemId,
        string? unidadeFornecedor,
        decimal? fatorConversao)
    {
        if (produtoId is null || produtoId == Guid.Empty)
        {
            errors["produtoId"] = ["Informe o produto."];
        }

        if (embalagemId is null || embalagemId == Guid.Empty)
        {
            errors["embalagemId"] = ["Informe a embalagem do produto."];
        }

        if (string.IsNullOrWhiteSpace(unidadeFornecedor))
        {
            errors["unidadeFornecedor"] = ["Informe a unidade do fornecedor (ex.: CX)."];
        }
        else if (unidadeFornecedor.Trim().Length > ProdutoFornecedor.UnidadeFornecedorMaxLength)
        {
            errors["unidadeFornecedor"] = [$"A unidade deve ter no máximo {ProdutoFornecedor.UnidadeFornecedorMaxLength} caracteres."];
        }

        if (fatorConversao is <= 0)
        {
            errors["fatorConversao"] = ["O fator de conversão deve ser maior que zero."];
        }
    }
}
