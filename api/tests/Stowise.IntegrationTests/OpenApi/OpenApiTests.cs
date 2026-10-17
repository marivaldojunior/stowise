using System.Net;
using System.Net.Http.Headers;
using System.Text.Json;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.OpenApi;

public class OpenApiTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public async Task V1_document_is_public_and_describes_versioned_routes()
    {
        using var document = await GetDocumentAsync();
        var root = document.RootElement;

        Assert.Equal("Stowise API", root.GetProperty("info").GetProperty("title").GetString());
        Assert.Equal("1.0", root.GetProperty("info").GetProperty("version").GetString());

        var paths = root.GetProperty("paths").EnumerateObject().Select(p => p.Name).ToList();
        Assert.Contains("/api/v1/auth/login", paths);
        Assert.Contains("/api/v1/usuarios", paths);
        Assert.Contains("/api/v1/usuarios/{id}", paths);
        Assert.Contains("/api/v1/perfis", paths);
        Assert.DoesNotContain(paths, p => p.Contains("{version", StringComparison.Ordinal));
        Assert.DoesNotContain(paths, p => p.StartsWith("/health", StringComparison.Ordinal));
    }

    [Fact]
    public async Task Bearer_scheme_is_required_only_on_protected_operations()
    {
        using var document = await GetDocumentAsync();
        var root = document.RootElement;

        var scheme = root.GetProperty("components").GetProperty("securitySchemes").GetProperty("Bearer");
        Assert.Equal("http", scheme.GetProperty("type").GetString());
        Assert.Equal("bearer", scheme.GetProperty("scheme").GetString());

        var paths = root.GetProperty("paths");
        var login = paths.GetProperty("/api/v1/auth/login").GetProperty("post");
        Assert.False(login.TryGetProperty("security", out _), "Login é anônimo e não deve exigir Bearer.");

        var listarUsuarios = paths.GetProperty("/api/v1/usuarios").GetProperty("get");
        var requirement = Assert.Single(listarUsuarios.GetProperty("security").EnumerateArray());
        Assert.True(requirement.TryGetProperty("Bearer", out _));
    }

    [Fact]
    public async Task Every_operation_has_a_unique_operation_id_for_client_generation()
    {
        using var document = await GetDocumentAsync();

        var operations = document.RootElement.GetProperty("paths").EnumerateObject()
            .SelectMany(path => path.Value.EnumerateObject().Select(op => (Route: $"{op.Name.ToUpperInvariant()} {path.Name}", op.Value)))
            .ToList();

        var semId = operations.Where(op => !op.Value.TryGetProperty("operationId", out _)).Select(op => op.Route).ToList();
        Assert.True(semId.Count == 0, $"Operações sem operationId (use .WithName): {string.Join(", ", semId)}");

        var ids = operations.Select(op => op.Value.GetProperty("operationId").GetString()).ToList();
        Assert.Equal(ids.Count, ids.Distinct(StringComparer.Ordinal).Count());
    }

    [Fact]
    public async Task Scalar_reference_is_public()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/scalar", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.Equal("text/html", response.Content.Headers.ContentType?.MediaType);
    }

    [Fact]
    public async Task Responses_report_supported_api_versions()
    {
        using var client = AuthenticatedClient();

        var response = await client.GetAsync(new Uri("/api/v1/perfis", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.Equal("1.0", Assert.Single(response.Headers.GetValues("api-supported-versions")));
    }

    [Fact]
    public async Task Unknown_version_in_the_path_returns_404_problem_details()
    {
        using var client = AuthenticatedClient();

        var response = await client.GetAsync(new Uri("/api/v2/perfis", UriKind.Relative));

        // Com a versão no caminho, uma versão inexistente é um recurso inexistente.
        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
        Assert.Equal("application/problem+json", response.Content.Headers.ContentType?.MediaType);
    }

    [Fact]
    public void Enums_are_serialized_as_text()
    {
        var options = factory.Services.GetRequiredService<Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Http.Json.JsonOptions>>();

        var json = JsonSerializer.Serialize(Stowise.Domain.Estrutura.ClasseArmazenagem.Refrigerado, options.Value.SerializerOptions);

        Assert.Equal("\"Refrigerado\"", json);
    }

    private async Task<JsonDocument> GetDocumentAsync()
    {
        using var client = factory.CreateClient();
        var response = await client.GetAsync(new Uri("/openapi/v1.json", UriKind.Relative));
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        return await JsonDocument.ParseAsync(await response.Content.ReadAsStreamAsync());
    }

    private HttpClient AuthenticatedClient()
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(Perfis.Admin));
        return client;
    }
}
