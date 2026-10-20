using System.Linq.Expressions;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using Stowise.Application.Common;
using Stowise.Application.Fornecedores;
using Stowise.Domain.Fornecedores;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Fornecedores;

internal sealed class FornecedorService(StowiseDbContext db, TimeProvider clock) : IFornecedorService
{
    public async Task<PagedResult<FornecedorResumo>> ListAsync(FornecedorFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query = db.Fornecedores.AsNoTracking();
        if (!string.IsNullOrWhiteSpace(filtro.Busca))
        {
            var busca = filtro.Busca.Trim();
            var pattern = $"%{LikePattern.Escape(busca)}%";
            var cnpj = Cnpj.Normalize(busca);
            var cnpjPattern = $"%{LikePattern.Escape(cnpj)}%";
            query = query.Where(f =>
                EF.Functions.ILike(f.RazaoSocial, pattern, LikePattern.EscapeCharacter)
                || (f.NomeFantasia != null && EF.Functions.ILike(f.NomeFantasia, pattern, LikePattern.EscapeCharacter))
                || (cnpj.Length > 0 && EF.Functions.Like(f.Cnpj, cnpjPattern, LikePattern.EscapeCharacter)));
        }

        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .OrderBy(f => f.RazaoSocial)
            .ThenBy(f => f.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .Select(f => new FornecedorResumo(
                f.Id,
                f.Cnpj,
                f.RazaoSocial,
                f.NomeFantasia,
                db.ProdutoFornecedores.Count(v => v.FornecedorId == f.Id)))
            .ToListAsync(cancellationToken);

        return new PagedResult<FornecedorResumo>(itens, pagina, tamanhoPagina, total);
    }

    public async Task<Result<FornecedorDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var detalhe = await LoadDetalheAsync(id, cancellationToken);
        return detalhe is null ? FornecedorNotFound() : detalhe;
    }

    public async Task<Result<FornecedorDetalhe>> CreateAsync(CriarFornecedor comando, CancellationToken cancellationToken = default)
    {
        var errors = FornecedorValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var fornecedor = Fornecedor.Create(comando.Cnpj!, comando.RazaoSocial!, comando.NomeFantasia);
        if (await db.Fornecedores.AnyAsync(f => f.Cnpj == fornecedor.Cnpj, cancellationToken))
        {
            return CnpjRepetido(fornecedor.Cnpj);
        }

        db.Fornecedores.Add(fornecedor);
        if (!await TrySaveAsync(cancellationToken))
        {
            return CnpjRepetido(fornecedor.Cnpj);
        }

        return (await LoadDetalheAsync(fornecedor.Id, cancellationToken))!;
    }

    public async Task<Result<FornecedorDetalhe>> UpdateAsync(Guid id, AtualizarFornecedor comando, CancellationToken cancellationToken = default)
    {
        var errors = FornecedorValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var fornecedor = await db.Fornecedores.FirstOrDefaultAsync(f => f.Id == id, cancellationToken);
        if (fornecedor is null)
        {
            return FornecedorNotFound();
        }

        if (fornecedor.Versao != comando.Versao)
        {
            return AppError.Conflict("O fornecedor foi alterado por outra pessoa depois que você o abriu. Recarregue e tente de novo.");
        }

        // A versão lida entra no WHERE do UPDATE: se outro usuário salvou antes, o EF lança conflito (409).
        db.Entry(fornecedor).Property(f => f.Versao).OriginalValue = comando.Versao!.Value;
        fornecedor.Update(comando.RazaoSocial!, comando.NomeFantasia);
        await db.SaveChangesAsync(cancellationToken);

        return (await LoadDetalheAsync(id, cancellationToken))!;
    }

    public async Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var fornecedor = await db.Fornecedores.FirstOrDefaultAsync(f => f.Id == id, cancellationToken);
        if (fornecedor is null)
        {
            return FornecedorNotFound();
        }

        var vinculos = await db.ProdutoFornecedores.CountAsync(v => v.FornecedorId == id, cancellationToken);
        if (vinculos > 0)
        {
            return AppError.BusinessRule($"O fornecedor tem {vinculos} produto(s) vinculado(s). Remova os vínculos antes de excluir.");
        }

        db.Fornecedores.Remove(fornecedor);
        await db.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    public async Task<Result<PagedResult<ProdutoFornecedorDetalhe>>> ListProdutosAsync(
        Guid fornecedorId,
        ProdutoFornecedorFiltro filtro,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        if (!await db.Fornecedores.AnyAsync(f => f.Id == fornecedorId, cancellationToken))
        {
            return FornecedorNotFound();
        }

        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);
        var query = Detalhes(v => v.FornecedorId == fornecedorId, filtro.Busca);
        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .ToListAsync(cancellationToken);

        return new PagedResult<ProdutoFornecedorDetalhe>(itens, pagina, tamanhoPagina, total);
    }

    public async Task<Result<ProdutoFornecedorDetalhe>> FindProdutoByCodigoAsync(
        Guid fornecedorId,
        string? codigo,
        CancellationToken cancellationToken = default)
    {
        var valor = codigo?.Trim();
        if (string.IsNullOrEmpty(valor))
        {
            return AppError.Validation("codigo", "Informe o código do produto no fornecedor.");
        }

        var vinculo = await Detalhes(v => v.FornecedorId == fornecedorId && v.CodigoFornecedor == valor).FirstOrDefaultAsync(cancellationToken);
        return vinculo is null ? AppError.NotFound($"O código {valor} não está vinculado a um produto deste fornecedor.") : vinculo;
    }

    public async Task<Result<ProdutoFornecedorDetalhe>> CreateProdutoAsync(
        Guid fornecedorId,
        CriarProdutoFornecedor comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default)
    {
        var errors = FornecedorValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        if (!await db.Fornecedores.AnyAsync(f => f.Id == fornecedorId, cancellationToken))
        {
            return FornecedorNotFound();
        }

        var codigo = comando.CodigoFornecedor!.Trim();
        if (await db.ProdutoFornecedores.AnyAsync(v => v.FornecedorId == fornecedorId && v.CodigoFornecedor == codigo, cancellationToken))
        {
            return CodigoRepetido(codigo);
        }

        var embalagem = await FindEmbalagemAsync(comando.ProdutoId!.Value, comando.EmbalagemId!.Value, cancellationToken);
        if (!embalagem.IsSuccess)
        {
            return embalagem.Error!;
        }

        var vinculo = ProdutoFornecedor.Create(
            fornecedorId,
            codigo,
            comando.ProdutoId.Value,
            comando.EmbalagemId.Value,
            comando.UnidadeFornecedor!,
            comando.FatorConversao ?? embalagem.Value,
            usuarioId,
            clock.GetUtcNow());
        db.ProdutoFornecedores.Add(vinculo);
        if (!await TrySaveAsync(cancellationToken))
        {
            return CodigoRepetido(codigo);
        }

        return await Detalhes(v => v.Id == vinculo.Id).FirstAsync(cancellationToken);
    }

    public async Task<Result<ProdutoFornecedorDetalhe>> UpdateProdutoAsync(
        Guid fornecedorId,
        Guid vinculoId,
        AtualizarProdutoFornecedor comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default)
    {
        var errors = FornecedorValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var vinculo = await db.ProdutoFornecedores.FirstOrDefaultAsync(v => v.Id == vinculoId && v.FornecedorId == fornecedorId, cancellationToken);
        if (vinculo is null)
        {
            return VinculoNotFound();
        }

        if (vinculo.Versao != comando.Versao)
        {
            return AppError.Conflict("O vínculo foi alterado por outra pessoa depois que você o abriu. Recarregue e tente de novo.");
        }

        var embalagem = await FindEmbalagemAsync(comando.ProdutoId!.Value, comando.EmbalagemId!.Value, cancellationToken);
        if (!embalagem.IsSuccess)
        {
            return embalagem.Error!;
        }

        db.Entry(vinculo).Property(v => v.Versao).OriginalValue = comando.Versao!.Value;
        vinculo.Update(
            comando.ProdutoId.Value,
            comando.EmbalagemId.Value,
            comando.UnidadeFornecedor!,
            comando.FatorConversao ?? embalagem.Value,
            usuarioId,
            clock.GetUtcNow());
        await db.SaveChangesAsync(cancellationToken);

        return await Detalhes(v => v.Id == vinculoId).FirstAsync(cancellationToken);
    }

    public async Task<Result> DeleteProdutoAsync(Guid fornecedorId, Guid vinculoId, CancellationToken cancellationToken = default)
    {
        var removidos = await db.ProdutoFornecedores
            .Where(v => v.Id == vinculoId && v.FornecedorId == fornecedorId)
            .ExecuteDeleteAsync(cancellationToken);
        return removidos == 0 ? VinculoNotFound() : Result.Success();
    }

    /// <summary>Confere que a embalagem é do produto e devolve o fator dela, usado quando o pedido não informa o fator.</summary>
    private async Task<Result<decimal>> FindEmbalagemAsync(Guid produtoId, Guid embalagemId, CancellationToken cancellationToken)
    {
        var embalagem = await db.ProdutoEmbalagens.AsNoTracking()
            .Where(e => e.Id == embalagemId)
            .Select(e => new { e.ProdutoId, e.FatorConversao })
            .FirstOrDefaultAsync(cancellationToken);
        if (embalagem is null)
        {
            return await db.Produtos.AnyAsync(p => p.Id == produtoId, cancellationToken)
                ? AppError.NotFound("Embalagem não encontrada.")
                : AppError.NotFound("Produto não encontrado.");
        }

        if (embalagem.ProdutoId != produtoId)
        {
            return AppError.BusinessRule("A embalagem informada não é deste produto.");
        }

        return embalagem.FatorConversao;
    }

    /// <summary>
    /// Vínculos com o produto e a embalagem, em ordem de código. Filtro, busca e ordem ficam antes da projeção: o EF não
    /// traduz o acesso a propriedades de um record criado pelo construtor.
    /// </summary>
    private IQueryable<ProdutoFornecedorDetalhe> Detalhes(Expression<Func<ProdutoFornecedor, bool>> filtro, string? busca = null)
    {
        var query =
            from v in db.ProdutoFornecedores.AsNoTracking().Where(filtro)
            join p in db.Produtos on v.ProdutoId equals p.Id
            join e in db.ProdutoEmbalagens on v.EmbalagemId equals e.Id
            select new { v, p, e };
        if (!string.IsNullOrWhiteSpace(busca))
        {
            var pattern = $"%{LikePattern.Escape(busca.Trim())}%";
            query = query.Where(x =>
                EF.Functions.ILike(x.v.CodigoFornecedor, pattern, LikePattern.EscapeCharacter)
                || EF.Functions.ILike(x.p.Sku, pattern, LikePattern.EscapeCharacter)
                || EF.Functions.ILike(x.p.Descricao, pattern, LikePattern.EscapeCharacter));
        }

        return query
            .OrderBy(x => x.v.CodigoFornecedor)
            .ThenBy(x => x.v.Id)
            .Select(x => new ProdutoFornecedorDetalhe(
                x.v.Id,
                x.v.FornecedorId,
                x.v.CodigoFornecedor,
                x.v.ProdutoId,
                x.p.Sku,
                x.p.Descricao,
                x.p.UnidadeBase,
                x.v.EmbalagemId,
                x.e.Tipo,
                x.v.UnidadeFornecedor,
                x.v.FatorConversao,
                x.v.ConfirmadoPor,
                x.v.ConfirmadoEm,
                x.v.Versao));
    }

    private Task<FornecedorDetalhe?> LoadDetalheAsync(Guid id, CancellationToken cancellationToken) =>
        db.Fornecedores.AsNoTracking()
            .Where(f => f.Id == id)
            .Select(f => new FornecedorDetalhe(
                f.Id,
                f.Cnpj,
                f.RazaoSocial,
                f.NomeFantasia,
                db.ProdutoFornecedores.Count(v => v.FornecedorId == f.Id),
                f.Versao))
            .FirstOrDefaultAsync(cancellationToken);

    /// <summary>Falso quando outra operação gravou a mesma chave única entre a verificação e o INSERT.</summary>
    private async Task<bool> TrySaveAsync(CancellationToken cancellationToken)
    {
        try
        {
            await db.SaveChangesAsync(cancellationToken);
            return true;
        }
        catch (DbUpdateException e) when (e is not DbUpdateConcurrencyException
            && e.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation })
        {
            return false;
        }
    }

    private static AppError FornecedorNotFound() => AppError.NotFound("Fornecedor não encontrado.");

    private static AppError VinculoNotFound() => AppError.NotFound("Vínculo de produto do fornecedor não encontrado.");

    private static AppError CnpjRepetido(string cnpj) => AppError.Conflict($"Já existe um fornecedor com o CNPJ {Cnpj.Format(cnpj)}.");

    private static AppError CodigoRepetido(string codigo) =>
        AppError.Conflict($"O código {codigo} já está vinculado a um produto deste fornecedor.");
}
