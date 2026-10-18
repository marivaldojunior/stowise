using System.Text.Json.Serialization;
using Hangfire;
using Microsoft.AspNetCore.Authorization;
using Stowise.Api.Endpoints;
using Stowise.Api.Errors;
using Stowise.Api.Hubs;
using Stowise.Api.Observability;
using Stowise.Api.OpenApi;
using Stowise.Application.Auth;
using Stowise.Application.Importacoes;
using Stowise.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

builder.AddObservability();
builder.Services.AddStowiseOpenApi();
builder.Services.AddStowiseProblemDetails();
// Enums como texto, igual à API HTTP, para o painel tratar o mesmo formato.
builder.Services.AddSignalR().AddJsonProtocol(o => o.PayloadSerializerOptions.Converters.Add(new JsonStringEnumConverter()));
builder.Services.AddScoped<INotificadorImportacao, SignalRNotificadorImportacao>();
builder.Services.AddInfrastructure();
builder.Services.AddJobsServer(builder.Configuration);

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

// ADR-0007: o painel do Hangfire só existe em Development e só aceita requisições locais.
if (app.Environment.IsDevelopment())
{
    app.UseHangfireDashboard("/hangfire");
}

app.MapHub<ImportacoesHub>(ImportacoesHub.Rota);

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
v1.MapIaEndpoints();

await app.RunAsync();

public partial class Program;
