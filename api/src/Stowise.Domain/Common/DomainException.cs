namespace Stowise.Domain.Common;

/// <summary>Violação de uma regra de negócio. A mensagem é exibida ao usuário.</summary>
public class DomainException : Exception
{
    public DomainException()
    {
    }

    public DomainException(string message)
        : base(message)
    {
    }

    public DomainException(string message, Exception innerException)
        : base(message, innerException)
    {
    }
}
