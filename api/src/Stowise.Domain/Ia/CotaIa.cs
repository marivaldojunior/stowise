using Stowise.Domain.Common;

namespace Stowise.Domain.Ia;

/// <summary>
/// Limite de uso de IA (ADR-0004, item 5; SPEC, módulo 6). Uma linha vale para um perfil ou é a exceção de um
/// usuário; vale para uma funcionalidade ou, sem ela, para todas. Limite nulo quer dizer sem limite. Acima do limite,
/// a API recusa a chamada (HTTP 429) e o fluxo segue sem IA.
/// </summary>
public sealed class CotaIa : Entity
{
    public const int PerfilMaxLength = 30;

    private CotaIa()
    {
    }

    /// <summary>Perfil a que a cota vale. Nulo na exceção de um usuário.</summary>
    public string? Perfil { get; private set; }

    /// <summary>Usuário da exceção. Nulo na cota de perfil.</summary>
    public Guid? UsuarioId { get; private set; }

    /// <summary>Nula: vale para todas as funcionalidades sem cota própria.</summary>
    public FuncionalidadeIa? Funcionalidade { get; private set; }

    /// <summary>Chamadas por dia (fuso da cota). Nulo: sem limite.</summary>
    public int? LimiteChamadasDia { get; private set; }

    /// <summary>Tokens de entrada + saída por mês (fuso da cota). Nulo: sem limite.</summary>
    public long? LimiteTokensMes { get; private set; }

    public uint Versao { get; private set; }

    public static CotaIa ForPerfil(string perfil, FuncionalidadeIa? funcionalidade, int? limiteChamadasDia, long? limiteTokensMes)
    {
        var cota = new CotaIa
        {
            Perfil = Guard.Required(perfil, "Perfil", PerfilMaxLength),
            Funcionalidade = funcionalidade,
        };
        cota.SetLimites(limiteChamadasDia, limiteTokensMes);
        return cota;
    }

    public static CotaIa ForUsuario(Guid usuarioId, FuncionalidadeIa? funcionalidade, int? limiteChamadasDia, long? limiteTokensMes)
    {
        if (usuarioId == Guid.Empty)
        {
            throw new DomainException("Informe o usuário da exceção de cota.");
        }

        var cota = new CotaIa { UsuarioId = usuarioId, Funcionalidade = funcionalidade };
        cota.SetLimites(limiteChamadasDia, limiteTokensMes);
        return cota;
    }

    /// <summary>Perfil, usuário e funcionalidade identificam a cota e não mudam; só os limites mudam.</summary>
    public void SetLimites(int? limiteChamadasDia, long? limiteTokensMes)
    {
        if (limiteChamadasDia < 0 || limiteTokensMes < 0)
        {
            throw new DomainException("Os limites de cota não podem ser negativos.");
        }

        (LimiteChamadasDia, LimiteTokensMes) = (limiteChamadasDia, limiteTokensMes);
    }

    /// <summary>
    /// A cota que vale para o usuário numa funcionalidade: a exceção do usuário vence; sem ela, vale a cota dos
    /// perfis, e com vários perfis vence a mais folgada. Em cada nível, a cota da funcionalidade vence a geral.
    /// Nula: sem cota, sem limite.
    /// </summary>
    public static LimitesIa? Resolve(IEnumerable<CotaIa> cotas, Guid usuarioId, IEnumerable<string> perfis, FuncionalidadeIa funcionalidade)
    {
        ArgumentNullException.ThrowIfNull(cotas);
        ArgumentNullException.ThrowIfNull(perfis);

        var todas = cotas.Where(c => c.Funcionalidade is null || c.Funcionalidade == funcionalidade).ToList();
        CotaIa? MaisEspecifica(IEnumerable<CotaIa> candidatas) =>
            candidatas.OrderBy(c => c.Funcionalidade is null ? 1 : 0).FirstOrDefault();

        if (MaisEspecifica(todas.Where(c => c.UsuarioId == usuarioId)) is { } excecao)
        {
            return LimitesIa.From(excecao);
        }

        var dosPerfis = perfis
            .Select(perfil => MaisEspecifica(todas.Where(c => string.Equals(c.Perfil, perfil, StringComparison.OrdinalIgnoreCase))))
            .OfType<CotaIa>()
            .Select(LimitesIa.From)
            .ToList();

        return dosPerfis.Count == 0 ? null : dosPerfis.Aggregate(LimitesIa.MaisFolgado);
    }
}

/// <param name="Funcionalidade">Nula: o consumo conta todas as funcionalidades.</param>
public sealed record LimitesIa(Guid CotaId, FuncionalidadeIa? Funcionalidade, int? ChamadasDia, long? TokensMes, string Origem)
{
    public static LimitesIa From(CotaIa cota)
    {
        ArgumentNullException.ThrowIfNull(cota);

        return new(cota.Id, cota.Funcionalidade, cota.LimiteChamadasDia, cota.LimiteTokensMes, cota.Perfil is null ? "exceção do usuário" : $"perfil {cota.Perfil}");
    }

    /// <summary>Com dois perfis, vale o maior limite de cada tipo; nulo (sem limite) vence qualquer número.</summary>
    public static LimitesIa MaisFolgado(LimitesIa a, LimitesIa b)
    {
        ArgumentNullException.ThrowIfNull(a);
        ArgumentNullException.ThrowIfNull(b);

        static T? Maior<T>(T? x, T? y)
            where T : struct, IComparable<T> =>
            x is null || y is null ? null : (x.Value.CompareTo(y.Value) >= 0 ? x : y);

        var base_ = a.ChamadasDia is null || (b.ChamadasDia is not null && a.ChamadasDia >= b.ChamadasDia) ? a : b;
        return base_ with
        {
            ChamadasDia = Maior(a.ChamadasDia, b.ChamadasDia),
            TokensMes = Maior(a.TokensMes, b.TokensMes),
            Funcionalidade = a.Funcionalidade == b.Funcionalidade ? a.Funcionalidade : null,
        };
    }
}
