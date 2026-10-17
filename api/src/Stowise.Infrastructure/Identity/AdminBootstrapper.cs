using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Stowise.Application.Auth;

namespace Stowise.Infrastructure.Identity;

internal sealed partial class AdminBootstrapper(
    UserManager<Usuario> users,
    IOptions<AdminBootstrapOptions> options,
    TimeProvider time,
    ILogger<AdminBootstrapper> logger)
{
    /// <returns><c>true</c> se um Admin foi criado.</returns>
    public async Task<bool> EnsureAdminAsync()
    {
        var config = options.Value;
        if (string.IsNullOrWhiteSpace(config.Email) || string.IsNullOrWhiteSpace(config.Password))
        {
            return false;
        }

        if ((await users.GetUsersInRoleAsync(Perfis.Admin)).Count > 0)
        {
            return false;
        }

        var admin = new Usuario(config.Email, config.Nome, time.GetUtcNow());
        var created = await users.CreateAsync(admin, config.Password);
        if (!created.Succeeded)
        {
            throw new InvalidOperationException(
                $"Could not create bootstrap admin: {string.Join("; ", created.Errors.Select(e => e.Description))}");
        }

        await users.AddToRoleAsync(admin, Perfis.Admin);
        LogAdminCreated(logger, admin.Id);
        return true;
    }

    [LoggerMessage(Level = LogLevel.Information, Message = "Bootstrap admin {UsuarioId} created")]
    private static partial void LogAdminCreated(ILogger logger, Guid usuarioId);
}
