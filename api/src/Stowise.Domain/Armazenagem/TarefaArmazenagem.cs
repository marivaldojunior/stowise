using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using Stowise.Domain.Common;
using Stowise.Domain.Recebimentos;

namespace Stowise.Domain.Armazenagem;

public enum StatusTarefaArmazenagem
{
    /// <summary>Esperando o operador guardar a mercadoria.</summary>
    Pendente,

    /// <summary>Guardada no endereço sugerido.</summary>
    Concluida,

    /// <summary>Guardada em outro endereço, com o motivo.</summary>
    Divergente,
}

/// <summary>
/// Guardar a quantidade contada de um item (e lote) do recebimento (SPEC, seção 4). A sugestão do motor fica em
/// snapshot (<see cref="Notas"/> e <see cref="RegrasVersao"/>), para explicar a escolha depois que os pesos mudam.
/// A entrada no estoque acontece na confirmação, pelo serviço de movimentação.
/// </summary>
public sealed class TarefaArmazenagem : Entity
{
    public const int MotivoDivergenciaMaxLength = 250;
    public const int RegrasVersaoLength = 12;

    private TarefaArmazenagem()
    {
    }

    public Guid RecebimentoId { get; private set; }

    public Guid RecebimentoItemId { get; private set; }

    public Guid ProdutoId { get; private set; }

    /// <summary>Lote contado na conferência; nulo para produto sem lote.</summary>
    public string? LoteNumero { get; private set; }

    public DateOnly? LoteFabricacao { get; private set; }

    public DateOnly? LoteValidade { get; private set; }

    /// <summary>Na unidade base.</summary>
    public decimal Quantidade { get; private set; }

    /// <summary>Nulo quando nenhum endereço passou pelas restrições (zona e capacidade).</summary>
    public Guid? EnderecoSugeridoId { get; private set; }

    /// <summary>Pontuação do endereço sugerido, de 0 a 100.</summary>
    public decimal? Pontuacao { get; private set; }

    /// <summary>Snapshot: nota, peso e explicação de cada regra para o endereço sugerido (o <c>PontuacaoJson</c> do SPEC).</summary>
    public IReadOnlyList<NotaRegra> Notas { get; private set; } = [];

    /// <summary>Resumo da configuração das regras usada na sugestão (ver <see cref="VersaoDe"/>).</summary>
    public string RegrasVersao { get; private set; } = null!;

    public StatusTarefaArmazenagem Status { get; private set; }

    public Guid? EnderecoConfirmadoId { get; private set; }

    public string? MotivoDivergencia { get; private set; }

    /// <summary>Entrada no estoque feita na confirmação.</summary>
    public Guid? MovimentacaoId { get; private set; }

    public Guid? ConcluidoPor { get; private set; }

    public DateTimeOffset CriadoEm { get; private set; }

    public DateTimeOffset? ConcluidoEm { get; private set; }

    public uint Versao { get; private set; }

    /// <param name="lote">Lote contado, com a quantidade na unidade base; nulo para produto sem lote.</param>
    /// <param name="quantidade">Na unidade base.</param>
    /// <param name="sugestao">Melhor endereço do motor; nulo quando nenhum endereço serve.</param>
    public static TarefaArmazenagem Create(
        RecebimentoItem item,
        LoteRecebido? lote,
        decimal quantidade,
        SugestaoEndereco? sugestao,
        string regrasVersao,
        DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(item);
        ArgumentException.ThrowIfNullOrWhiteSpace(regrasVersao);
        return new TarefaArmazenagem
        {
            RecebimentoId = item.RecebimentoId,
            RecebimentoItemId = item.Id,
            ProdutoId = item.ProdutoId,
            LoteNumero = lote?.Numero,
            LoteFabricacao = lote?.Fabricacao,
            LoteValidade = lote?.Validade,
            Quantidade = Guard.Positive(quantidade, "Quantidade a armazenar"),
            EnderecoSugeridoId = sugestao?.EnderecoId,
            Pontuacao = sugestao?.Pontuacao,
            Notas = sugestao?.Notas ?? [],
            RegrasVersao = regrasVersao,
            Status = StatusTarefaArmazenagem.Pendente,
            CriadoEm = agora.ToUniversalTime(),
        };
    }

    /// <summary>
    /// Confere a confirmação antes da entrada no estoque: a tarefa está pendente e, fora do endereço sugerido, o motivo
    /// é obrigatório.
    /// </summary>
    /// <returns>O motivo normalizado; nulo no endereço sugerido.</returns>
    public string? EnsureConfirmavel(Guid enderecoId, string? motivoDivergencia)
    {
        if (Status != StatusTarefaArmazenagem.Pendente)
        {
            throw new DomainException("Esta tarefa de armazenagem já foi concluída.");
        }

        if (enderecoId == EnderecoSugeridoId)
        {
            return null;
        }

        return string.IsNullOrWhiteSpace(motivoDivergencia)
            ? throw new DomainException("Informe o motivo de guardar fora do endereço sugerido.")
            : Guard.Required(motivoDivergencia, "Motivo da divergência", MotivoDivergenciaMaxLength);
    }

    /// <summary>A mercadoria foi guardada: grava o endereço, a entrada no estoque e, fora da sugestão, a divergência.</summary>
    public void Confirm(Guid enderecoId, string? motivoDivergencia, Guid movimentacaoId, Guid usuarioId, DateTimeOffset agora)
    {
        var motivo = EnsureConfirmavel(enderecoId, motivoDivergencia);
        Status = motivo is null ? StatusTarefaArmazenagem.Concluida : StatusTarefaArmazenagem.Divergente;
        EnderecoConfirmadoId = enderecoId;
        MotivoDivergencia = motivo;
        MovimentacaoId = movimentacaoId;
        ConcluidoPor = usuarioId;
        ConcluidoEm = agora.ToUniversalTime();
    }

    /// <summary>
    /// Resumo curto e estável da configuração (código, peso, estado e parâmetros de cada regra, em ordem): duas tarefas
    /// com a mesma versão foram pontuadas com os mesmos pesos.
    /// </summary>
    public static string VersaoDe(IEnumerable<ConfiguracaoRegra> configuracao)
    {
        ArgumentNullException.ThrowIfNull(configuracao);
        var texto = new StringBuilder();
        foreach (var regra in configuracao.OrderBy(r => r.Codigo, StringComparer.Ordinal))
        {
            texto.Append(CultureInfo.InvariantCulture, $"{regra.Codigo}:{regra.Peso:0.####}:{regra.Ativa}");
            foreach (var (nome, valor) in regra.Parametros.OrderBy(p => p.Key, StringComparer.Ordinal))
            {
                texto.Append(CultureInfo.InvariantCulture, $":{nome}={valor:0.####}");
            }

            texto.Append(';');
        }

        var hash = SHA256.HashData(Encoding.UTF8.GetBytes(texto.ToString()));
        return Convert.ToHexStringLower(hash)[..RegrasVersaoLength];
    }
}
