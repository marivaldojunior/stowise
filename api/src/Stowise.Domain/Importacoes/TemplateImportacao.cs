using Stowise.Domain.Common;

namespace Stowise.Domain.Importacoes;

/// <summary>
/// Mapeamento confirmado por uma pessoa para uma estrutura de arquivo (<see cref="Fingerprint"/>). Um arquivo
/// reconhecido recebe o mapeamento do template como sugestão e dispensa a IA (SPEC, decisão 8).
/// </summary>
public sealed class TemplateImportacao : Entity
{
    public const int NomeMaxLength = 100;

    private TemplateImportacao()
    {
    }

    public TipoImportacao Tipo { get; private set; }

    public string Nome { get; private set; } = null!;

    public string Fingerprint { get; private set; } = null!;

    public FormatoArquivo Formato { get; private set; }

    public string? Encoding { get; private set; }

    public string? Delimitador { get; private set; }

    public string SeparadorDecimal { get; private set; } = null!;

    public IReadOnlyList<MapeamentoColuna> Mapeamento { get; private set; } = [];

    public RegrasNormalizacao Regras { get; private set; } = RegrasNormalizacao.Vazias;

    /// <summary>Se o mapeamento veio de uma sugestão da IA (confirmada por uma pessoa).</summary>
    public bool SugeridoPorIa { get; private set; }

    public Guid ConfirmadoPor { get; private set; }

    public DateTimeOffset ConfirmadoEm { get; private set; }

    /// <summary>Importações confirmadas com este template, incluindo a que o criou.</summary>
    public int VezesUsado { get; private set; }

    public DateTimeOffset UltimoUsoEm { get; private set; }

    public uint Versao { get; private set; }

    /// <summary>Cria o template a partir de uma importação com mapeamento confirmado.</summary>
    public static TemplateImportacao Create(Importacao importacao, string nome, bool sugeridoPorIa, Guid usuarioId, DateTimeOffset agora)
    {
        var (fingerprint, mapeamento) = Confirmado(importacao);
        var template = new TemplateImportacao
        {
            Tipo = importacao.Tipo,
            Nome = Guard.Required(nome, "Nome do template", NomeMaxLength),
            Fingerprint = fingerprint,
            VezesUsado = 1,
            UltimoUsoEm = agora,
        };
        template.Learn(importacao, mapeamento, sugeridoPorIa, usuarioId, agora);
        return template;
    }

    /// <summary>
    /// Registra uma importação confirmada com este template. Se o mapeamento mudou, o template passa a usar o
    /// novo: a última confirmação vale. <paramref name="novoUso"/> é falso quando a mesma importação é confirmada de novo.
    /// </summary>
    public void RegisterUse(Importacao importacao, bool novoUso, bool sugeridoPorIa, Guid usuarioId, DateTimeOffset agora)
    {
        var (fingerprint, mapeamento) = Confirmado(importacao);
        if (fingerprint != Fingerprint || importacao.Tipo != Tipo)
        {
            throw new InvalidOperationException("The import does not match the template structure.");
        }

        if (!mapeamento.SequenceEqual(Mapeamento) || !(importacao.Regras ?? RegrasNormalizacao.Vazias).SameAs(Regras))
        {
            Learn(importacao, mapeamento, sugeridoPorIa, usuarioId, agora);
        }

        if (novoUso)
        {
            VezesUsado++;
        }

        UltimoUsoEm = agora;
    }

    public void Rename(string nome) => Nome = Guard.Required(nome, "Nome do template", NomeMaxLength);

    private static (string Fingerprint, IReadOnlyList<MapeamentoColuna> Mapeamento) Confirmado(Importacao importacao)
    {
        ArgumentNullException.ThrowIfNull(importacao);

        if (importacao.Fingerprint is null)
        {
            throw new DomainException("Arquivo delimitado sem cabeçalho não gera template: não há como reconhecê-lo depois.");
        }

        if (importacao.Mapeamento is null || importacao.MapeamentoConfirmadoPor is null)
        {
            throw new DomainException("Confirme o mapeamento antes de salvar o template.");
        }

        return (importacao.Fingerprint, importacao.Mapeamento);
    }

    private void Learn(Importacao importacao, IReadOnlyList<MapeamentoColuna> mapeamento, bool sugeridoPorIa, Guid usuarioId, DateTimeOffset agora)
    {
        Formato = importacao.Formato;
        Encoding = importacao.Encoding;
        Delimitador = importacao.Delimitador;
        SeparadorDecimal = importacao.SeparadorDecimal;
        Mapeamento = mapeamento;
        Regras = importacao.Regras ?? RegrasNormalizacao.Vazias;
        SugeridoPorIa = sugeridoPorIa;
        ConfirmadoPor = usuarioId;
        ConfirmadoEm = agora;
    }
}
