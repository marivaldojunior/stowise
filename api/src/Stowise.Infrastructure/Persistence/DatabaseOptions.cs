namespace Stowise.Infrastructure.Persistence;

public sealed class DatabaseOptions
{
    public const string SectionName = "Database";

    /// <summary>Aplica as migrations pendentes na inicialização da API.</summary>
    public bool MigrateOnStartup { get; set; }

    /// <summary>Cria o armazém de exemplo, se ele ainda não existir.</summary>
    public bool SeedSampleData { get; set; }
}
