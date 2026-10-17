using Microsoft.EntityFrameworkCore;

namespace Stowise.Infrastructure.Persistence;

internal static class NpgsqlOptions
{
    public static DbContextOptionsBuilder UseStowiseNpgsql(this DbContextOptionsBuilder options, string connectionString) =>
        options
            .UseNpgsql(connectionString, npgsql =>
            {
                npgsql.UseVector();
                npgsql.MigrationsHistoryTable("__ef_migrations_history");
            })
            .UseSnakeCaseNamingConvention();
}
