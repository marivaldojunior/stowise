using System.Net;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.Logging.Abstractions;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Ia;

namespace Stowise.IntegrationTests.Ia;

/// <summary>Timeout, nova tentativa e fallback do gateway (ADR-0004, item 4), sem banco e sem provedor real.</summary>
public class GatewayResilienceTests
{
    private readonly RegistroEmMemoria _registro = new();

    [Fact]
    public async Task First_answer_is_recorded_with_one_attempt_and_its_cost()
    {
        var resposta = await SendAsync(FakeProvedoresIa.With(FakeChatClient.Responding("ok")));

        Assert.True(resposta.Sucesso);
        var chamada = Assert.Single(_registro.Chamadas);
        Assert.Equal(("anthropic", "claude-opus-5-5", 1, false, 0.0108m), (chamada.Provedor, chamada.Modelo, chamada.Tentativas, chamada.UsouFallback, chamada.CustoEstimado));
    }

    [Fact]
    public async Task Transient_failure_is_retried_on_the_same_provider()
    {
        var principal = FakeChatClient.Sequence(
            (_, _) => Task.FromException<ChatResponse>(new HttpRequestException("busy", null, HttpStatusCode.ServiceUnavailable)),
            (_, _) => Task.FromException<ChatResponse>(new HttpRequestException("limit", null, HttpStatusCode.TooManyRequests)),
            (o, _) => Task.FromResult(FakeChatClient.Ok("ok", o)));
        var reserva = FakeChatClient.Responding("reserva");

        var resposta = await SendAsync(FakeProvedoresIa.With(principal, reserva));

        Assert.Equal(("ok", 3), (resposta.Texto, principal.Recebidas.Count));
        Assert.Empty(reserva.Recebidas);
        var chamada = Assert.Single(_registro.Chamadas);
        Assert.Equal((true, 3, false), (chamada.Sucesso, chamada.Tentativas, chamada.UsouFallback));
    }

    [Fact]
    public async Task Slow_answer_hits_the_timeout_and_the_next_attempt_answers()
    {
        var principal = FakeChatClient.Sequence(FakeChatClient.Hang, (o, _) => Task.FromResult(FakeChatClient.Ok("ok", o)));

        var resposta = await SendAsync(FakeProvedoresIa.With(TimeSpan.FromMilliseconds(200), 3, principal));

        Assert.True(resposta.Sucesso);
        Assert.Equal(2, Assert.Single(_registro.Chamadas).Tentativas);
    }

    [Fact]
    public async Task Permanent_failure_skips_to_the_fallback_without_retrying()
    {
        var principal = FakeChatClient.Failing(new HttpRequestException("invalid key", null, HttpStatusCode.Unauthorized));
        var reserva = FakeChatClient.Responding("reserva", tokensEntrada: 50, tokensSaida: 10);

        var resposta = await SendAsync(FakeProvedoresIa.With(principal, reserva));

        Assert.Equal(("reserva", 1), (resposta.Texto, principal.Recebidas.Count));
        Assert.Equal("llama3.2", reserva.Recebidas.Single().Opcoes!.ModelId);
        var chamada = Assert.Single(_registro.Chamadas);
        Assert.Equal(("reserva-1", "llama3.2", 2, true, 0m), (chamada.Provedor, chamada.Modelo, chamada.Tentativas, chamada.UsouFallback, chamada.CustoEstimado));
    }

    [Fact]
    public async Task When_every_provider_fails_the_answer_is_no_suggestion_with_the_last_error()
    {
        var principal = FakeChatClient.Failing(new HttpRequestException("network down"));
        var reserva = FakeChatClient.Failing(new TimeoutException("ollama is slow"));

        var resposta = await SendAsync(FakeProvedoresIa.With(TimeSpan.FromSeconds(5), 2, principal, reserva));

        Assert.False(resposta.Sucesso);
        Assert.Null(resposta.Resposta);
        var chamada = Assert.Single(_registro.Chamadas);
        Assert.Equal((false, 4, true, "reserva-1"), (chamada.Sucesso, chamada.Tentativas, chamada.UsouFallback, chamada.Provedor));
        Assert.Equal("TimeoutException: ollama is slow", chamada.Erro);
    }

    [Fact]
    public async Task Caller_cancellation_stops_without_retrying_or_falling_back()
    {
        using var cancelado = new CancellationTokenSource();
        await cancelado.CancelAsync();
        var principal = FakeChatClient.Sequence(FakeChatClient.Hang);
        var reserva = FakeChatClient.Responding("reserva");
        var gateway = new GatewayIa(FakeProvedoresIa.With(principal, reserva), _registro, TimeProvider.System, NullLogger<GatewayIa>.Instance);

        await Assert.ThrowsAnyAsync<OperationCanceledException>(() => gateway.SendAsync(Pedido(), cancelado.Token));

        Assert.Empty(reserva.Recebidas);
    }

    [Fact]
    public async Task Provider_parameters_reach_the_client_and_the_request_keeps_its_own_options()
    {
        var principal = FakeChatClient.Responding("ok");
        var provedores = FakeProvedoresIa.With(principal);
        provedores.Cadeia!.Provedores[0].Opcoes.ParametrosAdicionais["effort"] = "low";

        await SendAsync(provedores, new ChatOptions { Temperature = 0.1f });

        var opcoes = principal.Recebidas.Single().Opcoes!;
        Assert.Equal(("claude-opus-5-5", 4096, 0.1f), (opcoes.ModelId, opcoes.MaxOutputTokens, opcoes.Temperature));
        Assert.Equal("low", opcoes.AdditionalProperties!["effort"]);
    }

    [Theory]
    [InlineData(null, true)]
    [InlineData(HttpStatusCode.RequestTimeout, true)]
    [InlineData(HttpStatusCode.TooManyRequests, true)]
    [InlineData(HttpStatusCode.BadGateway, true)]
    [InlineData(HttpStatusCode.BadRequest, false)]
    [InlineData(HttpStatusCode.NotFound, false)]
    public void Http_status_decides_if_a_failure_is_transient(HttpStatusCode? status, bool transitoria)
    {
        Assert.Equal(transitoria, GatewayIa.IsTransient(new HttpRequestException("x", null, status)));
    }

    [Fact]
    public void Network_and_timeout_errors_are_transient_even_when_wrapped()
    {
        Assert.True(GatewayIa.IsTransient(new TimeoutException()));
        Assert.True(GatewayIa.IsTransient(new InvalidOperationException("wrapper", new IOException("reset"))));
        Assert.False(GatewayIa.IsTransient(new InvalidOperationException("bad schema")));
        Assert.True(new AnthropicFabrica().IsTransient(new InvalidOperationException()) is null);
    }

    [Fact]
    public void Backoff_doubles_with_jitter_and_has_a_ceiling()
    {
        var inicial = TimeSpan.FromMilliseconds(500);

        Assert.InRange(GatewayIa.Backoff(inicial, 1).TotalMilliseconds, 250, 500);
        Assert.InRange(GatewayIa.Backoff(inicial, 3).TotalMilliseconds, 1000, 2000);
        Assert.Equal(TimeSpan.FromSeconds(10), GatewayIa.Backoff(TimeSpan.FromSeconds(30), 1));
    }

    private Task<RespostaIa> SendAsync(FakeProvedoresIa provedores, ChatOptions? opcoes = null) =>
        new GatewayIa(provedores, _registro, TimeProvider.System, NullLogger<GatewayIa>.Instance).SendAsync(Pedido(opcoes), CancellationToken.None);

    private static PedidoIa Pedido(ChatOptions? opcoes = null) =>
        new(FuncionalidadeIa.Mapeamento, "mapeamento-v1", [new ChatMessage(ChatRole.User, "cabeçalho")], null, opcoes);
}
