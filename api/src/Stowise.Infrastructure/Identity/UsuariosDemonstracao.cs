using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Stowise.Application.Auth;

namespace Stowise.Infrastructure.Identity;

/// <summary>
/// Contas da demonstração pública: um Gestor e um Operador, com a mesma senha. Sem senha configurada, não faz nada.
/// O Admin não entra aqui: com ele, um visitante poderia trocar senhas ou desativar os outros usuários.
/// </summary>
public sealed class DemonstracaoOptions
{
    public const string SectionName = "Demonstracao";

    public string? Senha { get; set; }
}

internal sealed partial class UsuariosDemonstracao(
    UserManager<Usuario> users,
    IOptions<DemonstracaoOptions> options,
    TimeProvider time,
    ILogger<UsuariosDemonstracao> logger)
{
    public static readonly IReadOnlyList<(string Email, string Nome, string Perfil)> Contas =
    [
        ("gestor@demo.stowise.dev", "Gestor de demonstração", Perfis.Gestor),
        ("operador@demo.stowise.dev", "Operador de demonstração", Perfis.Operador),
    ];

    /// <returns>Quantas contas foram criadas.</returns>
    public async Task<int> EnsureAsync()
    {
        var senha = options.Value.Senha;
        if (string.IsNullOrWhiteSpace(senha))
        {
            return 0;
        }

        var criadas = 0;
        foreach (var (email, nome, perfil) in Contas)
        {
            if (await users.FindByEmailAsync(email) is not null)
            {
                continue;
            }

            var usuario = new Usuario(email, nome, time.GetUtcNow());
            var criada = await users.CreateAsync(usuario, senha);
            if (!criada.Succeeded)
            {
                throw new InvalidOperationException(
                    $"Could not create demo user {email}: {string.Join("; ", criada.Errors.Select(e => e.Description))}");
            }

            // Sem bloqueio por senha errada: na demonstração pública, qualquer visitante poderia bloquear a conta.
            // O CreateAsync liga o bloqueio pela configuração (AllowedForNewUsers); por isso, desliga depois de criar.
            await users.SetLockoutEnabledAsync(usuario, false);

            await users.AddToRoleAsync(usuario, perfil);
            criadas++;
        }

        if (criadas > 0)
        {
            LogDemoUsersCreated(logger, criadas);
        }

        return criadas;
    }

    [LoggerMessage(Level = LogLevel.Information, Message = "Demo users created: {Count}")]
    private static partial void LogDemoUsersCreated(ILogger logger, int count);
}
