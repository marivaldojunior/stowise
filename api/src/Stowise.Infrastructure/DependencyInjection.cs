using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Stowise.Application.Armazenagem;
using Stowise.Application.Auth;
using Stowise.Application.Catalogo;
using Stowise.Application.Estoque;
using Stowise.Application.Estrutura;
using Stowise.Application.Fornecedores;
using Stowise.Application.Ia;
using Stowise.Application.Importacoes;
using Stowise.Application.NotasFiscais;
using Stowise.Application.Recebimentos;
using Stowise.Application.Rfid;
using Stowise.Application.Usuarios;
using Stowise.Domain.Armazenagem;
using Stowise.Infrastructure.Armazenagem;
using Stowise.Infrastructure.Catalogo;
using Stowise.Infrastructure.Estoque;
using Stowise.Infrastructure.Estrutura;
using Stowise.Infrastructure.Fornecedores;
using Stowise.Infrastructure.Ia;
using Stowise.Infrastructure.Identity;
using Stowise.Infrastructure.Importacoes;
using Stowise.Infrastructure.Jobs;
using Stowise.Infrastructure.NotasFiscais;
using Stowise.Infrastructure.Persistence;
using Stowise.Infrastructure.Recebimentos;
using Stowise.Infrastructure.Rfid;

namespace Stowise.Infrastructure;

public static class DependencyInjection
{
    public const string ConnectionStringName = "Stowise";

    /// <summary>Tag dos health checks de dependências, usados em <c>/health/ready</c>.</summary>
    public const string ReadyTag = "ready";

    /// <summary>Prefixo dos hubs SignalR, que aceitam o token na query string.</summary>
    public const string HubsPath = "/hubs";

    public static IServiceCollection AddInfrastructure(this IServiceCollection services)
    {
        services.AddSingleton(TimeProvider.System);

        services.AddDbContext<StowiseDbContext>((provider, options) =>
        {
            var connectionString = provider.GetRequiredService<IConfiguration>().GetConnectionString(ConnectionStringName)
                ?? throw new InvalidOperationException($"Connection string '{ConnectionStringName}' is not configured.");
            options.UseStowiseNpgsql(connectionString);
        });

        services.AddOptions<DatabaseOptions>().BindConfiguration(DatabaseOptions.SectionName);
        services.AddScoped<DatabaseInitializer>();
        services.AddScoped<ICategoriaService, CategoriaService>();
        services.AddScoped<IProdutoService, ProdutoService>();
        services.AddScoped<IFornecedorService, FornecedorService>();
        services.AddSingleton<ILeitorNfe, LeitorNfe>();
        services.AddScoped<IAnaliseNotaFiscal, AnaliseNotaFiscalService>();
        services.AddScoped<IEfetivacaoNotaFiscal, EfetivacaoNotaFiscalService>();
        services.AddScoped<IRecebimentoService, RecebimentoService>();
        services.AddSingleton(MotorArmazenagem.Padrao());
        services.AddScoped<PlanejadorArmazenagem>();
        services.AddScoped<IArmazenagemService, ArmazenagemService>();
        services.AddScoped<IArmazemService, ArmazemService>();
        services.AddScoped<IEnderecoService, EnderecoService>();
        services.AddScoped<IMovimentacaoService, MovimentacaoService>();
        services.AddScoped<IReservaService, ReservaService>();
        services.AddScoped<IConsultaEstoqueService, ConsultaEstoqueService>();
        services.AddScoped<IImportacaoService, ImportacaoService>();
        services.AddScoped<StagingProdutos>();
        services.AddScoped<EfetivacaoProdutos>();
        services.AddScoped<SugestaoMapeamentoIa>();
        services.AddOptions<RfidOptions>().BindConfiguration(RfidOptions.SectionName);
        services.AddScoped<IRfidService, RfidService>();
        services.AddJobs();

        // ADR-0004: camada de IA atrás da API. Desligada (Ia:Habilitada=false), os fluxos seguem manuais.
        services.AddOptions<IaOptions>().BindConfiguration(IaOptions.SectionName);
        services.AddSingleton<IFabricaProvedorIa, AnthropicFabrica>();
        services.AddSingleton<IFabricaProvedorIa, OpenAICompativelFabrica>();
        services.AddSingleton<IFabricaProvedorIa, GeminiFabrica>();
        services.AddSingleton<IFabricaProvedorIa, OllamaFabrica>();
        services.AddSingleton<IProvedoresIa, ProvedoresIa>();
        services.AddSingleton<IRegistroChamadasIa, RegistroChamadasIaEf>();
        services.AddSingleton<GatewayIa>();
        services.AddSingleton<GeradorEmbeddings>();
        services.AddScoped<IBuscaProdutosSimilares, BuscaProdutosSimilares>();
        services.AddScoped<IConsultaIaService, ConsultaIaService>();
        services.AddScoped<ICotaIaService, CotaIaService>();
        services.AddSingleton<IVerificadorCotaIa, VerificadorCotaIa>();
        services.AddScoped<ITemplateImportacaoService, TemplateImportacaoService>();
        services.AddHealthChecks().AddDbContextCheck<StowiseDbContext>("database", tags: [ReadyTag]);

        services.AddIdentityAndJwt();

        return services;
    }

    /// <summary>Servidor de jobs no processo (ADR-0007), ligado por <c>Jobs:Enabled</c>.</summary>
    public static IServiceCollection AddJobsServer(this IServiceCollection services, IConfiguration configuration) =>
        JobsSetup.AddJobsServer(services, configuration);

    public static async Task InitializeDatabaseAsync(this IServiceProvider services, CancellationToken cancellationToken = default)
    {
        await using var scope = services.CreateAsyncScope();
        await scope.ServiceProvider.GetRequiredService<DatabaseInitializer>().InitializeAsync(cancellationToken);
    }

    private static void AddIdentityAndJwt(this IServiceCollection services)
    {
        services.AddIdentityCore<Usuario>(options =>
            {
                options.User.RequireUniqueEmail = true;
                options.Password.RequiredLength = 8;
                options.Password.RequireNonAlphanumeric = false;
                options.Lockout.AllowedForNewUsers = true;
                options.Lockout.MaxFailedAccessAttempts = 5;
                options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(5);
            })
            .AddRoles<Perfil>()
            .AddErrorDescriber<PortugueseIdentityErrorDescriber>()
            .AddEntityFrameworkStores<StowiseDbContext>();

        services.AddOptions<JwtOptions>()
            .BindConfiguration(JwtOptions.SectionName)
            .ValidateDataAnnotations()
            .ValidateOnStart();
        services.AddOptions<AdminBootstrapOptions>().BindConfiguration(AdminBootstrapOptions.SectionName);

        services.AddSingleton<TokenService>();
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<IUsuarioService, UsuarioService>();
        services.AddScoped<AdminBootstrapper>();
        services.AddOptions<DemonstracaoOptions>().BindConfiguration(DemonstracaoOptions.SectionName);
        services.AddScoped<UsuariosDemonstracao>();

        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer();
        services.AddOptions<JwtBearerOptions>(JwtBearerDefaults.AuthenticationScheme)
            .Configure<IOptions<JwtOptions>>((bearer, jwt) =>
            {
                bearer.MapInboundClaims = false;

                // SignalR por WebSocket não envia o cabeçalho Authorization: o token vem em access_token, só nos hubs.
                bearer.Events = new JwtBearerEvents
                {
                    OnMessageReceived = context =>
                    {
                        if (context.Request.Path.StartsWithSegments(HubsPath) && context.Request.Query["access_token"] is [{ Length: > 0 } token])
                        {
                            context.Token = token;
                        }

                        return Task.CompletedTask;
                    },
                };
                bearer.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidIssuer = jwt.Value.Issuer,
                    ValidAudience = jwt.Value.Audience,
                    IssuerSigningKey = TokenService.CreateSigningKey(jwt.Value.SigningKey),
                    ValidAlgorithms = [SecurityAlgorithms.HmacSha256],
                    ClockSkew = TimeSpan.FromSeconds(30),
                    NameClaimType = TokenService.ClaimTypes.Name,
                    RoleClaimType = TokenService.ClaimTypes.Role,
                };
            });
    }
}
