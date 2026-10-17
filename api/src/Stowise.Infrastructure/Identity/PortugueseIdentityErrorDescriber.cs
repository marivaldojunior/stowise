using Microsoft.AspNetCore.Identity;

namespace Stowise.Infrastructure.Identity;

/// <summary>Mensagens do Identity em português, porque elas chegam ao usuário nas respostas de validação.</summary>
internal sealed class PortugueseIdentityErrorDescriber : IdentityErrorDescriber
{
    public override IdentityError DefaultError() => Error(nameof(DefaultError), "Ocorreu um erro desconhecido.");

    public override IdentityError DuplicateEmail(string email) =>
        Error(nameof(DuplicateEmail), $"Já existe um usuário com o e-mail {email}.");

    public override IdentityError DuplicateUserName(string userName) =>
        Error(nameof(DuplicateUserName), $"Já existe um usuário com o e-mail {userName}.");

    public override IdentityError InvalidEmail(string? email) => Error(nameof(InvalidEmail), "Informe um e-mail válido.");

    public override IdentityError InvalidUserName(string? userName) =>
        Error(nameof(InvalidUserName), "O e-mail contém caracteres não permitidos.");

    public override IdentityError PasswordMismatch() => Error(nameof(PasswordMismatch), "Senha incorreta.");

    public override IdentityError PasswordTooShort(int length) =>
        Error(nameof(PasswordTooShort), $"A senha deve ter ao menos {length} caracteres.");

    public override IdentityError PasswordRequiresUniqueChars(int uniqueChars) =>
        Error(nameof(PasswordRequiresUniqueChars), $"A senha deve ter ao menos {uniqueChars} caracteres diferentes.");

    public override IdentityError PasswordRequiresNonAlphanumeric() =>
        Error(nameof(PasswordRequiresNonAlphanumeric), "A senha deve ter ao menos um caractere especial.");

    public override IdentityError PasswordRequiresDigit() =>
        Error(nameof(PasswordRequiresDigit), "A senha deve ter ao menos um número.");

    public override IdentityError PasswordRequiresLower() =>
        Error(nameof(PasswordRequiresLower), "A senha deve ter ao menos uma letra minúscula.");

    public override IdentityError PasswordRequiresUpper() =>
        Error(nameof(PasswordRequiresUpper), "A senha deve ter ao menos uma letra maiúscula.");

    private static IdentityError Error(string code, string description) => new() { Code = code, Description = description };
}
