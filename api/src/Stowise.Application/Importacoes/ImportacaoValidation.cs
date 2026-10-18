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
}
