using Stowise.Domain.Common;

namespace Stowise.Domain.Fornecedores;

/// <summary>Fornecedor identificado pelo CNPJ (o emitente da NF-e). O CNPJ não muda depois do cadastro.</summary>
public sealed class Fornecedor : Entity
{
    public const int RazaoSocialMaxLength = 150;
    public const int NomeFantasiaMaxLength = 150;

    private Fornecedor()
    {
    }

    /// <summary>CNPJ normalizado: 14 caracteres, sem máscara.</summary>
    public string Cnpj { get; private set; } = null!;

    public string RazaoSocial { get; private set; } = null!;

    public string? NomeFantasia { get; private set; }

    /// <summary>Versão para concorrência otimista (coluna xmin do PostgreSQL).</summary>
    public uint Versao { get; private set; }

    public static Fornecedor Create(string cnpj, string razaoSocial, string? nomeFantasia)
    {
        var normalizado = Fornecedores.Cnpj.Normalize(cnpj);
        if (!Fornecedores.Cnpj.IsValid(normalizado))
        {
            throw new DomainException($"O CNPJ {cnpj} não é válido.");
        }

        var fornecedor = new Fornecedor { Cnpj = normalizado };
        fornecedor.Update(razaoSocial, nomeFantasia);
        return fornecedor;
    }

    public void Update(string razaoSocial, string? nomeFantasia)
    {
        RazaoSocial = Guard.Required(razaoSocial, "Razão social", RazaoSocialMaxLength);
        NomeFantasia = string.IsNullOrWhiteSpace(nomeFantasia) ? null : Guard.Required(nomeFantasia, "Nome fantasia", NomeFantasiaMaxLength);
    }
}
