import type { ItemAnalisado } from '@/api/gerado/modelos'
import { HttpError } from '@/api/mutator'
import { falhaDe } from '@/api/falha'
import { decisaoInicial, errosPorItem, paraEfetivacao, skuSugerido, skuValido, validarDecisoes, type Decisao } from './decisoes'
import { ANALISE_EXEMPLO } from './exemplo'

const [GTIN, SIMILAR] = ANALISE_EXEMPLO.itens

function semCandidato(): ItemAnalisado {
  return { ...SIMILAR, origem: 'SemCandidato', sugestoes: [], metodoSugestoes: null }
}

describe('decisões da revisão da NF-e', () => {
  it('começa confirmando o casamento, sem escolher candidato da IA e criando produto sem candidato', () => {
    expect(decisaoInicial(GTIN).acao).toBe('Confirmar')

    const similar = decisaoInicial(SIMILAR)
    expect(similar.acao).toBe('Vincular')
    expect(similar.produtoId).toBeUndefined()

    const novo = decisaoInicial(semCandidato())
    expect(novo).toMatchObject({ acao: 'CriarProduto', sku: 'REF-077', descricao: 'COPO DESC 200ML PCT 100', classe: 'Normal' })
  })

  it('sugere um SKU válido a partir do código do fornecedor', () => {
    expect(skuSugerido(' cód 12/ação ')).toBe('COD-12-ACAO')
    expect(skuSugerido('x'.repeat(50))).toHaveLength(40)
    expect(skuValido('REF-001')).toBe(true)
    expect(skuValido('REF 001')).toBe(false)
    expect(skuValido('')).toBe(false)
  })

  it('valida a escolha do produto, o SKU e o fator antes de chamar a API', () => {
    const decisoes: Record<number, Decisao> = {
      1: { ...decisaoInicial(GTIN), fator: '0' },
      2: decisaoInicial(SIMILAR),
    }

    expect(validarDecisoes(ANALISE_EXEMPLO, decisoes)).toEqual({
      1: 'O fator de conversão deve ser um número maior que zero.',
      2: 'Escolha o produto e a embalagem.',
    })

    decisoes[1].fator = '12'
    decisoes[2] = { ...decisoes[2], acao: 'CriarProduto', sku: 'COPO 200' }
    expect(validarDecisoes(ANALISE_EXEMPLO, decisoes)[2]).toMatch(/SKU/)

    decisoes[2].sku = 'COPO-200'
    expect(validarDecisoes(ANALISE_EXEMPLO, decisoes)).toEqual({})
  })

  it('monta o corpo da efetivação com uma decisão por item', () => {
    const decisoes: Record<number, Decisao> = {
      1: decisaoInicial(GTIN),
      2: { ...decisaoInicial(SIMILAR), produtoId: 'prod-0016', embalagemId: 'emb-0161', fator: '1,5' },
    }

    expect(paraEfetivacao('<nfeProc/>', ANALISE_EXEMPLO, decisoes)).toEqual({
      xml: '<nfeProc/>',
      itens: [
        { numeroItem: 1, acao: 'Confirmar', produtoId: null, embalagemId: null, fatorConversao: null, novoProduto: null },
        { numeroItem: 2, acao: 'Vincular', produtoId: 'prod-0016', embalagemId: 'emb-0161', fatorConversao: 1.5, novoProduto: null },
      ],
    })

    decisoes[2] = { ...decisoes[2], acao: 'CriarProduto', sku: ' COPO-200 ', descricao: ' ', classe: 'Fragil', fator: '' }
    expect(paraEfetivacao('<nfeProc/>', ANALISE_EXEMPLO, decisoes).itens![1]).toEqual({
      numeroItem: 2,
      acao: 'CriarProduto',
      produtoId: null,
      embalagemId: null,
      fatorConversao: null,
      novoProduto: { sku: 'COPO-200', descricao: null, categoriaId: null, classeArmazenagem: 'Fragil' },
    })
  })

  it('agrupa os erros de validação da API pelo item', () => {
    const falha = falhaDe(
      new HttpError(400, 'Bad Request', {
        status: 400,
        title: 'Erro de validação',
        errors: { 'itens[2].fatorConversao': ['Informe o fator do item 2.'], 'itens[2]': ['Outro erro.'], xml: ['Envie o XML.'] },
      }),
    )

    expect(errosPorItem(falha)).toEqual({ 2: 'Informe o fator do item 2.' })
    expect(errosPorItem(null)).toEqual({})
  })
})
