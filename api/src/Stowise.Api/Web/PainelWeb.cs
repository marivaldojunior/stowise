using Microsoft.Net.Http.Headers;

namespace Stowise.Api.Web;

/// <summary>
/// Serve o painel React (build em <c>wwwroot</c>) pela própria API, na mesma origem: o painel chama <c>/api</c> sem
/// CORS e o cookie de refresh continua restrito a <c>/api/v1/auth</c>. Sem <c>wwwroot/index.html</c> (desenvolvimento,
/// testes, docker compose só da API), nada muda.
/// </summary>
public static class PainelWeb
{
    /// <summary>Prefixos da API: nunca devolvem o painel, mesmo quando a rota não existe.</summary>
    private static readonly string[] RotasDaApi = ["/api", "/health", "/hubs", "/openapi", "/scalar", "/hangfire"];

    /// <summary>Arquivos com hash no nome (gerados pelo Vite em /assets): podem ficar em cache por um ano.</summary>
    private const string CacheImutavel = "public, max-age=31536000, immutable";

    public static bool TemPainel(this WebApplication app) =>
        app.Environment.WebRootFileProvider.GetFileInfo("index.html").Exists;

    /// <summary>Arquivos do painel, antes da autenticação: são públicos (o login acontece dentro do painel).</summary>
    public static WebApplication UsePainelWeb(this WebApplication app)
    {
        if (!app.TemPainel())
        {
            return app;
        }

        app.UseStaticFiles(new StaticFileOptions
        {
            OnPrepareResponse = contexto =>
            {
                var cache = contexto.Context.Request.Path.StartsWithSegments("/assets") ? CacheImutavel : "no-cache";
                contexto.Context.Response.Headers[HeaderNames.CacheControl] = cache;
            },
        });
        return app;
    }

    /// <summary>
    /// Rotas do painel (ex.: <c>/catalogo/123</c> ao recarregar a página) devolvem o <c>index.html</c>; o React Router
    /// resolve a rota no navegador. Rotas desconhecidas da API continuam 404.
    /// </summary>
    public static WebApplication MapPainelWeb(this WebApplication app)
    {
        if (!app.TemPainel())
        {
            return app;
        }

        var index = app.Environment.WebRootFileProvider.GetFileInfo("index.html");
        app.MapFallback(async contexto =>
        {
            var caminho = contexto.Request.Path;
            if (!HttpMethods.IsGet(contexto.Request.Method) || RotasDaApi.Any(r => caminho.StartsWithSegments(r)))
            {
                contexto.Response.StatusCode = StatusCodes.Status404NotFound;
                return;
            }

            contexto.Response.ContentType = "text/html; charset=utf-8";
            contexto.Response.Headers[HeaderNames.CacheControl] = "no-cache";
            await contexto.Response.SendFileAsync(index, contexto.RequestAborted);
        }).AllowAnonymous();
        return app;
    }
}
