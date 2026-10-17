using Microsoft.AspNetCore.Authorization;
using Stowise.Api.Endpoints;
using Stowise.Api.Errors;
using Stowise.Api.Observability;
using Stowise.Application.Auth;
using Stowise.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

builder.AddObservability();
builder.Services.AddOpenApi();
builder.Services.AddStowiseProblemDetails();
builder.Services.AddInfrastructure();

// ADR-0005: todo endpoint exige usuário autenticado, salvo AllowAnonymous explícito.
var authorization = builder.Services.AddAuthorizationBuilder()
    .SetFallbackPolicy(new AuthorizationPolicyBuilder().RequireAuthenticatedUser().Build());
foreach (var perfil in Perfis.Todos)
{
    authorization.AddPolicy(perfil, policy => policy.RequireRole(perfil));
}

var app = builder.Build();

await app.Services.InitializeDatabaseAsync();

app.UseStowiseProblemDetails();
app.UseStowiseRequestLogging();

app.UseAuthentication();
app.UseAuthorization();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi().AllowAnonymous();
}

app.MapStowiseHealthChecks();
app.MapAuthEndpoints();
app.MapUsuariosEndpoints();

await app.RunAsync();

public partial class Program;
