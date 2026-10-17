namespace Stowise.Domain.Estoque;

public enum TipoMovimentacao
{
    /// <summary>Mercadoria chega ao endereço de destino.</summary>
    Entrada,

    /// <summary>Mercadoria sai do endereço de origem.</summary>
    Saida,

    /// <summary>Mercadoria passa do endereço de origem para o de destino.</summary>
    Transferencia,

    /// <summary>Correção do saldo: com destino aumenta, com origem diminui. Exige motivo.</summary>
    Ajuste,
}
