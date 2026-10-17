using Stowise.Domain.Common;

namespace Stowise.Domain.Estrutura;

/// <summary>Faixa inclusiva de coordenadas (ex.: módulos 1 a 10).</summary>
public sealed record Faixa(int Inicio, int Fim)
{
    public int Quantidade => Fim - Inicio + 1;

    public IEnumerable<int> Valores() => Enumerable.Range(Inicio, Quantidade);
}

/// <summary>
/// Plano de geração em lote: cada combinação rua × módulo × nível × posição vira um endereço.
/// </summary>
/// <param name="DistanciaBase">Distância até a expedição, em metros, do primeiro módulo de cada rua.</param>
/// <param name="DistanciaPorModulo">Metros somados a cada módulo depois do primeiro.</param>
public sealed record PlanoGeracaoEnderecos(
    IReadOnlyList<string> Ruas,
    Faixa Modulos,
    Faixa Niveis,
    Faixa Posicoes,
    decimal CapacidadePesoKg,
    decimal AlturaCm,
    decimal LarguraCm,
    decimal ProfundidadeCm,
    decimal DistanciaBase,
    decimal DistanciaPorModulo)
{
    public const int MaxEnderecos = 5000;

    public int Total => Ruas.Count * Modulos.Quantidade * Niveis.Quantidade * Posicoes.Quantidade;
}

public static class GeradorEnderecos
{
    /// <summary>Gera os endereços na ordem rua, módulo, nível e posição. Não grava nada.</summary>
    public static IReadOnlyList<Endereco> Gerar(Zona zona, PlanoGeracaoEnderecos plano)
    {
        ArgumentNullException.ThrowIfNull(zona);
        ArgumentNullException.ThrowIfNull(plano);

        if (plano.Ruas.Count == 0)
        {
            throw new DomainException("Informe ao menos uma rua.");
        }

        foreach (var faixa in new[] { plano.Modulos, plano.Niveis, plano.Posicoes })
        {
            if (faixa.Fim < faixa.Inicio)
            {
                throw new DomainException("O fim de cada faixa deve ser maior ou igual ao início.");
            }
        }

        if (plano.Total > PlanoGeracaoEnderecos.MaxEnderecos)
        {
            throw new DomainException($"O lote geraria {plano.Total} endereços; o limite é {PlanoGeracaoEnderecos.MaxEnderecos}.");
        }

        if (plano.DistanciaPorModulo < 0)
        {
            throw new DomainException("A distância por módulo não pode ser negativa.");
        }

        var enderecos = new List<Endereco>(plano.Total);
        foreach (var rua in plano.Ruas.Select(r => r.Trim().ToUpperInvariant()).Distinct(StringComparer.Ordinal))
        {
            foreach (var modulo in plano.Modulos.Valores())
            {
                var dimensoes = new DimensoesEndereco(
                    plano.CapacidadePesoKg,
                    plano.AlturaCm,
                    plano.LarguraCm,
                    plano.ProfundidadeCm,
                    plano.DistanciaBase + ((modulo - plano.Modulos.Inicio) * plano.DistanciaPorModulo));

                foreach (var nivel in plano.Niveis.Valores())
                {
                    foreach (var posicao in plano.Posicoes.Valores())
                    {
                        enderecos.Add(Endereco.Create(zona, rua, modulo, nivel, posicao, dimensoes));
                    }
                }
            }
        }

        return enderecos;
    }
}
