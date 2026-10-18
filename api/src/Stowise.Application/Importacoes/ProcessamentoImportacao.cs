using Stowise.Domain.Importacoes;

namespace Stowise.Application.Importacoes;

/// <summary>
/// Fila de trabalhos em background (ADR-0007). A Application só pede o trabalho; a Infrastructure decide como ele
/// roda (Hangfire). Os argumentos são só ids: o trabalho carrega o estado atual do banco.
/// </summary>
public interface IFilaTrabalhos
{
    /// <summary>Valida as linhas de uma importação em <see cref="StatusImportacao.Validando"/>.</summary>
    void EnfileirarStaging(Guid importacaoId);

    /// <summary>Grava no catálogo as linhas válidas de uma importação em <see cref="StatusImportacao.Efetivando"/>.</summary>
    void EnfileirarEfetivacao(Guid importacaoId);

    /// <summary>Sugestão de mapeamento pela IA para uma importação em <see cref="StatusImportacao.Mapeando"/>.</summary>
    /// <param name="usuarioId">Quem pediu: conta na cota e no registro da chamada.</param>
    void EnfileirarSugestaoMapeamento(Guid importacaoId, Guid usuarioId);
}

/// <summary>Avisa quem acompanha a importação (painel, por SignalR) sobre o andamento.</summary>
public interface INotificadorImportacao
{
    Task NotificarAsync(ProgressoImportacao progresso, CancellationToken cancellationToken = default);
}

/// <param name="LinhasProcessadas">Linhas já validadas nesta etapa; igual a <paramref name="TotalLinhas"/> no fim.</param>
public sealed record ProgressoImportacao(
    Guid Id,
    StatusImportacao Status,
    int TotalLinhas,
    int LinhasProcessadas,
    int LinhasValidas,
    int LinhasComErro,
    int LinhasPossivelDuplicata,
    string? MotivoFalha)
{
    public static ProgressoImportacao From(Importacao importacao)
    {
        ArgumentNullException.ThrowIfNull(importacao);

        return new(
            importacao.Id,
            importacao.Status,
            importacao.TotalLinhas,
            importacao.LinhasProcessadas,
            importacao.LinhasValidas,
            importacao.LinhasComErro,
            importacao.LinhasPossivelDuplicata,
            importacao.MotivoFalha);
    }
}
