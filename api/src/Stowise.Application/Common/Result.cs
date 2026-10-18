namespace Stowise.Application.Common;

public enum ErrorType
{
    /// <summary>Dados de entrada inválidos (HTTP 400).</summary>
    Validation,

    /// <summary>Recurso inexistente (HTTP 404).</summary>
    NotFound,

    /// <summary>Conflito com o estado atual, como um valor único duplicado (HTTP 409).</summary>
    Conflict,

    /// <summary>Dados válidos, mas a operação viola uma regra de negócio (HTTP 422).</summary>
    BusinessRule,

    /// <summary>Limite de uso atingido, como a cota de IA (HTTP 429). O cliente trata como caso normal, não como erro.</summary>
    TooManyRequests,
}

/// <summary>Falha esperada de um caso de uso. A mensagem é exibida ao usuário.</summary>
public sealed record AppError(ErrorType Type, string Message, IReadOnlyDictionary<string, string[]>? Fields = null)
{
    public static AppError Validation(IReadOnlyDictionary<string, string[]> fields) =>
        new(ErrorType.Validation, "Um ou mais campos são inválidos.", fields);

    public static AppError Validation(string field, string message) =>
        Validation(new Dictionary<string, string[]> { [field] = [message] });

    public static AppError NotFound(string message) => new(ErrorType.NotFound, message);

    public static AppError Conflict(string message) => new(ErrorType.Conflict, message);

    public static AppError BusinessRule(string message) => new(ErrorType.BusinessRule, message);

    public static AppError TooManyRequests(string message) => new(ErrorType.TooManyRequests, message);
}

public class Result
{
    protected Result(AppError? error)
    {
        Error = error;
    }

    public AppError? Error { get; }

    public bool IsSuccess => Error is null;

    public static Result Success() => new(null);

    public static Result Failure(AppError error) => new(error);

    public static implicit operator Result(AppError error) => Failure(error);
}

public sealed class Result<T> : Result
{
    private readonly T? _value;

    private Result(T? value, AppError? error)
        : base(error)
    {
        _value = value;
    }

    public T Value => IsSuccess ? _value! : throw new InvalidOperationException("A failed result has no value.");

    public static implicit operator Result<T>(T value) => new(value, null);

    public static implicit operator Result<T>(AppError error) => new(default, error);
}
