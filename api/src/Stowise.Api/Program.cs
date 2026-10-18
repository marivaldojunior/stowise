using Microsoft.AspNetCore.Authorization;
using Stowise.Api.Endpoints;
using Stowise.Api.Errors;
using Stowise.Api.Observability;
using Stowise.Api.OpenApi;
using Stowise.Application.Auth;
using Stowise.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

builder.AddObservability();
builder.Services.AddStowiseOpenApi();
builder.Services.AddStowiseProblemDetails();
builder.Services.AddInfrastructure();

// ADR-0005: todo endpoint exige usuário autenticado, salvo AllowAnonymous explícito.
var authorization = builder.Services.AddAuthorizationBuilder()
    .SetFallbackPolicy(new AuthorizationPolicyBuilder().RequireAuthenticatedUser().Build());
foreach (var perfil in Perfis.Todos)
{
    authorization.AddPolicy(perfil, policy => policy.RequireRole(perfil));
}

authorization.AddPolicy(Politicas.Gestao, policy => policy.RequireRole(Politicas.PerfisDeGestao));

var app = builder.Build();

await app.Services.InitializeDatabaseAsync();

app.UseStowiseProblemDetails();
app.UseStowiseRequestLogging();

app.UseAuthentication();
app.UseAuthorization();

app.MapStowiseHealthChecks();
app.MapStowiseOpenApi();

var v1 = app.MapApiV1();
v1.MapAuthEndpoints();
v1.MapUsuariosEndpoints();
v1.MapCategoriasEndpoints();
v1.MapProdutosEndpoints();
v1.MapEstruturaEndpoints();
v1.MapMovimentacoesEndpoints();
v1.MapReservasEndpoints();
v1.MapConsultasEstoqueEndpoints();
v1.MapImportacoesEndpoints();

await app.RunAsync();

public partial class Program;
