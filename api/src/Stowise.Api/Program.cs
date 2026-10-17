using Microsoft.AspNetCore.Authorization;
using Stowise.Api.Endpoints;
using Stowise.Application.Auth;
using Stowise.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();
builder.Services.AddProblemDetails();
builder.Services.AddHealthChecks();
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

app.UseExceptionHandler();
app.UseStatusCodePages();

app.UseAuthentication();
app.UseAuthorization();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi().AllowAnonymous();
}

app.MapHealthChecks("/health").AllowAnonymous();
app.MapAuthEndpoints();

await app.RunAsync();

public partial class Program;
