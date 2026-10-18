using Microsoft.Extensions.AI;
using Microsoft.Extensions.Logging.Abstractions;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Ia;

namespace Stowise.IntegrationTests.Ia;

/// <summary>JSON Schema por funcionalidade (ADR-0004, item 3): validação no código e recusa de resposta inválida.</summary>
public class SaidaEstruturadaTests
{
    private const string Schema = """
        {
          "type": "object",
          "additionalProperties": false,
          "required": ["campo", "coluna", "confianca"],
          "properties": {
            "campo": { "type": "string", "enum": ["sku", "descricao"] },
            "coluna": { "type": "integer", "minimum": 0 },
            "confianca": { "type": "number", "minimum": 0, "maximum": 1 }
          }
        }
        """;

    private const string Valida = """{"campo":"sku","coluna":0,"confianca":0.9}""";

    private static readonly ContratoSaidaIa<Sugestao> Contrato = ContratoSaidaIa<Sugestao>.Create("sugestao_teste", "teste-v1", Schema);

    private readonly RegistroEmMemoria _registro = new();

    [Fact]
    public void Answer_that_matches_the_schema_becomes_the_typed_value()
    {
        var saida = Contrato.Parse($"  {Valida}\n");

        Assert.True(saida.Valida);
        Assert.Equal(new Sugestao("sku", 0, 0.9), saida.Valor);
    }

    [Theory]
    [InlineData("", "empty answer")]
    [InlineData("Claro! Aqui está o JSON: {\"campo\":\"sku\"}", "not JSON")]
    [InlineData("```json\n{\"campo\":\"sku\",\"coluna\":0,\"confianca\":0.9}\n```", "not JSON")]
    [InlineData("""{"campo":"sku","coluna":0}""", "does not match schema teste-v1")]
    [InlineData("""{"campo":"gtin","coluna":0,"confianca":0.9}""", "does not match schema")]
    [InlineData("""{"campo":"sku","coluna":-1,"confianca":0.9}""", "does not match schema")]
    [InlineData("""{"campo":"sku","coluna":0,"confianca":0.9,"extra":true}""", "does not match schema")]
    public void Anything_else_is_refused_without_repair(string texto, string motivo)
    {
        var saida = Contrato.Parse(texto);

        Assert.False(saida.Valida);
        Assert.Null(saida.Valor);
        Assert.StartsWith(motivo, saida.Erro, StringComparison.Ordinal);
    }

    [Fact]
    public void Invalid_schema_fails_when_the_contract_is_created()
    {
        Assert.Throws<InvalidOperationException>(() => ContratoSaidaIa<Sugestao>.Create("x", "v1", "{ not json"));
    }

    [Fact]
    public async Task Native_mode_sends_the_schema_and_records_the_contract_version()
    {
        var principal = FakeChatClient.Responding(Valida);

        var resposta = await SendAsync(FakeProvedoresIa.With(principal));

        Assert.Equal(new Sugestao("sku", 0, 0.9), resposta.Valor);
        var (mensagens, opcoes) = principal.Recebidas.Single();
        var formato = Assert.IsType<ChatResponseFormatJson>(opcoes!.ResponseFormat);
        Assert.Equal(("sugestao_teste", "object"), (formato.SchemaName, formato.Schema!.Value.GetProperty("type").GetString()));
        Assert.Single(mensagens);
        Assert.Equal("teste-v1", Assert.Single(_registro.Chamadas).PromptVersao);
    }

    [Fact]
    public async Task Invalid_answer_goes_to_the_fallback_and_both_answers_count_in_the_cost()
    {
        var principal = FakeChatClient.Responding("""{"campo":"sku"}""", tokensEntrada: 1000, tokensSaida: 100);
        var reserva = FakeChatClient.Responding(Valida, tokensEntrada: 50, tokensSaida: 10);

        var resposta = await SendAsync(FakeProvedoresIa.With(principal, reserva));

        Assert.True(resposta.Sucesso);
        Assert.Single(principal.Recebidas);
        var chamada = Assert.Single(_registro.Chamadas);
        Assert.Equal(("reserva-1", 2, true, 1050, 110), (chamada.Provedor, chamada.Tentativas, chamada.UsouFallback, chamada.TokensEntrada, chamada.TokensSaida));
        Assert.Equal(0.006m, chamada.CustoEstimado);
    }

    [Fact]
    public async Task When_no_provider_answers_in_the_schema_there_is_no_suggestion()
    {
        var resposta = await SendAsync(FakeProvedoresIa.With(FakeChatClient.Responding("não sei"), FakeChatClient.Responding("{}")));

        Assert.False(resposta.Sucesso);
        Assert.Null(resposta.Valor);
        var chamada = Assert.Single(_registro.Chamadas);
        Assert.False(chamada.Sucesso);
        Assert.StartsWith("SaidaInvalida: does not match schema teste-v1", chamada.Erro, StringComparison.Ordinal);
    }

    [Theory]
    [InlineData(ModosJson.Json, true)]
    [InlineData(ModosJson.Prompt, false)]
    public async Task Providers_without_schema_support_get_the_schema_in_the_prompt(string modo, bool pedeJson)
    {
        var principal = FakeChatClient.Responding(Valida);
        var provedores = FakeProvedoresIa.With(principal);
        provedores.Cadeia!.Provedores[0].Opcoes.ModoJson = modo;

        var resposta = await SendAsync(provedores);

        Assert.True(resposta.Sucesso);
        var (mensagens, opcoes) = principal.Recebidas.Single();
        Assert.Equal(pedeJson, opcoes!.ResponseFormat is ChatResponseFormatJson { Schema: null });
        Assert.Equal(pedeJson, opcoes.ResponseFormat is not null);
        Assert.Equal(ChatRole.System, mensagens[0].Role);
        Assert.Contains("\"enum\": [\"sku\", \"descricao\"]", mensagens[0].Text, StringComparison.Ordinal);
        Assert.Equal(2, mensagens.Count);
    }

    private Task<RespostaIa<Sugestao>> SendAsync(FakeProvedoresIa provedores) =>
        new GatewayIa(provedores, _registro, FakeVerificadorCota.Livre, TimeProvider.System, NullLogger<GatewayIa>.Instance)
            .SendAsync(new PedidoIa(FuncionalidadeIa.Mapeamento, "ignorada", [new ChatMessage(ChatRole.User, "cabeçalho")], null), Contrato, CancellationToken.None);

    public sealed record Sugestao(string Campo, int Coluna, double Confianca);
}
