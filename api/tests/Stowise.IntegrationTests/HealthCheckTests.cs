using System.Net;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests;

public class HealthCheckTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public async Task Health_endpoint_returns_ok()
    {
        using var client = factory.CreateClient();

        var response = await client.GetAsync(new Uri("/health", UriKind.Relative));

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }
}
