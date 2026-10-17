using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;

namespace Stowise.Domain.Estoque;

/// <summary>Quem registrou o movimento, de onde e quando (hora do aparelho e hora do servidor).</summary>
public sealed record Registro(Guid UsuarioId, Guid? DispositivoId, DateTimeOffset OcorridoEm, DateTimeOffset RecebidoEm);

/// <summary>
/// Livro-razão do estoque (ADR-0001): nunca é editado nem apagado. A quantidade é sempre positiva e na
/// unidade base; o sentido vem dos endereços (origem = de onde sai, destino = para onde vai).
/// </summary>
public sealed class Movimentacao : Entity
{
    public const int DocumentoReferenciaMaxLength = 60;
    public const int ObservacaoMaxLength = 250;

    private Movimentacao()
    {
    }

    public TipoMovimentacao Tipo { get; private set; }

    public Guid ProdutoId { get; private set; }

    public Guid? LoteId { get; private set; }

    public Guid? EnderecoOrigemId { get; private set; }

    public Guid? EnderecoDestinoId { get; private set; }

    public decimal Quantidade { get; private set; }

    public string? DocumentoReferencia { get; private set; }

    public string? Observacao { get; private set; }

    public Guid UsuarioId { get; private set; }

    public Guid? DispositivoId { get; private set; }

    /// <summary>Hora do aparelho em que a operação aconteceu (pode ser anterior, no modo offline).</summary>
    public DateTimeOffset OcorridoEm { get; private set; }

    /// <summary>Hora em que o servidor recebeu a operação.</summary>
    public DateTimeOffset RecebidoEm { get; private set; }

    /// <summary>Entrada no endereço de destino. Atualiza o saldo de destino.</summary>
    public static Movimentacao Entrada(
        Produto produto,
        Lote? lote,
        Endereco destino,
        Saldo saldoDestino,
        decimal quantidade,
        Registro registro,
        string? documento)
    {
        ArgumentNullException.ThrowIfNull(produto);
        if (!produto.Ativo)
        {
            throw new DomainException($"O produto {produto.Sku} está inativo e não pode receber entrada.");
        }

        var movimentacao = Create(TipoMovimentacao.Entrada, produto, lote, origem: null, destino, quantidade, registro, documento, observacao: null);
        movimentacao.Apply(saldoOrigem: null, saldoDestino);
        return movimentacao;
    }

    /// <summary>Saída do endereço de origem. Exige saldo disponível.</summary>
    public static Movimentacao Saida(
        Produto produto,
        Lote? lote,
        Endereco origem,
        Saldo saldoOrigem,
        decimal quantidade,
        Registro registro,
        string? documento)
    {
        var movimentacao = Create(TipoMovimentacao.Saida, produto, lote, origem, destino: null, quantidade, registro, documento, observacao: null);
        movimentacao.Apply(saldoOrigem, saldoDestino: null);
        return movimentacao;
    }

    /// <summary>Correção do saldo de um endereço: <paramref name="delta"/> positivo aumenta, negativo diminui.</summary>
    public static Movimentacao Ajuste(
        Produto produto,
        Lote? lote,
        Endereco endereco,
        Saldo saldo,
        decimal delta,
        Registro registro,
        string motivo)
    {
        if (delta == 0)
        {
            throw new DomainException("O ajuste precisa alterar a quantidade.");
        }

        var observacao = Guard.Required(motivo, "Motivo do ajuste", ObservacaoMaxLength);
        var aumenta = delta > 0;
        var movimentacao = Create(
            TipoMovimentacao.Ajuste,
            produto,
            lote,
            origem: aumenta ? null : endereco,
            destino: aumenta ? endereco : null,
            Math.Abs(delta),
            registro,
            documento: null,
            observacao);
        movimentacao.Apply(aumenta ? null : saldo, aumenta ? saldo : null);
        return movimentacao;
    }

    private static Movimentacao Create(
        TipoMovimentacao tipo,
        Produto produto,
        Lote? lote,
        Endereco? origem,
        Endereco? destino,
        decimal quantidade,
        Registro registro,
        string? documento,
        string? observacao)
    {
        ArgumentNullException.ThrowIfNull(produto);
        ArgumentNullException.ThrowIfNull(registro);

        if (quantidade <= 0)
        {
            throw new DomainException("A quantidade deve ser maior que zero.");
        }

        if (destino is { Status: StatusEndereco.Bloqueado })
        {
            throw new DomainException($"O endereço {destino.Codigo} está bloqueado ({destino.MotivoBloqueio}) e não pode receber mercadoria.");
        }

        ValidateLote(produto, lote, exigeValidade: destino is not null);

        return new Movimentacao
        {
            Tipo = tipo,
            ProdutoId = produto.Id,
            LoteId = lote?.Id,
            EnderecoOrigemId = origem?.Id,
            EnderecoDestinoId = destino?.Id,
            Quantidade = quantidade,
            DocumentoReferencia = string.IsNullOrWhiteSpace(documento) ? null : Guard.Required(documento, "Documento de referência", DocumentoReferenciaMaxLength),
            Observacao = observacao,
            UsuarioId = registro.UsuarioId,
            DispositivoId = registro.DispositivoId,
            OcorridoEm = registro.OcorridoEm,
            RecebidoEm = registro.RecebidoEm,
        };
    }

    private static void ValidateLote(Produto produto, Lote? lote, bool exigeValidade)
    {
        if (!produto.ControlaLote)
        {
            if (lote is not null)
            {
                throw new DomainException($"O produto {produto.Sku} não controla lote. Não informe o lote.");
            }

            return;
        }

        if (lote is null)
        {
            throw new DomainException($"O produto {produto.Sku} controla lote. Informe o lote.");
        }

        if (lote.ProdutoId != produto.Id)
        {
            throw new DomainException($"O lote {lote.Numero} é de outro produto.");
        }

        if (exigeValidade && produto.ControlaValidade && lote.Validade is null)
        {
            throw new DomainException($"O produto {produto.Sku} controla validade. Informe a validade do lote {lote.Numero}.");
        }
    }

    private void Apply(Saldo? saldoOrigem, Saldo? saldoDestino)
    {
        if (EnderecoOrigemId is not null)
        {
            EnsureSaldoDe(saldoOrigem, EnderecoOrigemId.Value).Remove(Quantidade);
        }

        if (EnderecoDestinoId is not null)
        {
            EnsureSaldoDe(saldoDestino, EnderecoDestinoId.Value).Add(Quantidade);
        }
    }

    private Saldo EnsureSaldoDe(Saldo? saldo, Guid enderecoId)
    {
        if (saldo is null || saldo.EnderecoId != enderecoId || saldo.ProdutoId != ProdutoId || saldo.LoteId != LoteId)
        {
            throw new InvalidOperationException("The balance does not match the movement's address, product and lot.");
        }

        return saldo;
    }
}
