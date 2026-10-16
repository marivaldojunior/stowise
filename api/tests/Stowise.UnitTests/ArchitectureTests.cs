using System.Reflection;

namespace Stowise.UnitTests;

public class ArchitectureTests
{
    private static string[] StowiseReferences(Assembly assembly) =>
        [.. assembly.GetReferencedAssemblies()
            .Select(a => a.Name!)
            .Where(n => n.StartsWith("Stowise.", StringComparison.Ordinal))];

    [Fact]
    public void Domain_does_not_depend_on_other_layers()
    {
        Assert.Empty(StowiseReferences(Domain.AssemblyReference.Assembly));
    }

    [Fact]
    public void Application_depends_only_on_Domain()
    {
        var references = StowiseReferences(Application.AssemblyReference.Assembly);

        Assert.All(references, r => Assert.Equal("Stowise.Domain", r));
    }
}
