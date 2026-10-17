using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure;

public static class DependencyInjection
{
    public const string ConnectionStringName = "Stowise";

    public static IServiceCollection AddInfrastructure(this IServiceCollection services)
    {
        services.AddDbContext<StowiseDbContext>((provider, options) =>
        {
            var connectionString = provider.GetRequiredService<IConfiguration>().GetConnectionString(ConnectionStringName)
                ?? throw new InvalidOperationException($"Connection string '{ConnectionStringName}' is not configured.");
            options.UseStowiseNpgsql(connectionString);
        });

        services.AddOptions<DatabaseOptions>().BindConfiguration(DatabaseOptions.SectionName);
        services.AddScoped<DatabaseInitializer>();

        return services;
    }

    public static async Task InitializeDatabaseAsync(this IServiceProvider services, CancellationToken cancellationToken = default)
    {
        await using var scope = services.CreateAsyncScope();
        await scope.ServiceProvider.GetRequiredService<DatabaseInitializer>().InitializeAsync(cancellationToken);
    }
}
