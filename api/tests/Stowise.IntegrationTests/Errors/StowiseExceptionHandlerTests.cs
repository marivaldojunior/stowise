using System.Text.Json;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Npgsql;
using Stowise.Api.Errors;
using Stowise.Domain.Common;

namespace Stowise.IntegrationTests.Errors;

public class StowiseExceptionHandlerTests
{
    [Fact]
    public async Task Domain_exception_becomes_422_with_the_domain_message()
    {
        var (status, body) = await HandleAsync(new DomainException("Rua deve conter apenas letras."));

        Assert.Equal(StatusCodes.Status422UnprocessableEntity, status);
        Assert.Equal("Rua deve conter apenas letras.", body.GetProperty("title").GetString());
    }

    [Fact]
    public async Task Concurrency_exception_becomes_409()
    {
        var (status, _) = await HandleAsync(new DbUpdateConcurrencyException("row changed"));

        Assert.Equal(StatusCodes.Status409Conflict, status);
    }

    [Fact]
    public async Task Unique_violation_from_the_database_becomes_409()
    {
        var unique = new DbUpdateException("insert failed", new PostgresException("duplicate key", "ERROR", "ERROR", PostgresErrorCodes.UniqueViolation));

        var (status, body) = await HandleAsync(unique);

        Assert.Equal(StatusCodes.Status409Conflict, status);
        Assert.Equal("Registro duplicado", body.GetProperty("title").GetString());
        Assert.True(StowiseExceptionHandler.IsClientError(unique));
    }

    [Fact]
    public async Task Other_database_errors_stay_500()
    {
        var other = new DbUpdateException("insert failed", new PostgresException("fk violation", "ERROR", "ERROR", PostgresErrorCodes.ForeignKeyViolation));

        var (status, _) = await HandleAsync(other);

        Assert.Equal(StatusCodes.Status500InternalServerError, status);
        Assert.False(StowiseExceptionHandler.IsClientError(other));
    }

    [Fact]
    public async Task Unexpected_exception_becomes_500_without_internal_details()
    {
        var (status, body) = await HandleAsync(new InvalidOperationException("connection string secreta"));

        Assert.Equal(StatusCodes.Status500InternalServerError, status);
        Assert.DoesNotContain("secreta", body.GetRawText(), StringComparison.Ordinal);
        Assert.True(body.TryGetProperty("traceId", out _));
    }

    [Fact]
    public async Task Unexpected_exception_shows_its_message_only_in_development()
    {
        var (_, body) = await HandleAsync(new InvalidOperationException("detalhe útil"), Environments.Development);

        Assert.Contains("detalhe útil", body.GetProperty("exception").GetString(), StringComparison.Ordinal);
    }

    [Theory]
    [InlineData(typeof(DomainException), true)]
    [InlineData(typeof(DbUpdateConcurrencyException), true)]
    [InlineData(typeof(InvalidOperationException), false)]
    public void Only_client_errors_skip_error_logging(Type exceptionType, bool isClientError)
    {
        var exception = (Exception)Activator.CreateInstance(exceptionType)!;

        Assert.Equal(isClientError, StowiseExceptionHandler.IsClientError(exception));
    }

    private static async Task<(int Status, JsonElement Body)> HandleAsync(Exception exception, string environment = "Production")
    {
        var services = new ServiceCollection()
            .AddLogging()
            .AddSingleton<IHostEnvironment>(new TestEnvironment(environment))
            .AddStowiseProblemDetails()
            .BuildServiceProvider();

        await using var body = new MemoryStream();
        var http = new DefaultHttpContext { RequestServices = services };
        http.Response.Body = body;

        var handler = ActivatorUtilities.CreateInstance<StowiseExceptionHandler>(services);
        var handled = await handler.TryHandleAsync(http, exception, CancellationToken.None);

        Assert.True(handled);
        body.Position = 0;
        using var json = await JsonDocument.ParseAsync(body);
        return (http.Response.StatusCode, json.RootElement.Clone());
    }

    private sealed class TestEnvironment(string name) : IHostEnvironment
    {
        public string EnvironmentName { get; set; } = name;

        public string ApplicationName { get; set; } = "Stowise.Api";

        public string ContentRootPath { get; set; } = AppContext.BaseDirectory;

        public Microsoft.Extensions.FileProviders.IFileProvider ContentRootFileProvider { get; set; } =
            new Microsoft.Extensions.FileProviders.NullFileProvider();
    }
}
