namespace Stowise.Infrastructure.Persistence;

/// <summary>Escapa os curingas do LIKE/ILIKE para buscar o texto digitado de forma literal.</summary>
internal static class LikePattern
{
    public const string EscapeCharacter = @"\";

    public static string Escape(string value) =>
        value.Replace(@"\", @"\\", StringComparison.Ordinal)
            .Replace("%", @"\%", StringComparison.Ordinal)
            .Replace("_", @"\_", StringComparison.Ordinal);
}
