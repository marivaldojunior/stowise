import { screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { http, HttpResponse } from 'msw'
import type { EfetivarNotaFiscal, NotaFiscalEfetivada } from '@/api/gerado/modelos'
import { ANALISE_EXEMPLO } from '@/features/notasFiscais/exemplo'
import { gravarRequisicoes, problema, requisicoesPara, server, usarSessao } from '@/test/msw/api'
import { renderRoute } from '@/test/renderRoute'

const XML = '<nfeProc versao="4.00"><NFe/></nfeProc>'

const EFETIVADA: NotaFiscalEfetivada = {
  recebimentoId: 'rec-1',
  fornecedorId: 'forn-1',
  fornecedorCriado: true,
  produtosCriados: 1,
  vinculosCriados: 2,
  vinculosAtualizados: 0,
  itens: [
    { numeroItem: 1, produtoId: 'prod-0009', embalagemId: 'emb-0082', produtoFornecedorId: 'pf-1', fatorConversao: 12, quantidade: 120 },
    { numeroItem: 2, produtoId: 'prod-novo', embalagemId: 'emb-novo', produtoFornecedorId: 'pf-2', fatorConversao: 100, quantidade: 500 },
  ],
}

async function enviarXml() {
  const user = userEvent.setup()
  renderRoute('/notas-fiscais')
  await user.upload(await screen.findByLabelText('XML da NF-e'), new File([XML], 'nfe.xml', { type: 'text/xml' }))
  await screen.findByRole('heading', { name: 'NF-e 1234, série 1' })
  return user
}

function item(numero: number) {
  return screen.getByRole('heading', { name: new RegExp(`^Item ${numero}:`) }).closest('article')!
}

describe('NotaFiscalPage', () => {
  it('revisa os itens e efetiva com uma decisão por item', async () => {
    usarSessao(['Gestor'])
    const requisicoes = gravarRequisicoes()
    server.use(
      http.post('/api/v1/notas-fiscais/analise', () => HttpResponse.json(ANALISE_EXEMPLO)),
      http.post('/api/v1/notas-fiscais/efetivacao', () => HttpResponse.json(EFETIVADA, { status: 201 })),
    )

    const user = await enviarXml()
    expect(screen.getByText('Distribuidora Exemplo Ltda')).toBeInTheDocument()
    expect(within(item(1)).getByText('GTIN do catálogo')).toBeInTheDocument()
    expect(within(item(1)).getByText(/L2610A \(120, validade 30\/04\/2027\)/)).toBeInTheDocument()
    expect(within(item(1)).getByRole('radio', { name: 'Confirmar REF-COL-2L' })).toHaveAttribute('aria-checked', 'true')

    // A IA só sugere: o item 2 começa sem candidato escolhido, e a efetivação espera a escolha.
    expect(within(item(2)).getByText(/COP-VID-6/).closest('button')).toHaveAttribute('aria-checked', 'false')
    await user.click(screen.getByRole('button', { name: 'Efetivar a nota' }))
    expect(within(item(2)).getByRole('alert')).toHaveTextContent('Escolha o produto e a embalagem.')
    expect(requisicoesPara(requisicoes, '/api/v1/notas-fiscais/efetivacao')).toHaveLength(0)

    await user.click(within(item(2)).getByRole('radio', { name: 'Criar produto novo' }))
    const sku = within(item(2)).getByLabelText('SKU')
    expect(sku).toHaveValue('REF-077')
    await user.clear(sku)
    await user.type(sku, 'COPO-200')
    await user.click(screen.getByRole('button', { name: 'Efetivar a nota' }))

    expect(await screen.findByRole('heading', { name: 'Nota efetivada' })).toBeInTheDocument()
    expect(screen.getByText(/2 item\(ns\) no recebimento · 1 produto\(s\) novo\(s\)/)).toBeInTheDocument()
    await waitFor(() => expect(requisicoesPara(requisicoes, '/api/v1/notas-fiscais/efetivacao')[0]?.corpo).toBeDefined())
    const corpo = requisicoesPara(requisicoes, '/api/v1/notas-fiscais/efetivacao')[0].corpo as EfetivarNotaFiscal
    expect(corpo.xml).toBe(XML)
    expect(corpo.itens?.map((i) => [i.numeroItem, i.acao, i.novoProduto?.sku ?? null])).toEqual([
      [1, 'Confirmar', null],
      [2, 'CriarProduto', 'COPO-200'],
    ])
  })

  it('mostra no item o erro de validação da API', async () => {
    usarSessao(['Gestor'])
    server.use(
      http.post('/api/v1/notas-fiscais/analise', () => HttpResponse.json(ANALISE_EXEMPLO)),
      http.post('/api/v1/notas-fiscais/efetivacao', () =>
        problema(400, 'Erro de validação', undefined, { 'itens[2].fatorConversao': ['Informe o fator de conversão do item 2.'] }),
      ),
    )

    const user = await enviarXml()
    await user.click(within(item(2)).getByRole('radio', { name: 'Criar produto novo' }))
    await user.click(screen.getByRole('button', { name: 'Efetivar a nota' }))

    expect(await within(item(2)).findByRole('alert')).toHaveTextContent('Informe o fator de conversão do item 2.')
    expect(within(item(1)).queryByRole('alert')).not.toBeInTheDocument()
  })

  it('mostra a recusa do XML na análise', async () => {
    usarSessao(['Gestor'])
    server.use(http.post('/api/v1/notas-fiscais/analise', () => problema(422, 'O XML não é uma NF-e 4.00 válida.', 'O XML não é uma NF-e 4.00 válida.')))

    renderRoute('/notas-fiscais')
    await userEvent.upload(await screen.findByLabelText('XML da NF-e'), new File(['x'], 'nfe.xml'))

    expect(await screen.findByRole('alert')).toHaveTextContent('O XML não é uma NF-e 4.00 válida.')
  })

  it('o Operador recebe "Acesso negado"', async () => {
    usarSessao(['Operador'])

    renderRoute('/notas-fiscais')

    expect(await screen.findByRole('heading', { name: 'Acesso negado' })).toBeInTheDocument()
  })
})
