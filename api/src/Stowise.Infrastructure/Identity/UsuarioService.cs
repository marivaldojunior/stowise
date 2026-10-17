using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.Application.Usuarios;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Identity;

internal sealed class UsuarioService(UserManager<Usuario> users, StowiseDbContext db, TimeProvider time) : IUsuarioService
{
    public async Task<PagedResult<UsuarioDetalhe>> ListAsync(UsuarioFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query = db.Users.AsNoTracking();
        if (!string.IsNullOrWhiteSpace(filtro.Busca))
        {
            var pattern = $"%{EscapeLike(filtro.Busca.Trim())}%";
            query = query.Where(u => EF.Functions.ILike(u.Nome, pattern, @"\") || EF.Functions.ILike(u.Email!, pattern, @"\"));
        }

        if (filtro.Ativo is { } ativo)
        {
            query = query.Where(u => u.Ativo == ativo);
        }

        if (!string.IsNullOrWhiteSpace(filtro.Perfil))
        {
            var perfilId = db.Roles.Where(r => r.Name == filtro.Perfil).Select(r => r.Id);
            query = query.Where(u => db.UserRoles.Any(ur => ur.UserId == u.Id && perfilId.Contains(ur.RoleId)));
        }

        var total = await query.CountAsync(cancellationToken);
        var rows = await query
            .OrderBy(u => u.Nome)
            .ThenBy(u => u.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .Select(u => new UsuarioRow(u.Id, u.Nome, u.Email!, u.Ativo, u.LockoutEnd, u.CriadoEm))
            .ToListAsync(cancellationToken);

        var perfis = await LoadPerfisAsync([.. rows.Select(r => r.Id)], cancellationToken);
        var now = time.GetUtcNow();
        return new PagedResult<UsuarioDetalhe>([.. rows.Select(r => ToDetalhe(r, perfis, now))], pagina, tamanhoPagina, total);
    }

    public async Task<Result<UsuarioDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var detalhe = await FindDetalheAsync(id, cancellationToken);
        return detalhe is null ? NotFound() : detalhe;
    }

    public async Task<Result<UsuarioDetalhe>> CreateAsync(CriarUsuario comando, CancellationToken cancellationToken = default)
    {
        var errors = UsuarioValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var usuario = new Usuario(comando.Email!.Trim(), comando.Nome!.Trim(), time.GetUtcNow());

        await using var transaction = await db.Database.BeginTransactionAsync(cancellationToken);
        var created = await users.CreateAsync(usuario, comando.Senha!);
        if (!created.Succeeded)
        {
            return ToError(created, passwordField: "senha");
        }

        var perfis = await users.AddToRolesAsync(usuario, UsuarioValidation.NormalizePerfis(comando.Perfis!));
        if (!perfis.Succeeded)
        {
            return ToError(perfis, passwordField: "senha");
        }

        await transaction.CommitAsync(cancellationToken);
        return (await FindDetalheAsync(usuario.Id, cancellationToken))!;
    }

    public async Task<Result<UsuarioDetalhe>> UpdateAsync(
        Guid id,
        AtualizarUsuario comando,
        Guid executorId,
        CancellationToken cancellationToken = default)
    {
        var errors = UsuarioValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var usuario = await users.FindByIdAsync(id.ToString());
        if (usuario is null)
        {
            return NotFound();
        }

        var atuais = await users.GetRolesAsync(usuario);
        var novos = UsuarioValidation.NormalizePerfis(comando.Perfis!);
        if (atuais.Contains(Perfis.Admin) && !novos.Contains(Perfis.Admin))
        {
            if (id == executorId)
            {
                return AppError.BusinessRule("Você não pode remover o seu próprio perfil Admin.");
            }

            if (usuario.Ativo && !await HasOtherActiveAdminAsync(id, cancellationToken))
            {
                return AppError.BusinessRule("O sistema precisa de ao menos um Admin ativo.");
            }
        }

        await using var transaction = await db.Database.BeginTransactionAsync(cancellationToken);
        usuario.Nome = comando.Nome!.Trim();
        var steps = new List<Func<Task<IdentityResult>>> { () => users.UpdateAsync(usuario) };
        var adicionar = novos.Except(atuais).ToList();
        var remover = atuais.Except(novos).ToList();
        if (adicionar.Count > 0)
        {
            steps.Add(() => users.AddToRolesAsync(usuario, adicionar));
        }

        if (remover.Count > 0)
        {
            steps.Add(() => users.RemoveFromRolesAsync(usuario, remover));
        }

        foreach (var step in steps)
        {
            var result = await step();
            if (!result.Succeeded)
            {
                return ToError(result, passwordField: "senha");
            }
        }

        await transaction.CommitAsync(cancellationToken);
        return (await FindDetalheAsync(id, cancellationToken))!;
    }

    public async Task<Result> DeactivateAsync(Guid id, Guid executorId, CancellationToken cancellationToken = default)
    {
        if (id == executorId)
        {
            return AppError.BusinessRule("Você não pode desativar a sua própria conta.");
        }

        var usuario = await users.FindByIdAsync(id.ToString());
        if (usuario is null)
        {
            return NotFound();
        }

        if (!usuario.Ativo)
        {
            return Result.Success();
        }

        if (await users.IsInRoleAsync(usuario, Perfis.Admin) && !await HasOtherActiveAdminAsync(id, cancellationToken))
        {
            return AppError.BusinessRule("O sistema precisa de ao menos um Admin ativo.");
        }

        usuario.Ativo = false;
        var updated = await users.UpdateAsync(usuario);
        if (!updated.Succeeded)
        {
            return ToError(updated, passwordField: "senha");
        }

        await RevokeSessionsAsync(id, cancellationToken);
        return Result.Success();
    }

    public async Task<Result> ReactivateAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var usuario = await users.FindByIdAsync(id.ToString());
        if (usuario is null)
        {
            return NotFound();
        }

        if (usuario.Ativo)
        {
            return Result.Success();
        }

        usuario.Ativo = true;
        var updated = await users.UpdateAsync(usuario);
        return updated.Succeeded ? Result.Success() : ToError(updated, passwordField: "senha");
    }

    public async Task<Result> ResetPasswordAsync(Guid id, string? novaSenha, CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrEmpty(novaSenha))
        {
            return AppError.Validation("novaSenha", "Informe a nova senha.");
        }

        var usuario = await users.FindByIdAsync(id.ToString());
        if (usuario is null)
        {
            return NotFound();
        }

        // Valida antes de remover a senha atual, para o usuário nunca ficar sem senha.
        var policyErrors = new List<IdentityError>();
        foreach (var validator in users.PasswordValidators)
        {
            policyErrors.AddRange((await validator.ValidateAsync(users, usuario, novaSenha)).Errors);
        }

        if (policyErrors.Count > 0)
        {
            return ToError(IdentityResult.Failed([.. policyErrors]), passwordField: "novaSenha");
        }

        await using var transaction = await db.Database.BeginTransactionAsync(cancellationToken);
        var steps = new Func<Task<IdentityResult>>[]
        {
            () => users.RemovePasswordAsync(usuario),
            () => users.AddPasswordAsync(usuario, novaSenha),
            () => users.SetLockoutEndDateAsync(usuario, null),
            () => users.ResetAccessFailedCountAsync(usuario),
        };
        foreach (var step in steps)
        {
            var result = await step();
            if (!result.Succeeded)
            {
                return ToError(result, passwordField: "novaSenha");
            }
        }

        await transaction.CommitAsync(cancellationToken);
        await RevokeSessionsAsync(id, cancellationToken);
        return Result.Success();
    }

    private async Task<UsuarioDetalhe?> FindDetalheAsync(Guid id, CancellationToken cancellationToken)
    {
        var row = await db.Users.AsNoTracking()
            .Where(u => u.Id == id)
            .Select(u => new UsuarioRow(u.Id, u.Nome, u.Email!, u.Ativo, u.LockoutEnd, u.CriadoEm))
            .SingleOrDefaultAsync(cancellationToken);
        if (row is null)
        {
            return null;
        }

        var perfis = await LoadPerfisAsync([id], cancellationToken);
        return ToDetalhe(row, perfis, time.GetUtcNow());
    }

    private async Task<Dictionary<Guid, IReadOnlyList<string>>> LoadPerfisAsync(List<Guid> usuarioIds, CancellationToken cancellationToken)
    {
        var rows = await (
                from usuarioPerfil in db.UserRoles
                join perfil in db.Roles on usuarioPerfil.RoleId equals perfil.Id
                where usuarioIds.Contains(usuarioPerfil.UserId)
                select new { usuarioPerfil.UserId, perfil.Name })
            .ToListAsync(cancellationToken);

        return rows
            .GroupBy(r => r.UserId)
            .ToDictionary(g => g.Key, g => UsuarioValidation.NormalizePerfis(g.Select(r => r.Name!)));
    }

    private Task<bool> HasOtherActiveAdminAsync(Guid exceptId, CancellationToken cancellationToken)
    {
        var adminId = db.Roles.Where(r => r.Name == Perfis.Admin).Select(r => r.Id);
        return db.Users.AnyAsync(
            u => u.Id != exceptId && u.Ativo && db.UserRoles.Any(ur => ur.UserId == u.Id && adminId.Contains(ur.RoleId)),
            cancellationToken);
    }

    private Task<int> RevokeSessionsAsync(Guid usuarioId, CancellationToken cancellationToken)
    {
        var now = time.GetUtcNow();
        return db.RefreshTokens
            .Where(t => t.UsuarioId == usuarioId && t.RevokedAt == null)
            .ExecuteUpdateAsync(s => s.SetProperty(t => t.RevokedAt, now), cancellationToken);
    }

    private static UsuarioDetalhe ToDetalhe(UsuarioRow row, Dictionary<Guid, IReadOnlyList<string>> perfis, DateTimeOffset now) =>
        new(
            row.Id,
            row.Nome,
            row.Email,
            perfis.GetValueOrDefault(row.Id, []),
            row.Ativo,
            Bloqueado: row.LockoutEnd > now,
            row.CriadoEm);

    private static AppError NotFound() => AppError.NotFound("Usuário não encontrado.");

    private static AppError ToError(IdentityResult result, string passwordField)
    {
        var duplicate = result.Errors.FirstOrDefault(e => e.Code is "DuplicateEmail" or "DuplicateUserName");
        if (duplicate is not null)
        {
            return AppError.Conflict(duplicate.Description);
        }

        var fields = result.Errors
            .GroupBy(e => e.Code switch
            {
                _ when e.Code.StartsWith("Password", StringComparison.Ordinal) => passwordField,
                "InvalidEmail" or "InvalidUserName" => "email",
                _ => "usuario",
            })
            .ToDictionary(g => g.Key, g => g.Select(e => e.Description).ToArray());
        return AppError.Validation(fields);
    }

    private static string EscapeLike(string value) =>
        value.Replace(@"\", @"\\", StringComparison.Ordinal)
            .Replace("%", @"\%", StringComparison.Ordinal)
            .Replace("_", @"\_", StringComparison.Ordinal);

    private sealed record UsuarioRow(Guid Id, string Nome, string Email, bool Ativo, DateTimeOffset? LockoutEnd, DateTimeOffset CriadoEm);
}
