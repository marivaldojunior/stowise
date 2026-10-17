using System.Security.Claims;
using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Usuarios;

namespace Stowise.Api.Endpoints;

public static class UsuariosEndpoints
{
    private const string ObterUsuarioRoute = "ObterUsuario";

    public static IEndpointRouteBuilder MapUsuariosEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/v1/usuarios")
            .WithTags("Usuários")
            .RequireAuthorization(Perfis.Admin)
            .ProducesProblem(StatusCodes.Status401Unauthorized)
            .ProducesProblem(StatusCodes.Status403Forbidden);

        group.MapGet("/", ListAsync).WithName("ListarUsuarios");

        group.MapGet("/{id:guid}", GetAsync)
            .WithName(ObterUsuarioRoute)
            .Produces<UsuarioDetalhe>()
            .ProducesProblem(StatusCodes.Status404NotFound);

        group.MapPost("/", CreateAsync)
            .WithName("CriarUsuario")
            .Produces<UsuarioDetalhe>(StatusCodes.Status201Created)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status409Conflict);

        group.MapPut("/{id:guid}", UpdateAsync)
            .WithName("AtualizarUsuario")
            .Produces<UsuarioDetalhe>()
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPost("/{id:guid}/desativar", DeactivateAsync)
            .WithName("DesativarUsuario")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound)
            .ProducesProblem(StatusCodes.Status422UnprocessableEntity);

        group.MapPost("/{id:guid}/reativar", ReactivateAsync)
            .WithName("ReativarUsuario")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesProblem(StatusCodes.Status404NotFound);

        group.MapPost("/{id:guid}/senha", ResetPasswordAsync)
            .WithName("RedefinirSenhaUsuario")
            .Produces(StatusCodes.Status204NoContent)
            .ProducesValidationProblem()
            .ProducesProblem(StatusCodes.Status404NotFound);

        app.MapGet("/api/v1/perfis", () => TypedResults.Ok(Perfis.Todos))
            .WithName("ListarPerfis")
            .WithTags("Usuários")
            .RequireAuthorization(Perfis.Admin);

        return app;
    }

    private static async Task<IResult> ListAsync(
        IUsuarioService usuarios,
        string? busca,
        string? perfil,
        bool? ativo,
        int? pagina,
        int? tamanhoPagina,
        CancellationToken ct)
    {
        var page = await usuarios.ListAsync(new UsuarioFiltro(busca, perfil, ativo, pagina, tamanhoPagina), ct);
        return TypedResults.Ok(page);
    }

    private static async Task<IResult> GetAsync(Guid id, IUsuarioService usuarios, CancellationToken ct) =>
        (await usuarios.GetAsync(id, ct)).ToHttpResult(TypedResults.Ok);

    private static async Task<IResult> CreateAsync(CriarUsuarioRequest request, IUsuarioService usuarios, CancellationToken ct)
    {
        var result = await usuarios.CreateAsync(new CriarUsuario(request.Nome, request.Email, request.Senha, request.Perfis), ct);
        return result.ToHttpResult(u => TypedResults.CreatedAtRoute(u, ObterUsuarioRoute, new { id = u.Id }));
    }

    private static async Task<IResult> UpdateAsync(
        Guid id,
        AtualizarUsuarioRequest request,
        IUsuarioService usuarios,
        ClaimsPrincipal user,
        CancellationToken ct)
    {
        var result = await usuarios.UpdateAsync(id, new AtualizarUsuario(request.Nome, request.Perfis), user.GetUsuarioId(), ct);
        return result.ToHttpResult(TypedResults.Ok);
    }

    private static async Task<IResult> DeactivateAsync(Guid id, IUsuarioService usuarios, ClaimsPrincipal user, CancellationToken ct) =>
        (await usuarios.DeactivateAsync(id, user.GetUsuarioId(), ct)).ToNoContent();

    private static async Task<IResult> ReactivateAsync(Guid id, IUsuarioService usuarios, CancellationToken ct) =>
        (await usuarios.ReactivateAsync(id, ct)).ToNoContent();

    private static async Task<IResult> ResetPasswordAsync(Guid id, RedefinirSenhaRequest request, IUsuarioService usuarios, CancellationToken ct) =>
        (await usuarios.ResetPasswordAsync(id, request.NovaSenha, ct)).ToNoContent();
}

public sealed record CriarUsuarioRequest(string? Nome, string? Email, string? Senha, IReadOnlyList<string>? Perfis);

public sealed record AtualizarUsuarioRequest(string? Nome, IReadOnlyList<string>? Perfis);

public sealed record RedefinirSenhaRequest(string? NovaSenha);
