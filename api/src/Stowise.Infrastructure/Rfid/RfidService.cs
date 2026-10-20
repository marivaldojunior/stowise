using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Stowise.Application.Common;
using Stowise.Application.Rfid;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Rfid;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Rfid;

internal sealed class RfidService(StowiseDbContext db, IOptions<RfidOptions> options) : IRfidService
{
    /// <summary>Sequência das séries dos EPCs gerados (ADR-0010).</summary>
    public const string SerialSequence = "rfid_serial";

    public async Task<Result<LeiturasRfidResolvidas>> ResolveAsync(ResolverLeiturasRfid comando, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(comando);
        var epcs = (comando.Epcs ?? [])
            .Where(e => !string.IsNullOrWhiteSpace(e))
            .Select(e => e.Trim().ToUpperInvariant())
            .Distinct()
            .ToList();
        if (epcs.Count == 0)
        {
            return AppError.Validation("epcs", "Envie ao menos um EPC lido.");
        }

        if (epcs.Count > LimitesRfid.LeiturasPorLote)
        {
            return AppError.Validation("epcs", $"Envie no máximo {LimitesRfid.LeiturasPorLote} EPCs por lote.");
        }

        var lidos = epcs.Select(e => (Epc: e, Sgtin: Sgtin96.TryParseHex(e, out var sgtin) ? sgtin : null)).ToList();
        var embalagens = await FindByGtinAsync(lidos.Where(l => l.Sgtin is not null).Select(l => l.Sgtin!.Gtin14), cancellationToken);

        var leituras = lidos.Select(l =>
            {
                var embalagem = l.Sgtin is null ? null : embalagens.GetValueOrDefault(l.Sgtin.Gtin14);
                return new LeituraRfid(l.Epc, l.Sgtin?.Gtin14, l.Sgtin?.Serie, embalagem?.ProdutoId, embalagem?.EmbalagemId);
            })
            .ToList();

        var porEmbalagem = embalagens.Values.ToDictionary(e => e.EmbalagemId);
        var produtos = leituras
            .Where(l => l.EmbalagemId is not null)
            .GroupBy(l => l.EmbalagemId!.Value)
            .Select(g =>
            {
                var e = porEmbalagem[g.Key];
                var etiquetas = g.Count();
                return new ContagemRfid(
                    e.ProdutoId, e.Sku, e.Descricao, e.UnidadeBase, e.EmbalagemId, e.Tipo, e.FatorConversao, etiquetas, etiquetas * e.FatorConversao);
            })
            .OrderBy(c => c.Descricao)
            .ThenBy(c => c.FatorConversao)
            .ToList();

        return new LeiturasRfidResolvidas(leituras, produtos, leituras.Count(l => l.EmbalagemId is null));
    }

    public async Task<Result<EtiquetasRfidGeradas>> GenerateAsync(GerarEtiquetasRfid comando, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(comando);
        var erros = new Dictionary<string, string[]>();
        if (comando.EmbalagemId is null)
        {
            erros["embalagemId"] = ["Informe a embalagem."];
        }

        if (comando.Quantidade is not (>= 1 and <= LimitesRfid.EtiquetasPorPedido))
        {
            erros["quantidade"] = [$"Informe de 1 a {LimitesRfid.EtiquetasPorPedido} etiquetas."];
        }

        if (comando.TamanhoPrefixoEmpresa is < 6 or > 12)
        {
            erros["tamanhoPrefixoEmpresa"] = ["O prefixo da empresa GS1 tem de 6 a 12 dígitos."];
        }

        if (erros.Count > 0)
        {
            return AppError.Validation(erros);
        }

        var embalagem = await db.ProdutoEmbalagens.AsNoTracking()
            .Where(e => e.Id == comando.EmbalagemId)
            .Join(db.Produtos, e => e.ProdutoId, p => p.Id, (e, p) => new { e.Id, e.ProdutoId, e.Gtin, e.Tipo, p.Ativo })
            .FirstOrDefaultAsync(cancellationToken);
        if (embalagem is null)
        {
            return AppError.NotFound("Embalagem não encontrada.");
        }

        if (!embalagem.Ativo)
        {
            return AppError.BusinessRule("O produto está inativo. Reative o produto antes de gerar etiquetas.");
        }

        if (embalagem.Gtin is null)
        {
            return AppError.BusinessRule("A embalagem não tem GTIN. Cadastre o GTIN antes de gerar etiquetas RFID.");
        }

        if ((comando.TamanhoPrefixoEmpresa ?? options.Value.TamanhoPrefixoEmpresaPadrao) is not { } tamanhoPrefixo)
        {
            return AppError.Validation("tamanhoPrefixoEmpresa", "Informe o tamanho do prefixo da empresa GS1 do GTIN.");
        }

        // Séries da sequência do banco: dois aparelhos nunca recebem o mesmo EPC.
        var quantidade = comando.Quantidade!.Value;
        var series = await db.Database
            .SqlQuery<long>($"SELECT nextval('rfid_serial') AS \"Value\" FROM generate_series(1, {quantidade})")
            .ToListAsync(cancellationToken);

        var filtro = Sgtin96.FilterFor(embalagem.Tipo);
        var etiquetas = series
            .Order()
            .Select(serie => Sgtin96.Create(embalagem.Gtin, tamanhoPrefixo, serie, filtro))
            .Select(epc => new EtiquetaRfid(epc.Hex, epc.Uri, epc.Serie))
            .ToList();

        return new EtiquetasRfidGeradas(embalagem.ProdutoId, embalagem.Id, Gtin.ToGtin14(embalagem.Gtin), etiquetas);
    }

    /// <summary>Embalagens por GTIN-14, aceitando o GTIN gravado no cadastro com 8, 12, 13 ou 14 dígitos.</summary>
    private async Task<Dictionary<string, EmbalagemLida>> FindByGtinAsync(IEnumerable<string> gtins14, CancellationToken cancellationToken)
    {
        var formas = gtins14.Distinct().SelectMany(Gtin.Equivalents).ToList();
        if (formas.Count == 0)
        {
            return [];
        }

        var encontradas = await db.ProdutoEmbalagens.AsNoTracking()
            .Where(e => e.Gtin != null && formas.Contains(e.Gtin))
            .Join(
                db.Produtos,
                e => e.ProdutoId,
                p => p.Id,
                (e, p) => new EmbalagemLida(e.Gtin!, p.Id, p.Sku, p.Descricao, p.UnidadeBase, e.Id, e.Tipo, e.FatorConversao))
            .ToListAsync(cancellationToken);

        return encontradas
            .GroupBy(e => Gtin.ToGtin14(e.Gtin))
            .ToDictionary(g => g.Key, g => g.First());
    }

    private sealed record EmbalagemLida(
        string Gtin,
        Guid ProdutoId,
        string Sku,
        string Descricao,
        string UnidadeBase,
        Guid EmbalagemId,
        TipoEmbalagem Tipo,
        decimal FatorConversao);
}
