using Microsoft.EntityFrameworkCore;
using Stowise.Application.Armazenagem;
using Stowise.Application.Common;
using Stowise.Domain.Armazenagem;
using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Armazenagem;

internal sealed class ArmazenagemService(StowiseDbContext db, MotorArmazenagem motor, TimeProvider time) : IArmazenagemService
{
    private const int LimitePadrao = 5;
    private const int LimiteMaximo = 20;
    private const int DescartadosMaximo = 20;

    public async Task<Result<SugestaoArmazenagem>> SugerirAsync(PedidoSugestaoArmazenagem pedido, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(pedido);
        if (pedido.ProdutoId is not { } produtoId)
        {
            return AppError.Validation("produtoId", "Informe o produto.");
        }

        if (pedido.Quantidade is not { } quantidade || quantidade <= 0)
        {
            return AppError.Validation("quantidade", "Informe uma quantidade maior que zero.");
        }

        var produto = await db.Produtos.AsNoTracking().Include(p => p.Embalagens).FirstOrDefaultAsync(p => p.Id == produtoId, cancellationToken);
        if (produto is null)
        {
            return AppError.NotFound("Produto não encontrado.");
        }

        if (pedido.EmbalagemId is { } embalagemId)
        {
            var embalagem = produto.Embalagens.FirstOrDefault(e => e.Id == embalagemId);
            if (embalagem is null)
            {
                return AppError.BusinessRule("A embalagem não é deste produto.");
            }

            quantidade *= embalagem.FatorConversao;
        }

        var validade = pedido.Validade;
        if (pedido.LoteId is { } loteId)
        {
            var lote = await db.Lotes.AsNoTracking().FirstOrDefaultAsync(l => l.Id == loteId, cancellationToken);
            if (lote is null || lote.ProdutoId != produtoId)
            {
                return AppError.BusinessRule("O lote não é deste produto.");
            }

            validade = lote.Validade;
        }

        var medidas = MedidasUnitarias.From(produto.Embalagens);
        var item = new ItemArmazenagem(
            produto.Id, produto.ClasseArmazenagem, produto.ClasseAbc, pedido.LoteId, validade, quantidade, medidas.PesoDe(quantidade), medidas.VolumeDe(quantidade));

        var candidatos = await LoadCandidatosAsync(pedido.ArmazemId, cancellationToken);
        var configuracao = await db.RegrasArmazenagem.AsNoTracking().ToListAsync(cancellationToken);
        var resultado = motor.Sugerir(item, candidatos, configuracao.Select(r => r.ToConfiguracao()).ToList());

        var limite = Math.Clamp(pedido.Limite ?? LimitePadrao, 1, LimiteMaximo);
        return new SugestaoArmazenagem(
            produto.Id,
            produto.Sku,
            produto.ClasseArmazenagem,
            produto.ClasseAbc,
            quantidade,
            validade,
            item.PesoKg,
            item.VolumeCm3,
            candidatos.Count,
            resultado.Sugestoes.Take(limite).ToList(),
            resultado.Descartados.Count,
            resultado.Descartados.Take(DescartadosMaximo).ToList());
    }

    public async Task<IReadOnlyList<RegraArmazenagemDetalhe>> ListRegrasAsync(CancellationToken cancellationToken = default)
    {
        var regras = await db.RegrasArmazenagem.AsNoTracking().ToListAsync(cancellationToken);
        return motor.Regras
            .Select(r => regras.FirstOrDefault(c => c.Codigo == r.Codigo) is { } config ? ToDetalhe(r, config) : null)
            .OfType<RegraArmazenagemDetalhe>()
            .ToList();
    }

    public async Task<Result<RegraArmazenagemDetalhe>> UpdateRegraAsync(
        string codigo,
        AlterarRegraArmazenagem comando,
        Guid usuarioId,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(comando);
        if (comando.Peso is not { } peso)
        {
            return AppError.Validation("peso", "Informe o peso da regra.");
        }

        if (comando.Ativa is not { } ativa)
        {
            return AppError.Validation("ativa", "Informe se a regra está ativa.");
        }

        if (comando.Parametros is null)
        {
            return AppError.Validation("parametros", "Informe os parâmetros da regra ({} usa os valores padrão).");
        }

        if (comando.Versao is not { } versao)
        {
            return AppError.Validation("versao", "Informe a versão lida da regra.");
        }

        var regra = motor.Regras.FirstOrDefault(r => r.Codigo == codigo);
        var config = regra is null ? null : await db.RegrasArmazenagem.FirstOrDefaultAsync(r => r.Codigo == codigo, cancellationToken);
        if (regra is null || config is null)
        {
            return AppError.NotFound("Regra de armazenagem não encontrada.");
        }

        if (config.Versao != versao)
        {
            return Conflito();
        }

        try
        {
            config.Update(regra, peso, ativa, comando.Parametros, usuarioId, time.GetUtcNow());
        }
        catch (DomainException e)
        {
            return AppError.BusinessRule(e.Message);
        }

        db.Entry(config).Property(r => r.Versao).OriginalValue = versao;
        try
        {
            await db.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateConcurrencyException)
        {
            return Conflito();
        }

        var atualizada = await db.RegrasArmazenagem.AsNoTracking().FirstAsync(r => r.Id == config.Id, cancellationToken);
        return ToDetalhe(regra, atualizada);
    }

    /// <summary>Endereços não bloqueados, com a classe da zona e o estoque de cada um (peso e volume pelas embalagens).</summary>
    private async Task<IReadOnlyList<CandidatoEndereco>> LoadCandidatosAsync(Guid? armazemId, CancellationToken cancellationToken)
    {
        var enderecosQuery = db.Enderecos.AsNoTracking().Where(e => e.Status != StatusEndereco.Bloqueado);
        if (armazemId is { } id)
        {
            enderecosQuery = enderecosQuery.Where(e => e.ArmazemId == id);
        }

        var enderecos = await (
                from e in enderecosQuery
                join z in db.Zonas on e.ZonaId equals z.Id
                select new { Endereco = e, z.ClasseArmazenagem })
            .ToListAsync(cancellationToken);

        var saldos = await (
                from s in db.Saldos.AsNoTracking()
                join e in enderecosQuery on s.EnderecoId equals e.Id
                join l in db.Lotes on s.LoteId equals l.Id into lotes
                from l in lotes.DefaultIfEmpty()
                where s.Quantidade > 0
                select new { s.EnderecoId, s.ProdutoId, s.LoteId, Validade = l == null ? null : l.Validade, s.Quantidade })
            .ToListAsync(cancellationToken);

        var produtos = saldos.Select(s => s.ProdutoId).Distinct().ToList();
        var medidas = (await db.ProdutoEmbalagens.AsNoTracking().Where(e => produtos.Contains(e.ProdutoId)).ToListAsync(cancellationToken))
            .GroupBy(e => e.ProdutoId)
            .ToDictionary(g => g.Key, MedidasUnitarias.From);

        var ocupacao = saldos
            .GroupBy(s => s.EnderecoId)
            .ToDictionary(
                g => g.Key,
                g => (IReadOnlyList<OcupacaoEndereco>)g
                    .Select(s =>
                    {
                        var m = medidas.GetValueOrDefault(s.ProdutoId);
                        return new OcupacaoEndereco(s.ProdutoId, s.LoteId, s.Validade, s.Quantidade, m?.PesoDe(s.Quantidade), m?.VolumeDe(s.Quantidade));
                    })
                    .ToList());

        return enderecos
            .Select(x => CandidatoEndereco.From(x.Endereco, x.ClasseArmazenagem, ocupacao.GetValueOrDefault(x.Endereco.Id) ?? []))
            .ToList();
    }

    private static RegraArmazenagemDetalhe ToDetalhe(IRegraArmazenagem regra, RegraArmazenagem config) =>
        new(config.Id, config.Codigo, regra.Restritiva, config.Peso, config.Ativa, config.Parametros, regra.ParametrosPadrao, config.AtualizadoEm, config.AtualizadoPor, config.Versao);

    private static AppError Conflito() =>
        AppError.Conflict("A regra foi alterada por outra pessoa depois que você a abriu. Recarregue e tente de novo.");
}
