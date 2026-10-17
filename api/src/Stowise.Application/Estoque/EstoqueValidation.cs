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

        var errors = Common(comando.ProdutoId, comando.EnderecoId, comando.DocumentoReferencia);
        OcorridoEm(errors, comando.OcorridoEm, agora);
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

        var errors = Common(comando.ProdutoId, comando.EnderecoId, comando.DocumentoReferencia);
        OcorridoEm(errors, comando.OcorridoEm, agora);
        Positiva(errors, comando.Quantidade);
        Numero(errors, "lote", comando.Lote, obrigatorio: false);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(RegistrarTransferencia comando, DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = Common(comando.ProdutoId, comando.EnderecoOrigemId, comando.DocumentoReferencia);
        OcorridoEm(errors, comando.OcorridoEm, agora);
        if (errors.Remove("enderecoId"))
        {
            errors["enderecoOrigemId"] = ["Informe o endereço de origem."];
        }

        if (comando.EnderecoDestinoId is null)
        {
            errors["enderecoDestinoId"] = ["Informe o endereço de destino."];
        }
        else if (comando.EnderecoDestinoId == comando.EnderecoOrigemId)
        {
            errors["enderecoDestinoId"] = ["O destino deve ser diferente da origem."];
        }

        Positiva(errors, comando.Quantidade);
        Numero(errors, "lote", comando.Lote, obrigatorio: false);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(ConsumirReserva comando, DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (comando.DocumentoReferencia is not null && comando.DocumentoReferencia.Trim().Length > Movimentacao.DocumentoReferenciaMaxLength)
        {
            errors["documentoReferencia"] = [$"O documento de referência deve ter até {Movimentacao.DocumentoReferenciaMaxLength} caracteres."];
        }

        OcorridoEm(errors, comando.OcorridoEm, agora);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(CriarReserva comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = Common(comando.ProdutoId, comando.EnderecoId, comando.DocumentoReferencia);
        Positiva(errors, comando.Quantidade);
        Numero(errors, "lote", comando.Lote, obrigatorio: false);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(ExtratoFiltro filtro)
    {
        ArgumentNullException.ThrowIfNull(filtro);

        var errors = new Dictionary<string, string[]>();
        if (filtro.De is not null && filtro.Ate is not null && filtro.Ate < filtro.De)
        {
            errors["ate"] = ["O fim do período deve ser igual ou posterior ao início."];
        }

        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(SaldoNaDataFiltro filtro)
    {
        ArgumentNullException.ThrowIfNull(filtro);

        var errors = new Dictionary<string, string[]>();
        if (filtro.Data is null)
        {
            errors["data"] = ["Informe a data e hora (ISO 8601, ex.: 2026-10-01T23:59:59-03:00)."];
        }

        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(RegistrarAjuste comando, DateTimeOffset agora)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = Common(comando.ProdutoId, comando.EnderecoId, documento: null);
        OcorridoEm(errors, comando.OcorridoEm, agora);
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

    private static Dictionary<string, string[]> Common(Guid? produtoId, Guid? enderecoId, string? documento)
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

        return errors;
    }

    /// <summary>A hora do aparelho pode ser antiga (modo offline), mas não pode estar no futuro além da tolerância.</summary>
    private static void OcorridoEm(Dictionary<string, string[]> errors, DateTimeOffset? ocorridoEm, DateTimeOffset agora)
    {
        if (ocorridoEm is { } quando && quando > agora + ToleranciaRelogio)
        {
            errors["ocorridoEm"] = ["A data da operação não pode estar no futuro. Confira o relógio do aparelho."];
        }
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
