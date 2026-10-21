using Microsoft.EntityFrameworkCore;
using Stowise.Domain.Armazenagem;
using Stowise.Domain.Estoque;
using Stowise.Domain.Estrutura;
using Stowise.Domain.Recebimentos;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Armazenagem;

/// <summary>Carrega candidatos e configuração do banco para o <see cref="MotorArmazenagem"/> e cria as tarefas de armazenagem.</summary>
internal sealed class PlanejadorArmazenagem(StowiseDbContext db, MotorArmazenagem motor)
{
    public MotorArmazenagem Motor => motor;

    public async Task<IReadOnlyList<ConfiguracaoRegra>> LoadConfiguracaoAsync(CancellationToken cancellationToken) =>
        (await db.RegrasArmazenagem.AsNoTracking().ToListAsync(cancellationToken)).Select(r => r.ToConfiguracao()).ToList();

    /// <summary>
    /// Uma tarefa por item e lote contados, com a melhor sugestão do motor. A carga de cada tarefa entra na ocupação do
    /// endereço sugerido, para as próximas tarefas do mesmo recebimento não contarem com o mesmo espaço. Tarefas
    /// pendentes de outros recebimentos não reservam espaço.
    /// </summary>
    public async Task<IReadOnlyList<TarefaArmazenagem>> PlanejarAsync(Recebimento recebimento, DateTimeOffset agora, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(recebimento);
        var ids = recebimento.Itens.Select(i => i.ProdutoId).Distinct().ToList();
        var produtos = await db.Produtos.AsNoTracking().Include(p => p.Embalagens).Where(p => ids.Contains(p.Id)).ToDictionaryAsync(p => p.Id, cancellationToken);
        var lotes = await db.Lotes.AsNoTracking()
            .Where(l => ids.Contains(l.ProdutoId))
            .Select(l => new { l.Id, l.ProdutoId, l.Numero })
            .ToListAsync(cancellationToken);

        var configuracao = await LoadConfiguracaoAsync(cancellationToken);
        var versao = TarefaArmazenagem.VersaoDe(configuracao);
        var candidatos = (await LoadCandidatosAsync(null, cancellationToken)).ToList();
        var tarefas = new List<TarefaArmazenagem>();

        foreach (var item in recebimento.Itens.Where(i => i.QuantidadeConferida > 0).OrderBy(i => i.NumeroItem))
        {
            var produto = produtos[item.ProdutoId];
            var medidas = MedidasUnitarias.From(produto.Embalagens);
            IEnumerable<(LoteRecebido? Lote, decimal Quantidade)> partes = item.LotesConferidos.Count > 0
                ? item.LotesConferidos.Select(l => ((LoteRecebido?)l, l.QuantidadeBase))
                : [(null, item.QuantidadeConferida!.Value)];

            foreach (var (lote, quantidade) in partes.Where(p => p.Quantidade > 0))
            {
                var numero = lote is null ? null : Lote.NormalizeNumero(lote.Numero);
                var loteId = lotes.FirstOrDefault(l => l.ProdutoId == produto.Id && l.Numero == numero)?.Id;
                var carga = new ItemArmazenagem(
                    produto.Id, produto.ClasseArmazenagem, produto.ClasseAbc, loteId, lote?.Validade, quantidade, medidas.PesoDe(quantidade), medidas.VolumeDe(quantidade));

                var sugestoes = motor.Sugerir(carga, candidatos, configuracao).Sugestoes;
                var melhor = sugestoes.Count > 0 ? sugestoes[0] : null;
                tarefas.Add(TarefaArmazenagem.Create(item, lote, quantidade, melhor, versao, agora));

                var indice = melhor is null ? -1 : candidatos.FindIndex(c => c.EnderecoId == melhor.EnderecoId);
                if (indice >= 0)
                {
                    var planejada = new OcupacaoEndereco(carga.ProdutoId, carga.LoteId, carga.Validade, carga.Quantidade, carga.PesoKg, carga.VolumeCm3);
                    candidatos[indice] = candidatos[indice] with { Ocupacao = [.. candidatos[indice].Ocupacao, planejada] };
                }
            }
        }

        return tarefas;
    }

    /// <summary>Endereços não bloqueados, com a classe da zona e o estoque de cada um (peso e volume pelas embalagens).</summary>
    public async Task<IReadOnlyList<CandidatoEndereco>> LoadCandidatosAsync(Guid? armazemId, CancellationToken cancellationToken)
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
}
