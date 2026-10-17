using Stowise.Domain.Estrutura;

namespace Stowise.Application.Estrutura;

/// <summary>Validações de formato da estrutura física, com erro por campo (HTTP 400).</summary>
public static class EstruturaValidation
{
    public static IReadOnlyDictionary<string, string[]> Validate(CriarArmazem comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        Text(errors, "codigo", comando.Codigo, Armazem.CodigoMaxLength, "o código do armazém");
        Text(errors, "nome", comando.Nome, Armazem.NomeMaxLength, "o nome do armazém");
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(RenomearArmazem comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        Text(errors, "nome", comando.Nome, Armazem.NomeMaxLength, "o nome do armazém");
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(SalvarZona comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        Text(errors, "codigo", comando.Codigo, Zona.CodigoMaxLength, "o código da zona");
        if (comando.ClasseArmazenagem is null)
        {
            errors["classeArmazenagem"] = ["Informe a classe de armazenagem: Normal, Refrigerado, Inflamavel ou Fragil."];
        }

        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(CriarEndereco comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (comando.ZonaId is null)
        {
            errors["zonaId"] = ["Informe a zona do endereço."];
        }

        if (!Endereco.IsValidRua(comando.Rua))
        {
            errors["rua"] = ["Informe a rua com 1 a 3 letras (ex.: A, B, AA)."];
        }

        Range(errors, "modulo", comando.Modulo, Endereco.ModuloMax, "o módulo");
        Range(errors, "nivel", comando.Nivel, Endereco.NivelMax, "o nível");
        Range(errors, "posicao", comando.Posicao, Endereco.PosicaoMax, "a posição");
        Dimensoes(errors, comando.CapacidadePesoKg, comando.AlturaCm, comando.LarguraCm, comando.ProfundidadeCm, comando.DistanciaExpedicao);
        return errors;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(GerarEnderecos comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        if (comando.ZonaId is null)
        {
            errors["zonaId"] = ["Informe a zona dos endereços."];
        }

        var ruas = comando.Ruas ?? [];
        if (ruas.Count == 0 || !ruas.All(Endereco.IsValidRua))
        {
            errors["ruas"] = ["Informe as ruas, cada uma com 1 a 3 letras (ex.: A, B, AA)."];
        }
        else if (ruas.Select(r => r.Trim().ToUpperInvariant()).Distinct(StringComparer.Ordinal).Count() != ruas.Count)
        {
            errors["ruas"] = ["Há ruas repetidas na lista."];
        }

        var modulos = Faixa(errors, "modulo", comando.ModuloInicial, comando.ModuloFinal, Endereco.ModuloMax, "módulo");
        var niveis = Faixa(errors, "nivel", comando.NivelInicial, comando.NivelFinal, Endereco.NivelMax, "nível");
        var posicoes = Faixa(errors, "posicao", comando.PosicaoInicial, comando.PosicaoFinal, Endereco.PosicaoMax, "posição");
        Medidas(errors, comando.CapacidadePesoKg, comando.AlturaCm, comando.LarguraCm, comando.ProfundidadeCm);
        if (comando.DistanciaBase is < 0)
        {
            errors["distanciaBase"] = ["A distância base não pode ser negativa."];
        }

        if (comando.DistanciaPorModulo is < 0)
        {
            errors["distanciaPorModulo"] = ["A distância por módulo não pode ser negativa."];
        }

        if (errors.Count == 0)
        {
            var total = (long)ruas.Count * modulos * niveis * posicoes;
            if (total > PlanoGeracaoEnderecos.MaxEnderecos)
            {
                errors["lote"] = [$"O lote geraria {total} endereços; o limite por pedido é {PlanoGeracaoEnderecos.MaxEnderecos}."];
            }
        }

        return errors;
    }

    public static PlanoGeracaoEnderecos ToPlano(GerarEnderecos comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        return new PlanoGeracaoEnderecos(
            comando.Ruas!,
            new Faixa(comando.ModuloInicial!.Value, comando.ModuloFinal!.Value),
            new Faixa(comando.NivelInicial!.Value, comando.NivelFinal!.Value),
            new Faixa(comando.PosicaoInicial!.Value, comando.PosicaoFinal!.Value),
            comando.CapacidadePesoKg!.Value,
            comando.AlturaCm!.Value,
            comando.LarguraCm!.Value,
            comando.ProfundidadeCm!.Value,
            comando.DistanciaBase ?? 0m,
            comando.DistanciaPorModulo ?? 0m);
    }

    /// <returns>Quantidade de valores da faixa, ou 0 se ela for inválida.</returns>
    private static int Faixa(Dictionary<string, string[]> errors, string campo, int? inicio, int? fim, int max, string descricao)
    {
        Range(errors, campo + "Inicial", inicio, max, $"o {descricao} inicial");
        Range(errors, campo + "Final", fim, max, $"o {descricao} final");
        if (inicio is null || fim is null || errors.ContainsKey(campo + "Inicial") || errors.ContainsKey(campo + "Final"))
        {
            return 0;
        }

        if (fim < inicio)
        {
            errors[campo + "Final"] = [$"O {descricao} final deve ser maior ou igual ao inicial."];
            return 0;
        }

        return fim.Value - inicio.Value + 1;
    }

    public static IReadOnlyDictionary<string, string[]> Validate(DimensoesEnderecoComando comando)
    {
        ArgumentNullException.ThrowIfNull(comando);

        var errors = new Dictionary<string, string[]>();
        Dimensoes(errors, comando.CapacidadePesoKg, comando.AlturaCm, comando.LarguraCm, comando.ProfundidadeCm, comando.DistanciaExpedicao);
        return errors;
    }

    private static void Text(Dictionary<string, string[]> errors, string campo, string? valor, int maxLength, string descricao)
    {
        if (string.IsNullOrWhiteSpace(valor) || valor.Trim().Length > maxLength)
        {
            errors[campo] = [$"Informe {descricao} (até {maxLength} caracteres)."];
        }
    }

    private static void Range(Dictionary<string, string[]> errors, string campo, int? valor, int max, string descricao)
    {
        if (valor is null || valor < 1 || valor > max)
        {
            errors[campo] = [$"Informe {descricao} entre 1 e {max}."];
        }
    }

    private static void Dimensoes(
        Dictionary<string, string[]> errors,
        decimal? capacidadePesoKg,
        decimal? alturaCm,
        decimal? larguraCm,
        decimal? profundidadeCm,
        decimal? distanciaExpedicao)
    {
        Medidas(errors, capacidadePesoKg, alturaCm, larguraCm, profundidadeCm);
        if (distanciaExpedicao is not >= 0)
        {
            errors["distanciaExpedicao"] = ["Informe a distância até a expedição em metros (zero ou mais)."];
        }
    }

    private static void Medidas(
        Dictionary<string, string[]> errors,
        decimal? capacidadePesoKg,
        decimal? alturaCm,
        decimal? larguraCm,
        decimal? profundidadeCm)
    {
        foreach (var (campo, valor) in new[]
        {
            ("capacidadePesoKg", capacidadePesoKg),
            ("alturaCm", alturaCm),
            ("larguraCm", larguraCm),
            ("profundidadeCm", profundidadeCm),
        })
        {
            if (valor is not > 0)
            {
                errors[campo] = ["Informe um valor maior que zero."];
            }
        }
    }

    public static DimensoesEndereco ToDimensoes(
        decimal? capacidadePesoKg,
        decimal? alturaCm,
        decimal? larguraCm,
        decimal? profundidadeCm,
        decimal? distanciaExpedicao) =>
        new(capacidadePesoKg!.Value, alturaCm!.Value, larguraCm!.Value, profundidadeCm!.Value, distanciaExpedicao!.Value);
}
