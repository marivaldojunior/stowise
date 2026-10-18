using System.Net;
using System.Net.Http.Headers;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;
using Stowise.Application.Auth;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Ia;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Ia;

/// <summary>Configuração dos provedores sem banco: tipos, cadeias por funcionalidade, custo e autorização.</summary>
public class IaLayerTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    private static readonly IFabricaProvedorIa[] Fabricas = [new AnthropicFabrica(), new OpenAICompativelFabrica(), new GeminiFabrica(), new OllamaFabrica()];

    [Fact]
    public void Disabled_ai_has_no_chain()
    {
        using var provedores = Create(Config(("Ia:Habilitada", "false")));

        Assert.Null(provedores.Para(FuncionalidadeIa.Mapeamento));
    }

    [Fact]
    public void Every_supported_type_is_built_from_configuration_without_calling_the_provider()
    {
        using var provedores = Create(Config(
            ("Ia:Habilitada", "true"),
            ("Ia:Provedores:0:Nome", "anthropic"), ("Ia:Provedores:0:Tipo", "Anthropic"), ("Ia:Provedores:0:Modelo", "claude-opus-5-5"), ("Ia:Provedores:0:ApiKey", "test-key"),
            ("Ia:Provedores:1:Nome", "deepseek"), ("Ia:Provedores:1:Tipo", "OpenAICompativel"), ("Ia:Provedores:1:Modelo", "deepseek-chat"),
            ("Ia:Provedores:1:Endpoint", "https://api.deepseek.com/v1"), ("Ia:Provedores:1:ApiKey", "test-key"),
            ("Ia:Provedores:2:Nome", "gemini"), ("Ia:Provedores:2:Tipo", "gemini"), ("Ia:Provedores:2:Modelo", "gemini-2.5-flash"), ("Ia:Provedores:2:ApiKey", "test-key"),
            ("Ia:Provedores:3:Nome", "ollama-local"), ("Ia:Provedores:3:Tipo", "Ollama"), ("Ia:Provedores:3:Modelo", "qwen3"), ("Ia:Provedores:3:Endpoint", "http://127.0.0.1:1")));

        var cadeia = provedores.Para(FuncionalidadeIa.Consulta)!;

        Assert.Equal(["anthropic", "deepseek", "gemini", "ollama-local"], cadeia.Provedores.Select(p => p.Nome));
        Assert.Equal("deepseek-chat", cadeia.Provedores[1].Opcoes.Modelo);
        Assert.Equal((TimeSpan.FromSeconds(60), 3), (cadeia.Timeout, cadeia.TentativasPorProvedor));
    }

    [Fact]
    public void A_feature_can_use_its_own_providers_order_and_limits()
    {
        using var provedores = Create(Config(
            ("Ia:Habilitada", "true"),
            ("Ia:Provedores:0:Nome", "opus"), ("Ia:Provedores:0:Tipo", "Anthropic"), ("Ia:Provedores:0:Modelo", "claude-opus-5-5"), ("Ia:Provedores:0:ApiKey", "k"),
            ("Ia:Provedores:1:Nome", "haiku"), ("Ia:Provedores:1:Tipo", "Anthropic"), ("Ia:Provedores:1:Modelo", "claude-haiku-5-5"), ("Ia:Provedores:1:ApiKey", "k"),
            ("Ia:Funcionalidades:mapeamento:Provedores:0", "haiku"),
            ("Ia:Funcionalidades:mapeamento:TimeoutSegundos", "15"),
            ("Ia:Funcionalidades:mapeamento:TentativasPorProvedor", "1")));

        var mapeamento = provedores.Para(FuncionalidadeIa.Mapeamento)!;
        var consulta = provedores.Para(FuncionalidadeIa.Consulta)!;

        Assert.Equal(("haiku", TimeSpan.FromSeconds(15), 1), (Assert.Single(mapeamento.Provedores).Nome, mapeamento.Timeout, mapeamento.TentativasPorProvedor));
        Assert.Equal(["opus", "haiku"], consulta.Provedores.Select(p => p.Nome));
    }

    [Theory]
    [InlineData("Ia:Provedores:0:Tipo", "OutroProvedor", "Unknown AI provider type 'OutroProvedor'")]
    [InlineData("Ia:Provedores:1:Nome", "a", "repeated")]
    [InlineData("Ia:Funcionalidades:Mapeamento:Provedores:0", "inexistente", "unknown provider 'inexistente'")]
    [InlineData("Ia:Funcionalidades:Contabilidade:TimeoutSegundos", "5", "Unknown AI feature 'Contabilidade'")]
    [InlineData("Ia:Provedores:1:ApiKey", "", "needs an ApiKey")]
    [InlineData("Ia:Provedores:0:ModoJson", "Xml", "Unknown ModoJson 'Xml'")]
    public void Configuration_mistakes_fail_at_startup_with_a_clear_message(string chave, string valor, string trecho)
    {
        var config = Config(
            ("Ia:Habilitada", "true"),
            ("Ia:Provedores:0:Nome", "a"), ("Ia:Provedores:0:Tipo", "Ollama"), ("Ia:Provedores:0:Modelo", "llama3.2"),
            ("Ia:Provedores:1:Nome", "b"), ("Ia:Provedores:1:Tipo", "OpenAICompativel"), ("Ia:Provedores:1:Modelo", "gpt"), ("Ia:Provedores:1:ApiKey", "k"),
            (chave, valor));

        var erro = Assert.Throws<InvalidOperationException>(() => Create(config));

        Assert.Contains(trecho, erro.Message, StringComparison.Ordinal);
    }

    [Theory]
    [InlineData(1200, 300, "0.0108")]
    [InlineData(1_000_000, 0, "4")]
    [InlineData(null, 500, "0.01")]
    [InlineData(null, null, null)]
    public void Cost_uses_the_configured_price_per_million_tokens(int? entrada, int? saida, string? esperado)
    {
        var opcoes = new ProvedorIaOptions { PrecoEntradaPorMilhao = 4m, PrecoSaidaPorMilhao = 20m };

        Assert.Equal(esperado is null ? null : decimal.Parse(esperado, System.Globalization.CultureInfo.InvariantCulture), opcoes.EstimateCost(entrada, saida));
    }

    [Fact]
    public async Task Without_a_provider_the_gateway_answers_unavailable_and_records_nothing()
    {
        var registro = new RegistroEmMemoria();
        var gateway = new GatewayIa(FakeProvedoresIa.Desligada, registro, TimeProvider.System, NullLogger<GatewayIa>.Instance);

        var resposta = await gateway.SendAsync(new PedidoIa(FuncionalidadeIa.Mapeamento, "v1", [new ChatMessage(ChatRole.User, "oi")], null), CancellationToken.None);

        Assert.Same(RespostaIa.Indisponivel, resposta);
        Assert.Empty(registro.Chamadas);
    }

    [Fact]
    public async Task Ai_usage_is_only_for_admins()
    {
        using var anonimo = factory.CreateClient();
        using var gestor = factory.CreateClient();
        gestor.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(Perfis.Gestor));

        Assert.Equal(HttpStatusCode.Unauthorized, (await anonimo.GetAsync(new Uri("/api/v1/ia/chamadas", UriKind.Relative))).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await gestor.GetAsync(new Uri("/api/v1/ia/chamadas", UriKind.Relative))).StatusCode);
    }

    /// <summary>Monta as opções como a API faz, pelo binder de configuração (inclui listas e dicionários).</summary>
    private static IaOptions Config(params (string Chave, string Valor)[] valores)
    {
        // A última ocorrência de uma chave vale, como numa camada de configuração sobre outra.
        var porChave = new Dictionary<string, string?>(StringComparer.OrdinalIgnoreCase);
        foreach (var (chave, valor) in valores)
        {
            porChave[chave] = valor;
        }

        var configuracao = new ConfigurationBuilder().AddInMemoryCollection(porChave).Build();
        var opcoes = new IaOptions();
        configuracao.GetSection(IaOptions.SectionName).Bind(opcoes);
        return opcoes;
    }

    private static ProvedoresIa Create(IaOptions opcoes) => new(Options.Create(opcoes), Fabricas, NullLoggerFactory.Instance);
}
