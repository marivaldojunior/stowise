using Microsoft.Extensions.DependencyInjection;
using OpenTelemetry.Metrics;
using OpenTelemetry.Trace;
using Stowise.IntegrationTests.Infrastructure;

namespace Stowise.IntegrationTests.Observability;

public class ObservabilityTests(StowiseApiFactory factory) : IClassFixture<StowiseApiFactory>
{
    [Fact]
    public void Tracing_and_metrics_providers_are_registered()
    {
        Assert.NotNull(factory.Services.GetService<TracerProvider>());
        Assert.NotNull(factory.Services.GetService<MeterProvider>());
    }
}
