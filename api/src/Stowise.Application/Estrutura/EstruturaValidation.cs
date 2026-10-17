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

        if (distanciaExpedicao is not >= 0)
        {
            errors["distanciaExpedicao"] = ["Informe a distância até a expedição em metros (zero ou mais)."];
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
