using System.Net;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Stowise.Api.Common;
using Stowise.Application.Auth;
using Stowise.Application.Common;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Usuarios;

/// <summary>Autorização e validação de entrada, aplicadas antes de consultar o banco.</summary>
public class UsuariosEndpointsTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public async Task Without_token_returns_401()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/api/v1/usuarios", UriKind.Relative));

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Theory]
    [InlineData(Perfis.Gestor)]
    [InlineData(Perfis.Operador)]
    public async Task Non_admin_perfis_get_403(string perfil)
    {
        using var client = ClientWith(TestTokens.ForPerfis(perfil));

        var usuarios = await client.GetAsync(new Uri("/api/v1/usuarios", UriKind.Relative));
        var perfis = await client.GetAsync(new Uri("/api/v1/perfis", UriKind.Relative));

        Assert.Equal(HttpStatusCode.Forbidden, usuarios.StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, perfis.StatusCode);
    }

    [Fact]
    public async Task Admin_lists_the_fixed_perfis()
    {
        using var client = ClientWith(TestTokens.ForPerfis(Perfis.Admin));

        var perfis = await client.GetFromJsonAsync<string[]>("/api/v1/perfis");

        Assert.Equal(Perfis.Todos, perfis);
    }

    [Fact]
    public async Task Create_with_invalid_data_returns_validation_problem_per_field()
    {
        using var client = ClientWith(TestTokens.ForPerfis(Perfis.Admin));

        var response = await client.PostAsJsonAsync(
            "/api/v1/usuarios",
            new { nome = "", email = "invalido", senha = "x", perfis = new[] { "Chefe" } });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var problem = await response.Content.ReadFromJsonAsync<HttpValidationProblemDetails>();
        Assert.Equal(["email", "nome", "perfis"], problem!.Errors.Keys.Order());
    }

    [Theory]
    [InlineData(ErrorType.NotFound, StatusCodes.Status404NotFound)]
    [InlineData(ErrorType.Conflict, StatusCodes.Status409Conflict)]
    [InlineData(ErrorType.BusinessRule, StatusCodes.Status422UnprocessableEntity)]
    [InlineData(ErrorType.TooManyRequests, StatusCodes.Status429TooManyRequests)]
    public void Errors_map_to_problem_status_codes(ErrorType type, int expectedStatus)
    {
        var result = new AppError(type, "Mensagem").ToProblem();

        var problem = Assert.IsType<ProblemHttpResult>(result);
        Assert.Equal(expectedStatus, problem.StatusCode);
        Assert.Equal("Mensagem", problem.ProblemDetails.Title);
    }

    [Fact]
    public void Validation_error_maps_to_400_with_fields()
    {
        var result = AppError.Validation("senha", "Informe a senha.").ToProblem();

        var problem = Assert.IsType<ValidationProblem>(result);
        Assert.Equal(StatusCodes.Status400BadRequest, problem.StatusCode);
        Assert.Equal(["Informe a senha."], problem.ProblemDetails.Errors["senha"]);
    }

    private HttpClient ClientWith(string accessToken)
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
        return client;
    }
}
