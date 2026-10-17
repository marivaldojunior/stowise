using Microsoft.AspNetCore.Identity;

namespace Stowise.Infrastructure.Identity;

public sealed class Usuario : IdentityUser<Guid>
{
    public const int NomeMaxLength = 120;

    public Usuario()
    {
    }

    public Usuario(string email, string nome, DateTimeOffset criadoEm)
    {
        Id = Guid.CreateVersion7();
        UserName = email;
        Email = email;
        Nome = nome;
        Ativo = true;
        CriadoEm = criadoEm;
    }

    public string Nome { get; set; } = null!;

    public bool Ativo { get; set; }

    public DateTimeOffset CriadoEm { get; set; }
}
