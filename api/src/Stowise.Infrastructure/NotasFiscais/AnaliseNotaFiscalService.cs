using Microsoft.EntityFrameworkCore;
using Stowise.Application.Catalogo;
using Stowise.Application.Common;
using Stowise.Application.NotasFiscais;
using Stowise.Domain.Catalogo;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.NotasFiscais;

/// <summary>
/// Casamento dos itens da NF-e com o catálogo: de-para do fornecedor, depois GTIN (cEAN, depois cEANTrib), depois
/// similaridade da descrição. As duas primeiras etapas são consultas em lote; a similaridade roda item a item, só
/// para os que sobraram.
/// </summary>
internal sealed class AnaliseNotaFiscalService(StowiseDbContext db, ILeitorNfe leitor, IBuscaProdutosSimilares similares)
    : IAnaliseNotaFiscal
{
    /// <summary>Candidatos por item na similaridade.</summary>
    public const int SugestoesPorItem = 3;

    public async Task<Result<AnaliseNotaFiscal>> AnalyzeAsync(Stream xml, CancellationToken cancellationToken = default)
    {
        var lida = leitor.Read(xml);
        if (!lida.IsSuccess)
        {
            return lida.Error!;
        }

        var nota = lida.Value;
        var fornecedorId = nota.Emitente.Cnpj is null
            ? (Guid?)null
            : await db.Fornecedores.AsNoTracking()
                .Where(f => f.Cnpj == nota.Emitente.Cnpj)
                .Select(f => (Guid?)f.Id)
                .FirstOrDefaultAsync(cancellationToken);

        var dePara = fornecedorId is null ? [] : await DeParaAsync(fornecedorId.Value, nota.Itens, cancellationToken);
        var porGtin = await PorGtinAsync(nota.Itens, cancellationToken);

        var itens = new List<ItemAnalisado>(nota.Itens.Count);
        foreach (var item in nota.Itens)
        {
            if (dePara.TryGetValue(item.CodigoFornecedor, out var vinculo))
            {
                itens.Add(new ItemAnalisado(item, OrigemCasamento.DePara, vinculo, null, [], RequerConfirmacao: false));
            }
            else if (Gtin14(item.Gtin) is { } gtin && porGtin.TryGetValue(gtin, out var comercial))
            {
                itens.Add(new ItemAnalisado(item, OrigemCasamento.Gtin, comercial, null, [], RequerConfirmacao: true));
            }
            else if (Gtin14(item.GtinTributavel) is { } gtinTrib && porGtin.TryGetValue(gtinTrib, out var tributavel))
            {
                itens.Add(new ItemAnalisado(item, OrigemCasamento.Gtin, tributavel, null, [], RequerConfirmacao: true));
            }
            else
            {
                itens.Add(await SugestoesAsync(item, cancellationToken));
            }
        }

        var emitente = nota.Emitente;
        return new AnaliseNotaFiscal(
            nota.ChaveAcesso,
            nota.Numero,
            nota.Serie,
            nota.DataEmissao,
            nota.Autorizada,
            new FornecedorDaNota(fornecedorId, emitente.Cnpj, emitente.Cpf, emitente.RazaoSocial, emitente.NomeFantasia),
            itens);
    }

    private async Task<ItemAnalisado> SugestoesAsync(ItemNota item, CancellationToken cancellationToken)
    {
        var texto = item.Descricao.Length > LimitesSimilares.TextoMaximo ? item.Descricao[..LimitesSimilares.TextoMaximo] : item.Descricao;
        var busca = await similares.FindAsync(texto, SugestoesPorItem, cancellationToken);
        var encontrados = busca.IsSuccess ? busca.Value : null;
        return encontrados is { Produtos.Count: > 0 }
            ? new ItemAnalisado(item, OrigemCasamento.Similaridade, null, encontrados.Metodo, encontrados.Produtos, RequerConfirmacao: true)
            : new ItemAnalisado(item, OrigemCasamento.SemCandidato, null, encontrados?.Metodo, [], RequerConfirmacao: true);
    }

    private async Task<Dictionary<string, CasamentoItem>> DeParaAsync(Guid fornecedorId, IReadOnlyList<ItemNota> itens, CancellationToken cancellationToken)
    {
        var codigos = itens.Select(i => i.CodigoFornecedor).Distinct().ToList();
        var linhas = await (
            from v in db.ProdutoFornecedores.AsNoTracking().Where(v => v.FornecedorId == fornecedorId && codigos.Contains(v.CodigoFornecedor))
            join p in db.Produtos on v.ProdutoId equals p.Id
            join e in db.ProdutoEmbalagens on v.EmbalagemId equals e.Id
            select new { v.CodigoFornecedor, v.Id, v.ProdutoId, p.Sku, p.Descricao, v.EmbalagemId, e.Tipo, v.FatorConversao })
            .ToListAsync(cancellationToken);

        return linhas.ToDictionary(
            x => x.CodigoFornecedor,
            x => new CasamentoItem(x.ProdutoId, x.Sku, x.Descricao, x.EmbalagemId, x.Tipo, x.FatorConversao, x.Id),
            StringComparer.Ordinal);
    }

    /// <summary>Embalagens por GTIN-14; o cadastro pode guardar o GTIN com 8, 12, 13 ou 14 dígitos.</summary>
    private async Task<Dictionary<string, CasamentoItem>> PorGtinAsync(IReadOnlyList<ItemNota> itens, CancellationToken cancellationToken)
    {
        var formas = itens
            .SelectMany(i => new[] { Gtin14(i.Gtin), Gtin14(i.GtinTributavel) })
            .OfType<string>()
            .Distinct()
            .SelectMany(Gtin.Equivalents)
            .ToList();
        if (formas.Count == 0)
        {
            return [];
        }

        var linhas = await (
            from e in db.ProdutoEmbalagens.AsNoTracking().Where(e => e.Gtin != null && formas.Contains(e.Gtin))
            join p in db.Produtos on e.ProdutoId equals p.Id
            select new { Gtin = e.Gtin!, p.Id, p.Sku, p.Descricao, EmbalagemId = e.Id, e.Tipo, e.FatorConversao })
            .ToListAsync(cancellationToken);

        return linhas
            .GroupBy(x => Gtin.ToGtin14(x.Gtin))
            .ToDictionary(g => g.Key, g =>
            {
                var x = g.First();
                return new CasamentoItem(x.Id, x.Sku, x.Descricao, x.EmbalagemId, x.Tipo, x.FatorConversao, null);
            });
    }

    private static string? Gtin14(string? gtin) => gtin is null ? null : Gtin.ToGtin14(gtin);
}
