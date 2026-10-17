using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Stowise.Infrastructure.Persistence;

/// <summary>Usada só pelo <c>dotnet ef</c>. Gerar migrations não abre conexão com o banco.</summary>
public sealed class DesignTimeDbContextFactory : IDesignTimeDbContextFactory<StowiseDbContext>
{
    private const string DefaultConnectionString =
        "Host=localhost;Port=5432;Database=stowise;Username=stowise;Password=stowise";

    public StowiseDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Stowise") ?? DefaultConnectionString;
        var builder = new DbContextOptionsBuilder<StowiseDbContext>();
        builder.UseStowiseNpgsql(connectionString);
        return new StowiseDbContext(builder.Options);
    }
}
