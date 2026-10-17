using Microsoft.EntityFrameworkCore;
using Stowise.Infrastructure.Persistence;

namespace Stowise.IntegrationTests.Persistence;

public class ModelTests
{
    [Fact]
    public void Model_has_no_changes_missing_from_migrations()
    {
        using var db = new DesignTimeDbContextFactory().CreateDbContext([]);

        Assert.False(
            db.Database.HasPendingModelChanges(),
            "O modelo mudou sem migration. Rode: dotnet ef migrations add <Nome> -p src/Stowise.Infrastructure -s src/Stowise.Infrastructure -o Persistence/Migrations");
    }
}
