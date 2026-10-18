using Stowise.Application.Common;
using Stowise.Domain.Importacoes;

namespace Stowise.Application.Importacoes;

/// <summary>Recebe arquivos de importação e guarda o layout detectado. Nada é gravado no catálogo nesta etapa.</summary>
public interface IImportacaoService
{
    /// <summary>
    /// Detecta encoding, separadores, cabeçalho e colunas, guarda o arquivo original e cria a importação em
    /// <see cref="StatusImportacao.Recebido"/>. O mesmo arquivo de uma importação que não falhou dá conflito.
    /// </summary>
    Task<Result<ImportacaoDetalhe>> ReceberAsync(ReceberArquivo comando, Guid usuarioId, CancellationToken cancellationToken = default);

    Task<Result<ImportacaoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>Importações mais recentes primeiro.</summary>
    Task<PagedResult<ImportacaoResumo>> ListAsync(ImportacaoFiltro filtro, CancellationToken cancellationToken = default);
}

public sealed record ReceberArquivo(TipoImportacao Tipo, string? NomeArquivo, byte[]? Conteudo);

public sealed record ImportacaoFiltro(TipoImportacao? Tipo, StatusImportacao? Status, int? Pagina, int? TamanhoPagina);

public sealed record ImportacaoResumo(
    Guid Id,
    TipoImportacao Tipo,
    FormatoArquivo Formato,
    StatusImportacao Status,
    string NomeArquivo,
    int TotalLinhas,
    Guid UsuarioId,
    DateTimeOffset IniciadoEm,
    DateTimeOffset? ConcluidoEm);

/// <param name="Amostra">Primeiras linhas de dados, sem o cabeçalho, como foram lidas do arquivo.</param>
public sealed record ImportacaoDetalhe(
    Guid Id,
    TipoImportacao Tipo,
    StatusImportacao Status,
    string NomeArquivo,
    string HashArquivo,
    long TamanhoBytes,
    LayoutArquivo Layout,
    IReadOnlyList<IReadOnlyList<string>> Amostra,
    int TotalLinhas,
    Guid UsuarioId,
    DateTimeOffset IniciadoEm,
    DateTimeOffset? ConcluidoEm);
