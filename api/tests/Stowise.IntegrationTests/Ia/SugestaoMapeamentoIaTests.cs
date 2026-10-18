using System.Text.Json;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.Logging.Abstractions;
using Stowise.Domain.Ia;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Ia;
using Stowise.Infrastructure.Importacoes;

namespace Stowise.IntegrationTests.Ia;

/// <summary>Sugestão de mapeamento pela IA, sem banco: o que vai no prompt, o schema e a leitura da resposta.</summary>
public class SugestaoMapeamentoIaTests
{
    internal const string RespostaValida = """
        {
          "colunas": [
            { "campo": "sku", "coluna": 0, "confianca": 0.98 },
            { "campo": "descricao", "coluna": 1, "confianca": 0.95 },
            { "campo": "unidadeBase", "coluna": 2, "confianca": 0.9 },
            { "campo": "controlaLote", "coluna": 3, "confianca": 0.7 },
            { "campo": "gtin", "coluna": 9, "confianca": 0.4 }
          ],
          "regras": {
            "separadorDecimal": ",",
            "unidades": [ { "origem": "Saco", "destino": "SC" } ],
            "valoresVerdadeiros": [ "Ativo" ],
            "valoresFalsos": [ "Inativo" ]
          },
          "observacao": "A coluna Lote usa Ativo e Inativo."
        }
        """;

    private static readonly Guid Usuario = Guid.NewGuid();

    [Fact]
    public void Prompt_has_only_the_header_the_sample_and_the_target_fields()
    {
        var prompt = SugestaoMapeamentoIa.BuildPrompt(NovaImportacao());

        Assert.Contains("- sku (obrigatório): Código interno do produto (único).", prompt, StringComparison.Ordinal);
        Assert.Contains("- gtin: Código de barras", prompt, StringComparison.Ordinal);
        Assert.Contains("2: Unidade", prompt, StringComparison.Ordinal);
        Assert.Contains("[\"A1\",\"Arroz 5kg\",\"Saco\",\"Ativo\"]", prompt, StringComparison.Ordinal);
        Assert.Contains("Separador decimal detectado pelo sistema: \",\"", prompt, StringComparison.Ordinal);
        Assert.DoesNotContain("B9", prompt, StringComparison.Ordinal);
    }

    [Fact]
    public void Schema_uses_only_keywords_every_structured_output_mode_accepts()
    {
        using var schema = JsonDocument.Parse(SugestaoMapeamentoIa.Contrato.SchemaJson);
        var palavras = new HashSet<string>(StringComparer.Ordinal);
        void Coletar(JsonElement e)
        {
            if (e.ValueKind == JsonValueKind.Object)
            {
                foreach (var p in e.EnumerateObject())
                {
                    palavras.Add(p.Name);
                    Coletar(p.Value);
                }
            }
        }

        Coletar(schema.RootElement);

        Assert.DoesNotContain(palavras, p => p is "minimum" or "maximum" or "minItems" or "maxItems" or "maxLength" or "pattern" or "format");
        Assert.Equal("mapeamento-v1", SugestaoMapeamentoIa.Contrato.Versao);
    }

    [Fact]
    public async Task Valid_answer_becomes_a_suggestion_with_confidence_and_rules()
    {
        var cliente = FakeChatClient.Responding(RespostaValida);
        var registro = new RegistroEmMemoria();
        var gateway = new GatewayIa(FakeProvedoresIa.With(cliente), registro, FakeVerificadorCota.Livre, TimeProvider.System, NullLogger<GatewayIa>.Instance);

        var resposta = await new SugestaoMapeamentoIa(gateway).SuggestAsync(NovaImportacao(), Usuario, CancellationToken.None);
        var sugestao = SugestaoMapeamentoIa.ToSugestao(resposta.Valor!, resposta.ChamadaId);

        Assert.True(resposta.Sucesso);
        Assert.Equal(["sku", "descricao", "unidadeBase", "controlaLote", "gtin"], sugestao.Colunas.Select(c => c.Campo));
        Assert.Equal(0.98m, sugestao.Colunas[0].Confianca);
        Assert.Equal(new UnidadeDePara("Saco", "SC"), Assert.Single(sugestao.Regras.Unidades));
        Assert.Equal("A coluna Lote usa Ativo e Inativo.", sugestao.Observacao);
        var chamada = Assert.Single(registro.Chamadas);
        Assert.Equal((FuncionalidadeIa.Mapeamento, "mapeamento-v1", (Guid?)Usuario), (chamada.Funcionalidade, chamada.PromptVersao, chamada.UsuarioId));
        var (mensagens, _) = cliente.Recebidas.Single();
        Assert.Equal([ChatRole.System, ChatRole.User], mensagens.Select(m => m.Role));
    }

    [Fact]
    public void Answer_with_a_field_outside_the_catalog_is_refused()
    {
        var saida = SugestaoMapeamentoIa.Contrato.Parse(RespostaValida.Replace("\"gtin\"", "\"fabricante\"", StringComparison.Ordinal));

        Assert.False(saida.Valida);
    }

    internal static Importacao NovaImportacao() =>
        Importacao.Create(
            TipoImportacao.Produtos,
            "produtos.csv",
            new string('a', Importacao.HashArquivoLength),
            10,
            new LayoutArquivo(FormatoArquivo.Delimitado, "utf-8", ";", ",", true, [new(0, "SKU"), new(1, "Descrição"), new(2, "Unidade"), new(3, "Lote")]),
            [["A1", "Arroz 5kg", "Saco", "Ativo"]],
            2,
            Usuario,
            DateTimeOffset.UtcNow);
}
