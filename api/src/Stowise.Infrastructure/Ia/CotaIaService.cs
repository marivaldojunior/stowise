using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Stowise.Application.Common;
using Stowise.Application.Ia;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Ia;

internal sealed class CotaIaService(StowiseDbContext db, TimeProvider time, IOptions<IaOptions> options) : ICotaIaService
{
    public async Task<IReadOnlyList<CotaIaDetalhe>> ListAsync(CancellationToken cancellationToken = default) =>
        [.. (await db.CotasIa.AsNoTracking().ToListAsync(cancellationToken))
            .OrderBy(c => c.Perfil is null)
            .ThenBy(c => c.Perfil, StringComparer.Ordinal)
            .ThenBy(c => c.UsuarioId)
            .ThenBy(c => c.Funcionalidade)
            .Select(ToDetalhe)];

    public async Task<Result<CotaIaDetalhe>> CreateAsync(SalvarCotaIa comando, CancellationToken cancellationToken = default)
    {
        var errors = CotaIaValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        if (comando.UsuarioId is { } usuarioId && !await db.Users.AnyAsync(u => u.Id == usuarioId, cancellationToken))
        {
            return AppError.Validation("usuarioId", "Usuário não encontrado.");
        }

        var cota = comando.UsuarioId is { } usuario
            ? CotaIa.ForUsuario(usuario, comando.Funcionalidade, comando.LimiteChamadasDia, comando.LimiteTokensMes)
            : CotaIa.ForPerfil(Canonical(comando.Perfil!), comando.Funcionalidade, comando.LimiteChamadasDia, comando.LimiteTokensMes);

        var repetida = await db.CotasIa.AnyAsync(
            c => c.Perfil == cota.Perfil && c.UsuarioId == cota.UsuarioId && c.Funcionalidade == cota.Funcionalidade,
            cancellationToken);
        if (repetida)
        {
            return AppError.Conflict("Já existe uma cota para este perfil (ou usuário) e funcionalidade. Altere os limites dela.");
        }

        db.CotasIa.Add(cota);
        await db.SaveChangesAsync(cancellationToken);
        return ToDetalhe(cota);
    }

    public async Task<Result<CotaIaDetalhe>> UpdateAsync(Guid id, AlterarLimitesCotaIa comando, CancellationToken cancellationToken = default)
    {
        var errors = CotaIaValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var cota = await db.CotasIa.FirstOrDefaultAsync(c => c.Id == id, cancellationToken);
        if (cota is null)
        {
            return NotFound();
        }

        if (cota.Versao != comando.Versao)
        {
            return AppError.Conflict("A cota foi alterada depois que você a abriu. Recarregue e tente de novo.");
        }

        db.Entry(cota).Property(c => c.Versao).OriginalValue = comando.Versao!.Value;
        cota.SetLimites(comando.LimiteChamadasDia, comando.LimiteTokensMes);
        await db.SaveChangesAsync(cancellationToken);
        return ToDetalhe(cota);
    }

    public async Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default) =>
        await db.CotasIa.Where(c => c.Id == id).ExecuteDeleteAsync(cancellationToken) == 0 ? NotFound() : Result.Success();

    public async Task<UsoCotaIa> GetUsoAsync(Guid usuarioId, FuncionalidadeIa funcionalidade, CancellationToken cancellationToken = default)
    {
        var perfis = await (
                from ur in db.UserRoles
                join r in db.Roles on ur.RoleId equals r.Id
                where ur.UserId == usuarioId
                select r.Name!)
            .ToListAsync(cancellationToken);
        var cotas = await db.CotasIa.AsNoTracking()
            .Where(c => c.UsuarioId == usuarioId || (c.Perfil != null && perfis.Contains(c.Perfil)))
            .ToListAsync(cancellationToken);
        var limites = CotaIa.Resolve(cotas, usuarioId, perfis, funcionalidade);

        // O Npgsql só aceita DateTimeOffset em UTC nas colunas timestamptz.
        var (inicioDia, inicioMes) = Periodos();
        var doMes = db.ChamadasIa.Where(c => c.UsuarioId == usuarioId && c.CriadaEm >= inicioMes);
        if (limites?.Funcionalidade is { } escopo)
        {
            doMes = doMes.Where(c => c.Funcionalidade == escopo);
        }

        var chamadasHoje = await doMes.CountAsync(c => c.CriadaEm >= inicioDia, cancellationToken);
        var tokensMes = await doMes.SumAsync(c => (long)((c.TokensEntrada ?? 0) + (c.TokensSaida ?? 0)), cancellationToken);
        var excedida = limites is not null
            && ((limites.ChamadasDia is { } maxChamadas && chamadasHoje >= maxChamadas)
                || (limites.TokensMes is { } maxTokens && tokensMes >= maxTokens));

        return new UsoCotaIa(funcionalidade, chamadasHoje, limites?.ChamadasDia, tokensMes, limites?.TokensMes, limites?.Origem, excedida);
    }

    /// <summary>Início do dia e do mês no fuso da cota (<see cref="IaOptions.FusoHorarioCota"/>), em UTC.</summary>
    private (DateTimeOffset InicioDia, DateTimeOffset InicioMes) Periodos()
    {
        var fuso = Fuso(options.Value.FusoHorarioCota);
        var local = TimeZoneInfo.ConvertTime(time.GetUtcNow(), fuso);
        DateTimeOffset Inicio(DateTime data) => new DateTimeOffset(data, fuso.GetUtcOffset(data)).ToUniversalTime();
        return (Inicio(local.Date), Inicio(new DateTime(local.Year, local.Month, 1, 0, 0, 0, DateTimeKind.Unspecified)));
    }

    /// <summary>Sem a base de fusos no sistema (imagem mínima sem tzdata), a cota conta em UTC em vez de falhar.</summary>
    private static TimeZoneInfo Fuso(string id)
    {
        try
        {
            return TimeZoneInfo.FindSystemTimeZoneById(id);
        }
        catch (Exception e) when (e is TimeZoneNotFoundException or InvalidTimeZoneException)
        {
            return TimeZoneInfo.Utc;
        }
    }

    private static string Canonical(string perfil) =>
        Application.Auth.Perfis.Todos.First(p => string.Equals(p, perfil.Trim(), StringComparison.OrdinalIgnoreCase));

    private static CotaIaDetalhe ToDetalhe(CotaIa c) =>
        new(c.Id, c.Perfil, c.UsuarioId, c.Funcionalidade, c.LimiteChamadasDia, c.LimiteTokensMes, c.Versao);

    private static AppError NotFound() => AppError.NotFound("Cota de IA não encontrada.");
}

/// <summary>Consulta da cota pelo gateway, que é singleton: cada verificação abre o próprio escopo.</summary>
internal interface IVerificadorCotaIa
{
    Task<UsoCotaIa> CheckAsync(Guid usuarioId, FuncionalidadeIa funcionalidade, CancellationToken cancellationToken);
}

internal sealed class VerificadorCotaIa(IServiceScopeFactory scopes) : IVerificadorCotaIa
{
    public async Task<UsoCotaIa> CheckAsync(Guid usuarioId, FuncionalidadeIa funcionalidade, CancellationToken cancellationToken)
    {
        await using var scope = scopes.CreateAsyncScope();
        return await scope.ServiceProvider.GetRequiredService<ICotaIaService>().GetUsoAsync(usuarioId, funcionalidade, cancellationToken);
    }
}
