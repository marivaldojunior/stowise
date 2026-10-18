using Stowise.Domain.Common;

namespace Stowise.Domain.Importacoes;

public enum TipoImportacao
{
    Produtos,
    NotaFiscal,
    BensPatrimoniais,
}

public enum FormatoArquivo
{
    /// <summary>Texto com separador de colunas (CSV, TXT com <c>;</c>, tabulação ou <c>|</c>).</summary>
    Delimitado,

    /// <summary>Texto de largura fixa: cada coluna ocupa as mesmas posições em todas as linhas.</summary>
    Posicional,

    Excel,
    NFeXml,
}

/// <summary>Estados da importação (SPEC, módulo 5). As transições entram com a máquina de estados.</summary>
public enum StatusImportacao
{
    Recebido,
    Mapeando,
    AguardandoConfirmacao,
    Validando,
    AguardandoRevisao,
    Efetivando,
    Concluido,
    Falhou,
}

/// <summary>Coluna detectada no arquivo. <see cref="Inicio"/> e <see cref="Tamanho"/> só existem no layout posicional.</summary>
/// <param name="Indice">Posição da coluna, a partir de 0.</param>
/// <param name="Inicio">Posição do primeiro caractere na linha, a partir de 0.</param>
public sealed record ColunaArquivo(int Indice, string Nome, int? Inicio = null, int? Tamanho = null);

/// <summary>Como o arquivo foi lido: encoding, separadores, cabeçalho e colunas.</summary>
/// <param name="Encoding">Nulo na planilha Excel, que não é texto.</param>
/// <param name="Delimitador">Nulo no layout posicional, na planilha e em arquivo de uma coluna só.</param>
/// <param name="SeparadorDecimal">Na planilha, sempre ponto: os números saem na cultura invariante.</param>
/// <param name="Planilha">Nome da aba lida, só no Excel.</param>
public sealed record LayoutArquivo(
    FormatoArquivo Formato,
    string? Encoding,
    string? Delimitador,
    string SeparadorDecimal,
    bool TemCabecalho,
    IReadOnlyList<ColunaArquivo> Colunas,
    string? Planilha = null);

/// <summary>
/// Um arquivo enviado para importação. Guarda o layout detectado e uma amostra das primeiras linhas, que é o
/// que a IA recebe para sugerir o mapeamento. O conteúdo original fica em <see cref="ArquivoImportacao"/>.
/// </summary>
public sealed class Importacao : Entity
{
    public const int NomeArquivoMaxLength = 255;
    public const int HashArquivoLength = 64;
    public const int MaxColunas = 200;

    /// <summary>Linhas de dados aceitas num arquivo. Protege contra planilhas compactadas que expandem demais.</summary>
    public const int MaxLinhas = 1_000_000;

    /// <summary>Limite do Excel para o nome de uma aba.</summary>
    public const int PlanilhaMaxLength = 31;

    private Importacao()
    {
    }

    public TipoImportacao Tipo { get; private set; }

    public FormatoArquivo Formato { get; private set; }

    public string NomeArquivo { get; private set; } = null!;

    /// <summary>SHA-256 do conteúdo, em hexadecimal minúsculo. Impede importar o mesmo arquivo duas vezes.</summary>
    public string HashArquivo { get; private set; } = null!;

    public long TamanhoBytes { get; private set; }

    public string? Encoding { get; private set; }

    public string? Delimitador { get; private set; }

    public string SeparadorDecimal { get; private set; } = null!;

    public bool TemCabecalho { get; private set; }

    public string? Planilha { get; private set; }

    public IReadOnlyList<ColunaArquivo> Colunas { get; private set; } = [];

    /// <summary>Primeiras linhas de dados, sem o cabeçalho.</summary>
    public IReadOnlyList<IReadOnlyList<string>> Amostra { get; private set; } = [];

    /// <summary>Linhas de dados, sem o cabeçalho e sem linhas em branco.</summary>
    public int TotalLinhas { get; private set; }

    public StatusImportacao Status { get; private set; }

    public Guid UsuarioId { get; private set; }

    public DateTimeOffset IniciadoEm { get; private set; }

    public DateTimeOffset? ConcluidoEm { get; private set; }

    public static Importacao Create(
        TipoImportacao tipo,
        string nomeArquivo,
        string hashArquivo,
        long tamanhoBytes,
        LayoutArquivo layout,
        IReadOnlyList<IReadOnlyList<string>> amostra,
        int totalLinhas,
        Guid usuarioId,
        DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(layout);
        ArgumentNullException.ThrowIfNull(amostra);

        if (hashArquivo?.Length != HashArquivoLength)
        {
            throw new ArgumentException($"The file hash must have {HashArquivoLength} characters.", nameof(hashArquivo));
        }

        if (tamanhoBytes <= 0)
        {
            throw new DomainException("O arquivo está vazio.");
        }

        if (totalLinhas > MaxLinhas)
        {
            throw new DomainException($"O arquivo deve ter no máximo {MaxLinhas} linhas.");
        }

        if (layout.Colunas.Count is 0 or > MaxColunas)
        {
            throw new DomainException($"O arquivo deve ter entre 1 e {MaxColunas} colunas.");
        }

        return new Importacao
        {
            Tipo = tipo,
            Formato = layout.Formato,
            NomeArquivo = Guard.Required(nomeArquivo, "Nome do arquivo", NomeArquivoMaxLength),
            HashArquivo = hashArquivo.ToLowerInvariant(),
            TamanhoBytes = tamanhoBytes,
            Encoding = layout.Encoding,
            Planilha = layout.Planilha,
            Delimitador = layout.Delimitador,
            SeparadorDecimal = layout.SeparadorDecimal,
            TemCabecalho = layout.TemCabecalho,
            Colunas = layout.Colunas,
            Amostra = amostra,
            TotalLinhas = totalLinhas >= 0 ? totalLinhas : throw new ArgumentOutOfRangeException(nameof(totalLinhas)),
            Status = StatusImportacao.Recebido,
            UsuarioId = usuarioId,
            IniciadoEm = agora,
        };
    }

    public LayoutArquivo Layout => new(Formato, Encoding, Delimitador, SeparadorDecimal, TemCabecalho, Colunas, Planilha);
}

/// <summary>Conteúdo original do arquivo, separado da importação para não ser carregado nas consultas.</summary>
public sealed class ArquivoImportacao : Entity
{
    private ArquivoImportacao()
    {
    }

    public Guid ImportacaoId { get; private set; }

    public byte[] Conteudo { get; private set; } = [];

    public static ArquivoImportacao Create(Importacao importacao, byte[] conteudo)
    {
        ArgumentNullException.ThrowIfNull(importacao);
        ArgumentNullException.ThrowIfNull(conteudo);

        if (conteudo.LongLength != importacao.TamanhoBytes)
        {
            throw new ArgumentException("The content size does not match the import.", nameof(conteudo));
        }

        return new ArquivoImportacao { ImportacaoId = importacao.Id, Conteudo = conteudo };
    }
}
