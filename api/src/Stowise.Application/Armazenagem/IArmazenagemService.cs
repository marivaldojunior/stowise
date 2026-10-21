using Stowise.Application.Common;
using Stowise.Domain.Armazenagem;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estrutura;

namespace Stowise.Application.Armazenagem;

/// <summary>
/// Motor de armazenagem (SPEC, 2.3): sugere endereços para guardar um produto e mantém os pesos das regras. Só
/// sugere: nada é gravado no estoque aqui.
/// </summary>
public interface IArmazenagemService
{
    Task<Result<SugestaoArmazenagem>> SugerirAsync(PedidoSugestaoArmazenagem pedido, CancellationToken cancellationToken = default);

    Task<IReadOnlyList<RegraArmazenagemDetalhe>> ListRegrasAsync(CancellationToken cancellationToken = default);

    Task<Result<RegraArmazenagemDetalhe>> UpdateRegraAsync(
        string codigo,
        AlterarRegraArmazenagem comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default);
}

/// <param name="EmbalagemId">Embalagem da quantidade; sem ela, a quantidade já está na unidade base.</param>
/// <param name="LoteId">Lote já cadastrado; a validade vem dele.</param>
/// <param name="Validade">Validade de um lote que ainda não existe (ex.: o lote da nota antes da entrada).</param>
/// <param name="ArmazemId">Sem ele, os endereços de todos os armazéns são candidatos.</param>
/// <param name="Limite">Quantas sugestões devolver (padrão 5, máximo 20).</param>
public sealed record PedidoSugestaoArmazenagem(
    Guid? ProdutoId,
    Guid? EmbalagemId,
    decimal? Quantidade,
    Guid? LoteId,
    DateOnly? Validade,
    Guid? ArmazemId,
    int? Limite);

/// <param name="Quantidade">Na unidade base.</param>
/// <param name="PesoKg">Peso da carga; nulo quando o cadastro não tem o peso.</param>
/// <param name="VolumeCm3">Volume da carga; nulo quando o cadastro não tem as medidas.</param>
/// <param name="Descartados">Os primeiros endereços recusados por zona ou capacidade (até 20), com os motivos.</param>
public sealed record SugestaoArmazenagem(
    Guid ProdutoId,
    string Sku,
    ClasseArmazenagem ClasseArmazenagem,
    ClasseAbc ClasseAbc,
    decimal Quantidade,
    DateOnly? Validade,
    decimal? PesoKg,
    decimal? VolumeCm3,
    int TotalCandidatos,
    IReadOnlyList<SugestaoEndereco> Sugestoes,
    int TotalDescartados,
    IReadOnlyList<EnderecoDescartado> Descartados);

/// <param name="Restritiva">Recusa endereços (zona e capacidade) mesmo inativa.</param>
/// <param name="ParametrosPadrao">Parâmetros que a regra aceita, com o valor usado quando falta na configuração.</param>
public sealed record RegraArmazenagemDetalhe(
    Guid Id,
    string Codigo,
    bool Restritiva,
    decimal Peso,
    bool Ativa,
    IReadOnlyDictionary<string, decimal> Parametros,
    IReadOnlyDictionary<string, decimal> ParametrosPadrao,
    DateTimeOffset? AtualizadoEm,
    Guid? AtualizadoPor,
    uint Versao);

/// <param name="Peso">De 0 a 100; 0 tira a regra da nota.</param>
/// <param name="Parametros">Substitui os parâmetros gravados; os que faltam usam o valor padrão ({} volta todos ao padrão).</param>
/// <param name="Versao">Versão lida da regra.</param>
public sealed record AlterarRegraArmazenagem(decimal? Peso, bool? Ativa, IReadOnlyDictionary<string, decimal> Parametros, uint? Versao);
