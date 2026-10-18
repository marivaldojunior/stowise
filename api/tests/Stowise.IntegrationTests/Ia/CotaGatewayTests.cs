using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.AI;
using Microsoft.Extensions.Logging.Abstractions;
using Stowise.Application.Auth;
using Stowise.Application.Ia;
using Stowise.Domain.Ia;
using Stowise.Infrastructure.Ia;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Ia;

/// <summary>Cota no gateway e autorização dos endpoints de cota, sem banco.</summary>
public class CotaGatewayTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    private static readonly Guid Usuario = Guid.NewGuid();

    [Fact]
    public async Task Exceeded_quota_stops_before_the_provider_and_records_nothing()
    {
        var principal = FakeChatClient.Responding("ok");
        var registro = new RegistroEmMemoria();
        var cota = new FakeVerificadorCota(new UsoCotaIa(FuncionalidadeIa.Mapeamento, 50, 50, 1000, 500_000, "perfil Operador", Excedida: true));

        var resposta = await Gateway(principal, registro, cota).SendAsync(Pedido(Usuario), CancellationToken.None);

        Assert.False(resposta.Sucesso);
        Assert.True(resposta.CotaExcedida);
        Assert.Equal("Cota de IA atingida (perfil Operador): 50 de 50 chamadas hoje. Continue sem a sugestão da IA ou fale com o administrador.", resposta.MotivoCota);
        Assert.Empty(principal.Recebidas);
        Assert.Empty(registro.Chamadas);
        Assert.Equal((Usuario, FuncionalidadeIa.Mapeamento), Assert.Single(cota.Consultas));
    }

    [Fact]
    public async Task Calls_without_a_user_are_not_counted_against_a_quota()
    {
        var cota = new FakeVerificadorCota(new UsoCotaIa(FuncionalidadeIa.Mapeamento, 99, 1, 0, null, "perfil Operador", Excedida: true));

        var resposta = await Gateway(FakeChatClient.Responding("ok"), new RegistroEmMemoria(), cota).SendAsync(Pedido(usuario: null), CancellationToken.None);

        Assert.True(resposta.Sucesso);
        Assert.Empty(cota.Consultas);
    }

    [Fact]
    public void Token_quota_message_names_the_monthly_limit()
    {
        var mensagem = GatewayIa.DescribeQuota(new UsoCotaIa(FuncionalidadeIa.Consulta, 3, 200, 2_000_100, 2_000_000, "perfil Gestor", true));

        Assert.Contains("2000100 de 2000000 tokens neste mês", mensagem, StringComparison.Ordinal);
    }

    [Theory]
    [InlineData("GET", "/api/v1/ia/cotas")]
    [InlineData("POST", "/api/v1/ia/cotas")]
    [InlineData("DELETE", "/api/v1/ia/cotas/0199f0a0-0000-7000-8000-00000000c001")]
    public async Task Only_admins_manage_quotas(string metodo, string url)
    {
        using var client = ClientWith(Perfis.Gestor);
        using var request = new HttpRequestMessage(new HttpMethod(metodo), url) { Content = metodo == "POST" ? JsonContent.Create(new { }) : null };

        Assert.Equal(HttpStatusCode.Forbidden, (await client.SendAsync(request)).StatusCode);
    }

    [Fact]
    public async Task Own_quota_needs_the_feature()
    {
        using var client = ClientWith(Perfis.Operador);

        var response = await client.GetAsync(new Uri("/api/v1/ia/cota", UriKind.Relative));

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        Assert.Equal(["funcionalidade"], (await response.Content.ReadFromJsonAsync<HttpValidationProblemDetails>())!.Errors.Keys);
    }

    private static GatewayIa Gateway(FakeChatClient principal, RegistroEmMemoria registro, FakeVerificadorCota cota) =>
        new(FakeProvedoresIa.With(principal), registro, cota, TimeProvider.System, NullLogger<GatewayIa>.Instance);

    private static PedidoIa Pedido(Guid? usuario) =>
        new(FuncionalidadeIa.Mapeamento, "v1", [new ChatMessage(ChatRole.User, "cabeçalho")], usuario);

    private HttpClient ClientWith(string perfil)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", TestTokens.ForPerfis(perfil));
        return client;
    }
}
