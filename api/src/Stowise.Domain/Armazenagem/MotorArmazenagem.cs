namespace Stowise.Domain.Armazenagem;

/// <summary>
/// Ordena os endereços candidatos para guardar um item (SPEC, 2.3). Algorítmico, sem LLM: as regras restritivas
/// recusam endereços (mesmo inativas), e as regras ativas com peso dão a pontuação, uma média ponderada das notas.
/// Cada sugestão leva a nota e a explicação de todas as regras, para o snapshot da tarefa de armazenagem.
/// </summary>
public sealed class MotorArmazenagem
{
    private readonly IReadOnlyList<IRegraArmazenagem> _regras;

    public MotorArmazenagem(IEnumerable<IRegraArmazenagem> regras)
    {
        ArgumentNullException.ThrowIfNull(regras);
        _regras = regras.ToList();
        var repetida = _regras.GroupBy(r => r.Codigo, StringComparer.Ordinal).FirstOrDefault(g => g.Count() > 1);
        if (repetida is not null)
        {
            throw new ArgumentException($"Duplicate storage rule code '{repetida.Key}'.", nameof(regras));
        }
    }

    /// <summary>As cinco regras do SPEC: zona, capacidade, curva ABC, FEFO e consolidação.</summary>
    public static MotorArmazenagem Padrao() =>
        new([new RegraZona(), new RegraCapacidade(), new RegraCurvaAbc(), new RegraFefo(), new RegraConsolidacao()]);

    public IReadOnlyList<string> Codigos => _regras.Select(r => r.Codigo).ToList();

    /// <param name="configuracao">Peso, estado e parâmetros por código. Regra sem configuração fica inativa.</param>
    public ResultadoArmazenagem Sugerir(
        ItemArmazenagem item,
        IReadOnlyList<CandidatoEndereco> candidatos,
        IReadOnlyList<ConfiguracaoRegra> configuracao)
    {
        ArgumentNullException.ThrowIfNull(item);
        ArgumentNullException.ThrowIfNull(candidatos);
        ArgumentNullException.ThrowIfNull(configuracao);
        var porCodigo = configuracao.ToDictionary(c => c.Codigo, StringComparer.Ordinal);
        ConfiguracaoRegra? Config(IRegraArmazenagem regra) => porCodigo.GetValueOrDefault(regra.Codigo);
        ParametrosRegra Parametros(IRegraArmazenagem regra) => new(Config(regra)?.Parametros);

        // Primeiro as restrições: as outras regras comparam só os endereços que sobraram (ex.: a distância da curva ABC).
        var restritivas = _regras.Where(r => r.Restritiva).ToList();
        var avaliacoes = restritivas.ToDictionary(r => r.Codigo, r => r.Avaliar(item, candidatos, Parametros(r)), StringComparer.Ordinal);
        var aptos = new List<int>();
        var descartados = new List<EnderecoDescartado>();
        for (var i = 0; i < candidatos.Count; i++)
        {
            var motivos = restritivas.Select(r => avaliacoes[r.Codigo][i]).Where(a => !a.Apto).Select(a => a.Explicacao).ToList();
            if (motivos.Count == 0)
            {
                aptos.Add(i);
            }
            else
            {
                descartados.Add(new EnderecoDescartado(candidatos[i].EnderecoId, candidatos[i].Codigo, motivos));
            }
        }

        var restantes = aptos.Select(i => candidatos[i]).ToList();
        var notas = _regras.ToDictionary(
            r => r.Codigo,
            r => r.Restritiva ? aptos.Select(i => avaliacoes[r.Codigo][i]).ToList() : r.Avaliar(item, restantes, Parametros(r)),
            StringComparer.Ordinal);

        var sugestoes = restantes
            .Select((candidato, i) =>
            {
                var detalhe = _regras
                    .Select(r =>
                    {
                        var config = Config(r);
                        var avaliacao = notas[r.Codigo][i];
                        return new NotaRegra(r.Codigo, config?.Peso ?? 0m, config?.Ativa ?? false, avaliacao.Nota, avaliacao.Explicacao);
                    })
                    .ToList();
                return (candidato, sugestao: new SugestaoEndereco(candidato.EnderecoId, candidato.Codigo, Pontuar(detalhe), detalhe));
            })
            .OrderByDescending(x => x.sugestao.Pontuacao)
            .ThenBy(x => x.candidato.DistanciaExpedicao)
            .ThenBy(x => x.candidato.Codigo, StringComparer.Ordinal)
            .Select(x => x.sugestao)
            .ToList();

        return new ResultadoArmazenagem(sugestoes, descartados);
    }

    /// <summary>Média das notas das regras ativas e aplicáveis, ponderada pelos pesos, de 0 a 100.</summary>
    private static decimal Pontuar(IReadOnlyList<NotaRegra> notas)
    {
        var contam = notas.Where(n => n.Ativa && n.Peso > 0 && n.Nota is not null).ToList();
        var pesos = contam.Sum(n => n.Peso);
        return pesos == 0 ? 0m : Math.Round(contam.Sum(n => n.Peso * n.Nota!.Value) / pesos * 100m, 2);
    }
}
