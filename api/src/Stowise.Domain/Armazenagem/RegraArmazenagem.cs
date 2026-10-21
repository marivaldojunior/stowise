using Stowise.Domain.Common;

namespace Stowise.Domain.Armazenagem;

/// <summary>
/// Configuração de uma regra do motor de armazenagem: peso na nota final, estado e parâmetros (SPEC, seção 4). O
/// <see cref="Codigo"/> é a chave da estratégia no código e não muda; as linhas das cinco regras entram pela migration.
/// </summary>
public sealed class RegraArmazenagem : Entity
{
    public const int CodigoMaxLength = 40;
    public const decimal PesoMaximo = 100m;

    private RegraArmazenagem()
    {
    }

    public string Codigo { get; private set; } = null!;

    /// <summary>Importância da regra na nota final, de 0 a 100 (0 tira a regra da nota).</summary>
    public decimal Peso { get; private set; }

    /// <summary>Inativa: a regra não pontua. Uma regra restritiva continua recusando endereços.</summary>
    public bool Ativa { get; private set; }

    public Dictionary<string, decimal> Parametros { get; private set; } = [];

    public DateTimeOffset? AtualizadoEm { get; private set; }

    public Guid? AtualizadoPor { get; private set; }

    public uint Versao { get; private set; }

    /// <summary>Regra ativa, com os parâmetros padrão.</summary>
    public static RegraArmazenagem Create(IRegraArmazenagem regra, decimal peso)
    {
        ArgumentNullException.ThrowIfNull(regra);
        var config = new RegraArmazenagem
        {
            Codigo = Guard.Required(regra.Codigo, "Código da regra", CodigoMaxLength),
            Ativa = true,
            Parametros = new Dictionary<string, decimal>(regra.ParametrosPadrao),
        };
        config.Peso = ValidPeso(peso);
        return config;
    }

    /// <summary>Muda peso, estado e parâmetros. Só aceita os parâmetros que a regra conhece.</summary>
    public void Update(IRegraArmazenagem regra, decimal peso, bool ativa, IReadOnlyDictionary<string, decimal> parametros, Guid usuarioId, DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(regra);
        ArgumentNullException.ThrowIfNull(parametros);
        if (regra.Codigo != Codigo)
        {
            throw new ArgumentException($"Rule '{regra.Codigo}' does not match the configuration '{Codigo}'.", nameof(regra));
        }

        var desconhecido = parametros.Keys.FirstOrDefault(k => !regra.ParametrosPadrao.ContainsKey(k));
        if (desconhecido is not null)
        {
            throw new DomainException($"A regra {Codigo} não tem o parâmetro {desconhecido}.");
        }

        var negativo = parametros.FirstOrDefault(p => p.Value < 0);
        if (negativo.Key is not null)
        {
            throw new DomainException($"O parâmetro {negativo.Key} não pode ser negativo.");
        }

        Peso = ValidPeso(peso);
        Ativa = ativa;
        Parametros = new Dictionary<string, decimal>(parametros);
        AtualizadoPor = usuarioId;
        AtualizadoEm = agora.ToUniversalTime();
    }

    public ConfiguracaoRegra ToConfiguracao() => new(Codigo, Peso, Ativa, Parametros);

    private static decimal ValidPeso(decimal peso) =>
        peso is < 0 or > PesoMaximo ? throw new DomainException($"O peso da regra deve estar entre 0 e {PesoMaximo:0}.") : peso;
}
