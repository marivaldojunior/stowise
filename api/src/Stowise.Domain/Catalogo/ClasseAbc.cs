namespace Stowise.Domain.Catalogo;

/// <summary>
/// Giro do produto na curva ABC: A gira mais e fica perto da expedição; C gira menos. Produto novo entra como C até
/// o job de recálculo.
/// </summary>
public enum ClasseAbc
{
    A,
    B,
    C,
}
