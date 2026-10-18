using System.Globalization;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;
using Stowise.Domain.Importacoes;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.Importacoes;

/// <summary>
/// Grava no catálogo as linhas válidas de uma importação de produtos. Roda no job de background, em páginas: cada
/// página grava os produtos e marca as linhas (<see cref="ImportacaoLinha.EfetivadaEm"/>) na mesma transação.
/// Uma repetição do job só pega as linhas ainda não efetivadas, então nada é gravado duas vezes.
/// </summary>
internal sealed class EfetivacaoProdutos(StowiseDbContext db, TimeProvider time)
{
    public const int Pagina = 1000;

    /// <param name="aoAvancar">Chamado depois de cada página gravada, com o progresso já salvo.</param>
    public async Task RunAsync(Importacao importacao, Func<Importacao, CancellationToken, Task> aoAvancar, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(importacao);
        ArgumentNullException.ThrowIfNull(aoAvancar);

        var mapeados = (importacao.Mapeamento ?? throw new InvalidOperationException("The mapping must be confirmed before committing."))
            .ToDictionary(m => m.Campo, m => m.Coluna, StringComparer.Ordinal);
        var ultima = 0;
        while (true)
        {
            var linhas = await PendingAsync(importacao.Id, ultima, Pagina, cancellationToken);
            if (linhas.Count == 0)
            {
                break;
            }

            ultima = linhas[^1].NumeroLinha;
            try
            {
                await ApplyAsync(linhas, mapeados, cancellationToken);
                await db.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException e) when (IsUniqueViolation(e))
            {
                // Um GTIN ou SKU gravado por outra pessoa depois da validação derruba a página inteira. Refaz linha a
                // linha, para só a linha em conflito falhar.
                DetachAllBut(importacao);
                await ApplyOneByOneAsync(importacao.Id, linhas.Select(l => l.NumeroLinha).ToList(), mapeados, cancellationToken);
            }

            DetachAllBut(importacao);
            var processadas = await db.ImportacaoLinhas.CountAsync(l => l.ImportacaoId == importacao.Id && l.EfetivadaEm != null, cancellationToken);
            importacao.ReportProgress(processadas);
            await db.SaveChangesAsync(cancellationToken);
            await aoAvancar(importacao, cancellationToken);
        }

        // As contagens vêm das linhas gravadas, então valem também quando o job foi repetido no meio do caminho.
        var linhasDaImportacao = db.ImportacaoLinhas.Where(l => l.ImportacaoId == importacao.Id);
        var criados = await linhasDaImportacao.CountAsync(l => l.EfetivadaEm != null && l.Acao == AcaoLinha.Criar, cancellationToken);
        var atualizados = await linhasDaImportacao.CountAsync(l => l.EfetivadaEm != null && l.Acao == AcaoLinha.Atualizar, cancellationToken);
        var validas = await linhasDaImportacao.CountAsync(l => l.Status == StatusLinha.Valida, cancellationToken);
        var comErro = await linhasDaImportacao.CountAsync(l => l.Status == StatusLinha.Erro, cancellationToken);

        importacao.Complete(criados, atualizados, validas, comErro, time.GetUtcNow());
    }

    private Task<List<ImportacaoLinha>> PendingAsync(Guid importacaoId, int depoisDe, int quantidade, CancellationToken cancellationToken) =>
        db.ImportacaoLinhas
            .Where(l => l.ImportacaoId == importacaoId && l.Status == StatusLinha.Valida && l.EfetivadaEm == null && l.NumeroLinha > depoisDe)
            .OrderBy(l => l.NumeroLinha)
            .Take(quantidade)
            .ToListAsync(cancellationToken);

    private async Task ApplyOneByOneAsync(Guid importacaoId, List<int> numeros, IReadOnlyDictionary<string, int> mapeados, CancellationToken cancellationToken)
    {
        foreach (var numero in numeros)
        {
            var linha = await db.ImportacaoLinhas.SingleAsync(l => l.ImportacaoId == importacaoId && l.NumeroLinha == numero, cancellationToken);
            try
            {
                await ApplyAsync([linha], mapeados, cancellationToken);
                await db.SaveChangesAsync(cancellationToken);
            }
            catch (DbUpdateException e) when (IsUniqueViolation(e))
            {
                foreach (var entrada in db.ChangeTracker.Entries().Where(e => e.Entity is Produto or ProdutoEmbalagem or ImportacaoLinha).ToList())
                {
                    entrada.State = EntityState.Detached;
                }

                linha = await db.ImportacaoLinhas.SingleAsync(l => l.ImportacaoId == importacaoId && l.NumeroLinha == numero, cancellationToken);
                linha.MarkFalhaEfetivacao("O SKU ou o GTIN passou a ser usado por outro produto depois da validação. Valide a importação de novo.");
                await db.SaveChangesAsync(cancellationToken);
            }

            DetachLinhasEProdutos();
        }
    }

    private async Task ApplyAsync(List<ImportacaoLinha> linhas, IReadOnlyDictionary<string, int> mapeados, CancellationToken cancellationToken)
    {
        var skus = linhas.Select(l => l.DadosNormalizados["sku"]!).ToList();
        var produtos = await db.Produtos.Include(p => p.Embalagens)
            .Where(p => skus.Contains(p.Sku))
            .ToDictionaryAsync(p => p.Sku, StringComparer.Ordinal, cancellationToken);
        var agora = time.GetUtcNow();

        foreach (var linha in linhas)
        {
            var sku = linha.DadosNormalizados["sku"]!;
            try
            {
                if (produtos.TryGetValue(sku, out var existente))
                {
                    Update(existente, linha, mapeados);
                    linha.MarkEfetivada(AcaoLinha.Atualizar, existente.Id, agora);
                }
                else
                {
                    var novo = Produto.Create(sku, Dados(linha), Embalagem(linha, atual: null, mapeados));
                    db.Produtos.Add(novo);
                    produtos[sku] = novo;
                    linha.MarkEfetivada(AcaoLinha.Criar, novo.Id, agora);
                }
            }
            catch (DomainException e)
            {
                if (produtos.TryGetValue(sku, out var alterado) && db.Entry(alterado).State != EntityState.Added)
                {
                    await RevertAsync(alterado, cancellationToken);
                }

                linha.MarkFalhaEfetivacao(e.Message);
            }
        }
    }

    /// <summary>
    /// Atualização: só os campos que o arquivo preencheu. Célula vazia não apaga dado do cadastro, e a unidade
    /// base nunca muda por importação (mudaria o significado do saldo já registrado).
    /// </summary>
    private static void Update(Produto produto, ImportacaoLinha linha, IReadOnlyDictionary<string, int> mapeados)
    {
        bool Informado(string campo) =>
            mapeados.TryGetValue(campo, out var coluna) && coluna < linha.DadosBrutos.Count && linha.DadosBrutos[coluna].Trim().Length > 0;
        string? Valor(string campo) => linha.DadosNormalizados.GetValueOrDefault(campo);

        var embalagem = produto.EmbalagemBase;
        produto.UpdateEmbalagem(embalagem.Id, Embalagem(linha, embalagem, mapeados));
        produto.Update(new DadosProduto(
            Informado("descricao") ? Valor("descricao")! : produto.Descricao,
            produto.UnidadeBase,
            Informado("classeArmazenagem") ? Enum.Parse<ClasseArmazenagem>(Valor("classeArmazenagem")!) : produto.ClasseArmazenagem,
            Informado("controlaLote") ? bool.Parse(Valor("controlaLote")!) : produto.ControlaLote,
            Informado("controlaValidade") ? bool.Parse(Valor("controlaValidade")!) : produto.ControlaValidade,
            Informado("ncm") ? Valor("ncm") : produto.Ncm,
            Informado("cest") ? Valor("cest") : produto.Cest,
            Informado("categoria") ? Guid.Parse(Valor("categoriaId")!) : produto.CategoriaId));
    }

    /// <summary>Criação: campos vazios ficam com o padrão do normalizador (classe Normal, sem lote e sem validade).</summary>
    private static DadosProduto Dados(ImportacaoLinha linha)
    {
        string? Valor(string campo) => linha.DadosNormalizados.GetValueOrDefault(campo);

        return new DadosProduto(
            Valor("descricao")!,
            Valor("unidadeBase")!,
            Enum.Parse<ClasseArmazenagem>(Valor("classeArmazenagem") ?? nameof(ClasseArmazenagem.Normal)),
            bool.Parse(Valor("controlaLote") ?? "false"),
            bool.Parse(Valor("controlaValidade") ?? "false"),
            Valor("ncm"),
            Valor("cest"),
            Valor("categoriaId") is { } categoria ? Guid.Parse(categoria) : null);
    }

    /// <summary>GTIN e medidas da unidade base. Na atualização, o que o arquivo não trouxe fica como está.</summary>
    private static DadosEmbalagem Embalagem(ImportacaoLinha linha, ProdutoEmbalagem? atual, IReadOnlyDictionary<string, int> mapeados)
    {
        T? Ou<T>(string campo, Func<string, T> ler, T? padrao) =>
            linha.DadosNormalizados.GetValueOrDefault(campo) is { } valor && mapeados.ContainsKey(campo) ? ler(valor) : padrao;
        static decimal Numero(string valor) => decimal.Parse(valor, CultureInfo.InvariantCulture);

        return new DadosEmbalagem(
            Ou("gtin", v => v, atual?.Gtin),
            Ou<decimal?>("pesoKg", v => Numero(v), atual?.PesoKg),
            Ou<decimal?>("alturaCm", v => Numero(v), atual?.AlturaCm),
            Ou<decimal?>("larguraCm", v => Numero(v), atual?.LarguraCm),
            Ou<decimal?>("comprimentoCm", v => Numero(v), atual?.ComprimentoCm));
    }

    /// <summary>Desfaz as mudanças em memória de um produto cuja linha falhou no meio da atualização.</summary>
    private async Task RevertAsync(Produto produto, CancellationToken cancellationToken)
    {
        foreach (var embalagem in produto.Embalagens)
        {
            await db.Entry(embalagem).ReloadAsync(cancellationToken);
        }

        await db.Entry(produto).ReloadAsync(cancellationToken);
    }

    private void DetachAllBut(Importacao importacao)
    {
        foreach (var entrada in db.ChangeTracker.Entries().Where(e => e.Entity != importacao).ToList())
        {
            entrada.State = EntityState.Detached;
        }
    }

    private void DetachLinhasEProdutos()
    {
        foreach (var entrada in db.ChangeTracker.Entries().Where(e => e.Entity is Produto or ProdutoEmbalagem or ImportacaoLinha).ToList())
        {
            entrada.State = EntityState.Detached;
        }
    }

    private static bool IsUniqueViolation(DbUpdateException e) =>
        e.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation };
}
