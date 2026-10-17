using System.Net;
using System.Text.Encodings.Web;
using System.Text.Json;
using System.Text.Json.Nodes;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.OpenApi;

/// <summary>
/// O contrato versionado em <c>api/openapi/v1.json</c> precisa ser igual ao gerado pela API.
/// Uma mudança no contrato é intencional e aparece no diff do commit; os clientes são gerados a partir do arquivo.
/// </summary>
public class OpenApiContractTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    public const string UpdateVariable = "STOWISE_UPDATE_CONTRACT";

    private static readonly JsonSerializerOptions ContractFormat = new()
    {
        WriteIndented = true,
        IndentSize = 2,
        NewLine = "\n",
        Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping,
    };

    [Fact]
    public async Task Committed_v1_contract_matches_the_generated_document()
    {
        var generated = await GenerateAsync("v1");
        var path = Path.Combine(FindApiDirectory(), "openapi", "v1.json");

        if (string.Equals(Environment.GetEnvironmentVariable(UpdateVariable), "true", StringComparison.OrdinalIgnoreCase))
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path)!);
            await File.WriteAllTextAsync(path, generated);
            return;
        }

        Assert.True(File.Exists(path), $"Contrato ausente em {path}. {UpdateHint}");
        var committed = (await File.ReadAllTextAsync(path)).ReplaceLineEndings("\n");

        if (!string.Equals(committed, generated, StringComparison.Ordinal))
        {
            Assert.Fail($"O contrato OpenAPI mudou. {FirstDifference(committed, generated)}\n{UpdateHint}");
        }
    }

    private const string UpdateHint =
        "Se a mudança é intencional, atualize o arquivo e inclua-o no commit (em api/): "
        + "PowerShell: $env:" + UpdateVariable + "='true'; dotnet test --filter OpenApiContract; Remove-Item Env:" + UpdateVariable
        + " | bash: " + UpdateVariable + "=true dotnet test --filter OpenApiContract";

    private async Task<string> GenerateAsync(string documentName)
    {
        using var client = factory.CreateClient();
        var response = await client.GetAsync(new Uri($"/openapi/{documentName}.json", UriKind.Relative));
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        var node = JsonNode.Parse(await response.Content.ReadAsStringAsync());
        return node!.ToJsonString(ContractFormat) + "\n";
    }

    private static string FirstDifference(string committed, string generated)
    {
        var expected = committed.Split('\n');
        var actual = generated.Split('\n');
        for (var i = 0; i < Math.Max(expected.Length, actual.Length); i++)
        {
            var e = i < expected.Length ? expected[i] : "<fim do arquivo>";
            var a = i < actual.Length ? actual[i] : "<fim do arquivo>";
            if (!string.Equals(e, a, StringComparison.Ordinal))
            {
                return $"Primeira diferença na linha {i + 1}:\n  arquivo: {e.Trim()}\n  gerado:  {a.Trim()}";
            }
        }

        return string.Empty;
    }

    /// <summary>A pasta <c>api/</c> é a que contém <c>Stowise.slnx</c>.</summary>
    private static string FindApiDirectory()
    {
        for (var dir = new DirectoryInfo(AppContext.BaseDirectory); dir is not null; dir = dir.Parent)
        {
            if (File.Exists(Path.Combine(dir.FullName, "Stowise.slnx")))
            {
                return dir.FullName;
            }
        }

        throw new InvalidOperationException("Stowise.slnx not found above the test output directory.");
    }
}
