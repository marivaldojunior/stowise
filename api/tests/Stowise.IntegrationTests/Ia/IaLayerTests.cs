using System.Net;
using System.Net.Http.Headers;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Options;
using Stowise.Application.Auth;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Ia;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Ia;

/// <summary>Camada de IA sem banco: provedores pela configuração, custo, IA desligada e autorização.</summary>
public class IaLayerTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public void Disabled_ai_has_no_provider()
    {
        using var provedores = Create(new IaOptions { Habilitada = false });

        Assert.Null(provedores.Principal);
        Assert.Null(provedores.Reserva);
    }

    [Fact]
    public void Anthropic_and_ollama_are_built_from_the_configuration_without_calling_them()
    {
        using var provedores = Create(new IaOptions
        {
            Habilitada = true,
            Principal = new ProvedorIaOptions { Provedor = ProvedorIaOptions.Anthropic, Modelo = "claude-opus-5-5", ApiKey = "test-key-not-used" },
            Reserva = new ProvedorIaOptions { Provedor = ProvedorIaOptions.Ollama, Modelo = "llama3.2", Endpoint = "http://127.0.0.1:1" },
        });

        Assert.Equal((ProvedorIaOptions.Anthropic, "claude-opus-5-5"), (provedores.Principal!.Nome, provedores.Principal.Opcoes.Modelo));
        Assert.Equal(ProvedorIaOptions.Ollama, provedores.Reserva!.Nome);
        Assert.NotNull(provedores.Principal.Cliente.GetService<ChatClientMetadata>());
    }

    [Fact]
    public void Unknown_provider_is_a_configuration_error()
    {
        var erro = Assert.Throws<InvalidOperationException>(() => Create(new IaOptions
        {
            Habilitada = true,
            Principal = new ProvedorIaOptions { Provedor = "OutroProvedor" },
        }));

        Assert.Contains("OutroProvedor", erro.Message, StringComparison.Ordinal);
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
        var gateway = new GatewayIa(new FakeProvedoresIa(principal: null), factory.Services.GetRequiredService<IServiceScopeFactory>(), TimeProvider.System, NullLogger<GatewayIa>.Instance);

        // Sem provedor, o gateway nem abre o banco (a fábrica aponta para uma porta que recusa conexão).
        var resposta = await gateway.SendAsync(new PedidoIa(FuncionalidadeIa.Mapeamento, "v1", [new ChatMessage(ChatRole.User, "oi")], null), CancellationToken.None);

        Assert.Same(RespostaIa.Indisponivel, resposta);
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

    private static ProvedoresIa Create(IaOptions opcoes) => new(Options.Create(opcoes), NullLoggerFactory.Instance);
}
