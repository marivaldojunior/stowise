import type {
  AcaoItemNota,
  AnaliseNotaFiscal,
  ClasseArmazenagem,
  DecisaoItemNota,
  EfetivarNotaFiscal,
  ItemAnalisado,
} from '@/api/gerado/modelos'
import type { Falha } from '@/api/falha'
import { lerNumero } from '@/lib/numeros'

/** Decisão de um item como a tela guarda (texto nos campos), antes de virar o corpo da efetivação. */
export interface Decisao {
  acao: AcaoItemNota
  /** Produto e embalagem escolhidos em "Vincular". */
  produtoId?: string
  embalagemId?: string
  /** Fator digitado (vazio: o inferido pela API). */
  fator: string
  /** Dados do produto novo em "Criar produto". */
  sku: string
  descricao: string
  classe: ClasseArmazenagem
}

const SKU_MAX = 40

/** SKU sugerido para um produto novo: o código do fornecedor só com letras, dígitos, "-", "_" e ".". */
export function skuSugerido(codigoFornecedor: string): string {
  return codigoFornecedor
    .trim()
    .toUpperCase()
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^A-Z0-9._-]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, SKU_MAX)
}

export function skuValido(sku: string): boolean {
  const limpo = sku.trim()
  return limpo.length > 0 && limpo.length <= SKU_MAX && /^[A-Za-z0-9._-]+$/.test(limpo)
}

/**
 * Ponto de partida da revisão: com de-para ou GTIN, confirmar o casamento; com candidatos pela descrição, nenhum
 * escolhido (a IA só sugere, e a pessoa escolhe); sem candidato, criar um produto novo com o SKU sugerido.
 */
export function decisaoInicial(item: ItemAnalisado): Decisao {
  const novo = { fator: '', sku: skuSugerido(item.item.codigoFornecedor), descricao: item.item.descricao, classe: 'Normal' as const }
  if (item.casamento) {
    return { ...novo, acao: 'Confirmar' }
  }

  return item.sugestoes.length > 0 ? { ...novo, acao: 'Vincular' } : { ...novo, acao: 'CriarProduto' }
}

/** Erros que a tela mostra sem chamar a API, por número do item. */
export function validarDecisoes(analise: AnaliseNotaFiscal, decisoes: Record<number, Decisao>): Record<number, string> {
  const erros: Record<number, string> = {}
  for (const { item } of analise.itens) {
    const decisao = decisoes[item.numeroItem]
    if (!decisao) {
      erros[item.numeroItem] = 'Decida o que fazer com este item.'
      continue
    }

    const fator = lerNumero(decisao.fator)
    if (decisao.acao === 'Vincular' && (!decisao.produtoId || !decisao.embalagemId)) {
      erros[item.numeroItem] = 'Escolha o produto e a embalagem.'
    } else if (decisao.acao === 'CriarProduto' && !skuValido(decisao.sku)) {
      erros[item.numeroItem] = 'Informe um SKU com letras, números, "-", "_" ou "." (até 40 caracteres).'
    } else if (fator !== null && !(fator > 0)) {
      erros[item.numeroItem] = 'O fator de conversão deve ser um número maior que zero.'
    }
  }

  return erros
}

/** Corpo do POST /notas-fiscais/efetivacao. Valide antes com {@link validarDecisoes}. */
export function paraEfetivacao(xml: string, analise: AnaliseNotaFiscal, decisoes: Record<number, Decisao>): EfetivarNotaFiscal {
  return {
    xml,
    itens: analise.itens.map(({ item }): DecisaoItemNota => {
      const decisao = decisoes[item.numeroItem]
      const fator = lerNumero(decisao.fator)
      return {
        numeroItem: item.numeroItem,
        acao: decisao.acao,
        produtoId: decisao.acao === 'Vincular' ? (decisao.produtoId ?? null) : null,
        embalagemId: decisao.acao === 'Vincular' ? (decisao.embalagemId ?? null) : null,
        fatorConversao: fator,
        novoProduto:
          decisao.acao === 'CriarProduto'
            ? {
                sku: decisao.sku.trim(),
                descricao: decisao.descricao.trim() || null,
                categoriaId: null,
                classeArmazenagem: decisao.classe,
              }
            : null,
      }
    }),
  }
}

/** Erros de validação da API (`itens[2].fatorConversao`, `itens[2]`) agrupados pelo número do item. */
export function errosPorItem(falha: Falha | null): Record<number, string> {
  const erros: Record<number, string> = {}
  for (const [campo, mensagens] of Object.entries(falha?.campos ?? {})) {
    const numero = /^itens\[(\d+)\]/i.exec(campo)?.[1]
    if (numero && mensagens[0]) {
      erros[Number(numero)] ??= mensagens[0]
    }
  }

  return erros
}
