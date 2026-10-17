namespace Stowise.Application.Auth;

/// <summary>Políticas que combinam perfis. Políticas de um perfil só usam o nome do perfil (<see cref="Perfis"/>).</summary>
public static class Politicas
{
    /// <summary>Cadastros e configurações: Admin ou Gestor.</summary>
    public const string Gestao = "Gestao";

    public static IReadOnlyList<string> PerfisDeGestao { get; } = [Perfis.Admin, Perfis.Gestor];
}
