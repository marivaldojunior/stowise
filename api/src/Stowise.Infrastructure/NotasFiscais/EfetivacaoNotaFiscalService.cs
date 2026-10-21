using System.Text;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using Stowise.Application.Common;
using Stowise.Application.NotasFiscais;
using Stowise.Domain.Catalogo;
using Stowise.Domain.Common;
using Stowise.Domain.Estrutura;
using Stowise.Domain.Fornecedores;
using Stowise.Domain.Recebimentos;
using Stowise.Infrastructure.Persistence;

namespace Stowise.Infrastructure.NotasFiscais;

/// <summary>
/// Efetivação da NF-e revisada. Primeiro valida tudo (a análise de novo, as decisões, os produtos e os fatores); só
/// depois monta as entidades e grava num único SaveChanges, que é atômico: ou entra a nota inteira, ou nada.
/// </summary>
internal sealed class EfetivacaoNotaFiscalService(StowiseDbContext db, IAnaliseNotaFiscal analise, TimeProvider time)
    : IEfetivacaoNotaFiscal
{
    public async Task<Result<NotaFiscalEfetivada>> EfetivarAsync(EfetivarNotaFiscal comando, Guid usuarioId, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(comando);
        if (string.IsNullOrWhiteSpace(comando.Xml))
        {
            return AppError.Validation("xml", "Envie o XML da NF-e.");
        }

        var bytes = Encoding.UTF8.GetBytes(comando.Xml);
        Result<AnaliseNotaFiscal> analisada;
        using (var xml = new MemoryStream(bytes))
        {
            analisada = await analise.AnalyzeAsync(xml, cancellationToken);
        }

        if (!analisada.IsSuccess)
        {
            return analisada.Error!;
        }

        var nota = analisada.Value;
        var problema = await CheckNotaAsync(nota, cancellationToken) ?? CheckDecisoes(nota, comando.Itens);
        if (problema is not null)
        {
            return problema;
        }

        var decisoes = comando.Itens!.ToDictionary(d => d.NumeroItem);
        var agora = time.GetUtcNow();
        var fornecedor = await FornecedorAsync(nota.Fornecedor, cancellationToken);
        var resumo = new Resumo { FornecedorCriado = db.Entry(fornecedor).State == EntityState.Added };
        var recebimento = Recebimento.Create(fornecedor.Id, nota.ChaveAcesso, nota.Numero, nota.Serie, nota.DataEmissao, usuarioId, agora);
        var vinculos = await db.ProdutoFornecedores
            .Where(v => v.FornecedorId == fornecedor.Id)
            .ToDictionaryAsync(v => v.CodigoFornecedor, StringComparer.Ordinal, cancellationToken);

        var itens = new List<ItemEfetivado>();
        foreach (var item in nota.Itens)
        {
            var decisao = decisoes[item.Item.NumeroItem];
            var destino = await DestinoAsync(item, decisao, resumo, cancellationToken);
            if (!destino.IsSuccess)
            {
                return destino.Error!;
            }

            var (produto, embalagemId) = destino.Value;
            var inferencia = InferenciaItemNota.Infer(item.Item, nota.DataEmissao, Inferencia(produto, embalagemId, item, decisao));
            if ((decisao.FatorConversao ?? inferencia.Conversao.Fator) is not { } fator || fator <= 0)
            {
                return AppError.Validation(
                    $"itens[{item.Item.NumeroItem}].fatorConversao",
                    $"Informe o fator de conversão do item {item.Item.NumeroItem}: quantas {produto.UnidadeBase} há em 1 {item.Item.UnidadeComercial}.");
            }

            var vinculo = Vincular(vinculos, fornecedor.Id, item.Item, produto.Id, embalagemId, fator, usuarioId, agora, resumo);
            var lotes = inferencia.Lotes
                .Select(l => new LoteRecebido(
                    l.Numero,
                    decisao.FatorConversao is null && l.QuantidadeBase is { } base_ ? base_ : Math.Round(l.QuantidadeNota * fator, 4, MidpointRounding.AwayFromZero),
                    l.Fabricacao,
                    l.Validade))
                .ToList();
            var recebido = recebimento.AddItem(new DadosItemRecebido(
                item.Item.NumeroItem,
                produto.Id,
                vinculo.Id,
                embalagemId,
                item.Item.CodigoFornecedor,
                item.Item.Descricao,
                item.Item.UnidadeComercial,
                item.Item.QuantidadeComercial,
                fator,
                item.Item.Cfop,
                item.Item.ValorUnitarioComercial,
                lotes));
            itens.Add(new ItemEfetivado(recebido.NumeroItem, produto.Id, embalagemId, vinculo.Id, fator, recebido.Quantidade));
        }

        db.Recebimentos.Add(recebimento);
        db.XmlsRecebimento.Add(XmlRecebimento.Create(recebimento, bytes));
        try
        {
            await db.SaveChangesAsync(cancellationToken);
        }
        catch (DbUpdateException e) when (e is not DbUpdateConcurrencyException
            && e.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation })
        {
            // Corrida: outra pessoa efetivou a mesma nota, ou criou o mesmo SKU, entre a verificação e a gravação.
            return AppError.Conflict("Outra operação gravou esta nota ou um destes produtos agora há pouco. Recarregue e confira.");
        }

        return new NotaFiscalEfetivada(
            recebimento.Id,
            fornecedor.Id,
            resumo.FornecedorCriado,
            resumo.ProdutosCriados,
            resumo.VinculosCriados,
            resumo.VinculosAtualizados,
            itens);
    }

    private async Task<AppError?> CheckNotaAsync(AnaliseNotaFiscal nota, CancellationToken cancellationToken)
    {
        if (!nota.Autorizada)
        {
            return AppError.BusinessRule("A nota não traz o protocolo de autorização da SEFAZ. Envie o XML autorizado (nfeProc).");
        }

        if (nota.Fornecedor.Cnpj is null)
        {
            return AppError.BusinessRule("O emitente é pessoa física (CPF). Por enquanto, o recebimento aceita só fornecedor com CNPJ.");
        }

        return await db.Recebimentos.AnyAsync(r => r.ChaveAcesso == nota.ChaveAcesso, cancellationToken)
            ? AppError.Conflict($"A nota {nota.Numero} (série {nota.Serie}) já foi recebida.")
            : null;
    }

    private static AppError? CheckDecisoes(AnaliseNotaFiscal nota, IReadOnlyList<DecisaoItemNota>? decisoes)
    {
        var erros = new Dictionary<string, string[]>();
        var porItem = (decisoes ?? []).GroupBy(d => d.NumeroItem).ToDictionary(g => g.Key, g => g.Count());
        var itensNota = nota.Itens.ToDictionary(i => i.Item.NumeroItem);

        var faltando = itensNota.Keys.Where(n => !porItem.ContainsKey(n)).ToList();
        var sobrando = porItem.Keys.Where(n => !itensNota.ContainsKey(n)).ToList();
        var repetidos = porItem.Where(p => p.Value > 1).Select(p => p.Key).ToList();
        if (faltando.Count > 0 || sobrando.Count > 0 || repetidos.Count > 0)
        {
            erros["itens"] = [.. new[]
            {
                faltando.Count > 0 ? $"Falta a decisão dos itens {string.Join(", ", faltando)}." : null,
                sobrando.Count > 0 ? $"A nota não tem os itens {string.Join(", ", sobrando)}." : null,
                repetidos.Count > 0 ? $"Os itens {string.Join(", ", repetidos)} têm mais de uma decisão." : null,
            }.OfType<string>()];
            return AppError.Validation(erros);
        }

        foreach (var decisao in decisoes!)
        {
            var chave = $"itens[{decisao.NumeroItem}]";
            var analisado = itensNota[decisao.NumeroItem];
            switch (decisao.Acao)
            {
                case AcaoItemNota.Confirmar when analisado.Casamento is null:
                    erros[chave] = [$"O item {decisao.NumeroItem} não tem casamento para confirmar: escolha um produto ou crie um novo."];
                    break;
                case AcaoItemNota.Vincular when decisao.ProdutoId is null || decisao.EmbalagemId is null:
                    erros[chave] = [$"Informe o produto e a embalagem do item {decisao.NumeroItem}."];
                    break;
                case AcaoItemNota.CriarProduto when !Produto.IsValidSku(decisao.NovoProduto?.Sku):
                    erros[chave] = [$"Informe um SKU válido para o produto novo do item {decisao.NumeroItem}."];
                    break;
                case AcaoItemNota.CriarProduto when !Produto.IsValidUnidadeBase(InferenciaItemNota.NormalizeUnidade(analisado.Item.UnidadeTributavel)):
                    erros[chave] = [$"A unidade tributável do item {decisao.NumeroItem} ({analisado.Item.UnidadeTributavel}) não serve como unidade base."];
                    break;
                default:
                    if (decisao.FatorConversao is <= 0)
                    {
                        erros[chave] = [$"O fator de conversão do item {decisao.NumeroItem} deve ser maior que zero."];
                    }

                    break;
            }
        }

        return erros.Count > 0 ? AppError.Validation(erros) : null;
    }

    private async Task<Fornecedor> FornecedorAsync(FornecedorDaNota daNota, CancellationToken cancellationToken)
    {
        if (daNota.FornecedorId is { } id)
        {
            return await db.Fornecedores.FirstAsync(f => f.Id == id, cancellationToken);
        }

        var novo = Fornecedor.Create(daNota.Cnpj!, daNota.RazaoSocial, daNota.NomeFantasia);
        db.Fornecedores.Add(novo);
        return novo;
    }

    /// <summary>Produto e embalagem do item, conforme a decisão.</summary>
    private async Task<Result<(Produto Produto, Guid EmbalagemId)>> DestinoAsync(
        ItemAnalisado item,
        DecisaoItemNota decisao,
        Resumo resumo,
        CancellationToken cancellationToken)
    {
        switch (decisao.Acao)
        {
            case AcaoItemNota.Confirmar:
                {
                    var casamento = item.Casamento!;
                    var produto = await db.Produtos.Include(p => p.Embalagens).FirstAsync(p => p.Id == casamento.ProdutoId, cancellationToken);
                    return (produto, casamento.EmbalagemId);
                }

            case AcaoItemNota.Vincular:
                {
                    var produto = await db.Produtos.Include(p => p.Embalagens).FirstOrDefaultAsync(p => p.Id == decisao.ProdutoId, cancellationToken);
                    if (produto is null)
                    {
                        return AppError.NotFound($"O produto escolhido para o item {decisao.NumeroItem} não existe.");
                    }

                    return produto.Embalagens.Any(e => e.Id == decisao.EmbalagemId)
                        ? (produto, decisao.EmbalagemId!.Value)
                        : AppError.BusinessRule($"A embalagem escolhida para o item {decisao.NumeroItem} não é do produto {produto.Sku}.");
                }

            default:
                return await CreateProdutoAsync(item.Item, decisao, resumo, cancellationToken);
        }
    }

    /// <summary>
    /// Produto novo com os dados da nota: a unidade tributável vira a base (com o cEANTrib), e uma unidade comercial
    /// diferente vira uma caixa (com o cEAN). Sem medidas, ele entra como Incompleto e vai para a fila de cadastros.
    /// </summary>
    private async Task<Result<(Produto Produto, Guid EmbalagemId)>> CreateProdutoAsync(
        ItemNota item,
        DecisaoItemNota decisao,
        Resumo resumo,
        CancellationToken cancellationToken)
    {
        var novo = decisao.NovoProduto!;
        var sku = Produto.NormalizeSku(novo.Sku);
        if (resumo.Skus.Contains(sku) || await db.Produtos.AnyAsync(p => p.Sku == sku, cancellationToken))
        {
            return AppError.Conflict($"Já existe um produto com o SKU {sku} (item {item.NumeroItem}).");
        }

        var gtins = new[] { item.GtinTributavel, item.Gtin }.OfType<string>().SelectMany(g => Gtin.Equivalents(Gtin.ToGtin14(g))).ToList();
        var usados = await db.ProdutoEmbalagens.Where(e => e.Gtin != null && gtins.Contains(e.Gtin)).Select(e => e.Gtin!).ToListAsync(cancellationToken);
        string? Livre(string? gtin) => gtin is null || resumo.Gtins.Contains(gtin) || usados.Any(u => Gtin.ToGtin14(u) == Gtin.ToGtin14(gtin)) ? null : gtin;

        var lotes = item.Lotes.Count > 0;
        var descricao = string.IsNullOrWhiteSpace(novo.Descricao) ? item.Descricao : novo.Descricao;
        try
        {
            var produto = Produto.Create(
                sku,
                new DadosProduto(
                    descricao.Length > Produto.DescricaoMaxLength ? descricao[..Produto.DescricaoMaxLength] : descricao,
                    InferenciaItemNota.NormalizeUnidade(item.UnidadeTributavel),
                    novo.ClasseArmazenagem ?? ClasseArmazenagem.Normal,
                    lotes,
                    lotes && item.Lotes.All(l => l.Validade is not null),
                    item.Ncm is { Length: CodigosFiscais.NcmLength } ncm ? ncm : null,
                    item.Cest is { Length: CodigosFiscais.CestLength } cest ? cest : null,
                    novo.CategoriaId),
                new DadosEmbalagem(Livre(item.GtinTributavel), null, null, null, null));

            var embalagemId = produto.EmbalagemBase.Id;
            var fator = decisao.FatorConversao ?? (item.QuantidadeComercial > 0 ? item.QuantidadeTributavel / item.QuantidadeComercial : 0);
            var comercial = InferenciaItemNota.NormalizeUnidade(item.UnidadeComercial);
            if (comercial != produto.UnidadeBase && fator > 1)
            {
                var caixa = produto.AddEmbalagem(TipoEmbalagem.Caixa, Math.Round(fator, 4, MidpointRounding.AwayFromZero), new DadosEmbalagem(Livre(item.Gtin), null, null, null, null));
                embalagemId = caixa.Id;
            }

            db.Produtos.Add(produto);
            resumo.ProdutosCriados++;
            resumo.Skus.Add(sku);
            foreach (var e in produto.Embalagens.Where(e => e.Gtin is not null))
            {
                resumo.Gtins.Add(e.Gtin!);
            }

            return (produto, embalagemId);
        }
        catch (DomainException e)
        {
            return AppError.BusinessRule($"Item {item.NumeroItem}: {e.Message}");
        }
    }

    /// <summary>
    /// O que o catálogo sabe do destino, para conferir a nota. No produto recém-criado, a embalagem nasceu da própria
    /// nota: não há fator de cadastro para comparar.
    /// </summary>
    private static ProdutoParaInferencia Inferencia(Produto produto, Guid embalagemId, ItemAnalisado item, DecisaoItemNota decisao)
    {
        var embalagem = produto.Embalagens.First(e => e.Id == embalagemId);
        decimal? fatorCadastro = decisao.Acao switch
        {
            AcaoItemNota.CriarProduto => null,
            AcaoItemNota.Confirmar when item.Casamento is { PorGtinTributavel: true } => null,
            AcaoItemNota.Confirmar when item.Casamento is { } casamento => casamento.FatorConversao,
            _ => embalagem.FatorConversao,
        };
        var origem = item.Casamento?.ProdutoFornecedorId is not null && decisao.Acao == AcaoItemNota.Confirmar ? OrigemFator.DePara : OrigemFator.Embalagem;
        return new ProdutoParaInferencia(produto.UnidadeBase, produto.ControlaLote, produto.ControlaValidade, fatorCadastro, origem);
    }

    /// <summary>Cria ou atualiza o de-para do código do fornecedor: a decisão desta revisão passa a valer nas próximas notas.</summary>
    private ProdutoFornecedor Vincular(
        Dictionary<string, ProdutoFornecedor> vinculos,
        Guid fornecedorId,
        ItemNota item,
        Guid produtoId,
        Guid embalagemId,
        decimal fator,
        Guid usuarioId,
        DateTimeOffset agora,
        Resumo resumo)
    {
        var unidade = item.UnidadeComercial.Length > ProdutoFornecedor.UnidadeFornecedorMaxLength
            ? item.UnidadeComercial[..ProdutoFornecedor.UnidadeFornecedorMaxLength]
            : item.UnidadeComercial;
        if (vinculos.TryGetValue(item.CodigoFornecedor, out var existente))
        {
            if (existente.ProdutoId != produtoId || existente.EmbalagemId != embalagemId || existente.FatorConversao != fator
                || !string.Equals(existente.UnidadeFornecedor, unidade, StringComparison.OrdinalIgnoreCase))
            {
                existente.Update(produtoId, embalagemId, unidade, fator, usuarioId, agora);
                resumo.VinculosAtualizados++;
            }

            return existente;
        }

        var novo = ProdutoFornecedor.Create(fornecedorId, item.CodigoFornecedor, produtoId, embalagemId, unidade, fator, usuarioId, agora);
        db.ProdutoFornecedores.Add(novo);
        vinculos[item.CodigoFornecedor] = novo;
        resumo.VinculosCriados++;
        return novo;
    }

    private sealed class Resumo
    {
        public bool FornecedorCriado { get; init; }

        public int ProdutosCriados { get; set; }

        public int VinculosCriados { get; set; }

        public int VinculosAtualizados { get; set; }

        public HashSet<string> Skus { get; } = new(StringComparer.Ordinal);

        public HashSet<string> Gtins { get; } = new(StringComparer.Ordinal);
    }
}
