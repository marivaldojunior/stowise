using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Recebimentos;
using Stowise.Domain.Common;
using Stowise.Domain.Recebimentos;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Recebimentos;

internal sealed class RecebimentoService(StowiseDbContext db, TimeProvider time) : IRecebimentoService
{
    public async Task<PagedResult<RecebimentoResumo>> ListAsync(RecebimentoFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query =
            from r in db.Recebimentos.AsNoTracking()
            join f in db.Fornecedores on r.FornecedorId equals f.Id
            select new { r, f.RazaoSocial };
        if (filtro.Status is { } status)
        {
            query = query.Where(x => x.r.Status == status);
        }

        if (!string.IsNullOrWhiteSpace(filtro.Busca))
        {
            var busca = filtro.Busca.Trim();
            var pattern = $"%{LikePattern.Escape(busca)}%";
            var numero = int.TryParse(busca, out var n) ? n : -1;
            query = query.Where(x =>
                x.r.Numero == numero
                || EF.Functions.Like(x.r.ChaveAcesso, pattern, LikePattern.EscapeCharacter)
                || EF.Functions.ILike(x.RazaoSocial, pattern, LikePattern.EscapeCharacter));
        }

        var total = await query.CountAsync(cancellationToken);
        var linhas = await query
            .OrderByDescending(x => x.r.CriadoEm)
            .ThenBy(x => x.r.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .Select(x => new
            {
                x.r.Id,
                x.r.Numero,
                x.r.Serie,
                x.r.ChaveAcesso,
                x.r.FornecedorId,
                x.RazaoSocial,
                x.r.DataEmissao,
                x.r.Status,
                Itens = x.r.Itens.Count,
                Conferidos = x.r.Itens.Count(i => i.QuantidadeConferida != null),
                Divergente = x.r.Itens.Any(i => i.Divergente),
                x.r.CriadoEm,
            })
            .ToListAsync(cancellationToken);

        var itens = linhas
            .Select(x => new RecebimentoResumo(
                x.Id, x.Numero, x.Serie, x.ChaveAcesso, x.FornecedorId, x.RazaoSocial, x.DataEmissao, x.Status, x.Itens, x.Conferidos, x.Divergente, x.CriadoEm))
            .ToList();
        return new PagedResult<RecebimentoResumo>(itens, pagina, tamanhoPagina, total);
    }

    public async Task<Result<RecebimentoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var recebimento = await LoadAsync(id, tracking: false, cancellationToken);
        return recebimento is null ? NotFound() : await ToDetalheAsync(recebimento, cancellationToken);
    }

    public Task<Result<RecebimentoDetalhe>> StartConferenciaAsync(Guid id, AlterarRecebimento comando, CancellationToken cancellationToken = default) =>
        ChangeAsync(id, comando, r => r.StartConferencia(time.GetUtcNow()), cancellationToken);

    public Task<Result<RecebimentoDetalhe>> FinishConferenciaAsync(
        Guid id,
        AlterarRecebimento comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default) =>
        ChangeAsync(id, comando, r => r.FinishConferencia(usuarioId, time.GetUtcNow()), cancellationToken);

    public async Task<Result<RecebimentoDetalhe>> ConferirItemAsync(
        Guid id,
        Guid itemId,
        ConferirItemRecebimento comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(comando);
        if (comando.Quantidade is null)
        {
            return AppError.Validation("quantidade", "Informe a quantidade contada.");
        }

        var recebimento = await LoadAsync(id, tracking: true, cancellationToken);
        if (recebimento is null)
        {
            return NotFound();
        }

        var item = recebimento.Itens.FirstOrDefault(i => i.Id == itemId);
        if (item is null)
        {
            return AppError.NotFound("Item não encontrado neste recebimento.");
        }

        var produto = await db.Produtos.AsNoTracking()
            .Where(p => p.Id == item.ProdutoId)
            .Select(p => new { p.ControlaLote, p.ControlaValidade })
            .FirstAsync(cancellationToken);
        try
        {
            recebimento.ConferirItem(itemId, comando.Quantidade.Value, comando.Lotes ?? [], produto.ControlaLote, produto.ControlaValidade, usuarioId, time.GetUtcNow());
        }
        catch (DomainException e)
        {
            return AppError.BusinessRule(e.Message);
        }

        await db.SaveChangesAsync(cancellationToken);
        return await ToDetalheAsync(recebimento, cancellationToken);
    }

    /// <summary>Mudança no próprio recebimento: a versão lida entra no WHERE do UPDATE (409 se outra pessoa mudou antes).</summary>
    private async Task<Result<RecebimentoDetalhe>> ChangeAsync(
        Guid id,
        AlterarRecebimento comando,
        Action<Recebimento> mudanca,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(comando);
        if (comando.Versao is null)
        {
            return AppError.Validation("versao", "Informe a versão lida do recebimento.");
        }

        var recebimento = await LoadAsync(id, tracking: true, cancellationToken);
        if (recebimento is null)
        {
            return NotFound();
        }

        if (recebimento.Versao != comando.Versao)
        {
            return AppError.Conflict("O recebimento foi alterado por outra pessoa depois que você o abriu. Recarregue e tente de novo.");
        }

        try
        {
            mudanca(recebimento);
        }
        catch (DomainException e)
        {
            return AppError.BusinessRule(e.Message);
        }

        db.Entry(recebimento).Property(r => r.Versao).OriginalValue = comando.Versao.Value;
        await db.SaveChangesAsync(cancellationToken);
        return await ToDetalheAsync((await LoadAsync(id, tracking: false, cancellationToken))!, cancellationToken);
    }

    private Task<Recebimento?> LoadAsync(Guid id, bool tracking, CancellationToken cancellationToken)
    {
        var query = db.Recebimentos.Include(r => r.Itens).AsQueryable();
        if (!tracking)
        {
            query = query.AsNoTracking();
        }

        return query.FirstOrDefaultAsync(r => r.Id == id, cancellationToken);
    }

    private async Task<RecebimentoDetalhe> ToDetalheAsync(Recebimento r, CancellationToken cancellationToken)
    {
        var fornecedor = await db.Fornecedores.AsNoTracking().Where(f => f.Id == r.FornecedorId).Select(f => f.RazaoSocial).FirstAsync(cancellationToken);
        var ids = r.Itens.Select(i => i.ProdutoId).Distinct().ToList();
        var produtos = await db.Produtos.AsNoTracking()
            .Where(p => ids.Contains(p.Id))
            .Select(p => new { p.Id, p.Sku, p.Descricao, p.UnidadeBase, p.ControlaLote, p.ControlaValidade })
            .ToDictionaryAsync(p => p.Id, cancellationToken);

        var itens = r.Itens
            .OrderBy(i => i.NumeroItem)
            .Select(i =>
            {
                var p = produtos[i.ProdutoId];
                return new RecebimentoItemDetalhe(
                    i.Id, i.NumeroItem, i.ProdutoId, p.Sku, p.Descricao, p.UnidadeBase, p.ControlaLote, p.ControlaValidade, i.EmbalagemId,
                    i.CodigoFornecedor, i.DescricaoNota, i.UnidadeNota, i.QuantidadeNota, i.FatorConversao, i.Quantidade, i.Lotes,
                    i.QuantidadeConferida, i.LotesConferidos, i.Divergente, i.ConferidoPor, i.ConferidoEm);
            })
            .ToList();

        return new RecebimentoDetalhe(
            r.Id, r.Numero, r.Serie, r.ChaveAcesso, r.FornecedorId, fornecedor, r.DataEmissao, r.Status, r.DataChegada,
            r.ConferidoPor, r.ConferidoEm, r.TemDivergencia, r.Versao, itens);
    }

    private static AppError NotFound() => AppError.NotFound("Recebimento não encontrado.");
}
