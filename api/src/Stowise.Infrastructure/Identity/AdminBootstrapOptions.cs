namespace Stowise.Infrastructure.Identity;

/// <summary>Cria o primeiro Admin quando nenhum existe. Sem e-mail ou senha, não faz nada.</summary>
public sealed class AdminBootstrapOptions
{
    public const string SectionName = "AdminBootstrap";

    public string? Email { get; set; }

    public string? Password { get; set; }

    public string Nome { get; set; } = "Administrador";
}
