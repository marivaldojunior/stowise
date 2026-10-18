using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Ia;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Ia;

internal sealed class ConsultaIaService(StowiseDbContext db) : IConsultaIaService
{
    public async Task<PagedResult<ChamadaIaDetalhe>> ListChamadasAsync(ChamadaIaFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query = db.ChamadasIa.AsNoTracking();
        if (filtro.Funcionalidade is { } funcionalidade)
        {
            query = query.Where(c => c.Funcionalidade == funcionalidade);
        }

        if (filtro.UsuarioId is { } usuarioId)
        {
            query = query.Where(c => c.UsuarioId == usuarioId);
        }

        if (filtro.Sucesso is { } sucesso)
        {
            query = query.Where(c => c.Sucesso == sucesso);
        }

        if (filtro.De is { } de)
        {
            query = query.Where(c => c.CriadaEm >= de);
        }

        if (filtro.Ate is { } ate)
        {
            query = query.Where(c => c.CriadaEm <= ate);
        }

        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .OrderByDescending(c => c.CriadaEm)
            .ThenByDescending(c => c.Id)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .Select(c => new ChamadaIaDetalhe(
                c.Id,
                c.Funcionalidade,
                c.UsuarioId,
                c.Provedor,
                c.Modelo,
                c.PromptVersao,
                c.TokensEntrada,
                c.TokensSaida,
                c.CustoEstimado,
                c.LatenciaMs,
                c.Tentativas,
                c.UsouFallback,
                c.Sucesso,
                c.Erro,
                c.CorrelacaoId,
                c.CriadaEm))
            .ToListAsync(cancellationToken);

        return new PagedResult<ChamadaIaDetalhe>(itens, pagina, tamanhoPagina, total);
    }
}
