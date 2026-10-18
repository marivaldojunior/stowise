using System.Net;
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
        _factory = _base.WithWebHostBuilder(b => b.ConfigureTestServices(s => s.AddSingleton<IProvedoresIa>(FakeProvedoresIa.With(_principal))));
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
                FakeProvedoresIa.With(FakeChatClient.Failing(new HttpRequestException("connection refused"))),
                _factory.Services.GetRequiredService<IRegistroChamadasIa>(),
                _factory.Services.GetRequiredService<IVerificadorCotaIa>(),
                TimeProvider.System,
                Microsoft.Extensions.Logging.Abstractions.NullLogger<GatewayIa>.Instance)
            .SendAsync(new PedidoIa(FuncionalidadeIa.Consulta, "consulta-v1", [new ChatMessage(ChatRole.User, "x")], null), CancellationToken.None);

        Assert.False(falha.Sucesso);
        Assert.NotNull(falha.ChamadaId);

        await using var scope = _factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<StowiseDbContext>();
        var registrada = await db.ChamadasIa.SingleAsync(c => c.Id == ok.ChamadaId);
        Assert.Equal((usuarioId, "anthropic", "claude-opus-5-5", "mapeamento-v1"), (registrada.UsuarioId, registrada.Provedor, registrada.Modelo, registrada.PromptVersao));
        Assert.Equal((1200, 300, 0.0108m, true), (registrada.TokensEntrada, registrada.TokensSaida, registrada.CustoEstimado, registrada.Sucesso));
        Assert.True(registrada.LatenciaMs >= 0);

        var lista = (await _client.GetFromJsonAsync<PagedResult<ChamadaIaDetalhe>>("/api/v1/ia/chamadas?sucesso=false", Json))!;
        var falhou = Assert.Single(lista.Itens);
        Assert.Equal(FuncionalidadeIa.Consulta, falhou.Funcionalidade);
        Assert.StartsWith("HttpRequestException: connection refused", falhou.Erro, StringComparison.Ordinal);
        Assert.Equal(3, falhou.Tentativas);
        Assert.Null(falhou.CustoEstimado);
    }

    [DockerFact]
    public async Task User_exception_blocks_the_feature_after_the_limit_and_the_admin_can_change_it()
    {
        var usuarioId = (await _client.GetFromJsonAsync<UsuarioAtual>("/api/v1/auth/me", Json))!.Id;
        var gateway = _factory.Services.GetRequiredService<GatewayIa>();
        PedidoIa Pedido(FuncionalidadeIa funcionalidade) => new(funcionalidade, "v1", [new ChatMessage(ChatRole.User, "x")], usuarioId);

        var iniciais = (await _client.GetFromJsonAsync<List<CotaIaDetalhe>>("/api/v1/ia/cotas", Json))!;
        Assert.Contains(iniciais, c => c is { Perfil: "Gestor", LimiteChamadasDia: 200, LimiteTokensMes: 2_000_000 });
        Assert.Contains(iniciais, c => c is { Perfil: "Operador", LimiteChamadasDia: 50, LimiteTokensMes: 500_000 });

        var criada = await _client.PostAsJsonAsync("/api/v1/ia/cotas", new { usuarioId, funcionalidade = "Mapeamento", limiteChamadasDia = 1 });
        Assert.Equal(HttpStatusCode.Created, criada.StatusCode);
        var cota = (await criada.Content.ReadFromJsonAsync<CotaIaDetalhe>(Json))!;
        var repetida = await _client.PostAsJsonAsync("/api/v1/ia/cotas", new { usuarioId, funcionalidade = "Mapeamento", limiteChamadasDia = 3 });
        Assert.Equal(HttpStatusCode.Conflict, repetida.StatusCode);

        Assert.True((await gateway.SendAsync(Pedido(FuncionalidadeIa.Mapeamento), CancellationToken.None)).Sucesso);
        var bloqueada = await gateway.SendAsync(Pedido(FuncionalidadeIa.Mapeamento), CancellationToken.None);
        Assert.True(bloqueada.CotaExcedida);
        Assert.Contains("(exceção do usuário): 1 de 1 chamadas hoje", bloqueada.MotivoCota, StringComparison.Ordinal);

        // A exceção vale só para o mapeamento; o Admin não tem cota de perfil, então a consulta segue livre.
        Assert.True((await gateway.SendAsync(Pedido(FuncionalidadeIa.Consulta), CancellationToken.None)).Sucesso);

        var uso = (await _client.GetFromJsonAsync<UsoCotaIa>("/api/v1/ia/cota?funcionalidade=Mapeamento", Json))!;
        Assert.Equal((1, 1, true, "exceção do usuário"), (uso.ChamadasHoje, uso.LimiteChamadasDia, uso.Excedida, uso.Origem));
        Assert.Equal(1500, uso.TokensMes);

        var desatualizada = await _client.PutAsJsonAsync($"/api/v1/ia/cotas/{cota.Id}", new { limiteChamadasDia = 5, versao = cota.Versao + 1 });
        Assert.Equal(HttpStatusCode.Conflict, desatualizada.StatusCode);
        var alterada = await _client.PutAsJsonAsync($"/api/v1/ia/cotas/{cota.Id}", new { limiteChamadasDia = 5, versao = cota.Versao });
        Assert.Equal(HttpStatusCode.OK, alterada.StatusCode);
        Assert.True((await gateway.SendAsync(Pedido(FuncionalidadeIa.Mapeamento), CancellationToken.None)).Sucesso);

        Assert.Equal(HttpStatusCode.NoContent, (await _client.DeleteAsync(new Uri($"/api/v1/ia/cotas/{cota.Id}", UriKind.Relative))).StatusCode);
        var semCota = (await _client.GetFromJsonAsync<UsoCotaIa>("/api/v1/ia/cota?funcionalidade=Mapeamento", Json))!;
        // Sem cota não há escopo de funcionalidade: o consumo conta tudo (2 mapeamentos e 1 consulta).
        Assert.Equal(((int?)null, false, (string?)null, 3), (semCota.LimiteChamadasDia, semCota.Excedida, semCota.Origem, semCota.ChamadasHoje));
    }

    private sealed record UsuarioAtual(Guid Id);
}
