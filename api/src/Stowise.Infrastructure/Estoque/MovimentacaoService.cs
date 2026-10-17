using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Estoque;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;
using Stowise.Infrastructure.Persistence;
using Stowise.Infrastructure.Persistence.Configurations;

namespace Stowise.Infrastructure.Estoque;

/// <summary>
/// Orquestra as movimentações: carrega produto, endereço, lote e saldo, deixa o domínio aplicar as regras
/// e grava movimentação, saldo e ocupação do endereço num único SaveChanges (uma transação).
/// Idempotência e concorrência seguem o ADR-0006.
/// </summary>
internal sealed class MovimentacaoService(StowiseDbContext db, TimeProvider time) : IMovimentacaoService
{
    public Task<Result<MovimentacaoRegistrada>> RegistrarEntradaAsync(
        RegistrarEntrada comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default) =>
        RegistrarAsync(
            comando.IdempotencyKey,
            agora => EstoqueValidation.Validate(comando, agora),
            () => new Esperado(TipoMovimentacao.Entrada, comando.ProdutoId!.Value, comando.EmbalagemId, Origem: null, comando.EnderecoId, comando.Quantidade!.Value),
            agora => PrepareEntradaAsync(comando, usuarioId, agora, cancellationToken),
            cancellationToken);

    public Task<Result<MovimentacaoRegistrada>> RegistrarSaidaAsync(
        RegistrarSaida comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default) =>
        RegistrarAsync(
            comando.IdempotencyKey,
            agora => EstoqueValidation.Validate(comando, agora),
            () => new Esperado(TipoMovimentacao.Saida, comando.ProdutoId!.Value, comando.EmbalagemId, comando.EnderecoId, Destino: null, comando.Quantidade!.Value),
            agora => PrepareSaidaAsync(comando, usuarioId, agora, cancellationToken),
            cancellationToken);

    public Task<Result<MovimentacaoRegistrada>> RegistrarAjusteAsync(
        RegistrarAjuste comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default) =>
        RegistrarAsync(
            comando.IdempotencyKey,
            agora => EstoqueValidation.Validate(comando, agora),
            () =>
            {
                var delta = comando.Quantidade!.Value;
                return new Esperado(
                    TipoMovimentacao.Ajuste,
                    comando.ProdutoId!.Value,
                    EmbalagemId: null,
                    delta < 0 ? comando.EnderecoId : null,
                    delta > 0 ? comando.EnderecoId : null,
                    Math.Abs(delta));
            },
            agora => PrepareAjusteAsync(comando, usuarioId, agora, cancellationToken),
            cancellationToken);

    public Task<Result<MovimentacaoRegistrada>> RegistrarTransferenciaAsync(
        RegistrarTransferencia comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default) =>
        RegistrarAsync(
            comando.IdempotencyKey,
            agora => EstoqueValidation.Validate(comando, agora),
            () => new Esperado(
                TipoMovimentacao.Transferencia,
                comando.ProdutoId!.Value,
                comando.EmbalagemId,
                comando.EnderecoOrigemId,
                comando.EnderecoDestinoId,
                comando.Quantidade!.Value),
            agora => PrepareTransferenciaAsync(comando, usuarioId, agora, cancellationToken),
            cancellationToken);

    public async Task<Result<MovimentacaoRegistrada>> ConsumirReservaAsync(
        Guid reservaId,
        ConsumirReserva comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default)
    {
        var reserva = await db.Reservas.AsNoTracking().FirstOrDefaultAsync(r => r.Id == reservaId, cancellationToken);
        if (reserva is null)
        {
            return AppError.NotFound("Reserva não encontrada.");
        }

        return await RegistrarAsync(
            comando.IdempotencyKey,
            agora => EstoqueValidation.Validate(comando, agora),
            () => new Esperado(TipoMovimentacao.Saida, reserva.ProdutoId, EmbalagemId: null, reserva.EnderecoId, Destino: null, reserva.Quantidade),
            agora => PrepareConsumoAsync(reservaId, comando, usuarioId, agora, cancellationToken),
            cancellationToken);
    }

    public async Task<Result<MovimentacaoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var detalhe = await DetalheAsync(m => m.Id == id, cancellationToken);
        return detalhe is null ? AppError.NotFound("Movimentação não encontrada.") : detalhe;
    }

    private async Task<Result<MovimentacaoRegistrada>> RegistrarAsync(
        Guid? idempotencyKey,
        Func<DateTimeOffset, IReadOnlyDictionary<string, string[]>> validate,
        Func<Esperado> esperado,
        Func<DateTimeOffset, Task<Result<Preparada>>> prepare,
        CancellationToken cancellationToken)
    {
        var agora = time.GetUtcNow();
        var errors = validate(agora);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        // Reenvio da mesma operação (app offline): devolve a original antes de reaplicar qualquer regra.
        if (idempotencyKey is { } key && await DetalheAsync(m => m.IdempotencyKey == key, cancellationToken) is { } original)
        {
            return await ReplayAsync(original, esperado(), cancellationToken);
        }

        for (var tentativa = 1; ; tentativa++)
        {
            try
            {
                if (tentativa > 1 && idempotencyKey is { } chave
                    && await DetalheAsync(m => m.IdempotencyKey == chave, cancellationToken) is { } gravadaNoMeioTempo)
                {
                    return await ReplayAsync(gravadaNoMeioTempo, esperado(), cancellationToken);
                }

                var preparada = await prepare(agora);
                if (preparada.Error is not null)
                {
                    return preparada.Error;
                }

                return new MovimentacaoRegistrada(await SaveAsync(preparada.Value, cancellationToken), Repetida: false);
            }
            catch (DbUpdateException e) when (idempotencyKey is not null && EstoqueRetry.IsUniqueViolation(e, MovimentacaoConfiguration.IdempotencyKeyIndex))
            {
                // Duas requisições simultâneas com a mesma chave: a outra gravou primeiro.
                db.ChangeTracker.Clear();
                var vencedora = await DetalheAsync(m => m.IdempotencyKey == idempotencyKey, cancellationToken);
                return await ReplayAsync(vencedora!, esperado(), cancellationToken);
            }
            catch (DbUpdateException e) when (tentativa < EstoqueRetry.MaxTentativas && EstoqueRetry.IsRetryable(e))
            {
                // Outra operação mudou o saldo (ou criou o mesmo saldo ou lote) entre a leitura e a gravação:
                // repete com dados frescos. Na última tentativa, a exceção vira 409 no handler global.
                db.ChangeTracker.Clear();
                await EstoqueRetry.DelayAsync(tentativa, time, cancellationToken);
            }
        }
    }

    private async Task<Result<MovimentacaoRegistrada>> ReplayAsync(MovimentacaoDetalhe original, Esperado esperado, CancellationToken cancellationToken)
    {
        var fator = esperado.EmbalagemId is { } embalagemId
            ? await db.ProdutoEmbalagens.Where(e => e.Id == embalagemId).Select(e => (decimal?)e.FatorConversao).FirstOrDefaultAsync(cancellationToken) ?? 0m
            : 1m;

        var mesmaOperacao = original.Tipo == esperado.Tipo
            && original.ProdutoId == esperado.ProdutoId
            && original.EnderecoOrigemId == esperado.Origem
            && original.EnderecoDestinoId == esperado.Destino
            && original.Quantidade == esperado.Quantidade * fator;

        return mesmaOperacao
            ? new MovimentacaoRegistrada(original, Repetida: true)
            : AppError.Conflict("Esta chave de idempotência já foi usada para outra operação. Gere uma nova chave para uma nova operação.");
    }

    private async Task<Result<Preparada>> PrepareEntradaAsync(RegistrarEntrada comando, Guid usuarioId, DateTimeOffset agora, CancellationToken cancellationToken)
    {
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
            new Registro(usuarioId, comando.DispositivoId, comando.OcorridoEm ?? agora, agora, comando.IdempotencyKey),
            comando.DocumentoReferencia);
        return new Preparada(movimentacao, [endereco], [saldo], lote);
    }

    private async Task<Result<Preparada>> PrepareSaidaAsync(RegistrarSaida comando, Guid usuarioId, DateTimeOffset agora, CancellationToken cancellationToken)
    {
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
            new Registro(usuarioId, comando.DispositivoId, comando.OcorridoEm ?? agora, agora, comando.IdempotencyKey),
            comando.DocumentoReferencia);
        return new Preparada(movimentacao, [endereco], [saldo], lote.Value);
    }

    private async Task<Result<Preparada>> PrepareAjusteAsync(RegistrarAjuste comando, Guid usuarioId, DateTimeOffset agora, CancellationToken cancellationToken)
    {
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
            new Registro(usuarioId, DispositivoId: null, comando.OcorridoEm ?? agora, agora, comando.IdempotencyKey),
            comando.Motivo!);
        return new Preparada(movimentacao, [endereco], [saldo], lote.Value);
    }

    private async Task<Result<Preparada>> PrepareTransferenciaAsync(
        RegistrarTransferencia comando,
        Guid usuarioId,
        DateTimeOffset agora,
        CancellationToken cancellationToken)
    {
        var (produto, fator, origem, erro) = await LoadAsync(comando.ProdutoId!.Value, comando.EmbalagemId, comando.EnderecoOrigemId!.Value, cancellationToken);
        if (erro is not null)
        {
            return erro.Fields?.ContainsKey("enderecoId") == true ? AppError.Validation("enderecoOrigemId", "Endereço de origem não encontrado.") : erro;
        }

        var destino = await db.Enderecos.FindAsync([comando.EnderecoDestinoId!.Value], cancellationToken);
        if (destino is null)
        {
            return AppError.Validation("enderecoDestinoId", "Endereço de destino não encontrado.");
        }

        var lote = await FindLoteAsync(produto!.Id, comando.Lote, cancellationToken);
        if (lote.Error is not null)
        {
            return lote.Error;
        }

        var saldoOrigem = await GetOrCreateSaldoAsync(origem!.Id, produto.Id, lote.Value?.Id, cancellationToken);
        var saldoDestino = await GetOrCreateSaldoAsync(destino.Id, produto.Id, lote.Value?.Id, cancellationToken);
        var movimentacao = Movimentacao.Transferencia(
            produto,
            lote.Value,
            origem,
            saldoOrigem,
            destino,
            saldoDestino,
            comando.Quantidade!.Value * fator,
            new Registro(usuarioId, comando.DispositivoId, comando.OcorridoEm ?? agora, agora, comando.IdempotencyKey),
            comando.DocumentoReferencia);
        return new Preparada(movimentacao, [origem, destino], [saldoOrigem, saldoDestino], lote.Value);
    }

    private async Task<Result<Preparada>> PrepareConsumoAsync(
        Guid reservaId,
        ConsumirReserva comando,
        Guid usuarioId,
        DateTimeOffset agora,
        CancellationToken cancellationToken)
    {
        var reserva = await db.Reservas.FindAsync([reservaId], cancellationToken);
        if (reserva is null)
        {
            return AppError.NotFound("Reserva não encontrada.");
        }

        var (produto, _, endereco, erro) = await LoadAsync(reserva.ProdutoId, embalagemId: null, reserva.EnderecoId, cancellationToken);
        if (erro is not null)
        {
            return erro;
        }

        var lote = reserva.LoteId is { } loteId ? await db.Lotes.FindAsync([loteId], cancellationToken) : null;
        var saldo = await GetOrCreateSaldoAsync(endereco!.Id, produto!.Id, lote?.Id, cancellationToken);
        var movimentacao = Movimentacao.SaidaReservada(
            produto,
            lote,
            endereco,
            saldo,
            reserva,
            new Registro(usuarioId, comando.DispositivoId, comando.OcorridoEm ?? agora, agora, comando.IdempotencyKey),
            comando.DocumentoReferencia);
        return new Preparada(movimentacao, [endereco], [saldo], lote);
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

    private async Task<MovimentacaoDetalhe> SaveAsync(Preparada preparada, CancellationToken cancellationToken)
    {
        var (movimentacao, enderecos, saldos, lote) = preparada;
        var afetados = saldos.Select(s => s.Id).ToList();
        foreach (var endereco in enderecos)
        {
            var temSaldo = saldos.Any(s => s.EnderecoId == endereco.Id && s.Quantidade > 0)
                || await db.Saldos.AnyAsync(s => s.EnderecoId == endereco.Id && !afetados.Contains(s.Id) && s.Quantidade > 0, cancellationToken);
            endereco.SyncOcupacao(temSaldo);
        }

        db.Movimentacoes.Add(movimentacao);
        await db.SaveChangesAsync(cancellationToken);
        return ToDetalhe(movimentacao, lote?.Numero);
    }

    private async Task<MovimentacaoDetalhe?> DetalheAsync(
        System.Linq.Expressions.Expression<Func<Movimentacao, bool>> filtro,
        CancellationToken cancellationToken)
    {
        var encontrada = await (
                from m in db.Movimentacoes.AsNoTracking().Where(filtro)
                join l in db.Lotes on m.LoteId equals l.Id into lotes
                from l in lotes.DefaultIfEmpty()
                select new { m, LoteNumero = l == null ? null : l.Numero })
            .FirstOrDefaultAsync(cancellationToken);

        return encontrada is null ? null : ToDetalhe(encontrada.m, encontrada.LoteNumero);
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
            m.RecebidoEm,
            m.IdempotencyKey);

    /// <summary>Operação montada pelo domínio, pronta para gravar, com os endereços e saldos que ela altera.</summary>
    private sealed record Preparada(Movimentacao Movimentacao, IReadOnlyList<Endereco> Enderecos, IReadOnlyList<Saldo> Saldos, Lote? Lote);

    /// <summary>O que o comando pede, para comparar com a movimentação já gravada sob a mesma chave.</summary>
    private sealed record Esperado(
        TipoMovimentacao Tipo,
        Guid ProdutoId,
        Guid? EmbalagemId,
        Guid? Origem,
        Guid? Destino,
        decimal Quantidade);
}
