namespace Stowise.IntegrationTests.Infrastructure;

/// <summary>
/// Teste que precisa de Docker (Testcontainers). Sem Docker, o teste é pulado localmente.
/// No CI, <c>STOWISE_REQUIRE_DOCKER=true</c> faz o teste falhar em vez de ser pulado.
/// </summary>
[AttributeUsage(AttributeTargets.Method)]
public sealed class DockerFactAttribute : FactAttribute
{
    public DockerFactAttribute()
    {
        if (!DockerEnvironment.IsAvailable && !DockerEnvironment.IsRequired)
        {
            Skip = "Docker indisponível. Instale o Docker para rodar os testes de integração com PostgreSQL.";
        }
    }
}

internal static class DockerEnvironment
{
    public static bool IsAvailable { get; } = Detect();

    public static bool IsRequired { get; } =
        string.Equals(Environment.GetEnvironmentVariable("STOWISE_REQUIRE_DOCKER"), "true", StringComparison.OrdinalIgnoreCase);

    private static bool Detect()
    {
        if (!string.IsNullOrEmpty(Environment.GetEnvironmentVariable("DOCKER_HOST")))
        {
            return true;
        }

        return OperatingSystem.IsWindows()
            ? Directory.GetFiles(@"\\.\pipe\").Any(p => p.EndsWith("docker_engine", StringComparison.OrdinalIgnoreCase))
            : File.Exists("/var/run/docker.sock");
    }
}
