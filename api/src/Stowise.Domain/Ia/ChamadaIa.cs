using Stowise.Domain.Common;

namespace Stowise.Domain.Ia;

/// <summary>Funcionalidades que usam IA (SPEC, módulo 6). Base para cota, custo e comparação de prompts.</summary>
public enum FuncionalidadeIa
{
    Mapeamento,
    CasamentoItens,
    Camera,
    CadastroPorFoto,
    Consulta,
    Embeddings,
    Documentos,
    LeituraPlaqueta,
    EstadoConservacao,
    CasamentoBens,
}

/// <summary>
/// Registro de uma chamada a um provedor de IA (ADR-0004, item 5): quem pediu, qual modelo respondeu, quanto custou
/// e quanto demorou. Imutável: é um log de auditoria, gravado com sucesso ou com falha.
/// </summary>
public sealed class ChamadaIa : Entity
{
    public const int ProvedorMaxLength = 40;
    public const int ModeloMaxLength = 100;
    public const int PromptVersaoMaxLength = 40;
    public const int ErroMaxLength = 1000;
    public const int CorrelacaoIdMaxLength = 64;

    private ChamadaIa()
    {
    }

    public FuncionalidadeIa Funcionalidade { get; private set; }

    /// <summary>Nulo em chamadas de sistema (ex.: job sem usuário).</summary>
    public Guid? UsuarioId { get; private set; }

    public string Provedor { get; private set; } = null!;

    public string Modelo { get; private set; } = null!;

    /// <summary>Versão do prompt e do JSON Schema da funcionalidade, para comparar resultados entre versões.</summary>
    public string PromptVersao { get; private set; } = null!;

    public int? TokensEntrada { get; private set; }

    public int? TokensSaida { get; private set; }

    /// <summary>Em dólares, pela tabela de preço configurada para o modelo. Nulo sem contagem de tokens.</summary>
    public decimal? CustoEstimado { get; private set; }

    public int LatenciaMs { get; private set; }

    public int Tentativas { get; private set; }

    public bool UsouFallback { get; private set; }

    public bool Sucesso { get; private set; }

    /// <summary>Tipo e mensagem da falha, sem dados do prompt.</summary>
    public string? Erro { get; private set; }

    /// <summary>Trace id do OpenTelemetry, para achar a chamada junto da requisição ou do job que a originou.</summary>
    public string? CorrelacaoId { get; private set; }

    public DateTimeOffset CriadaEm { get; private set; }

    /// <param name="custoEstimado">Calculado por quem conhece a tabela de preço do modelo.</param>
    public static ChamadaIa Create(
        FuncionalidadeIa funcionalidade,
        Guid? usuarioId,
        string provedor,
        string modelo,
        string promptVersao,
        UsoIa uso,
        decimal? custoEstimado,
        string? erro,
        string? correlacaoId,
        DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(uso);
        ArgumentOutOfRangeException.ThrowIfNegative(uso.LatenciaMs);
        ArgumentOutOfRangeException.ThrowIfLessThan(uso.Tentativas, 1);

        return new ChamadaIa
        {
            Funcionalidade = funcionalidade,
            UsuarioId = usuarioId,
            Provedor = Guard.Required(provedor, "Provedor", ProvedorMaxLength),
            Modelo = Guard.Required(modelo, "Modelo", ModeloMaxLength),
            PromptVersao = Guard.Required(promptVersao, "Versão do prompt", PromptVersaoMaxLength),
            TokensEntrada = uso.TokensEntrada,
            TokensSaida = uso.TokensSaida,
            CustoEstimado = custoEstimado,
            LatenciaMs = uso.LatenciaMs,
            Tentativas = uso.Tentativas,
            UsouFallback = uso.UsouFallback,
            Sucesso = erro is null,
            Erro = erro is null ? null : erro.Length <= ErroMaxLength ? erro : erro[..ErroMaxLength],
            CorrelacaoId = correlacaoId is { Length: > CorrelacaoIdMaxLength } ? correlacaoId[..CorrelacaoIdMaxLength] : correlacaoId,
            CriadaEm = agora,
        };
    }
}

/// <summary>Medições de uma chamada de IA.</summary>
public sealed record UsoIa(int? TokensEntrada, int? TokensSaida, int LatenciaMs, int Tentativas = 1, bool UsouFallback = false);
