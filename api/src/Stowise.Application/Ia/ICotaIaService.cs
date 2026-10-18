using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Domain.Ia;

namespace Stowise.Application.Ia;

/// <summary>Cotas de IA por perfil e exceções por usuário (ADR-0004, item 5). Só o Admin altera.</summary>
public interface ICotaIaService
{
    Task<IReadOnlyList<CotaIaDetalhe>> ListAsync(CancellationToken cancellationToken = default);

    Task<Result<CotaIaDetalhe>> CreateAsync(SalvarCotaIa comando, CancellationToken cancellationToken = default);

    /// <summary>Muda só os limites; perfil, usuário e funcionalidade identificam a cota. Exige a versão lida.</summary>
    Task<Result<CotaIaDetalhe>> UpdateAsync(Guid id, AlterarLimitesCotaIa comando, CancellationToken cancellationToken = default);

    Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>Cota que vale para o usuário na funcionalidade e o consumo atual (dia e mês, no fuso da cota).</summary>
    Task<UsoCotaIa> GetUsoAsync(Guid usuarioId, FuncionalidadeIa funcionalidade, CancellationToken cancellationToken = default);
}

/// <summary>Informe o perfil (cota do perfil) ou o usuário (exceção), nunca os dois. Limite nulo: sem limite.</summary>
public sealed record SalvarCotaIa(
    string? Perfil,
    Guid? UsuarioId,
    FuncionalidadeIa? Funcionalidade,
    int? LimiteChamadasDia,
    long? LimiteTokensMes);

public sealed record AlterarLimitesCotaIa(int? LimiteChamadasDia, long? LimiteTokensMes, uint? Versao);

public sealed record CotaIaDetalhe(
    Guid Id,
    string? Perfil,
    Guid? UsuarioId,
    FuncionalidadeIa? Funcionalidade,
    int? LimiteChamadasDia,
    long? LimiteTokensMes,
    uint Versao);

/// <param name="Origem">De onde vem a cota (ex.: "perfil Operador"); nula sem cota.</param>
/// <param name="Excedida">Verdadeiro quando a próxima chamada seria recusada com HTTP 429.</param>
public sealed record UsoCotaIa(
    FuncionalidadeIa Funcionalidade,
    int ChamadasHoje,
    int? LimiteChamadasDia,
    long TokensMes,
    long? LimiteTokensMes,
    string? Origem,
    bool Excedida);

public static class CotaIaValidation
{
    public static IReadOnlyDictionary<string, string[]> Validate(SalvarCotaIa comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        var temPerfil = !string.IsNullOrWhiteSpace(comando.Perfil);
        if (temPerfil == comando.UsuarioId.HasValue)
        {
            errors["perfil"] = ["Informe o perfil (cota do perfil) ou o usuário (exceção), não os dois."];
        }
        else if (temPerfil && !Perfis.Todos.Contains(comando.Perfil!.Trim(), StringComparer.OrdinalIgnoreCase))
        {
            errors["perfil"] = [$"Perfil desconhecido. Use {string.Join(", ", Perfis.Todos)}."];
        }

        Limites(errors, comando.LimiteChamadasDia, comando.LimiteTokensMes);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(AlterarLimitesCotaIa comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        Limites(errors, comando.LimiteChamadasDia, comando.LimiteTokensMes);
        if (comando.Versao is null)
        {
            errors["versao"] = ["Informe a versão da cota lida antes da alteração."];
        }

        return errors;
    }

    private static void Limites(Dictionary<string, string[]> errors, int? chamadas, long? tokens)
    {
        if (chamadas < 0)
        {
            errors["limiteChamadasDia"] = ["O limite de chamadas não pode ser negativo. Deixe vazio para não limitar."];
        }

        if (tokens < 0)
        {
            errors["limiteTokensMes"] = ["O limite de tokens não pode ser negativo. Deixe vazio para não limitar."];
        }
    }
}
