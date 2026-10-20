namespace Stowise.Domain.Catalogo;

/// <summary>
/// Situação do cadastro. Incompleto: falta peso ou medida em alguma embalagem (a NF-e não traz esses dados); o produto
/// entra na fila de cadastros incompletos. O SPEC chama o estado completo de "Ativo"; aqui é Completo, para não
/// confundir com <see cref="Produto.Ativo"/>.
/// </summary>
public enum StatusCadastro
{
    Incompleto,
    Completo,
}
