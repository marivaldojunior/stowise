using System.Net;
using System.Net.Http.Headers;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Stowise.Application.Auth;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Importacoes;

/// <summary>Hub de progresso e servidor de jobs, sem banco.</summary>
public class ProcessamentoEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    private const string Negotiate = "/hubs/importacoes/negotiate?negotiateVersion=1";

    [Fact]
    public async Task Progress_hub_requires_a_manager()
    {
        using var anonimo = factory.CreateClient();
        using var operador = factory.CreateClient();
        operador.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(Perfis.Operador));

        Assert.Equal(HttpStatusCode.Unauthorized, (await anonimo.PostAsync(new Uri(Negotiate, UriKind.Relative), null)).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await operador.PostAsync(new Uri(Negotiate, UriKind.Relative), null)).StatusCode);
    }

    [Fact]
    public async Task Hub_accepts_the_token_in_the_query_string_used_by_websockets()
    {
        using var client = factory.CreateClient();
        var token = Uri.EscapeDataString(TestTokens.ForPerfis(Perfis.Gestor));

        var hub = await client.PostAsync(new Uri($"{Negotiate}&access_token={token}", UriKind.Relative), null);
        var api = await client.GetAsync(new Uri($"/api/v1/importacoes?access_token={token}", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, hub.StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, api.StatusCode);
    }

    [Fact]
    public void Job_server_does_not_start_without_a_database()
    {
        var servicos = factory.Services.GetServices<IHostedService>().Select(s => s.GetType().Name);

        Assert.DoesNotContain(servicos, n => n.Contains("BackgroundJobServer", StringComparison.Ordinal));
    }
}
