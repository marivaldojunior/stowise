using Stowise.Domain.Common;

namespace Stowise.Domain.Importacoes;

public enum StatusLinha
{
    Valida,
    Erro,

    /// <summary>O GTIN já pertence a outro produto: uma pessoa decide se é o mesmo item.</summary>
    PossivelDuplicata,

    Ignorada,
}

public enum AcaoLinha
{
    Criar,
    Atualizar,
    Ignorar,
}

/// <param name="Campo">Campo de destino (ex.: <c>gtin</c>) ou <c>linha</c> para problemas da linha inteira.</param>
public sealed record ErroLinha(string Campo, string Mensagem);

/// <summary>
/// Uma linha do arquivo no staging (SPEC, módulo 5): o texto lido, os valores normalizados e o resultado das
/// validações. Nada vai para o catálogo antes da revisão e da efetivação.
/// </summary>
public sealed class ImportacaoLinha : Entity
{
    private ImportacaoLinha()
    {
    }

    public Guid ImportacaoId { get; private set; }

    /// <summary>Posição entre as linhas de dados, a partir de 1 (sem o cabeçalho e sem linhas em branco).</summary>
    public int NumeroLinha { get; private set; }

    public IReadOnlyList<string> DadosBrutos { get; private set; } = [];

    /// <summary>Valores por campo de destino, em texto canônico: números com ponto, booleanos <c>true</c>/<c>false</c>.</summary>
    public IReadOnlyDictionary<string, string?> DadosNormalizados { get; private set; } = new Dictionary<string, string?>();

    public StatusLinha Status { get; private set; }

    public AcaoLinha Acao { get; private set; }

    /// <summary>Produto com o mesmo SKU (atualização) ou com o mesmo GTIN (possível duplicata).</summary>
    public Guid? ProdutoCorrespondenteId { get; private set; }

    /// <summary>De 0 a 1. O casamento exato por GTIN vale 1; a busca semântica entra no Marco 4.</summary>
    public decimal? Similaridade { get; private set; }

    public IReadOnlyList<ErroLinha> Erros { get; private set; } = [];

    /// <param name="produtoMesmoSku">Produto do catálogo com o SKU da linha.</param>
    /// <param name="produtoMesmoGtin">Produto do catálogo com o GTIN da linha, se for outro SKU.</param>
    public static ImportacaoLinha Create(
        Guid importacaoId,
        int numeroLinha,
        IReadOnlyList<string> dadosBrutos,
        IReadOnlyDictionary<string, string?> dadosNormalizados,
        IReadOnlyList<ErroLinha> erros,
        Guid? produtoMesmoSku,
        Guid? produtoMesmoGtin)
    {
        ArgumentNullException.ThrowIfNull(dadosBrutos);
        ArgumentNullException.ThrowIfNull(dadosNormalizados);
        ArgumentNullException.ThrowIfNull(erros);
        ArgumentOutOfRangeException.ThrowIfLessThan(numeroLinha, 1);

        var linha = new ImportacaoLinha
        {
            ImportacaoId = importacaoId,
            NumeroLinha = numeroLinha,
            DadosBrutos = dadosBrutos,
            DadosNormalizados = dadosNormalizados,
            Erros = erros,
        };

        if (erros.Count > 0)
        {
            (linha.Status, linha.Acao) = (StatusLinha.Erro, AcaoLinha.Ignorar);
        }
        else if (produtoMesmoGtin is { } outro && outro != produtoMesmoSku)
        {
            (linha.Status, linha.Acao, linha.ProdutoCorrespondenteId, linha.Similaridade) = (StatusLinha.PossivelDuplicata, AcaoLinha.Ignorar, outro, 1m);
        }
        else if (produtoMesmoSku is { } existente)
        {
            (linha.Status, linha.Acao, linha.ProdutoCorrespondenteId) = (StatusLinha.Valida, AcaoLinha.Atualizar, existente);
        }
        else
        {
            (linha.Status, linha.Acao) = (StatusLinha.Valida, AcaoLinha.Criar);
        }

        return linha;
    }
}
