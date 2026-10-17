namespace Stowise.Application.Auth;

/// <summary>Perfis de acesso. O nome do perfil também é o nome da política de autorização.</summary>
public static class Perfis
{
    public const string Admin = "Admin";
    public const string Gestor = "Gestor";
    public const string Operador = "Operador";

    public static IReadOnlyList<string> Todos { get; } = [Admin, Gestor, Operador];
}
