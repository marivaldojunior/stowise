using Stowise.Application.Auth;
using Stowise.Application.Usuarios;

namespace Stowise.UnitTests.Usuarios;

public class UsuarioValidationTests
{
    private static CriarUsuario Valid() => new("Ana Souza", "ana@stowise.dev", "Senha-forte-1", [Perfis.Gestor]);

    [Fact]
    public void Valid_create_command_has_no_errors()
    {
        Assert.Empty(UsuarioValidation.Validate(Valid()));
    }

    [Fact]
    public void Create_requires_nome_email_senha_and_perfis()
    {
        var errors = UsuarioValidation.Validate(new CriarUsuario(" ", null, "", []));

        Assert.Equal(["email", "nome", "perfis", "senha"], errors.Keys.Order());
    }

    [Theory]
    [InlineData("sem-arroba")]
    [InlineData("Ana <ana@stowise.dev>")]
    [InlineData("ana@")]
    public void Create_rejects_invalid_email(string email)
    {
        var errors = UsuarioValidation.Validate(Valid() with { Email = email });

        Assert.Equal(["email"], errors.Keys);
    }

    [Fact]
    public void Create_rejects_nome_longer_than_limit()
    {
        var errors = UsuarioValidation.Validate(Valid() with { Nome = new string('a', UsuarioValidation.NomeMaxLength + 1) });

        Assert.Equal(["nome"], errors.Keys);
    }

    [Fact]
    public void Create_rejects_unknown_perfil_and_names_it()
    {
        var errors = UsuarioValidation.Validate(Valid() with { Perfis = [Perfis.Admin, "SuperUsuario"] });

        var message = Assert.Single(errors["perfis"]);
        Assert.Contains("SuperUsuario", message, StringComparison.Ordinal);
    }

    [Fact]
    public void Update_requires_nome_and_perfis()
    {
        var errors = UsuarioValidation.Validate(new AtualizarUsuario(null, null));

        Assert.Equal(["nome", "perfis"], errors.Keys.Order());
    }

    [Fact]
    public void NormalizePerfis_removes_duplicates_and_follows_official_order()
    {
        var perfis = UsuarioValidation.NormalizePerfis([Perfis.Operador, Perfis.Admin, Perfis.Operador]);

        Assert.Equal([Perfis.Admin, Perfis.Operador], perfis);
    }
}
