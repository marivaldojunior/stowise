using Microsoft.EntityFrameworkCore;
using Stowise.Application.Common;
using Stowise.Application.Estrutura;
using Stowise.Domain.Estrutura;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Estrutura;

internal sealed class EnderecoService(StowiseDbContext db) : IEnderecoService
{
    public async Task<PagedResult<EnderecoDetalhe>> ListAsync(EnderecoFiltro filtro, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(filtro);
        var (pagina, tamanhoPagina) = Paging.Normalize(filtro.Pagina, filtro.TamanhoPagina);

        var query = db.Enderecos.AsNoTracking();
        if (filtro.ArmazemId is { } armazemId)
        {
            query = query.Where(e => e.ArmazemId == armazemId);
        }

        if (filtro.ZonaId is { } zonaId)
        {
            query = query.Where(e => e.ZonaId == zonaId);
        }

        if (!string.IsNullOrWhiteSpace(filtro.Codigo))
        {
            var prefixo = $"{LikePattern.Escape(filtro.Codigo.Trim())}%";
            query = query.Where(e => EF.Functions.ILike(e.Codigo, prefixo, LikePattern.EscapeCharacter));
        }

        if (filtro.Status is { } status)
        {
            query = query.Where(e => e.Status == status);
        }

        var total = await query.CountAsync(cancellationToken);
        var itens = await query
            .OrderBy(e => e.Rua)
            .ThenBy(e => e.Modulo)
            .ThenBy(e => e.Nivel)
            .ThenBy(e => e.Posicao)
            .ThenBy(e => e.ArmazemId)
            .Skip((pagina - 1) * tamanhoPagina)
            .Take(tamanhoPagina)
            .ToListAsync(cancellationToken);

        return new PagedResult<EnderecoDetalhe>([.. itens.Select(ToDetalhe)], pagina, tamanhoPagina, total);
    }

    public async Task<Result<EnderecoDetalhe>> GetAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var endereco = await db.Enderecos.AsNoTracking().FirstOrDefaultAsync(e => e.Id == id, cancellationToken);
        return endereco is null ? NotFound() : ToDetalhe(endereco);
    }

    public async Task<Result<EnderecoDetalhe>> FindByCodigoAsync(Guid armazemId, string? codigo, CancellationToken cancellationToken = default)
    {
        var valor = codigo?.Trim().ToUpperInvariant();
        if (string.IsNullOrEmpty(valor))
        {
            return AppError.Validation("codigo", "Informe o código do endereço (ex.: A-03-02-1).");
        }

        var endereco = await db.Enderecos.AsNoTracking()
            .FirstOrDefaultAsync(e => e.ArmazemId == armazemId && e.Codigo == valor, cancellationToken);
        return endereco is null ? AppError.NotFound($"Endereço {valor} não encontrado neste armazém.") : ToDetalhe(endereco);
    }

    public async Task<Result<EnderecoDetalhe>> CreateAsync(CriarEndereco comando, CancellationToken cancellationToken = default)
    {
        var errors = EstruturaValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var zona = await db.Zonas.AsNoTracking().FirstOrDefaultAsync(z => z.Id == comando.ZonaId, cancellationToken);
        if (zona is null)
        {
            return AppError.Validation("zonaId", "Zona não encontrada.");
        }

        var endereco = Endereco.Create(
            zona,
            comando.Rua!,
            comando.Modulo!.Value,
            comando.Nivel!.Value,
            comando.Posicao!.Value,
            EstruturaValidation.ToDimensoes(comando.CapacidadePesoKg, comando.AlturaCm, comando.LarguraCm, comando.ProfundidadeCm, comando.DistanciaExpedicao));

        if (await db.Enderecos.AnyAsync(e => e.ArmazemId == endereco.ArmazemId && e.Codigo == endereco.Codigo, cancellationToken))
        {
            return AppError.Conflict($"O endereço {endereco.Codigo} já existe neste armazém.");
        }

        db.Enderecos.Add(endereco);
        await db.SaveChangesAsync(cancellationToken);
        return ToDetalhe(endereco);
    }

    public async Task<Result<GeracaoEnderecosResultado>> GenerateAsync(GerarEnderecos comando, CancellationToken cancellationToken = default)
    {
        var errors = EstruturaValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var zona = await db.Zonas.AsNoTracking().FirstOrDefaultAsync(z => z.Id == comando.ZonaId, cancellationToken);
        if (zona is null)
        {
            return AppError.Validation("zonaId", "Zona não encontrada.");
        }

        var gerados = GeradorEnderecos.Gerar(zona, EstruturaValidation.ToPlano(comando));
        var codigos = gerados.Select(e => e.Codigo).ToList();
        var existentes = await db.Enderecos.AsNoTracking()
            .Where(e => e.ArmazemId == zona.ArmazemId && codigos.Contains(e.Codigo))
            .Select(e => e.Codigo)
            .ToListAsync(cancellationToken);
        existentes.Sort(StringComparer.Ordinal);

        var jaExistem = existentes.ToHashSet(StringComparer.Ordinal);
        var novos = gerados.Where(e => !jaExistem.Contains(e.Codigo)).ToList();
        var resultado = new GeracaoEnderecosResultado(
            gerados.Count,
            novos.Count,
            existentes.Count,
            comando.Simular,
            [.. existentes.Take(50)],
            [.. novos.Take(10).Select(e => e.Codigo)]);

        if (comando.Simular)
        {
            return resultado;
        }

        if (existentes.Count > 0 && !comando.IgnorarExistentes)
        {
            return AppError.Conflict(
                $"{existentes.Count} dos {gerados.Count} endereços já existem neste armazém (ex.: {string.Join(", ", existentes.Take(5))}). "
                + "Use ignorarExistentes para criar só os que faltam.");
        }

        db.Enderecos.AddRange(novos);
        await db.SaveChangesAsync(cancellationToken);
        return resultado;
    }

    public async Task<Result<EnderecoDetalhe>> UpdateAsync(Guid id, DimensoesEnderecoComando comando, CancellationToken cancellationToken = default)
    {
        var errors = EstruturaValidation.Validate(comando);
        if (errors.Count > 0)
        {
            return AppError.Validation(errors);
        }

        var endereco = await db.Enderecos.FindAsync([id], cancellationToken);
        if (endereco is null)
        {
            return NotFound();
        }

        endereco.UpdateDimensoes(EstruturaValidation.ToDimensoes(
            comando.CapacidadePesoKg, comando.AlturaCm, comando.LarguraCm, comando.ProfundidadeCm, comando.DistanciaExpedicao));
        await db.SaveChangesAsync(cancellationToken);
        return ToDetalhe(endereco);
    }

    public async Task<Result> DeleteAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var endereco = await db.Enderecos.FindAsync([id], cancellationToken);
        if (endereco is null)
        {
            return NotFound();
        }

        if (endereco.Status == StatusEndereco.Ocupado)
        {
            return AppError.BusinessRule($"O endereço {endereco.Codigo} está ocupado e não pode ser excluído.");
        }

        db.Enderecos.Remove(endereco);
        await db.SaveChangesAsync(cancellationToken);
        return Result.Success();
    }

    private static EnderecoDetalhe ToDetalhe(Endereco e) =>
        new(
            e.Id,
            e.ArmazemId,
            e.ZonaId,
            e.Codigo,
            e.Rua,
            e.Modulo,
            e.Nivel,
            e.Posicao,
            e.CapacidadePesoKg,
            e.AlturaCm,
            e.LarguraCm,
            e.ProfundidadeCm,
            e.DistanciaExpedicao,
            e.Status,
            e.MotivoBloqueio);

    private static AppError NotFound() => AppError.NotFound("Endereço não encontrado.");
}
