using Microsoft.Extensions.AI;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Stowise.Domain.Ia;

namespace Stowise.Infrastructure.Ia;

/// <summary>
/// Configuração da camada de IA (seção <c>Ia</c>, ADR-0004). As chaves ficam só no servidor. Trocar de modelo ou
/// de provedor entre os tipos suportados é só configuração: nenhum código de funcionalidade conhece o provedor.
/// </summary>
public sealed class IaOptions
{
    public const string SectionName = "Ia";

    /// <summary>Desligada, nenhuma funcionalidade chama IA e os fluxos seguem manuais.</summary>
    public bool Habilitada { get; set; }

    /// <summary>Tempo máximo de cada tentativa.</summary>
    public double TimeoutSegundos { get; set; } = 60;

    /// <summary>Tentativas em cada provedor para falhas transitórias (timeout, 408, 429, 5xx, rede).</summary>
    public int TentativasPorProvedor { get; set; } = 3;

    /// <summary>Espera antes da segunda tentativa; dobra a cada nova tentativa, com variação aleatória (jitter).</summary>
    public int EsperaInicialMs { get; set; } = 500;

    /// <summary>Fuso (IANA) que define o dia e o mês das cotas de IA.</summary>
    public string FusoHorarioCota { get; set; } = "America/Sao_Paulo";

    /// <summary>Provedores em ordem de preferência: o primeiro é o principal, os seguintes são o fallback.</summary>
    public List<ProvedorIaOptions> Provedores { get; } = [];

    /// <summary>Ajustes por funcionalidade (chave = nome de <see cref="FuncionalidadeIa"/>). Sem ajuste, vale a lista global.</summary>
    public Dictionary<string, FuncionalidadeIaOptions> Funcionalidades { get; } = new(StringComparer.OrdinalIgnoreCase);

    /// <summary>Modelo de embeddings (ADR-0011): um só, sem fallback, porque vetores de modelos diferentes não se comparam.</summary>
    public EmbeddingsIaOptions Embeddings { get; } = new();
}

/// <summary>Embeddings dos produtos (ADR-0011). Desligado, a busca de similares usa trigramas.</summary>
public sealed class EmbeddingsIaOptions
{
    /// <summary>Dimensões do vetor gravado; o modelo precisa gerar (ou aceitar reduzir para) este tamanho.</summary>
    public const int Dimensoes = 768;

    public bool Habilitado { get; set; }

    /// <summary>OpenAICompativel, Gemini ou Ollama.</summary>
    public string Tipo { get; set; } = string.Empty;

    /// <summary>Ex.: nomic-embed-text (Ollama), text-embedding-3-small (OpenAI), gemini-embedding-001.</summary>
    public string Modelo { get; set; } = string.Empty;

    public string? Endpoint { get; set; }

    public string? ApiKey { get; set; }

    /// <summary>Textos por chamada ao provedor.</summary>
    public int Lote { get; set; } = 64;

    public double TimeoutSegundos { get; set; } = 30;

    public int Tentativas { get; set; } = 3;

    /// <summary>Preço por milhão de tokens de entrada, para o custo estimado no registro.</summary>
    public decimal PrecoEntradaPorMilhao { get; set; }
}

/// <summary>Um modelo num provedor. Dois modelos do mesmo provedor são duas entradas com nomes diferentes.</summary>
public sealed class ProvedorIaOptions
{
    /// <summary>Identifica a entrada nas listas por funcionalidade e no registro <c>ChamadaIa</c>.</summary>
    public string Nome { get; set; } = string.Empty;

    /// <summary>Tipo de provedor: <c>Anthropic</c>, <c>OpenAICompativel</c>, <c>Gemini</c> ou <c>Ollama</c>.</summary>
    public string Tipo { get; set; } = string.Empty;

    public string Modelo { get; set; } = string.Empty;

    /// <summary>
    /// Endereço da API. No <c>OpenAICompativel</c>, aponta para OpenAI, Azure, DeepSeek, Qwen, Kimi, GLM, Groq e
    /// outros com API no formato da OpenAI. No Ollama, o servidor local. Vazio, vale o padrão do tipo.
    /// </summary>
    public string? Endpoint { get; set; }

    /// <summary>Chave do provedor. Nunca versionar: use variável de ambiente ou cofre de segredos.</summary>
    public string? ApiKey { get; set; }

    public int MaxTokensSaida { get; set; } = 4096;

    /// <summary>
    /// Como pedir JSON (<see cref="ModosJson"/>): <c>JsonSchema</c> (padrão, saída estruturada nativa), <c>Json</c>
    /// (só "responda em JSON", schema no prompt) ou <c>Prompt</c> (schema só no prompt). Use <c>Json</c> ou
    /// <c>Prompt</c> em provedores sem suporte a JSON Schema. A validação pelo schema acontece sempre.
    /// </summary>
    public string ModoJson { get; set; } = ModosJson.JsonSchema;

    /// <summary>Preço em dólares por milhão de tokens de entrada, para o custo estimado.</summary>
    public decimal PrecoEntradaPorMilhao { get; set; }

    public decimal PrecoSaidaPorMilhao { get; set; }

    /// <summary>
    /// Parâmetros próprios do provedor, repassados em <see cref="ChatOptions.AdditionalProperties"/>. Cada adaptador
    /// decide o que aceita; o código das funcionalidades não depende deles.
    /// </summary>
    public Dictionary<string, string> ParametrosAdicionais { get; } = new(StringComparer.Ordinal);

    public decimal? EstimateCost(int? tokensEntrada, int? tokensSaida) =>
        tokensEntrada is null && tokensSaida is null
            ? null
            : Math.Round((((tokensEntrada ?? 0) * PrecoEntradaPorMilhao) + ((tokensSaida ?? 0) * PrecoSaidaPorMilhao)) / 1_000_000m, 6);
}

public sealed class FuncionalidadeIaOptions
{
    /// <summary>Nomes dos provedores, em ordem. Vazio, vale a lista global.</summary>
    public List<string> Provedores { get; } = [];

    public double? TimeoutSegundos { get; set; }

    public int? TentativasPorProvedor { get; set; }
}

/// <summary>Traces das chamadas de IA (OpenTelemetry), exportados junto com os da API.</summary>
public static class IaTelemetry
{
    public const string SourceName = "Stowise.Ia";
}

/// <summary>Um provedor pronto para uso: o cliente e a configuração que o originou.</summary>
/// <param name="Transitoria">Classificação de erros do SDK do provedor; nulo usa a regra geral.</param>
internal sealed record ProvedorIa(string Nome, IChatClient Cliente, ProvedorIaOptions Opcoes, Func<Exception, bool?>? Transitoria = null);

/// <summary>Provedores e limites de uma funcionalidade, na ordem em que o gateway tenta.</summary>
internal sealed record CadeiaIa(IReadOnlyList<ProvedorIa> Provedores, TimeSpan Timeout, int TentativasPorProvedor, TimeSpan EsperaInicial);

internal interface IProvedoresIa
{
    /// <summary>Nulo quando a IA está desligada.</summary>
    CadeiaIa? Para(FuncionalidadeIa funcionalidade);
}

/// <summary>
/// Monta os <see cref="IChatClient"/> pela configuração, com a fábrica do tipo de cada entrada, e valida as listas
/// por funcionalidade na partida. Cada cliente ganha traces do OpenTelemetry.
/// </summary>
internal sealed class ProvedoresIa : IProvedoresIa, IDisposable
{
    private readonly Dictionary<string, ProvedorIa> _porNome = new(StringComparer.OrdinalIgnoreCase);
    private readonly List<ProvedorIa> _ordem = [];
    private readonly Dictionary<FuncionalidadeIa, CadeiaIa> _cadeias = [];
    private readonly List<IDisposable> _descartaveis = [];
    private readonly CadeiaIa? _padrao;

    public ProvedoresIa(IOptions<IaOptions> options, IEnumerable<IFabricaProvedorIa> fabricas, ILoggerFactory loggers)
    {
        ArgumentNullException.ThrowIfNull(options);

        var ia = options.Value;
        if (!ia.Habilitada)
        {
            return;
        }

        var porTipo = fabricas.ToDictionary(f => f.Tipo, StringComparer.OrdinalIgnoreCase);
        foreach (var opcoes in ia.Provedores)
        {
            if (string.IsNullOrWhiteSpace(opcoes.Nome) || string.IsNullOrWhiteSpace(opcoes.Modelo))
            {
                throw new InvalidOperationException("Each AI provider needs a Nome and a Modelo.");
            }

            if (!((string[])[ModosJson.JsonSchema, ModosJson.Json, ModosJson.Prompt]).Contains(opcoes.ModoJson, StringComparer.OrdinalIgnoreCase))
            {
                throw new InvalidOperationException(
                    $"Unknown ModoJson '{opcoes.ModoJson}' for '{opcoes.Nome}'. Use {ModosJson.JsonSchema}, {ModosJson.Json} or {ModosJson.Prompt}.");
            }

            if (!porTipo.TryGetValue(opcoes.Tipo, out var fabrica))
            {
                throw new InvalidOperationException(
                    $"Unknown AI provider type '{opcoes.Tipo}' for '{opcoes.Nome}'. Use one of: {string.Join(", ", porTipo.Keys.Order(StringComparer.Ordinal))}.");
            }

            var cliente = fabrica.Create(opcoes);
            _descartaveis.Add(cliente);
            var provedor = new ProvedorIa(
                opcoes.Nome,
                new ChatClientBuilder(cliente).UseOpenTelemetry(loggers, IaTelemetry.SourceName).Build(),
                opcoes,
                fabrica.IsTransient);
            if (!_porNome.TryAdd(opcoes.Nome, provedor))
            {
                throw new InvalidOperationException($"The AI provider name '{opcoes.Nome}' is repeated.");
            }

            _ordem.Add(provedor);
        }

        if (_ordem.Count == 0)
        {
            throw new InvalidOperationException("AI is enabled but Ia:Provedores is empty.");
        }

        _padrao = Cadeia(_ordem, ia.TimeoutSegundos, ia.TentativasPorProvedor, ia);
        foreach (var (chave, ajuste) in ia.Funcionalidades)
        {
            if (!Enum.TryParse<FuncionalidadeIa>(chave, ignoreCase: true, out var funcionalidade))
            {
                throw new InvalidOperationException($"Unknown AI feature '{chave}' in Ia:Funcionalidades.");
            }

            var provedores = ajuste.Provedores.Count == 0
                ? _ordem
                : ajuste.Provedores.Select(nome => _porNome.TryGetValue(nome, out var p)
                    ? p
                    : throw new InvalidOperationException($"Ia:Funcionalidades:{chave} uses the unknown provider '{nome}'.")).ToList();
            _cadeias[funcionalidade] = Cadeia(provedores, ajuste.TimeoutSegundos ?? ia.TimeoutSegundos, ajuste.TentativasPorProvedor ?? ia.TentativasPorProvedor, ia);
        }
    }

    public CadeiaIa? Para(FuncionalidadeIa funcionalidade) => _cadeias.GetValueOrDefault(funcionalidade) ?? _padrao;

    public void Dispose()
    {
        foreach (var descartavel in _descartaveis)
        {
            descartavel.Dispose();
        }
    }

    private static CadeiaIa Cadeia(IReadOnlyList<ProvedorIa> provedores, double timeoutSegundos, int tentativas, IaOptions ia) =>
        new(
            provedores,
            TimeSpan.FromSeconds(Math.Max(0.1, timeoutSegundos)),
            Math.Max(1, tentativas),
            TimeSpan.FromMilliseconds(Math.Max(0, ia.EsperaInicialMs)));
}
