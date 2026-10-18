using Stowise.Application.Ia;
using Stowise.Domain.Common;
using Stowise.Domain.Ia;

namespace Stowise.UnitTests.Ia;

public class CotaIaTests
{
    private static readonly Guid Usuario = Guid.NewGuid();

    [Fact]
    public void Limits_cannot_be_negative_and_an_exception_needs_a_user()
    {
        Assert.Throws<DomainException>(() => CotaIa.ForPerfil("Gestor", null, -1, null));
        Assert.Throws<DomainException>(() => CotaIa.ForPerfil(" ", null, 1, null));
        Assert.Throws<DomainException>(() => CotaIa.ForUsuario(Guid.Empty, null, 1, 1));
        Assert.Null(CotaIa.ForPerfil("Gestor", null, null, null).LimiteChamadasDia);
    }

    [Fact]
    public void No_quota_means_no_limit()
    {
        Assert.Null(CotaIa.Resolve([], Usuario, ["Admin"], FuncionalidadeIa.Mapeamento));
    }

    [Fact]
    public void User_exception_beats_the_profile_and_feature_quota_beats_the_general_one()
    {
        CotaIa[] cotas =
        [
            CotaIa.ForPerfil("Operador", null, 50, 500_000),
            CotaIa.ForPerfil("Operador", FuncionalidadeIa.Mapeamento, 10, null),
            CotaIa.ForUsuario(Usuario, null, 5, 1000),
        ];

        var excecao = CotaIa.Resolve(cotas, Usuario, ["Operador"], FuncionalidadeIa.Mapeamento)!;
        var porFuncionalidade = CotaIa.Resolve(cotas, Guid.NewGuid(), ["Operador"], FuncionalidadeIa.Mapeamento)!;
        var geral = CotaIa.Resolve(cotas, Guid.NewGuid(), ["Operador"], FuncionalidadeIa.Consulta)!;

        Assert.Equal((5, 1000L, "exceção do usuário", (FuncionalidadeIa?)null), (excecao.ChamadasDia, excecao.TokensMes, excecao.Origem, excecao.Funcionalidade));
        Assert.Equal((10, (long?)null, (FuncionalidadeIa?)FuncionalidadeIa.Mapeamento), (porFuncionalidade.ChamadasDia, porFuncionalidade.TokensMes, porFuncionalidade.Funcionalidade));
        Assert.Equal((50, 500_000L, "perfil Operador"), (geral.ChamadasDia, geral.TokensMes, geral.Origem));
    }

    [Fact]
    public void With_several_profiles_the_most_generous_limit_wins_and_no_limit_beats_any_number()
    {
        CotaIa[] cotas =
        [
            CotaIa.ForPerfil("Operador", null, 50, 500_000),
            CotaIa.ForPerfil("Gestor", null, 200, null),
        ];

        var limites = CotaIa.Resolve(cotas, Usuario, ["Operador", "Gestor"], FuncionalidadeIa.Consulta)!;

        Assert.Equal((200, (long?)null), (limites.ChamadasDia, limites.TokensMes));
    }

    [Fact]
    public void Quota_request_needs_a_profile_or_a_user_and_valid_limits()
    {
        static IEnumerable<string> Campos(SalvarCotaIa c) => CotaIaValidation.Validate(c).Keys.Order(StringComparer.Ordinal);

        Assert.Equal(["perfil"], Campos(new SalvarCotaIa("Gestor", Guid.NewGuid(), null, 1, 1)));
        Assert.Equal(["perfil"], Campos(new SalvarCotaIa(null, null, null, 1, 1)));
        Assert.Equal(["perfil"], Campos(new SalvarCotaIa("Estagiario", null, null, 1, 1)));
        Assert.Equal(["limiteChamadasDia", "limiteTokensMes"], Campos(new SalvarCotaIa("operador", null, null, -1, -5)));
        Assert.Empty(Campos(new SalvarCotaIa(null, Guid.NewGuid(), FuncionalidadeIa.Mapeamento, null, null)));
        Assert.Equal(["versao"], CotaIaValidation.Validate(new AlterarLimitesCotaIa(1, 1, null)).Keys);
    }
}
