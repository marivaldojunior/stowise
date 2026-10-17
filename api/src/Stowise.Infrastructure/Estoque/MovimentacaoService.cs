using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Estoque;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Estoque;

/// <summary>
/// Orquestra as movimentações: carrega produto, endereço, lote e saldo, deixa o domínio aplicar as regras
/// e grava movimentação, saldo e ocupação do endereço num único SaveChanges (uma transação).
/// </summary>
internal sealed class MovimentacaoService(StowiseDbContext db, TimeProvider time) : IMovimentacaoService
{
    public async Task<Result<MovimentacaoDetalhe>> RegistrarEntradaAsync(
        RegistrarEntrada comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default)
    {
        var agora = time.GetUtcNow();
        var errors = EstoqueValidation.Validate(comando, agora);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var (produto, fator, endereco, erro) = await LoadAsync(comando.ProdutoId!.Value, comando.EmbalagemId, comando.EnderecoId!.Value, cancellationToken);
        if (erro is not null)
        {
            return erro;
        }

        Lote? lote = null;
        if (comando.Lote is { } informado)
        {
            var resolvido = await GetOrCreateLoteAsync(produto!, informado, cancellationToken);
            if (resolvido.Error is not null)
            {
                return resolvido.Error;
            }

            lote = resolvido.Value;
        }

        var saldo = await GetOrCreateSaldoAsync(endereco!.Id, produto!.Id, lote?.Id, cancellationToken);
        var movimentacao = Movimentacao.Entrada(
            produto,
            lote,
            endereco,
            saldo,
            comando.Quantidade!.Value * fator,
            new Registro(usuarioId, comando.DispositivoId, comando.OcorridoEm ?? agora, agora),
            comando.DocumentoReferencia);

        return await SaveAsync(movimentacao, endereco, saldo, lote, cancellationToken);
    }

    public async Task<Result<MovimentacaoDetalhe>> RegistrarSaidaAsync(
        RegistrarSaida comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default)
    {
        var agora = time.GetUtcNow();
        var errors = EstoqueValidation.Validate(comando, agora);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var (produto, fator, endereco, erro) = await LoadAsync(comando.ProdutoId!.Value, comando.EmbalagemId, comando.EnderecoId!.Value, cancellationToken);
        if (erro is not null)
        {
            return erro;
        }

        var lote = await FindLoteAsync(produto!.Id, comando.Lote, cancellationToken);
        if (lote.Error is not null)
        {
            return lote.Error;
        }

        var saldo = await GetOrCreateSaldoAsync(endereco!.Id, produto.Id, lote.Value?.Id, cancellationToken);
        var movimentacao = Movimentacao.Saida(
            produto,
            lote.Value,
            endereco,
            saldo,
            comando.Quantidade!.Value * fator,
            new Registro(usuarioId, comando.DispositivoId, comando.OcorridoEm ?? agora, agora),
            comando.DocumentoReferencia);

        return await SaveAsync(movimentacao, endereco, saldo, lote.Value, cancellationToken);
    }

    public async Task<Result<MovimentacaoDetalhe>> RegistrarAjusteAsync(
        RegistrarAjuste comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default)
    {
        var agora = time.GetUtcNow();
        var errors = EstoqueValidation.Validate(comando, agora);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var (produto, _, endereco, erro) = await LoadAsync(comando.ProdutoId!.Value, embalagemId: null, comando.EnderecoId!.Value, cancellationToken);
        if (erro is not null)
        {
            return erro;
        }

        var lote = await FindLoteAsync(produto!.Id, comando.Lote, cancellationToken);
        if (lote.Error is not null)
        {
            return lote.Error;
        }

        var saldo = await GetOrCreateSaldoAsync(endereco!.Id, produto.Id, lote.Value?.Id, cancellationToken);
        var movimentacao = Movimentacao.Ajuste(
            produto,
            lote.Value,
            endereco,
            saldo,
            comando.Quantidade!.Value,
            new Registro(usuarioId, DispositivoId: null, comando.OcorridoEm ?? agora, agora),
            comando.Motivo!);

        return await SaveAsync(movimentacao, endereco, saldo, lote.Value, cancellationToken);
    }

    public async Task<Result<MovimentacaoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var detalhe = await (
                from m in db.Movimentacoes.AsNoTracking()
                join l in db.Lotes on m.LoteId equals l.Id into lotes
                from l in lotes.DefaultIfEmpty()
                where m.Id == id
                select new { m, LoteNumero = l == null ? null : l.Numero })
            .FirstOrDefaultAsync(cancellationToken);

        return detalhe is null
            ? AppError.NotFound("Movimentação não encontrada.")
            : ToDetalhe(detalhe.m, detalhe.LoteNumero);
    }

    private async Task<(Produto? Produto, decimal Fator, Endereco? Endereco, AppError? Erro)> LoadAsync(
        Guid produtoId,
        Guid? embalagemId,
        Guid enderecoId,
        CancellationToken cancellationToken)
    {
        var produto = await db.Produtos.Include(p => p.Embalagens).FirstOrDefaultAsync(p => p.Id == produtoId, cancellationToken);
        if (produto is null)
        {
            return (null, 0, null, AppError.Validation("produtoId", "Produto não encontrado."));
        }

        var fator = 1m;
        if (embalagemId is not null)
        {
            var embalagem = produto.Embalagens.FirstOrDefault(e => e.Id == embalagemId);
            if (embalagem is null)
            {
                return (null, 0, null, AppError.Validation("embalagemId", "Embalagem não encontrada neste produto."));
            }

            fator = embalagem.FatorConversao;
        }

        var endereco = await db.Enderecos.FindAsync([enderecoId], cancellationToken);
        return endereco is null
            ? (null, 0, null, AppError.Validation("enderecoId", "Endereço não encontrado."))
            : (produto, fator, endereco, null);
    }

    private async Task<Result<Lote>> GetOrCreateLoteAsync(Produto produto, LoteInformado informado, CancellationToken cancellationToken)
    {
        var numero = Lote.NormalizeNumero(informado.Numero);
        var existente = await db.Lotes.FirstOrDefaultAsync(l => l.ProdutoId == produto.Id && l.Numero == numero, cancellationToken);
        if (existente is null)
        {
            var novo = Lote.Create(produto.Id, numero, informado.Fabricacao, informado.Validade);
            db.Lotes.Add(novo);
            return novo;
        }

        // Um lote já cadastrado não muda de datas: divergência indica erro de digitação ou de etiqueta.
        if ((informado.Validade is not null && informado.Validade != existente.Validade)
            || (informado.Fabricacao is not null && informado.Fabricacao != existente.Fabricacao))
        {
            return AppError.BusinessRule(
                $"O lote {numero} já está cadastrado com fabricação {existente.Fabricacao:dd/MM/yyyy} e validade {existente.Validade:dd/MM/yyyy}. Confira a etiqueta.");
        }

        return existente;
    }

    private async Task<Result<Lote?>> FindLoteAsync(Guid produtoId, string? numero, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(numero))
        {
            return (Lote?)null;
        }

        var normalizado = Lote.NormalizeNumero(numero);
        var lote = await db.Lotes.FirstOrDefaultAsync(l => l.ProdutoId == produtoId && l.Numero == normalizado, cancellationToken);
        return lote is null ? AppError.BusinessRule($"O lote {normalizado} não existe para este produto.") : lote;
    }

    private async Task<Saldo> GetOrCreateSaldoAsync(Guid enderecoId, Guid produtoId, Guid? loteId, CancellationToken cancellationToken)
    {
        var saldo = await db.Saldos.FirstOrDefaultAsync(
            s => s.EnderecoId == enderecoId && s.ProdutoId == produtoId && s.LoteId == loteId,
            cancellationToken);
        if (saldo is null)
        {
            saldo = Saldo.Create(enderecoId, produtoId, loteId);
            db.Saldos.Add(saldo);
        }

        return saldo;
    }

    private async Task<Result<MovimentacaoDetalhe>> SaveAsync(
        Movimentacao movimentacao,
        Endereco endereco,
        Saldo saldoAfetado,
        Lote? lote,
        CancellationToken cancellationToken)
    {
        var outrosSaldos = await db.Saldos.AnyAsync(
            s => s.EnderecoId == endereco.Id && s.Id != saldoAfetado.Id && s.Quantidade > 0,
            cancellationToken);
        endereco.SyncOcupacao(saldoAfetado.Quantidade > 0 || outrosSaldos);

        db.Movimentacoes.Add(movimentacao);
        await db.SaveChangesAsync(cancellationToken);
        return ToDetalhe(movimentacao, lote?.Numero);
    }

    private static MovimentacaoDetalhe ToDetalhe(Movimentacao m, string? loteNumero) =>
        new(
            m.Id,
            m.Tipo,
            m.ProdutoId,
            m.LoteId,
            loteNumero,
            m.EnderecoOrigemId,
            m.EnderecoDestinoId,
            m.Quantidade,
            m.DocumentoReferencia,
            m.Observacao,
            m.UsuarioId,
            m.DispositivoId,
            m.OcorridoEm,
            m.RecebidoEm);
}
