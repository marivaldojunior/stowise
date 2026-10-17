using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;

namespace Stowise.IntegrationTests.Infrastructure;

/// <summary>
/// API em memória no ambiente "Testing": sem migrations nem seed na inicialização.
/// Sem <see cref="ConnectionString"/> informada, usa uma que nunca é aberta.
/// </summary>
public class StowiseApiFactory : WebApplicationFactory<Program>
{
    public string ConnectionString { get; init; } = "Host=localhost;Database=stowise_unused";

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment("Testing");
        builder.UseSetting("ConnectionStrings:Stowise", ConnectionString);
    }
}
