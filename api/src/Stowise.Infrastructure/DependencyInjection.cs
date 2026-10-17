using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Stowise.Application.Auth;
using Stowise.Application.Usuarios;
using Stowise.Infrastructure.Identity;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure;

public static class DependencyInjection
{
    public const string ConnectionStringName = "Stowise";

    /// <summary>Tag dos health checks de dependências, usados em <c>/health/ready</c>.</summary>
    public const string ReadyTag = "ready";

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
        services.AddHealthChecks().AddDbContextCheck<StowiseDbContext>("database", tags: [ReadyTag]);

        services.AddIdentityAndJwt();

        return services;
    }

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

        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer();
        services.AddOptions<JwtBearerOptions>(JwtBearerDefaults.AuthenticationScheme)
            .Configure<IOptions<JwtOptions>>((bearer, jwt) =>
            {
                bearer.MapInboundClaims = false;
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
