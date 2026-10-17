using Microsoft.EntityFrameworkCore;
using Npgsql;
using Stowise.Application.Catalogo;
using Stowise.Application.Common;
using Stowise.Domain.Catalogo;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Catalogo;

internal sealed class ProdutoService(StowiseDbContext db) : IProdutoService
{
    public async Task<PagedResult<ProdutoResumo>> ListAsync(ProdutoFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query = db.Produtos.AsNoTracking();
        if (!string.IsNullOrWhiteSpace(filtro.Busca))
        {
            var busca = filtro.Busca.Trim();
            var pattern = $"%{LikePattern.Escape(busca)}%";
            query = query.Where(p =>
                EF.Functions.ILike(p.Sku, pattern, LikePattern.EscapeCharacter)
                || EF.Functions.ILike(p.Descricao, pattern, LikePattern.EscapeCharacter)
                || p.Embalagens.Any(e => e.Gtin == busca));
        }

        if (filtro.CategoriaId is { } categoriaId)
        {
            query = query.Where(p => p.CategoriaId == categoriaId);
        }

        if (filtro.Ativo is { } ativo)
        {
            query = query.Where(p => p.Ativo == ativo);
        }

        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .OrderBy(p => p.Descricao)
            .ThenBy(p => p.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .Select(p => new ProdutoResumo(p.Id, p.Sku, p.Descricao, p.UnidadeBase, p.ClasseArmazenagem, p.CategoriaId, p.Ativo))
            .ToListAsync(cancellationToken);

        return new PagedResult<ProdutoResumo>(itens, pagina, tamanhoPagina, total);
    }

    public async Task<Result<ProdutoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var produto = await LoadAsync(id, tracking: false, cancellationToken);
        return produto is null ? NotFound() : ToDetalhe(produto);
    }

    public async Task<Result<ProdutoPorCodigo>> FindByCodigoAsync(string? codigo, CancellationToken cancellationToken = default)
    {
        var valor = codigo?.Trim();
        if (string.IsNullOrEmpty(valor))
        {
            return AppError.Validation("codigo", "Informe o SKU ou o GTIN.");
        }

        var porGtin = await db.ProdutoEmbalagens.AsNoTracking()
            .Where(e => e.Gtin == valor)
            .Select(e => new { e.ProdutoId, e.Id })
            .FirstOrDefaultAsync(cancellationToken);
        if (porGtin is not null)
        {
            var produto = (await LoadAsync(porGtin.ProdutoId, tracking: false, cancellationToken))!;
            return new ProdutoPorCodigo(ToDetalhe(produto), porGtin.Id);
        }

        var sku = valor.ToUpperInvariant();
        var porSku = await db.Produtos.AsNoTracking().Include(p => p.Embalagens)
            .FirstOrDefaultAsync(p => p.Sku == sku, cancellationToken);
        return porSku is null
            ? AppError.NotFound($"Nenhum produto com o SKU ou GTIN {valor}.")
            : new ProdutoPorCodigo(ToDetalhe(porSku), porSku.EmbalagemBase.Id);
    }

    public async Task<Result<ProdutoDetalhe>> CreateAsync(CriarProduto comando, CancellationToken cancellationToken = default)
    {
        var errors = CatalogoValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var sku = Produto.NormalizeSku(comando.Sku);
        if (await db.Produtos.AnyAsync(p => p.Sku == sku, cancellationToken))
        {
            return AppError.Conflict($"Já existe um produto com o SKU {sku}.");
        }

        var medidas = comando.EmbalagemBase ?? new EmbalagemMedidas(null, null, null, null, null);
        var conflito = await ValidateReferencesAsync(comando.CategoriaId, medidas.Gtin, exceptEmbalagemId: null, cancellationToken);
        if (conflito is not null)
        {
            return conflito;
        }

        var produto = Produto.Create(
            sku,
            ToDados(comando.Descricao, comando.UnidadeBase, comando.ClasseArmazenagem, comando.ControlaLote, comando.ControlaValidade, comando.Ncm, comando.Cest, comando.CategoriaId),
            ToDados(medidas));
        db.Produtos.Add(produto);

        return await SaveAsync(produto, cancellationToken);
    }

    public async Task<Result<ProdutoDetalhe>> UpdateAsync(Guid id, AtualizarProduto comando, CancellationToken cancellationToken = default)
    {
        var errors = CatalogoValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var produto = await LoadAsync(id, tracking: true, cancellationToken);
        if (produto is null)
        {
            return NotFound();
        }

        if (produto.Versao != comando.Versao)
        {
            return VersaoDesatualizada();
        }

        var conflito = await ValidateReferencesAsync(comando.CategoriaId, gtin: null, exceptEmbalagemId: null, cancellationToken);
        if (conflito is not null)
        {
            return conflito;
        }

        // A versão lida pelo cliente entra no WHERE do UPDATE: se outro usuário salvou antes, o EF lança conflito (409).
        db.Entry(produto).Property(p => p.Versao).OriginalValue = comando.Versao!.Value;
        produto.Update(ToDados(comando.Descricao, comando.UnidadeBase, comando.ClasseArmazenagem, comando.ControlaLote, comando.ControlaValidade, comando.Ncm, comando.Cest, comando.CategoriaId));

        return await SaveAsync(produto, cancellationToken);
    }

    public Task<Result> DeactivateAsync(Guid id, CancellationToken cancellationToken = default) =>
        SetAtivoAsync(id, ativo: false, cancellationToken);

    public Task<Result> ReactivateAsync(Guid id, CancellationToken cancellationToken = default) =>
        SetAtivoAsync(id, ativo: true, cancellationToken);

    public async Task<Result<ProdutoDetalhe>> AddEmbalagemAsync(Guid produtoId, AdicionarEmbalagem comando, CancellationToken cancellationToken = default)
    {
        var errors = CatalogoValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var produto = await LoadAsync(produtoId, tracking: true, cancellationToken);
        if (produto is null)
        {
            return NotFound();
        }

        var conflito = await ValidateReferencesAsync(categoriaId: null, comando.Gtin, exceptEmbalagemId: null, cancellationToken);
        if (conflito is not null)
        {
            return conflito;
        }

        produto.AddEmbalagem(
            comando.Tipo!.Value,
            comando.FatorConversao!.Value,
            new DadosEmbalagem(comando.Gtin, comando.PesoKg, comando.AlturaCm, comando.LarguraCm, comando.ComprimentoCm));
        return await SaveAsync(produto, cancellationToken);
    }

    public async Task<Result<ProdutoDetalhe>> UpdateEmbalagemAsync(
        Guid produtoId,
        Guid embalagemId,
        EmbalagemMedidas comando,
        CancellationToken cancellationToken = default)
    {
        var errors = CatalogoValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var produto = await LoadAsync(produtoId, tracking: true, cancellationToken);
        if (produto is null || produto.Embalagens.All(e => e.Id != embalagemId))
        {
            return produto is null ? NotFound() : EmbalagemNotFound();
        }

        var conflito = await ValidateReferencesAsync(categoriaId: null, comando.Gtin, embalagemId, cancellationToken);
        if (conflito is not null)
        {
            return conflito;
        }

        produto.UpdateEmbalagem(embalagemId, ToDados(comando));
        return await SaveAsync(produto, cancellationToken);
    }

    public async Task<Result<ProdutoDetalhe>> RemoveEmbalagemAsync(Guid produtoId, Guid embalagemId, CancellationToken cancellationToken = default)
    {
        var produto = await LoadAsync(produtoId, tracking: true, cancellationToken);
        if (produto is null || produto.Embalagens.All(e => e.Id != embalagemId))
        {
            return produto is null ? NotFound() : EmbalagemNotFound();
        }

        produto.RemoveEmbalagem(embalagemId);
        return await SaveAsync(produto, cancellationToken);
    }

    private async Task<Result> SetAtivoAsync(Guid id, bool ativo, CancellationToken cancellationToken)
    {
        var produto = await db.Produtos.FindAsync([id], cancellationToken);
        if (produto is null)
        {
            return NotFound();
        }

        if (ativo)
        {
            produto.Reactivate();
        }
        else
        {
            produto.Deactivate();
        }

        await db.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    private async Task<AppError?> ValidateReferencesAsync(
        Guid? categoriaId,
        string? gtin,
        Guid? exceptEmbalagemId,
        CancellationToken cancellationToken)
    {
        if (categoriaId is not null && !await db.Categorias.AnyAsync(c => c.Id == categoriaId, cancellationToken))
        {
            return AppError.Validation("categoriaId", "Categoria não encontrada.");
        }

        var valor = gtin?.Trim();
        if (!string.IsNullOrEmpty(valor)
            && await db.ProdutoEmbalagens.AnyAsync(e => e.Gtin == valor && e.Id != exceptEmbalagemId, cancellationToken))
        {
            return AppError.Conflict($"O GTIN {valor} já está cadastrado em outra embalagem.");
        }

        return null;
    }

    private async Task<Result<ProdutoDetalhe>> SaveAsync(Produto produto, CancellationToken cancellationToken)
    {
        try
        {
            await db.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateException e) when (e is not DbUpdateConcurrencyException && IsUniqueViolation(e))
        {
            // Corrida entre a verificação e o INSERT/UPDATE: outro usuário gravou o mesmo SKU ou GTIN.
            return AppError.Conflict("SKU ou GTIN já cadastrado por outra operação. Recarregue e tente de novo.");
        }

        return ToDetalhe((await LoadAsync(produto.Id, tracking: false, cancellationToken))!);
    }

    private Task<Produto?> LoadAsync(Guid id, bool tracking, CancellationToken cancellationToken)
    {
        var query = db.Produtos.Include(p => p.Embalagens).AsQueryable();
        if (!tracking)
        {
            query = query.AsNoTracking();
        }

        return query.FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
    }

    private static DadosProduto ToDados(
        string? descricao,
        string? unidadeBase,
        Domain.Estrutura.ClasseArmazenagem? classe,
        bool controlaLote,
        bool controlaValidade,
        string? ncm,
        string? cest,
        Guid? categoriaId) =>
        new(descricao!, unidadeBase!, classe!.Value, controlaLote, controlaValidade, ncm, cest, categoriaId);

    private static DadosEmbalagem ToDados(EmbalagemMedidas medidas) =>
        new(medidas.Gtin, medidas.PesoKg, medidas.AlturaCm, medidas.LarguraCm, medidas.ComprimentoCm);

    private static ProdutoDetalhe ToDetalhe(Produto p) =>
        new(
            p.Id,
            p.Sku,
            p.Descricao,
            p.UnidadeBase,
            p.ClasseArmazenagem,
            p.ControlaLote,
            p.ControlaValidade,
            p.Ncm,
            p.Cest,
            p.CategoriaId,
            p.Ativo,
            p.Versao,
            [.. p.Embalagens
                .OrderByDescending(e => e.UnidadeBase)
                .ThenBy(e => e.Tipo)
                .ThenBy(e => e.FatorConversao)
                .Select(e => new EmbalagemDetalhe(
                    e.Id, e.Tipo, e.FatorConversao, e.UnidadeBase, e.Gtin, e.PesoKg, e.AlturaCm, e.LarguraCm, e.ComprimentoCm))]);

    private static bool IsUniqueViolation(DbUpdateException e) =>
        e.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation };

    private static AppError NotFound() => AppError.NotFound("Produto não encontrado.");

    private static AppError EmbalagemNotFound() => AppError.NotFound("Embalagem não encontrada neste produto.");

    private static AppError VersaoDesatualizada() =>
        AppError.Conflict("O produto foi alterado por outra pessoa depois que você o abriu. Recarregue e tente de novo.");
}
