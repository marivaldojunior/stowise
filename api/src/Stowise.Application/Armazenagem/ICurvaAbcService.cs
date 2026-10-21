namespace Stowise.Application.Armazenagem;

/// <summary>
/// Recálculo da curva ABC (SPEC, 2.3): roda todo dia num job recorrente e pode ser pedido pela Gestão. O giro é o
/// número de saídas de cada produto na janela, e não a quantidade: produtos têm unidades diferentes, e o que pesa na
/// distância até a expedição é quantas vezes o produto é separado.
/// </summary>
public interface ICurvaAbcService
{
    Task<ResumoCurvaAbc> RecalcularAsync(CancellationToken cancellationToken = default);
}

/// <param name="Desde">Início da janela de saídas (UTC).</param>
/// <param name="Alterados">Produtos que mudaram de classe nesta rodada.</param>
public sealed record ResumoCurvaAbc(DateTimeOffset Desde, int ClasseA, int ClasseB, int ClasseC, int Alterados);
