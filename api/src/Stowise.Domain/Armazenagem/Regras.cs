using Stowise.Domain.Catalogo;
using Stowise.Domain.Estrutura;

namespace Stowise.Domain.Armazenagem;

/// <summary>Códigos das regras (a chave de <c>RegraArmazenagem.Codigo</c>).</summary>
public static class CodigosRegra
{
    public const string Zona = "zona";
    public const string Capacidade = "capacidade";
    public const string CurvaAbc = "curva-abc";
    public const string Fefo = "fefo";
    public const string Consolidacao = "consolidacao";
}

/// <summary>Restritiva: o produto só fica numa zona da mesma classe de armazenagem (ex.: inflamável na zona de inflamáveis).</summary>
public sealed class RegraZona : IRegraArmazenagem
{
    public string Codigo => CodigosRegra.Zona;

    public bool Restritiva => true;

    public IReadOnlyDictionary<string, decimal> ParametrosPadrao { get; } = new Dictionary<string, decimal>();

    public IReadOnlyList<AvaliacaoRegra> Avaliar(ItemArmazenagem item, IReadOnlyList<CandidatoEndereco> candidatos, ParametrosRegra parametros)
    {
        ArgumentNullException.ThrowIfNull(item);
        ArgumentNullException.ThrowIfNull(candidatos);
        return candidatos
            .Select(c => c.ClasseZona == item.Classe
                ? AvaliacaoRegra.Com(1m, $"Zona de produtos {Nome(c.ClasseZona)}, a mesma classe do produto.")
                : AvaliacaoRegra.Inapto($"Zona de produtos {Nome(c.ClasseZona)}; o produto é {Nome(item.Classe)}."))
            .ToList();
    }

    private static string Nome(ClasseArmazenagem classe) => classe switch
    {
        ClasseArmazenagem.Normal => "normais",
        ClasseArmazenagem.Refrigerado => "refrigerados",
        ClasseArmazenagem.Inflamavel => "inflamáveis",
        ClasseArmazenagem.Fragil => "frágeis",
        _ => classe.ToString(),
    };
}

/// <summary>
/// Restritiva: a carga cabe no peso e no volume que sobram (até <c>ocupacaoMaxima</c>%, padrão 100). A nota é a ocupação
/// depois de guardar: o endereço mais justo desperdiça menos espaço. Sem peso e medidas no cadastro, a regra não se aplica.
/// </summary>
public sealed class RegraCapacidade : IRegraArmazenagem
{
    public const string OcupacaoMaxima = "ocupacaoMaxima";

    public string Codigo => CodigosRegra.Capacidade;

    public bool Restritiva => true;

    public IReadOnlyDictionary<string, decimal> ParametrosPadrao { get; } = new Dictionary<string, decimal> { [OcupacaoMaxima] = 100m };

    public IReadOnlyList<AvaliacaoRegra> Avaliar(ItemArmazenagem item, IReadOnlyList<CandidatoEndereco> candidatos, ParametrosRegra parametros)
    {
        ArgumentNullException.ThrowIfNull(item);
        ArgumentNullException.ThrowIfNull(candidatos);
        ArgumentNullException.ThrowIfNull(parametros);
        var limite = Math.Clamp(parametros.Get(OcupacaoMaxima, ParametrosPadrao[OcupacaoMaxima]), 1m, 100m) / 100m;
        return candidatos.Select(c => Avaliar(item, c, limite)).ToList();
    }

    private static AvaliacaoRegra Avaliar(ItemArmazenagem item, CandidatoEndereco candidato, decimal limite)
    {
        if (item.PesoKg is null && item.VolumeCm3 is null)
        {
            return AvaliacaoRegra.NaoAplicavel("Cadastro sem peso e medidas: confira se a carga cabe no endereço.");
        }

        decimal? usoPeso = null;
        if (item.PesoKg is { } peso)
        {
            var depois = candidato.Ocupacao.Sum(o => o.PesoKg ?? 0m) + peso;
            var maximo = candidato.CapacidadePesoKg * limite;
            if (depois > maximo)
            {
                return AvaliacaoRegra.Inapto($"Peso excede a capacidade: {Formato.Numero(depois)} kg de {Formato.Numero(maximo)} kg.");
            }

            usoPeso = depois / candidato.CapacidadePesoKg;
        }

        decimal? usoVolume = null;
        if (item.VolumeCm3 is { } volume)
        {
            var depois = candidato.Ocupacao.Sum(o => o.VolumeCm3 ?? 0m) + volume;
            var maximo = candidato.VolumeCm3 * limite;
            if (depois > maximo)
            {
                return AvaliacaoRegra.Inapto(
                    $"Volume excede a capacidade: {Formato.Numero(depois / 1_000_000m)} m³ de {Formato.Numero(maximo / 1_000_000m)} m³.");
            }

            usoVolume = depois / candidato.VolumeCm3;
        }

        var uso = Math.Max(usoPeso ?? 0m, usoVolume ?? 0m);
        var falta = usoPeso is null ? " Sem peso no cadastro." : usoVolume is null ? " Sem medidas no cadastro." : string.Empty;
        return AvaliacaoRegra.Com(uso, $"Cabe: o endereço fica com {Formato.Percentual(uso)} da capacidade ocupada.{falta}");
    }
}

/// <summary>
/// Classe A perto da expedição, C longe e B no meio. A distância é comparada entre os candidatos (0 = o mais perto,
/// 1 = o mais longe).
/// </summary>
public sealed class RegraCurvaAbc : IRegraArmazenagem
{
    public string Codigo => CodigosRegra.CurvaAbc;

    public bool Restritiva => false;

    public IReadOnlyDictionary<string, decimal> ParametrosPadrao { get; } = new Dictionary<string, decimal>();

    public IReadOnlyList<AvaliacaoRegra> Avaliar(ItemArmazenagem item, IReadOnlyList<CandidatoEndereco> candidatos, ParametrosRegra parametros)
    {
        ArgumentNullException.ThrowIfNull(item);
        ArgumentNullException.ThrowIfNull(candidatos);
        if (candidatos.Count == 0)
        {
            return [];
        }

        var menor = candidatos.Min(c => c.DistanciaExpedicao);
        var faixa = candidatos.Max(c => c.DistanciaExpedicao) - menor;
        var objetivo = item.ClasseAbc switch
        {
            ClasseAbc.A => "mais perto é melhor",
            ClasseAbc.B => "no meio é melhor",
            _ => "mais longe é melhor",
        };

        return candidatos
            .Select(c =>
            {
                var explicacao = $"Classe {item.ClasseAbc}: endereço a {Formato.Numero(c.DistanciaExpedicao)} m da expedição ({objetivo}).";
                if (faixa == 0)
                {
                    return AvaliacaoRegra.Com(1m, explicacao);
                }

                var posicao = (c.DistanciaExpedicao - menor) / faixa;
                var nota = item.ClasseAbc switch
                {
                    ClasseAbc.A => 1m - posicao,
                    ClasseAbc.B => 1m - (Math.Abs(posicao - 0.5m) * 2m),
                    _ => posicao,
                };
                return AvaliacaoRegra.Com(nota, explicacao);
            })
            .ToList();
    }
}

/// <summary>
/// Não misturar validades do mesmo produto num endereço: o lote que vence antes ficaria escondido e a separação não
/// seguiria o FEFO. Validades com diferença de até <c>toleranciaDias</c> (padrão 0) contam como iguais. Só se aplica
/// a item com validade.
/// </summary>
public sealed class RegraFefo : IRegraArmazenagem
{
    public const string ToleranciaDias = "toleranciaDias";

    public string Codigo => CodigosRegra.Fefo;

    public bool Restritiva => false;

    public IReadOnlyDictionary<string, decimal> ParametrosPadrao { get; } = new Dictionary<string, decimal> { [ToleranciaDias] = 0m };

    public IReadOnlyList<AvaliacaoRegra> Avaliar(ItemArmazenagem item, IReadOnlyList<CandidatoEndereco> candidatos, ParametrosRegra parametros)
    {
        ArgumentNullException.ThrowIfNull(item);
        ArgumentNullException.ThrowIfNull(candidatos);
        ArgumentNullException.ThrowIfNull(parametros);
        if (item.Validade is not { } validade)
        {
            return candidatos.Select(_ => AvaliacaoRegra.NaoAplicavel("O item não tem validade.")).ToList();
        }

        var tolerancia = (int)Math.Max(0m, parametros.Get(ToleranciaDias, ParametrosPadrao[ToleranciaDias]));
        return candidatos
            .Select(c =>
            {
                var outra = c.Ocupacao
                    .Where(o => o.ProdutoId == item.ProdutoId && o.Validade is not null)
                    .Select(o => o.Validade!.Value)
                    .Where(v => Math.Abs(v.DayNumber - validade.DayNumber) > tolerancia)
                    .Order()
                    .Select(v => (DateOnly?)v)
                    .FirstOrDefault();
                return outra is null
                    ? AvaliacaoRegra.Com(1m, $"Sem outra validade do produto no endereço (este lote vence em {Formato.Data(validade)}).")
                    : AvaliacaoRegra.Com(0m, $"Misturaria validades: o endereço tem o produto com validade {Formato.Data(outra.Value)}; este lote vence em {Formato.Data(validade)}.");
            })
            .ToList();
    }
}

/// <summary>
/// Juntar o mesmo produto num endereço: mesmo lote (<c>mesmoLote</c>, padrão 100), mesmo produto em outro lote
/// (<c>mesmoProduto</c>, 70), endereço vazio (<c>vazio</c>, 40) e só outros produtos (<c>outroProduto</c>, 0). Valores em %.
/// </summary>
public sealed class RegraConsolidacao : IRegraArmazenagem
{
    public const string MesmoLote = "mesmoLote";
    public const string MesmoProduto = "mesmoProduto";
    public const string Vazio = "vazio";
    public const string OutroProduto = "outroProduto";

    public string Codigo => CodigosRegra.Consolidacao;

    public bool Restritiva => false;

    public IReadOnlyDictionary<string, decimal> ParametrosPadrao { get; } = new Dictionary<string, decimal>
    {
        [MesmoLote] = 100m,
        [MesmoProduto] = 70m,
        [Vazio] = 40m,
        [OutroProduto] = 0m,
    };

    public IReadOnlyList<AvaliacaoRegra> Avaliar(ItemArmazenagem item, IReadOnlyList<CandidatoEndereco> candidatos, ParametrosRegra parametros)
    {
        ArgumentNullException.ThrowIfNull(item);
        ArgumentNullException.ThrowIfNull(candidatos);
        ArgumentNullException.ThrowIfNull(parametros);
        return candidatos
            .Select(c =>
            {
                var doProduto = c.Ocupacao.Where(o => o.ProdutoId == item.ProdutoId).ToList();
                if (doProduto.Any(o => o.LoteId == item.LoteId))
                {
                    var explicacao = item.LoteId is null ? "O endereço já tem o produto." : "O endereço já tem o produto, do mesmo lote.";
                    return Nota(parametros, MesmoLote, explicacao);
                }

                if (doProduto.Count > 0)
                {
                    return Nota(parametros, MesmoProduto, "O endereço já tem o produto, de outro lote.");
                }

                return c.Ocupacao.Count == 0
                    ? Nota(parametros, Vazio, "Endereço vazio.")
                    : Nota(parametros, OutroProduto, "O endereço só tem outros produtos.");
            })
            .ToList();
    }

    private AvaliacaoRegra Nota(ParametrosRegra parametros, string nome, string explicacao) =>
        AvaliacaoRegra.Com(parametros.Get(nome, ParametrosPadrao[nome]) / 100m, explicacao);
}
