using System.Diagnostics;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Stowise.Domain.Ia;

namespace Stowise.Infrastructure.Ia;

/// <summary>
/// Embeddings pelo único modelo configurado em <c>Ia:Embeddings</c> (ADR-0011). Cada chamada tem timeout e nova
/// tentativa só para falha transitória (a mesma regra do <see cref="GatewayIa"/>), e grava um <see cref="ChamadaIa"/>
/// sem usuário: o trabalho é do sistema e não conta na cota de ninguém. Sem fallback entre modelos.
/// </summary>
internal sealed partial class GeradorEmbeddings : IDisposable
{
    public const string PromptVersao = "embeddings-v1";

    private readonly IEmbeddingGenerator<string, Embedding<float>>? _gerador;
    private readonly EmbeddingsIaOptions _opcoes;
    private readonly IRegistroChamadasIa _registro;
    private readonly TimeProvider _time;
    private readonly ILogger<GeradorEmbeddings> _logger;

    public GeradorEmbeddings(
        IOptions<IaOptions> options,
        IEnumerable<IFabricaProvedorIa> fabricas,
        IRegistroChamadasIa registro,
        TimeProvider time,
        ILogger<GeradorEmbeddings> logger)
        : this(Criar(options.Value, fabricas), options.Value.Embeddings, registro, time, logger)
    {
    }

    internal GeradorEmbeddings(
        IEmbeddingGenerator<string, Embedding<float>>? gerador,
        EmbeddingsIaOptions opcoes,
        IRegistroChamadasIa registro,
        TimeProvider time,
        ILogger<GeradorEmbeddings> logger)
    {
        _gerador = gerador;
        _opcoes = opcoes;
        _registro = registro;
        _time = time;
        _logger = logger;
    }

    /// <summary>Falso quando a IA ou os embeddings estão desligados.</summary>
    public bool Disponivel => _gerador is not null;

    /// <summary>Identifica o modelo dos vetores: trocar o modelo torna os vetores antigos desatualizados.</summary>
    public string Modelo => $"{_opcoes.Tipo}:{_opcoes.Modelo}".ToLowerInvariant();

    /// <summary>Um vetor de <see cref="EmbeddingsIaOptions.Dimensoes"/> por texto, na mesma ordem; nulo quando falhou ou está desligado.</summary>
    public async Task<IReadOnlyList<float[]>?> GenerateAsync(IReadOnlyList<string> textos, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(textos);
        if (_gerador is null || textos.Count == 0)
        {
            return null;
        }

        var relogio = Stopwatch.StartNew();
        var opcoes = new EmbeddingGenerationOptions { Dimensions = EmbeddingsIaOptions.Dimensoes };
        string? erro = null;
        int? tokens = null;
        var tentativas = 0;
        IReadOnlyList<float[]>? vetores = null;

        while (vetores is null && erro is null)
        {
            tentativas++;
            using var limite = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
            limite.CancelAfter(TimeSpan.FromSeconds(_opcoes.TimeoutSegundos));
            try
            {
                var gerados = await _gerador.GenerateAsync(textos, opcoes, limite.Token);
                tokens = (int?)gerados.Usage?.InputTokenCount;
                if (gerados.Count != textos.Count || gerados.Any(g => g.Vector.Length != EmbeddingsIaOptions.Dimensoes))
                {
                    erro = $"The embedding model must return {textos.Count} vectors of {EmbeddingsIaOptions.Dimensoes} dimensions.";
                }
                else
                {
                    vetores = [.. gerados.Select(g => g.Vector.ToArray())];
                }
            }
            catch (Exception e) when (!cancellationToken.IsCancellationRequested)
            {
                var transitoria = e is OperationCanceledException || GatewayIa.IsTransient(e);
                LogAttemptFailed(e, Modelo, tentativas);
                if (!transitoria || tentativas >= _opcoes.Tentativas)
                {
                    erro = $"{e.GetType().Name}: {e.Message}";
                }
                else
                {
                    await Task.Delay(GatewayIa.Backoff(TimeSpan.FromMilliseconds(500), tentativas), _time, cancellationToken);
                }
            }
        }

        await _registro.SaveAsync(ChamadaIa.Create(
            FuncionalidadeIa.Embeddings,
            usuarioId: null,
            _opcoes.Tipo,
            _opcoes.Modelo,
            PromptVersao,
            new UsoIa(tokens, null, (int)relogio.ElapsedMilliseconds, tentativas),
            tokens is null ? null : tokens * _opcoes.PrecoEntradaPorMilhao / 1_000_000m,
            erro,
            Activity.Current?.TraceId.ToString(),
            _time.GetUtcNow()));

        return vetores;
    }

    public void Dispose() => _gerador?.Dispose();

    private static IEmbeddingGenerator<string, Embedding<float>>? Criar(IaOptions ia, IEnumerable<IFabricaProvedorIa> fabricas)
    {
        var opcoes = ia.Embeddings;
        if (!ia.Habilitada || !opcoes.Habilitado)
        {
            return null;
        }

        if (string.IsNullOrWhiteSpace(opcoes.Modelo))
        {
            throw new InvalidOperationException("Ia:Embeddings needs a Modelo.");
        }

        var fabrica = fabricas.FirstOrDefault(f => string.Equals(f.Tipo, opcoes.Tipo, StringComparison.OrdinalIgnoreCase))
            ?? throw new InvalidOperationException($"Unknown AI provider type '{opcoes.Tipo}' in Ia:Embeddings.");
        return fabrica.CreateEmbeddings(new ProvedorIaOptions
        {
            Nome = "embeddings",
            Tipo = opcoes.Tipo,
            Modelo = opcoes.Modelo,
            Endpoint = opcoes.Endpoint,
            ApiKey = opcoes.ApiKey,
        });
    }

    [LoggerMessage(Level = LogLevel.Warning, Message = "Embedding attempt {Tentativa} with {Modelo} failed")]
    private partial void LogAttemptFailed(Exception exception, string modelo, int tentativa);
}
