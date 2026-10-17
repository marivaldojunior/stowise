using Microsoft.AspNetCore.Identity;
using Stowise.Application.Auth;

namespace Stowise.Infrastructure.Identity;

public sealed class Perfil : IdentityRole<Guid>
{
    /// <summary>Perfis fixos, criados pela migration. Ids e stamps estáveis para o HasData.</summary>
    internal static IReadOnlyList<Perfil> Padrao { get; } =
    [
        Create(new Guid("0199f2a0-0000-7000-8000-000000000001"), Perfis.Admin),
        Create(new Guid("0199f2a0-0000-7000-8000-000000000002"), Perfis.Gestor),
        Create(new Guid("0199f2a0-0000-7000-8000-000000000003"), Perfis.Operador),
    ];

    private static Perfil Create(Guid id, string nome) => new()
    {
        Id = id,
        Name = nome,
        NormalizedName = nome.ToUpperInvariant(),
        ConcurrencyStamp = id.ToString(),
    };
}
