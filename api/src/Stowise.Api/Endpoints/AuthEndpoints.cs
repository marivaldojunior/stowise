using System.Security.Claims;
using Microsoft.AspNetCore.Http.HttpResults;
using Stowise.Application.Auth;

namespace Stowise.Api.Endpoints;

public static class AuthEndpoints
{
    public const string RoutePrefix = "/api/v1/auth";
    public const string RefreshCookieName = "stowise_refresh";

    public static IEndpointRouteBuilder MapAuthEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup(RoutePrefix).WithTags("Autenticação");

        group.MapPost("/login", LoginAsync).AllowAnonymous();
        group.MapPost("/refresh", RefreshAsync).AllowAnonymous();
        group.MapPost("/logout", LogoutAsync).AllowAnonymous();
        group.MapGet("/me", MeAsync);

        return app;
    }

    private static async Task<Results<Ok<AuthResponse>, ValidationProblem, ProblemHttpResult>> LoginAsync(LoginRequest request, IAuthService auth, HttpContext http, CancellationToken ct)
    {
        var errors = new Dictionary<string, string[]>();
        if (string.IsNullOrWhiteSpace(request.Email))
        {
            errors["email"] = ["Informe o e-mail."];
        }

        if (string.IsNullOrEmpty(request.Senha))
        {
            errors["senha"] = ["Informe a senha."];
        }

        if (errors.Count > 0)
        {
            return TypedResults.ValidationProblem(errors);
        }

        var session = await auth.LoginAsync(request.Email!.Trim(), request.Senha!, ct);
        if (session is null)
        {
            return Unauthorized("Credenciais inválidas", "E-mail ou senha incorretos, ou usuário bloqueado.");
        }

        return Session(session, request.UseCookie, http);
    }

    private static async Task<Results<Ok<AuthResponse>, ProblemHttpResult>> RefreshAsync(RefreshRequest? request, IAuthService auth, HttpContext http, CancellationToken ct)
    {
        var useCookie = request?.UseCookie ?? false;
        var refreshToken = request?.RefreshToken ?? http.Request.Cookies[RefreshCookieName];
        if (string.IsNullOrEmpty(refreshToken))
        {
            return Unauthorized("Sessão inválida", "Refresh token não informado.");
        }

        var session = await auth.RefreshAsync(refreshToken, ct);
        if (session is null)
        {
            http.Response.Cookies.Delete(RefreshCookieName, CookieOptions(expires: null));
            return Unauthorized("Sessão inválida", "A sessão expirou ou foi encerrada. Entre novamente.");
        }

        return Session(session, useCookie, http);
    }

    private static async Task<NoContent> LogoutAsync(RefreshRequest? request, IAuthService auth, HttpContext http, CancellationToken ct)
    {
        var refreshToken = request?.RefreshToken ?? http.Request.Cookies[RefreshCookieName];
        if (!string.IsNullOrEmpty(refreshToken))
        {
            await auth.LogoutAsync(refreshToken, ct);
        }

        http.Response.Cookies.Delete(RefreshCookieName, CookieOptions(expires: null));
        return TypedResults.NoContent();
    }

    private static async Task<Results<Ok<UsuarioResumo>, UnauthorizedHttpResult>> MeAsync(ClaimsPrincipal user, IAuthService auth, CancellationToken ct)
    {
        if (!Guid.TryParse(user.FindFirstValue("sub"), out var usuarioId))
        {
            return TypedResults.Unauthorized();
        }

        var usuario = await auth.GetUsuarioAsync(usuarioId, ct);
        if (usuario is null)
        {
            return TypedResults.Unauthorized();
        }

        return TypedResults.Ok(usuario);
    }

    private static Ok<AuthResponse> Session(AuthSession session, bool useCookie, HttpContext http)
    {
        if (useCookie)
        {
            http.Response.Cookies.Append(RefreshCookieName, session.RefreshToken, CookieOptions(session.RefreshTokenExpiresAt));
        }

        return TypedResults.Ok(new AuthResponse(
            session.AccessToken,
            session.AccessTokenExpiresAt,
            useCookie ? null : session.RefreshToken,
            session.RefreshTokenExpiresAt,
            session.Usuario));
    }

    private static CookieOptions CookieOptions(DateTimeOffset? expires) => new()
    {
        HttpOnly = true,
        Secure = true,
        SameSite = SameSiteMode.Strict,
        Path = RoutePrefix,
        Expires = expires,
    };

    private static ProblemHttpResult Unauthorized(string title, string detail) =>
        TypedResults.Problem(title: title, detail: detail, statusCode: StatusCodes.Status401Unauthorized);
}

/// <param name="UseCookie">Painel web: o refresh token vai em cookie HttpOnly, e não no corpo (ADR-0005).</param>
public sealed record LoginRequest(string? Email, string? Senha, bool UseCookie = false);

/// <param name="RefreshToken">Obrigatório no app. No painel web, vem do cookie.</param>
public sealed record RefreshRequest(string? RefreshToken, bool UseCookie = false);

/// <param name="RefreshToken">Nulo quando o refresh token foi enviado em cookie.</param>
public sealed record AuthResponse(
    string AccessToken,
    DateTimeOffset AccessTokenExpiresAt,
    string? RefreshToken,
    DateTimeOffset RefreshTokenExpiresAt,
    UsuarioResumo Usuario);
