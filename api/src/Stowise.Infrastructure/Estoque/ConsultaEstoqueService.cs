using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Estoque;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Estoque;

internal sealed class ConsultaEstoqueService(StowiseDbContext db) : IConsultaEstoqueService
{
    public async Task<PagedResult<SaldoItem>> ListSaldosAsync(SaldoFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query =
            from s in db.Saldos.AsNoTracking()
            join e in db.Enderecos on s.EnderecoId equals e.Id
            join p in db.Produtos on s.ProdutoId equals p.Id
            join l in db.Lotes on s.LoteId equals (Guid?)l.Id into lotes
            from l in lotes.DefaultIfEmpty()
            select new { s, e, p, l };

        if (filtro.ProdutoId is { } produtoId)
        {
            query = query.Where(x => x.s.ProdutoId == produtoId);
        }

        if (filtro.EnderecoId is { } enderecoId)
        {
            query = query.Where(x => x.s.EnderecoId == enderecoId);
        }

        if (filtro.LoteId is { } loteId)
        {
            query = query.Where(x => x.s.LoteId == loteId);
        }

        if (filtro.ArmazemId is { } armazemId)
        {
            query = query.Where(x => x.e.ArmazemId == armazemId);
        }

        if (filtro.ZonaId is { } zonaId)
        {
            query = query.Where(x => x.e.ZonaId == zonaId);
        }

        if (!filtro.IncluirZerados)
        {
            query = query.Where(x => x.s.Quantidade > 0 || x.s.QuantidadeReservada > 0);
        }

        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .OrderBy(x => x.p.Sku)
            .ThenBy(x => x.l == null ? null : x.l.Validade)
            .ThenBy(x => x.e.Codigo)
            .ThenBy(x => x.s.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .Select(x => new SaldoItem(
                x.e.Id,
                x.e.Codigo,
                x.e.ArmazemId,
                x.e.ZonaId,
                x.p.Id,
                x.p.Sku,
                x.p.Descricao,
                x.p.UnidadeBase,
                x.s.LoteId,
                x.l == null ? null : x.l.Numero,
                x.l == null ? null : x.l.Validade,
                x.s.Quantidade,
                x.s.QuantidadeReservada,
                x.s.Quantidade - x.s.QuantidadeReservada))
            .ToListAsync(cancellationToken);

        return new PagedResult<SaldoItem>(itens, pagina, tamanhoPagina, total);
    }

    public async Task<Result<ResumoSaldoProduto>> GetResumoProdutoAsync(Guid produtoId, CancellationToken cancellationToken = default)
    {
        var produto = await db.Produtos.AsNoTracking()
            .Where(p => p.Id == produtoId)
            .Select(p => new { p.Sku, p.Descricao, p.UnidadeBase })
            .FirstOrDefaultAsync(cancellationToken);
        if (produto is null)
        {
            return AppError.NotFound("Produto não encontrado.");
        }

        var saldos = db.Saldos.AsNoTracking().Where(s => s.ProdutoId == produtoId && (s.Quantidade > 0 || s.QuantidadeReservada > 0));
        var lotes = await (
                from s in saldos
                join l in db.Lotes on s.LoteId equals (Guid?)l.Id into ls
                from l in ls.DefaultIfEmpty()
                group s by new { s.LoteId, Numero = l == null ? null : l.Numero, Validade = l == null ? null : l.Validade } into g
                select new ResumoSaldoLote(
                    g.Key.LoteId,
                    g.Key.Numero,
                    g.Key.Validade,
                    g.Sum(s => s.Quantidade),
                    g.Sum(s => s.QuantidadeReservada)))
            .ToListAsync(cancellationToken);

        var enderecos = await saldos.Where(s => s.Quantidade > 0).Select(s => s.EnderecoId).Distinct().CountAsync(cancellationToken);
        var quantidade = lotes.Sum(l => l.Quantidade);
        var reservada = lotes.Sum(l => l.QuantidadeReservada);

        return new ResumoSaldoProduto(
            produtoId,
            produto.Sku,
            produto.Descricao,
            produto.UnidadeBase,
            quantidade,
            reservada,
            quantidade - reservada,
            enderecos,
            [.. lotes.OrderBy(l => l.Validade ?? DateOnly.MaxValue).ThenBy(l => l.Numero, StringComparer.Ordinal)]);
    }

    public async Task<Result<PagedResult<SaldoNaData>>> GetSaldoNaDataAsync(SaldoNaDataFiltro filtro, CancellationToken cancellationToken = default)
    {
        var errors = EstoqueValidation.Validate(filtro);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);
        var data = filtro.Data!.Value.ToUniversalTime();

        var movimentacoes = db.Movimentacoes.AsNoTracking().Where(m => m.OcorridoEm <= data);
        if (filtro.ProdutoId is { } produtoId)
        {
            movimentacoes = movimentacoes.Where(m => m.ProdutoId == produtoId);
        }

        // Livro-razão em linhas com sinal: + no destino, − na origem (uma transferência gera as duas).
        var chegadas = movimentacoes
            .Where(m => m.EnderecoDestinoId != null)
            .Select(m => new { EnderecoId = m.EnderecoDestinoId!.Value, m.ProdutoId, m.LoteId, Quantidade = m.Quantidade });
        var saidas = movimentacoes
            .Where(m => m.EnderecoOrigemId != null)
            .Select(m => new { EnderecoId = m.EnderecoOrigemId!.Value, m.ProdutoId, m.LoteId, Quantidade = -m.Quantidade });
        var linhas = chegadas.Concat(saidas);

        if (filtro.EnderecoId is { } enderecoId)
        {
            linhas = linhas.Where(l => l.EnderecoId == enderecoId);
        }

        if (filtro.ArmazemId is { } armazemId)
        {
            var enderecosDoArmazem = db.Enderecos.Where(e => e.ArmazemId == armazemId).Select(e => e.Id);
            linhas = linhas.Where(l => enderecosDoArmazem.Contains(l.EnderecoId));
        }

        var saldos = linhas
            .GroupBy(l => new { l.EnderecoId, l.ProdutoId, l.LoteId })
            .Select(g => new { g.Key.EnderecoId, g.Key.ProdutoId, g.Key.LoteId, Quantidade = g.Sum(l => l.Quantidade) })
            .Where(s => s.Quantidade != 0);

        var total = await saldos.CountAsync(cancellationToken);
        var linhasDaPagina = await saldos
            .OrderBy(s => s.ProdutoId)
            .ThenBy(s => s.EnderecoId)
            .ThenBy(s => s.LoteId)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .ToListAsync(cancellationToken);

        // Códigos legíveis só para a página retornada.
        var produtoIds = linhasDaPagina.Select(s => s.ProdutoId).Distinct().ToList();
        var enderecoIds = linhasDaPagina.Select(s => s.EnderecoId).Distinct().ToList();
        var loteIds = linhasDaPagina.Where(s => s.LoteId != null).Select(s => s.LoteId!.Value).Distinct().ToList();
        var skus = await db.Produtos.AsNoTracking().Where(p => produtoIds.Contains(p.Id)).ToDictionaryAsync(p => p.Id, p => p.Sku, cancellationToken);
        var codigos = await db.Enderecos.AsNoTracking().Where(e => enderecoIds.Contains(e.Id)).ToDictionaryAsync(e => e.Id, e => e.Codigo, cancellationToken);
        var numeros = await db.Lotes.AsNoTracking().Where(l => loteIds.Contains(l.Id)).ToDictionaryAsync(l => l.Id, l => l.Numero, cancellationToken);

        var itens = linhasDaPagina
            .Select(s => new SaldoNaData(
                s.EnderecoId,
                codigos[s.EnderecoId],
                s.ProdutoId,
                skus[s.ProdutoId],
                s.LoteId,
                s.LoteId is { } id ? numeros[id] : null,
                s.Quantidade))
            .OrderBy(s => s.Sku, StringComparer.Ordinal)
            .ThenBy(s => s.EnderecoCodigo, StringComparer.Ordinal)
            .ToList();

        return new PagedResult<SaldoNaData>(itens, pagina, tamanhoPagina, total);
    }

    public async Task<Result<PagedResult<ExtratoItem>>> GetExtratoAsync(ExtratoFiltro filtro, CancellationToken cancellationToken = default)
    {
        var errors = EstoqueValidation.Validate(filtro);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query =
            from m in db.Movimentacoes.AsNoTracking()
            join p in db.Produtos on m.ProdutoId equals p.Id
            join l in db.Lotes on m.LoteId equals (Guid?)l.Id into lotes
            from l in lotes.DefaultIfEmpty()
            join o in db.Enderecos on m.EnderecoOrigemId equals (Guid?)o.Id into origens
            from o in origens.DefaultIfEmpty()
            join d in db.Enderecos on m.EnderecoDestinoId equals (Guid?)d.Id into destinos
            from d in destinos.DefaultIfEmpty()
            select new { m, p.Sku, LoteNumero = l == null ? null : l.Numero, Origem = o == null ? null : o.Codigo, Destino = d == null ? null : d.Codigo };

        if (filtro.ProdutoId is { } produtoId)
        {
            query = query.Where(x => x.m.ProdutoId == produtoId);
        }

        if (filtro.EnderecoId is { } enderecoId)
        {
            query = query.Where(x => x.m.EnderecoOrigemId == enderecoId || x.m.EnderecoDestinoId == enderecoId);
        }

        if (filtro.LoteId is { } loteId)
        {
            query = query.Where(x => x.m.LoteId == loteId);
        }

        if (filtro.Tipo is { } tipo)
        {
            query = query.Where(x => x.m.Tipo == tipo);
        }

        if (filtro.De is { } de)
        {
            var inicio = de.ToUniversalTime();
            query = query.Where(x => x.m.OcorridoEm >= inicio);
        }

        if (filtro.Ate is { } ate)
        {
            var fim = ate.ToUniversalTime();
            query = query.Where(x => x.m.OcorridoEm <= fim);
        }

        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .OrderByDescending(x => x.m.OcorridoEm)
            .ThenByDescending(x => x.m.RecebidoEm)
            .ThenByDescending(x => x.m.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .Select(x => new ExtratoItem(
                x.m.Id,
                x.m.Tipo,
                x.m.OcorridoEm,
                x.m.RecebidoEm,
                x.m.ProdutoId,
                x.Sku,
                x.LoteNumero,
                x.Origem,
                x.Destino,
                x.m.Quantidade,
                x.m.DocumentoReferencia,
                x.m.Observacao,
                x.m.UsuarioId))
            .ToListAsync(cancellationToken);

        return new PagedResult<ExtratoItem>(itens, pagina, tamanhoPagina, total);
    }
}
