using Microsoft.EntityFrameworkCore;
using Npgsql;
using NpgsqlTypes;
using Stowise.Application.Importacoes;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Persistence;
using Stowise.Infrastructure.Persistence.Configurations;

namespace Stowise.Infrastructure.Importacoes;

/// <summary>
/// Monta o staging de uma importação de produtos: lê o arquivo guardado com o layout e o mapeamento confirmados,
/// normaliza cada linha e cruza com o catálogo (SKU e GTIN existentes, categoria por nome). Roda no job de
/// background: apaga as linhas de uma execução anterior e grava as novas em lotes com COPY, salvando o progresso
/// a cada lote. Uma repetição do job recomeça do zero, então o resultado não depende de quantas vezes rodou.
/// Quem chama salva o resultado final (<see cref="Importacao.CompleteValidacao"/>).
/// </summary>
internal sealed class StagingProdutos(StowiseDbContext db)
{
    /// <summary>Tamanho dos lotes de SKU e GTIN nas consultas ao catálogo (limite prático de parâmetros do IN).</summary>
    private const int LoteConsulta = 1000;

    /// <summary>Linhas por COPY; também é o passo do progresso.</summary>
    public const int LoteGravacao = 5000;

    /// <param name="aoAvancar">Chamado depois de cada lote gravado, com o progresso já salvo.</param>
    public async Task BuildAsync(Importacao importacao, Func<Importacao, CancellationToken, Task> aoAvancar, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(aoAvancar);
        ArgumentNullException.ThrowIfNull(importacao);

        var conteudo = await db.ArquivosImportacao.AsNoTracking()
            .Where(a => a.ImportacaoId == importacao.Id)
            .Select(a => a.Conteudo)
            .SingleAsync(cancellationToken);
        var layout = importacao.Layout;
        var registros = layout.Formato == FormatoArquivo.Excel
            ? LeitorXlsx.ReadRows(conteudo, layout)
            : [.. DetectorLayout.ReadRows(conteudo, layout)];

        var mapeamento = importacao.Mapeamento ?? throw new InvalidOperationException("The mapping must be confirmed before staging.");
        var normalizadas = registros
            .Select(r => (Brutos: r, Linha: NormalizadorProdutos.Normalize(r, mapeamento, layout.SeparadorDecimal, importacao.Regras)))
            .ToList();

        var skus = await ExistingAsync(
            normalizadas.Select(n => n.Linha.Dados["sku"]),
            lote => db.Produtos.Where(p => lote.Contains(p.Sku)).Select(p => new KeyValuePair<string, Guid>(p.Sku, p.Id)),
            cancellationToken);
        var gtins = await ExistingAsync(
            normalizadas.Select(n => n.Linha.Dados.GetValueOrDefault("gtin")),
            lote => db.ProdutoEmbalagens.Where(e => e.Gtin != null && lote.Contains(e.Gtin)).Select(e => new KeyValuePair<string, Guid>(e.Gtin!, e.ProdutoId)),
            cancellationToken);
        var categorias = (await db.Categorias.AsNoTracking().Select(c => new { c.Id, c.Nome }).ToListAsync(cancellationToken))
            .GroupBy(c => FingerprintLayout.Normalize(c.Nome))
            .ToDictionary(g => g.Key, g => g.Select(c => c.Id).ToList(), StringComparer.Ordinal);

        await db.ImportacaoLinhas.Where(l => l.ImportacaoId == importacao.Id).ExecuteDeleteAsync(cancellationToken);

        var lote = new List<ImportacaoLinha>(LoteGravacao);
        var primeiraLinhaDoSku = new Dictionary<string, int>(StringComparer.Ordinal);
        var primeiraLinhaDoGtin = new Dictionary<string, int>(StringComparer.Ordinal);
        int validas = 0, comErro = 0, duplicatas = 0;
        for (var i = 0; i < normalizadas.Count; i++)
        {
            var numero = i + 1;
            var (brutos, linha) = normalizadas[i];
            var dados = new Dictionary<string, string?>(linha.Dados, StringComparer.Ordinal);
            var erros = new List<ErroLinha>(linha.Erros);

            var sku = dados["sku"]!;
            if (sku.Length > 0 && !primeiraLinhaDoSku.TryAdd(sku, numero))
            {
                erros.Add(new ErroLinha("sku", $"SKU {sku} repetido no arquivo (já aparece na linha {primeiraLinhaDoSku[sku]})."));
            }

            var gtin = dados.GetValueOrDefault("gtin");
            if (gtin is not null && !primeiraLinhaDoGtin.TryAdd(gtin, numero))
            {
                erros.Add(new ErroLinha("gtin", $"GTIN {gtin} repetido no arquivo (já aparece na linha {primeiraLinhaDoGtin[gtin]})."));
            }

            if (dados.GetValueOrDefault("categoria") is { } categoria)
            {
                dados["categoriaId"] = categorias.GetValueOrDefault(FingerprintLayout.Normalize(categoria)) switch
                {
                    [var id] => id.ToString(),
                    null => Erro(erros, "categoria", $"Categoria {categoria} não existe. Cadastre a categoria ou deixe o campo vazio."),
                    _ => Erro(erros, "categoria", $"Há mais de uma categoria chamada {categoria}. Ajuste os nomes no cadastro."),
                };
            }

            var nova = ImportacaoLinha.Create(
                importacao.Id,
                numero,
                brutos,
                dados,
                erros,
                skus.TryGetValue(sku, out var mesmoSku) ? mesmoSku : null,
                gtin is not null && gtins.TryGetValue(gtin, out var mesmoGtin) ? mesmoGtin : null);
            lote.Add(nova);

            switch (nova.Status)
            {
                case StatusLinha.Valida:
                    validas++;
                    break;
                case StatusLinha.PossivelDuplicata:
                    duplicatas++;
                    break;
                default:
                    comErro++;
                    break;
            }

            if (lote.Count == LoteGravacao && numero < normalizadas.Count)
            {
                await CopyAsync(lote, cancellationToken);
                importacao.ReportProgress(numero);
                await db.SaveChangesAsync(cancellationToken);
                await aoAvancar(importacao, cancellationToken);
            }
        }

        await CopyAsync(lote, cancellationToken);
        importacao.CompleteValidacao(validas, comErro, duplicatas);
    }

    /// <summary>
    /// Grava o lote com COPY binário (muito mais rápido que INSERT para milhares de linhas). Os nomes de tabela e
    /// colunas vêm do modelo do EF, e o JSON é o mesmo das colunas <c>jsonb</c> mapeadas.
    /// </summary>
    private async Task CopyAsync(List<ImportacaoLinha> lote, CancellationToken cancellationToken)
    {
        if (lote.Count == 0)
        {
            return;
        }

        var entidade = db.Model.FindEntityType(typeof(ImportacaoLinha))!;
        string Coluna(string propriedade) => entidade.FindProperty(propriedade)!.GetColumnName();
        string[] colunas =
        [
            Coluna(nameof(ImportacaoLinha.Id)), Coluna(nameof(ImportacaoLinha.ImportacaoId)), Coluna(nameof(ImportacaoLinha.NumeroLinha)),
            Coluna(nameof(ImportacaoLinha.DadosBrutos)), Coluna(nameof(ImportacaoLinha.DadosNormalizados)), Coluna(nameof(ImportacaoLinha.Status)),
            Coluna(nameof(ImportacaoLinha.Acao)), Coluna(nameof(ImportacaoLinha.ProdutoCorrespondenteId)), Coluna(nameof(ImportacaoLinha.Similaridade)),
            Coluna(nameof(ImportacaoLinha.Erros)),
        ];

        await db.Database.OpenConnectionAsync(cancellationToken);
        try
        {
            var conexao = (NpgsqlConnection)db.Database.GetDbConnection();
            await using var copy = await conexao.BeginBinaryImportAsync(
                $"COPY {entidade.GetTableName()} ({string.Join(", ", colunas)}) FROM STDIN (FORMAT BINARY)",
                cancellationToken);
            foreach (var linha in lote)
            {
                await copy.StartRowAsync(cancellationToken);
                await copy.WriteAsync(linha.Id, NpgsqlDbType.Uuid, cancellationToken);
                await copy.WriteAsync(linha.ImportacaoId, NpgsqlDbType.Uuid, cancellationToken);
                await copy.WriteAsync(linha.NumeroLinha, NpgsqlDbType.Integer, cancellationToken);
                await copy.WriteAsync(JsonColumn.Serialize(linha.DadosBrutos), NpgsqlDbType.Jsonb, cancellationToken);
                await copy.WriteAsync(JsonColumn.Serialize(linha.DadosNormalizados), NpgsqlDbType.Jsonb, cancellationToken);
                await copy.WriteAsync(linha.Status.ToString(), NpgsqlDbType.Varchar, cancellationToken);
                await copy.WriteAsync(linha.Acao.ToString(), NpgsqlDbType.Varchar, cancellationToken);
                await WriteNullableAsync(copy, linha.ProdutoCorrespondenteId, NpgsqlDbType.Uuid, cancellationToken);
                await WriteNullableAsync(copy, linha.Similaridade, NpgsqlDbType.Numeric, cancellationToken);
                await copy.WriteAsync(JsonColumn.Serialize(linha.Erros), NpgsqlDbType.Jsonb, cancellationToken);
            }

            await copy.CompleteAsync(cancellationToken);
        }
        finally
        {
            await db.Database.CloseConnectionAsync();
        }

        lote.Clear();
    }

    private static async Task WriteNullableAsync<T>(NpgsqlBinaryImporter copy, T? valor, NpgsqlDbType tipo, CancellationToken cancellationToken)
        where T : struct
    {
        if (valor is { } presente)
        {
            await copy.WriteAsync(presente, tipo, cancellationToken);
        }
        else
        {
            await copy.WriteNullAsync(cancellationToken);
        }
    }

    private static string? Erro(List<ErroLinha> erros, string campo, string mensagem)
    {
        erros.Add(new ErroLinha(campo, mensagem));
        return null;
    }

    /// <summary>Valores já cadastrados, consultados em lotes. Com valores repetidos no banco, vale o primeiro.</summary>
    private static async Task<Dictionary<string, Guid>> ExistingAsync(
        IEnumerable<string?> valores,
        Func<List<string>, IQueryable<KeyValuePair<string, Guid>>> consulta,
        CancellationToken cancellationToken)
    {
        var encontrados = new Dictionary<string, Guid>(StringComparer.Ordinal);
        foreach (var lote in valores.OfType<string>().Where(v => v.Length > 0).Distinct(StringComparer.Ordinal).Chunk(LoteConsulta))
        {
            foreach (var (valor, id) in await consulta([.. lote]).ToListAsync(cancellationToken))
            {
                encontrados.TryAdd(valor, id);
            }
        }

        return encontrados;
    }
}
