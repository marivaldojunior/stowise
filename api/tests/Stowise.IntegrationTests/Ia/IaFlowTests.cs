using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Api.Endpoints;
using Stowise.Application.Common;
using Stowise.Application.Ia;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Ia;
using Stowise.Infrastructure.Persistence;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Ia;

/// <summary>Gateway de IA contra o PostgreSQL, com provedor falso: toda chamada vira um ChamadaIa.</summary>
[Collection(PostgresTestGroup.Name)]
public sealed class IaFlowTests : IAsyncLifetime
{
    private const string AdminEmail = "admin@stowise.test";
    private const string AdminPassword = "Senha-de-teste-123";

    private static readonly JsonSerializerOptions Json = new(JsonSerializerDefaults.Web) { Converters = { new JsonStringEnumConverter() } };

    private readonly StowiseApiFactory _base;
    private readonly FakeChatClient _principal = FakeChatClient.Responding("{\"ok\":true}");
    private readonly WebApplicationFactory<Program> _factory;
    private readonly HttpClient _client;

    public IaFlowTests(PostgresFixture postgres)
    {
        _base = StowiseApiFactory.WithDatabase(postgres, AdminEmail, AdminPassword);
        _factory = _base.WithWebHostBuilder(b => b.ConfigureTestServices(s => s.AddSingleton<IProvedoresIa>(new FakeProvedoresIa(_principal))));
        _client = _factory.CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = false });
    }

    public async Task InitializeAsync()
    {
        if (!DockerEnvironment.IsAvailable && !DockerEnvironment.IsRequired)
        {
            return;
        }

        var login = await _client.PostAsJsonAsync("/api/v1/auth/login", new { email = AdminEmail, senha = AdminPassword });
        var token = (await login.Content.ReadFromJsonAsync<AuthResponse>())!.AccessToken;
        _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    }

    public async Task DisposeAsync()
    {
        _client.Dispose();
        await _factory.DisposeAsync();
        await _base.DisposeAsync();
    }

    [DockerFact]
    public async Task Successful_and_failed_calls_are_recorded_with_cost_and_latency()
    {
        var usuarioId = (await _client.GetFromJsonAsync<UsuarioAtual>("/api/v1/auth/me", Json))!.Id;
        var gateway = _factory.Services.GetRequiredService<GatewayIa>();

        var ok = await gateway.SendAsync(new PedidoIa(FuncionalidadeIa.Mapeamento, "mapeamento-v1", [new ChatMessage(ChatRole.User, "cabeçalho")], usuarioId), CancellationToken.None);

        Assert.True(ok.Sucesso);
        Assert.Equal("{\"ok\":true}", ok.Texto);
        var (_, opcoes) = Assert.Single(_principal.Recebidas);
        Assert.Equal(("claude-opus-5-5", 4096), (opcoes!.ModelId, opcoes.MaxOutputTokens));

        var falha = await new GatewayIa(
                new FakeProvedoresIa(FakeChatClient.Failing(new HttpRequestException("connection refused"))),
                _factory.Services.GetRequiredService<IServiceScopeFactory>(),
                TimeProvider.System,
                Microsoft.Extensions.Logging.Abstractions.NullLogger<GatewayIa>.Instance)
            .SendAsync(new PedidoIa(FuncionalidadeIa.Consulta, "consulta-v1", [new ChatMessage(ChatRole.User, "x")], null), CancellationToken.None);

        Assert.False(falha.Sucesso);
        Assert.NotNull(falha.ChamadaId);

        await using var scope = _factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
        var registrada = await db.ChamadasIa.SingleAsync(c => c.Id == ok.ChamadaId);
        Assert.Equal((usuarioId, "Anthropic", "claude-opus-5-5", "mapeamento-v1"), (registrada.UsuarioId, registrada.Provedor, registrada.Modelo, registrada.PromptVersao));
        Assert.Equal((1200, 300, 0.0108m, true), (registrada.TokensEntrada, registrada.TokensSaida, registrada.CustoEstimado, registrada.Sucesso));
        Assert.True(registrada.LatenciaMs >= 0);

        var lista = (await _client.GetFromJsonAsync<PagedResult<ChamadaIaDetalhe>>("/api/v1/ia/chamadas?sucesso=false", Json))!;
        var falhou = Assert.Single(lista.Itens);
        Assert.Equal(FuncionalidadeIa.Consulta, falhou.Funcionalidade);
        Assert.StartsWith("HttpRequestException: connection refused", falhou.Erro, StringComparison.Ordinal);
        Assert.Null(falhou.CustoEstimado);
    }

    private sealed record UsuarioAtual(Guid Id);
}
