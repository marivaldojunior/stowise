using System.Net;
using System.Net.Http.Json;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Observability;

public class HealthCheckTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public async Task Live_is_healthy_without_checking_dependencies()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/health/live", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var report = await response.Content.ReadFromJsonAsync<HealthReportDto>();
        Assert.Equal("Healthy", report!.Status);
        Assert.Empty(report.Checks);
    }

    [Fact]
    public async Task Ready_returns_503_and_names_the_failing_database_check()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/health/ready", UriKind.Relative));

        Assert.Equal(HttpStatusCode.ServiceUnavailable, response.StatusCode);
        var report = await response.Content.ReadFromJsonAsync<HealthReportDto>();
        Assert.Equal("Unhealthy", report!.Status);
        var check = Assert.Single(report.Checks);
        Assert.Equal("database", check.Name);
        Assert.Equal("Unhealthy", check.Status);
    }

    [Fact]
    public async Task Health_endpoints_do_not_require_authentication()
    {
        using var client = factory.CreateClient();

        var live = await client.GetAsync(new Uri("/health/live", UriKind.Relative));

        Assert.NotEqual(HttpStatusCode.Unauthorized, live.StatusCode);
    }

    internal sealed record HealthReportDto(string Status, double TotalDurationMs, IReadOnlyList<HealthCheckDto> Checks);

    internal sealed record HealthCheckDto(string Name, string Status, double DurationMs);
}

[Collection(PostgresTestGroup.Name)]
public sealed class ReadyHealthCheckWithDatabaseTests(PostgresFixture postgres)
{
    [DockerFact]
    public async Task Ready_is_healthy_when_the_database_answers()
    {
        await using var factory = StowiseApiFactory.WithDatabase(postgres, "admin@stowise.test", "Senha-de-teste-123");
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/health/ready", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var report = await response.Content.ReadFromJsonAsync<HealthCheckTests.HealthReportDto>();
        Assert.Equal("Healthy", report!.Status);
    }
}
