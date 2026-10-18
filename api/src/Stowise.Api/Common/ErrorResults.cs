using Microsoft.AspNetCore.Http.HttpResults;
using Stowise.Application.Common;

namespace Stowise.Api.Common;

/// <summary>Converte falhas de caso de uso em ProblemDetails com o status HTTP correspondente.</summary>
public static class ErrorResults
{
    public static IResult ToProblem(this AppError error)
    {
        ArgumentNullException.ThrowIfNull(error);

        return error.Type switch
        {
            ErrorType.Validation => TypedResults.ValidationProblem(
                error.Fields?.ToDictionary(f => f.Key, f => f.Value) ?? [],
                title: error.Message),
            ErrorType.NotFound => Problem(error, StatusCodes.Status404NotFound),
            ErrorType.Conflict => Problem(error, StatusCodes.Status409Conflict),
            ErrorType.BusinessRule => Problem(error, StatusCodes.Status422UnprocessableEntity),
            ErrorType.TooManyRequests => Problem(error, StatusCodes.Status429TooManyRequests),
            _ => throw new ArgumentOutOfRangeException(nameof(error), error.Type, "Unknown error type."),
        };
    }

    public static IResult ToHttpResult<T>(this Result<T> result, Func<T, IResult> onSuccess)
    {
        ArgumentNullException.ThrowIfNull(result);
        ArgumentNullException.ThrowIfNull(onSuccess);

        return result.IsSuccess ? onSuccess(result.Value) : result.Error!.ToProblem();
    }

    public static IResult ToNoContent(this Result result)
    {
        ArgumentNullException.ThrowIfNull(result);

        return result.IsSuccess ? TypedResults.NoContent() : result.Error!.ToProblem();
    }

    private static ProblemHttpResult Problem(AppError error, int statusCode) =>
        TypedResults.Problem(title: error.Message, statusCode: statusCode);
}
