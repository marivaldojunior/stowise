using System.Net.Mail;
using Stowise.Application.Auth;

namespace Stowise.Application.Usuarios;

/// <summary>Validações de formato. Regras que dependem do banco (e-mail único, último Admin) ficam no serviço.</summary>
public static class UsuarioValidation
{
    public const int NomeMaxLength = 120;
    public const int EmailMaxLength = 256;

    public static IReadOnlyDictionary<string, string[]> Validate(CriarUsuario comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        ValidateNome(errors, comando.Nome);
        ValidateEmail(errors, comando.Email);
        if (string.IsNullOrEmpty(comando.Senha))
        {
            errors["senha"] = ["Informe a senha."];
        }

        ValidatePerfis(errors, comando.Perfis);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(AtualizarUsuario comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        ValidateNome(errors, comando.Nome);
        ValidatePerfis(errors, comando.Perfis);
        return errors;
    }

    /// <summary>Perfis sem repetição, na ordem da lista oficial.</summary>
    public static IReadOnlyList<string> NormalizePerfis(IEnumerable<string> perfis) =>
        [.. Perfis.Todos.Where(perfis.Contains)];

    private static void ValidateNome(Dictionary<string, string[]> errors, string? nome)
    {
        if (string.IsNullOrWhiteSpace(nome))
        {
            errors["nome"] = ["Informe o nome."];
        }
        else if (nome.Trim().Length > NomeMaxLength)
        {
            errors["nome"] = [$"O nome deve ter no máximo {NomeMaxLength} caracteres."];
        }
    }

    private static void ValidateEmail(Dictionary<string, string[]> errors, string? email)
    {
        var trimmed = email?.Trim();
        if (string.IsNullOrEmpty(trimmed))
        {
            errors["email"] = ["Informe o e-mail."];
        }
        else if (trimmed.Length > EmailMaxLength
            || !MailAddress.TryCreate(trimmed, out var address)
            || !string.Equals(address.Address, trimmed, StringComparison.Ordinal))
        {
            errors["email"] = ["Informe um e-mail válido."];
        }
    }

    private static void ValidatePerfis(Dictionary<string, string[]> errors, IReadOnlyList<string>? perfis)
    {
        if (perfis is null || perfis.Count == 0)
        {
            errors["perfis"] = ["Informe ao menos um perfil."];
            return;
        }

        var invalidos = perfis.Where(p => !Perfis.Todos.Contains(p)).Distinct().ToList();
        if (invalidos.Count > 0)
        {
            errors["perfis"] = [$"Perfil inválido: {string.Join(", ", invalidos)}. Use: {string.Join(", ", Perfis.Todos)}."];
        }
    }
}
