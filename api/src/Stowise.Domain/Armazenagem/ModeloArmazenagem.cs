using Stowise.Domain.Catalogo;
using Stowise.Domain.Estrutura;

namespace Stowise.Domain.Armazenagem;

/// <summary>O que vai ser guardado, na unidade base.</summary>
/// <param name="PesoKg">Peso total da carga; nulo quando o cadastro não tem o peso.</param>
/// <param name="VolumeCm3">Volume total da carga; nulo quando o cadastro não tem as medidas.</param>
public sealed record ItemArmazenagem(
    Guid ProdutoId,
    ClasseArmazenagem Classe,
    ClasseAbc ClasseAbc,
    Guid? LoteId,
    DateOnly? Validade,
    decimal Quantidade,
    decimal? PesoKg,
    decimal? VolumeCm3);

/// <summary>Estoque que já está num endereço candidato.</summary>
public sealed record OcupacaoEndereco(
    Guid ProdutoId,
    Guid? LoteId,
    DateOnly? Validade,
    decimal Quantidade,
    decimal? PesoKg,
    decimal? VolumeCm3);

/// <summary>Endereço que pode receber o item. Endereços bloqueados não entram como candidatos.</summary>
/// <param name="DistanciaExpedicao">Em metros.</param>
public sealed record CandidatoEndereco(
    Guid EnderecoId,
    string Codigo,
    ClasseArmazenagem ClasseZona,
    decimal CapacidadePesoKg,
    decimal VolumeCm3,
    decimal DistanciaExpedicao,
    IReadOnlyList<OcupacaoEndereco> Ocupacao)
{
    public static CandidatoEndereco From(Endereco endereco, ClasseArmazenagem classeZona, IReadOnlyList<OcupacaoEndereco> ocupacao)
    {
        ArgumentNullException.ThrowIfNull(endereco);
        return new CandidatoEndereco(
            endereco.Id,
            endereco.Codigo,
            classeZona,
            endereco.CapacidadePesoKg,
            endereco.AlturaCm * endereco.LarguraCm * endereco.ProfundidadeCm,
            endereco.DistanciaExpedicao,
            ocupacao);
    }
}

/// <summary>Peso, estado e parâmetros de uma regra, como estão gravados na configuração.</summary>
/// <param name="Peso">Importância da regra na nota final (0 tira a regra da nota).</param>
public sealed record ConfiguracaoRegra(string Codigo, decimal Peso, bool Ativa, IReadOnlyDictionary<string, decimal> Parametros);

/// <summary>Nota de uma regra para um endereço, como fica no snapshot da sugestão.</summary>
/// <param name="Nota">De 0 a 1; nula quando a regra não se aplica ao item.</param>
public sealed record NotaRegra(string Codigo, decimal Peso, bool Ativa, decimal? Nota, string Explicacao);

/// <param name="Pontuacao">De 0 a 100: média das notas das regras ativas, ponderada pelos pesos.</param>
public sealed record SugestaoEndereco(Guid EnderecoId, string Codigo, decimal Pontuacao, IReadOnlyList<NotaRegra> Notas);

/// <summary>Endereço recusado por uma regra restritiva (zona ou capacidade), com os motivos.</summary>
public sealed record EnderecoDescartado(Guid EnderecoId, string Codigo, IReadOnlyList<string> Motivos);

/// <param name="Sugestoes">Da maior para a menor pontuação.</param>
public sealed record ResultadoArmazenagem(IReadOnlyList<SugestaoEndereco> Sugestoes, IReadOnlyList<EnderecoDescartado> Descartados);
