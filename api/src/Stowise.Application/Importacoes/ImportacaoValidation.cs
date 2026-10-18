using Stowise.Domain.Importacoes;

namespace Stowise.Application.Importacoes;

/// <summary>Validações do envio de arquivo, com erro por campo (HTTP 400).</summary>
public static class ImportacaoValidation
{
    public const long TamanhoMaximoBytes = 20 * 1024 * 1024;

    public static string MensagemTamanhoMaximo => $"O arquivo deve ter no máximo {TamanhoMaximoBytes / (1024 * 1024)} MB.";

    public static IReadOnlyDictionary<string, string[]> Validate(ReceberArquivo comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (comando.Conteudo is null)
        {
            errors["arquivo"] = ["Envie um arquivo."];
        }
        else if (comando.Conteudo.LongLength == 0)
        {
            errors["arquivo"] = ["O arquivo está vazio."];
        }
        else if (comando.Conteudo.LongLength > TamanhoMaximoBytes)
        {
            errors["arquivo"] = [MensagemTamanhoMaximo];
        }

        if (comando.Conteudo is null)
        {
            return errors;
        }

        if (string.IsNullOrWhiteSpace(comando.NomeArquivo))
        {
            errors["nomeArquivo"] = ["Informe o nome do arquivo."];
        }
        else if (comando.NomeArquivo.Trim().Length > Importacao.NomeArquivoMaxLength)
        {
            errors["nomeArquivo"] = [$"O nome do arquivo deve ter no máximo {Importacao.NomeArquivoMaxLength} caracteres."];
        }

        return errors;
    }

    /// <summary>Campos conhecidos, sem repetição e com os obrigatórios. A faixa de colunas depende do arquivo e é conferida no serviço.</summary>
    public static IReadOnlyDictionary<string, string[]> Validate(ConfirmarMapeamento comando, TipoImportacao tipo)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (comando.Versao is null)
        {
            errors["versao"] = ["Informe a versão da importação lida antes da confirmação."];
        }

        NomeTemplate(errors, "nomeTemplate", comando.NomeTemplate, obrigatorio: false);

        if (comando.Colunas is not { Count: > 0 } colunas)
        {
            errors["colunas"] = ["Mapeie ao menos uma coluna."];
            return errors;
        }

        var campos = CamposImportacao.Para(tipo);
        for (var i = 0; i < colunas.Count; i++)
        {
            var item = colunas[i];
            if (item is null || campos.All(c => c.Nome != item.Campo))
            {
                errors[$"colunas[{i}].campo"] = [$"Campo desconhecido. Use um destes: {string.Join(", ", campos.Select(c => c.Nome))}."];
            }
            else if (colunas.Take(i).Any(anterior => anterior?.Campo == item.Campo))
            {
                errors[$"colunas[{i}].campo"] = [$"O campo {item.Campo} já foi mapeado."];
            }

            if (item is { Coluna: < 0 })
            {
                errors[$"colunas[{i}].coluna"] = ["A coluna não pode ser negativa."];
            }
        }

        var faltando = campos.Where(c => c.Obrigatorio && colunas.All(m => m?.Campo != c.Nome)).Select(c => c.Nome).ToList();
        if (faltando.Count > 0)
        {
            errors["colunas"] = [$"Mapeie os campos obrigatórios: {string.Join(", ", faltando)}."];
        }

        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(RenomearTemplate comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        NomeTemplate(errors, "nome", comando.Nome, obrigatorio: true);
        if (comando.Versao is null)
        {
            errors["versao"] = ["Informe a versão do template lida antes da alteração."];
        }

        return errors;
    }

    private static void NomeTemplate(Dictionary<string, string[]> errors, string campo, string? nome, bool obrigatorio)
    {
        if (string.IsNullOrWhiteSpace(nome))
        {
            if (obrigatorio)
            {
                errors[campo] = ["Informe o nome do template."];
            }
        }
        else if (nome.Trim().Length > TemplateImportacao.NomeMaxLength)
        {
            errors[campo] = [$"O nome do template deve ter no máximo {TemplateImportacao.NomeMaxLength} caracteres."];
        }
    }
}
