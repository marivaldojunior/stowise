using Stowise.Domain.Estoque;

namespace Stowise.Application.Estoque;

/// <summary>Validações de formato das movimentações, com erro por campo (HTTP 400).</summary>
public static class EstoqueValidation
{
    /// <summary>Tolerância para relógio adiantado no aparelho.</summary>
    public static readonly TimeSpan ToleranciaRelogio = TimeSpan.FromMinutes(5);

    public static IReadOnlyDictionary<string, string[]> Validate(RegistrarEntrada comando, DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = Common(comando.ProdutoId, comando.EnderecoId, comando.DocumentoReferencia, comando.OcorridoEm, agora);
        Positiva(errors, comando.Quantidade);
        if (comando.Lote is { } lote)
        {
            Numero(errors, "lote.numero", lote.Numero, obrigatorio: true);
            if (lote.Fabricacao is not null && lote.Validade is not null && lote.Validade < lote.Fabricacao)
            {
                errors["lote.validade"] = ["A validade não pode ser anterior à fabricação."];
            }
        }

        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(RegistrarSaida comando, DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = Common(comando.ProdutoId, comando.EnderecoId, comando.DocumentoReferencia, comando.OcorridoEm, agora);
        Positiva(errors, comando.Quantidade);
        Numero(errors, "lote", comando.Lote, obrigatorio: false);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(RegistrarAjuste comando, DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = Common(comando.ProdutoId, comando.EnderecoId, documento: null, comando.OcorridoEm, agora);
        if (comando.Quantidade is null or 0)
        {
            errors["quantidade"] = ["Informe a diferença na unidade base: positiva aumenta o saldo, negativa diminui."];
        }

        Numero(errors, "lote", comando.Lote, obrigatorio: false);
        if (string.IsNullOrWhiteSpace(comando.Motivo) || comando.Motivo.Trim().Length > Movimentacao.ObservacaoMaxLength)
        {
            errors["motivo"] = [$"Informe o motivo do ajuste (até {Movimentacao.ObservacaoMaxLength} caracteres)."];
        }

        return errors;
    }

    private static Dictionary<string, string[]> Common(
        Guid? produtoId,
        Guid? enderecoId,
        string? documento,
        DateTimeOffset? ocorridoEm,
        DateTimeOffset agora)
    {
        var errors = new Dictionary<string, string[]>();
        if (produtoId is null)
        {
            errors["produtoId"] = ["Informe o produto."];
        }

        if (enderecoId is null)
        {
            errors["enderecoId"] = ["Informe o endereço."];
        }

        if (documento is not null && documento.Trim().Length > Movimentacao.DocumentoReferenciaMaxLength)
        {
            errors["documentoReferencia"] = [$"O documento de referência deve ter até {Movimentacao.DocumentoReferenciaMaxLength} caracteres."];
        }

        if (ocorridoEm > agora + ToleranciaRelogio)
        {
            errors["ocorridoEm"] = ["A data da operação não pode estar no futuro. Confira o relógio do aparelho."];
        }

        return errors;
    }

    private static void Positiva(Dictionary<string, string[]> errors, decimal? quantidade)
    {
        if (quantidade is not > 0)
        {
            errors["quantidade"] = ["Informe uma quantidade maior que zero."];
        }
    }

    private static void Numero(Dictionary<string, string[]> errors, string campo, string? numero, bool obrigatorio)
    {
        if (string.IsNullOrWhiteSpace(numero))
        {
            if (obrigatorio)
            {
                errors[campo] = ["Informe o número do lote."];
            }

            return;
        }

        if (numero.Trim().Length > Lote.NumeroMaxLength)
        {
            errors[campo] = [$"O número do lote deve ter até {Lote.NumeroMaxLength} caracteres."];
        }
    }
}
