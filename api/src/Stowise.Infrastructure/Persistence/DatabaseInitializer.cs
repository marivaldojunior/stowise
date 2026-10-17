using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Stowise.Infrastructure.Persistence.Seed;

namespace Stowise.Infrastructure.Persistence;

public sealed partial class DatabaseInitializer(
    StowiseDbContext db,
    IOptions<DatabaseOptions> options,
    ILogger<DatabaseInitializer> logger)
{
    public async Task InitializeAsync(CancellationToken cancellationToken = default)
    {
        if (options.Value.MigrateOnStartup)
        {
            LogApplyingMigrations(logger);
            await db.Database.MigrateAsync(cancellationToken);
        }

        if (options.Value.SeedSampleData)
        {
            var created = await SampleDataSeeder.SeedAsync(db, cancellationToken);
            LogSeedFinished(logger, created);
        }
    }

    [LoggerMessage(Level = LogLevel.Information, Message = "Applying pending database migrations")]
    private static partial void LogApplyingMigrations(ILogger logger);

    [LoggerMessage(Level = LogLevel.Information, Message = "Sample data seed finished (created: {Created})")]
    private static partial void LogSeedFinished(ILogger logger, bool created);
}
