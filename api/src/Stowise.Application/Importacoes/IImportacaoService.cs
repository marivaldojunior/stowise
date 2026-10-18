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

    /// <summary>
    /// Confirma o mapeamento de colunas e valida as linhas (staging), deixando a importação em revisão. Com <see cref="ConfirmarMapeamento.SalvarTemplate"/>, cria ou atualiza o
    /// template do fingerprint; sem ele, só conta o uso do template sugerido, se o mapeamento for o mesmo.
    /// Exige a <see cref="ImportacaoDetalhe.Versao"/> lida.
    /// </summary>
    Task<Result<ImportacaoDetalhe>> ConfirmarMapeamentoAsync(Guid id, ConfirmarMapeamento comando, Guid usuarioId, CancellationToken cancellationToken = default);

    Task<Result<ImportacaoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>Linhas do staging na ordem do arquivo, com filtro por status e ação.</summary>
    Task<Result<PagedResult<ImportacaoLinhaDetalhe>>> ListLinhasAsync(Guid id, LinhaFiltro filtro, CancellationToken cancellationToken = default);

    /// <summary>Importações mais recentes primeiro.</summary>
    Task<PagedResult<ImportacaoResumo>> ListAsync(ImportacaoFiltro filtro, CancellationToken cancellationToken = default);
}

public sealed record ReceberArquivo(TipoImportacao Tipo, string? NomeArquivo, byte[]? Conteudo);

/// <param name="NomeTemplate">Nome do template novo; sem ele, vale o nome do arquivo sem a extensão.</param>
public sealed record ConfirmarMapeamento(
    IReadOnlyList<MapeamentoColuna>? Colunas,
    uint? Versao,
    bool SalvarTemplate = false,
    string? NomeTemplate = null);

public sealed record LinhaFiltro(StatusLinha? Status, AcaoLinha? Acao, int? Pagina, int? TamanhoPagina);

public sealed record ImportacaoLinhaDetalhe(
    Guid Id,
    int NumeroLinha,
    IReadOnlyList<string> DadosBrutos,
    IReadOnlyDictionary<string, string?> DadosNormalizados,
    StatusLinha Status,
    AcaoLinha Acao,
    Guid? ProdutoCorrespondenteId,
    decimal? Similaridade,
    IReadOnlyList<ErroLinha> Erros);

public sealed record ImportacaoFiltro(TipoImportacao? Tipo, StatusImportacao? Status, int? Pagina, int? TamanhoPagina);

public sealed record ImportacaoResumo(
    Guid Id,
    TipoImportacao Tipo,
    FormatoArquivo Formato,
    StatusImportacao Status,
    string NomeArquivo,
    int TotalLinhas,
    int LinhasValidas,
    int LinhasComErro,
    Guid UsuarioId,
    DateTimeOffset IniciadoEm,
    DateTimeOffset? ConcluidoEm);

/// <param name="Mapeamento">Sugestão enquanto <paramref name="MapeamentoConfirmadoPor"/> é nulo; depois, o confirmado.</param>
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
    DateTimeOffset? ConcluidoEm,
    string? Fingerprint,
    Guid? TemplateId,
    IReadOnlyList<MapeamentoColuna>? Mapeamento,
    Guid? MapeamentoConfirmadoPor,
    DateTimeOffset? MapeamentoConfirmadoEm,
    int LinhasValidas,
    int LinhasComErro,
    int LinhasPossivelDuplicata,
    string? MotivoFalha,
    uint Versao);

/// <summary>Templates aprendidos nas confirmações de mapeamento. Não há criação direta: o template nasce de uma importação.</summary>
public interface ITemplateImportacaoService
{
    Task<PagedResult<TemplateDetalhe>> ListAsync(TemplateFiltro filtro, CancellationToken cancellationToken = default);

    Task<Result<TemplateDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default);

    /// <summary>Exige a <see cref="TemplateDetalhe.Versao"/> lida.</summary>
    Task<Result<TemplateDetalhe>> RenameAsync(Guid id, RenomearTemplate comando, CancellationToken cancellationToken = default);

    /// <summary>As importações que usaram o template continuam com o mapeamento confirmado.</summary>
    Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default);
}

public sealed record TemplateFiltro(TipoImportacao? Tipo, int? Pagina, int? TamanhoPagina);

public sealed record RenomearTemplate(string? Nome, uint? Versao);

public sealed record TemplateDetalhe(
    Guid Id,
    TipoImportacao Tipo,
    string Nome,
    string Fingerprint,
    FormatoArquivo Formato,
    string? Encoding,
    string? Delimitador,
    string SeparadorDecimal,
    IReadOnlyList<MapeamentoColuna> Mapeamento,
    bool SugeridoPorIa,
    Guid ConfirmadoPor,
    DateTimeOffset ConfirmadoEm,
    int VezesUsado,
    DateTimeOffset UltimoUsoEm,
    uint Versao);
