using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Stowise.Domain.Common;

namespace Stowise.Api.Errors;

/// <summary>
/// Converte exceções em ProblemDetails. Falhas esperadas de caso de uso não chegam aqui:
/// elas voltam como <c>Result</c>. Este handler cobre regras violadas no domínio, requisições
/// malformadas, conflitos de concorrência e erros inesperados (sem expor detalhes internos).
/// </summary>
public sealed class StowiseExceptionHandler(IProblemDetailsService problemDetails, IHostEnvironment environment)
    : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(httpContext);
        ArgumentNullException.ThrowIfNull(exception);

        var problem = exception switch
        {
            DomainException e => Problem(StatusCodes.Status422UnprocessableEntity, e.Message, detail: null),
            BadHttpRequestException e => Problem(
                e.StatusCode,
                "Requisição inválida",
                "O corpo ou os parâmetros da requisição estão em formato inválido."),
            DbUpdateConcurrencyException => Problem(
                StatusCodes.Status409Conflict,
                "Conflito de concorrência",
                "O registro foi alterado por outra operação. Recarregue os dados e tente de novo."),
            _ => Problem(
                StatusCodes.Status500InternalServerError,
                "Erro interno",
                "Ocorreu um erro inesperado. Informe o traceId ao suporte."),
        };

        if (problem.Status >= StatusCodes.Status500InternalServerError && environment.IsDevelopment())
        {
            problem.Extensions["exception"] = $"{exception.GetType().Name}: {exception.Message}";
        }

        httpContext.Response.StatusCode = problem.Status!.Value;
        return await problemDetails.TryWriteAsync(new ProblemDetailsContext
        {
            HttpContext = httpContext,
            Exception = exception,
            ProblemDetails = problem,
        });
    }

    /// <summary>Exceções que viram 4xx não são erros do servidor: o middleware não precisa registrá-las como erro.</summary>
    public static bool IsClientError(Exception exception) =>
        exception is DomainException or BadHttpRequestException or DbUpdateConcurrencyException;

    private static ProblemDetails Problem(int status, string title, string? detail) =>
        new() { Status = status, Title = title, Detail = detail };
}
