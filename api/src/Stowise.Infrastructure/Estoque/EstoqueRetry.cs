using Microsoft.EntityFrameworkCore;
using Npgsql;
using Stowise.Infrastructure.Persistence.Configurations;

namespace Stowise.Infrastructure.Estoque;

/// <summary>Regras de nova tentativa das operações que alteram o saldo (ADR-0006).</summary>
internal static class EstoqueRetry
{
    /// <summary>Com conflito otimista, cada rodada tem ao menos um vencedor: N operações simultâneas precisam de até N tentativas.</summary>
    public const int MaxTentativas = 5;

    /// <summary>Outra operação mudou o saldo, o endereço ou a reserva, ou criou o mesmo saldo ou lote, entre a leitura e a gravação.</summary>
    public static bool IsRetryable(DbUpdateException e) =>
        e is DbUpdateConcurrencyException
        || IsUniqueViolation(e, SaldoConfiguration.UniqueIndex)
        || IsUniqueViolation(e, LoteConfiguration.UniqueIndex);

    public static bool IsUniqueViolation(DbUpdateException e, string index) =>
        e.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation } pg && pg.ConstraintName == index;

    /// <summary>Espera curta e aleatória, crescente por tentativa, para as operações concorrentes não colidirem de novo.</summary>
    public static Task DelayAsync(int tentativa, TimeProvider time, CancellationToken cancellationToken) =>
        Task.Delay(TimeSpan.FromMilliseconds(Random.Shared.Next(5, 25) * tentativa), time, cancellationToken);
}
