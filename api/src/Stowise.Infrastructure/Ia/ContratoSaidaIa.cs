using System.Text.Json;
using NJsonSchema;

namespace Stowise.Infrastructure.Ia;

/// <summary>Resultado da leitura de uma resposta: o valor tipado ou o motivo da recusa.</summary>
internal sealed record SaidaIa<T>(T? Valor, string? Erro)
    where T : class
{
    public bool Valida => Erro is null;
}

/// <summary>Como pedir JSON a um provedor (<see cref="ProvedorIaOptions.ModoJson"/>).</summary>
public static class ModosJson
{
    /// <summary>Saída estruturada nativa, com o schema (Anthropic, OpenAI, Gemini, Ollama).</summary>
    public const string JsonSchema = "JsonSchema";

    /// <summary>Só "responda em JSON", com o schema no prompt (provedores sem suporte a schema).</summary>
    public const string Json = "Json";

    /// <summary>Nenhum recurso do provedor: o schema vai só no prompt.</summary>
    public const string Prompt = "Prompt";
}

/// <summary>
/// Contrato de saída de uma funcionalidade de IA (ADR-0004, item 3): o JSON Schema versionado junto do prompt e o
/// tipo que a funcionalidade recebe. A resposta é validada contra o schema no código, para o resultado não depender
/// do suporte de cada provedor. Resposta inválida é recusada: nada é corrigido "no melhor esforço".
/// </summary>
internal sealed class ContratoSaidaIa<T>
    where T : class
{
    private const int ErrosNaMensagem = 5;

    private static readonly JsonSerializerOptions Leitura = new(JsonSerializerDefaults.Web);

    private readonly JsonSchema _schema;

    private ContratoSaidaIa(string nome, string versao, string schemaJson, JsonSchema schema)
    {
        Nome = nome;
        Versao = versao;
        SchemaJson = schemaJson;
        Schema = JsonDocument.Parse(schemaJson).RootElement.Clone();
        _schema = schema;
    }

    /// <summary>Nome do schema enviado ao provedor (letras, números e sublinhado).</summary>
    public string Nome { get; }

    /// <summary>Versão do prompt e do schema, gravada em <c>ChamadaIa.PromptVersao</c>.</summary>
    public string Versao { get; }

    public string SchemaJson { get; }

    public JsonElement Schema { get; }

    /// <summary>Lê e valida o schema uma vez, na criação do contrato. Schema inválido é erro de programação.</summary>
    public static ContratoSaidaIa<T> Create(string nome, string versao, string schemaJson)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(nome);
        ArgumentException.ThrowIfNullOrWhiteSpace(versao);
        ArgumentException.ThrowIfNullOrWhiteSpace(schemaJson);

        try
        {
            var schema = JsonSchema.FromJsonAsync(schemaJson).GetAwaiter().GetResult();
            return new ContratoSaidaIa<T>(nome, versao, schemaJson, schema);
        }
        catch (Exception e) when (e is Newtonsoft.Json.JsonException or JsonException or InvalidOperationException)
        {
            throw new InvalidOperationException($"The output schema '{nome}' ({versao}) is not valid JSON Schema.", e);
        }
    }

    /// <summary>
    /// A resposta inteira tem de ser um JSON válido pelo schema: texto antes ou depois, bloco de código em Markdown
    /// ou campo a mais são recusados, e a mensagem diz o primeiro motivo.
    /// </summary>
    public SaidaIa<T> Parse(string? texto)
    {
        var json = texto?.Trim();
        if (string.IsNullOrEmpty(json))
        {
            return new SaidaIa<T>(null, "empty answer");
        }

        try
        {
            using var _ = JsonDocument.Parse(json);
        }
        catch (JsonException e)
        {
            return new SaidaIa<T>(null, $"not JSON ({e.Message})");
        }

        var erros = _schema.Validate(json);
        if (erros.Count > 0)
        {
            var descricao = string.Join("; ", erros.Take(ErrosNaMensagem).Select(e => $"{(string.IsNullOrEmpty(e.Path) ? "#" : e.Path)}: {e.Kind}"));
            return new SaidaIa<T>(null, $"does not match schema {Versao}: {descricao}");
        }

        try
        {
            var valor = JsonSerializer.Deserialize<T>(json, Leitura);
            return valor is null ? new SaidaIa<T>(null, "null answer") : new SaidaIa<T>(valor, null);
        }
        catch (JsonException e)
        {
            return new SaidaIa<T>(null, $"does not match type {typeof(T).Name} ({e.Message})");
        }
    }

    /// <summary>Instrução para os modos sem saída estruturada nativa: o schema vai no prompt, como mensagem de sistema.</summary>
    public string InstrucaoNoPrompt() =>
        "Responda somente com um objeto JSON válido, sem texto antes ou depois e sem bloco de código, " +
        $"seguindo exatamente este JSON Schema:\n{SchemaJson}";
}
