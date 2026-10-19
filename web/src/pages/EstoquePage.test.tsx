import { screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { http, HttpResponse } from 'msw'
import type { ExtratoItem, SaldoItem } from '@/api/gerado/modelos'
import { limiteDoDia, sinal } from '@/features/estoque/formato'
import { gravarRequisicoes, server, usarSessao } from '@/test/msw/api'
import { renderRoute } from '@/test/renderRoute'

function saldo(endereco: string, lote: string | null, quantidade: number, reservada = 0): SaldoItem {
  return {
    enderecoId: `end-${endereco}`,
    enderecoCodigo: endereco,
    armazemId: 'arm-1',
    zonaId: 'z-seca',
    produtoId: 'p-1',
    sku: 'ARROZ-5KG',
    descricao: 'Arroz tipo 1 5kg',
    unidadeBase: 'UN',
    loteId: lote ? `lote-${lote}` : null,
    loteNumero: lote,
    validade: lote ? '2027-03-31' : null,
    quantidade,
    quantidadeReservada: reservada,
    quantidadeDisponivel: quantidade - reservada,
  }
}

function movimentacao(id: string, tipo: ExtratoItem['tipo'], origem: string | null, destino: string | null): ExtratoItem {
  return {
    id,
    tipo,
    ocorridoEm: '2026-10-15T14:30:00Z',
    recebidoEm: '2026-10-15T14:30:01Z',
    produtoId: 'p-1',
    sku: 'ARROZ-5KG',
    loteNumero: 'L1',
    enderecoOrigemCodigo: origem,
    enderecoDestinoCodigo: destino,
    quantidade: 12,
    documentoReferencia: tipo === 'Entrada' ? 'NF 1234' : null,
    observacao: null,
    usuarioId: 'u-1',
  }
}

/** API das consultas de estoque (handlers do MSW). */
function apiDeEstoque() {
  usarSessao(['Operador'])
  server.use(
    http.get('/api/v1/armazens', () =>
      HttpResponse.json([{ id: 'arm-1', codigo: 'CD1', nome: 'Centro', zonas: 1, enderecos: 3 }]),
    ),
    http.get('/api/v1/armazens/arm-1', () =>
      HttpResponse.json({
        id: 'arm-1',
        codigo: 'CD1',
        nome: 'Centro',
        zonas: [{ id: 'z-seca', codigo: 'SECA', classeArmazenagem: 'Normal', enderecos: 3 }],
      }),
    ),
    http.get('/api/v1/saldos', ({ request }) => {
      const params = new URL(request.url).searchParams
      const todos = [saldo('A-01-1-1', 'L1', 30, 5), saldo('A-01-2-1', null, 10)]
      const itens = todos.filter((s) => !params.get('enderecoId') || s.enderecoId === params.get('enderecoId'))
      return HttpResponse.json({ itens, pagina: 1, tamanhoPagina: 50, total: itens.length })
    }),
    http.get('/api/v1/movimentacoes', ({ request }) => {
      const tipo = new URL(request.url).searchParams.get('tipo')
      const todos = [
        movimentacao('m1', 'Entrada', null, 'A-01-1-1'),
        movimentacao('m2', 'Transferencia', 'A-01-1-1', 'A-01-2-1'),
        movimentacao('m3', 'Saida', 'A-01-2-1', null),
      ]
      const itens = todos.filter((m) => !tipo || m.tipo === tipo)
      return HttpResponse.json({ itens, pagina: 1, tamanhoPagina: 50, total: itens.length })
    }),
    http.get('/api/v1/produtos/p-1', () =>
      HttpResponse.json({ id: 'p-1', sku: 'ARROZ-5KG', descricao: 'Arroz tipo 1 5kg' }),
    ),
    http.get('/api/v1/enderecos/end-A-01-1-1', () => HttpResponse.json({ id: 'end-A-01-1-1', codigo: 'A-01-1-1' })),
  )
  return gravarRequisicoes()
}

describe('saldos', () => {
  it('mostra quantidade, reservada e disponível por endereço e lote', async () => {
    apiDeEstoque()
    renderRoute('/estoque')

    const linha = (await screen.findByRole('link', { name: 'A-01-1-1' })).closest('tr') as HTMLElement
    expect(within(linha).getByText('L1')).toBeInTheDocument()
    expect(within(linha).getByText('31/03/2027')).toBeInTheDocument()
    expect(within(linha).getByText('30 UN')).toBeInTheDocument()
    expect(within(linha).getByText('25')).toBeInTheDocument()
    expect(within(linha).getByRole('link', { name: /Arroz tipo 1 5kg/ })).toHaveAttribute('href', '/catalogo/p-1')
  })

  it('filtra pelo endereço vindo de um link e permite remover o filtro', async () => {
    const requisicoes = apiDeEstoque()
    const { router } = renderRoute('/estoque?enderecoId=end-A-01-1-1')
    const user = userEvent.setup()

    expect(await screen.findByText('Endereço A-01-1-1')).toBeInTheDocument()
    await screen.findByRole('link', { name: 'A-01-1-1' })
    expect(screen.queryByRole('link', { name: 'A-01-2-1' })).not.toBeInTheDocument()
    expect(requisicoes.some((r) => r.url.includes('enderecoId=end-A-01-1-1'))).toBe(true)

    await user.click(screen.getByRole('button', { name: 'Remover o filtro Endereço A-01-1-1' }))

    expect(await screen.findByRole('link', { name: 'A-01-2-1' })).toBeInTheDocument()
    expect(router.state.location.search).toBe('')
  })

  it('filtra por armazém e zona e inclui os zerados', async () => {
    const requisicoes = apiDeEstoque()
    renderRoute('/estoque')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('combobox', { name: 'Filtrar por armazém' }))
    await user.click(await screen.findByRole('option', { name: 'CD1 · Centro' }))
    await user.click(await screen.findByRole('combobox', { name: 'Filtrar por zona' }))
    await user.click(await screen.findByRole('option', { name: 'SECA' }))
    await user.click(screen.getByLabelText('Mostrar saldos zerados'))

    await waitFor(() =>
      expect(
        requisicoes.some(
          (r) => r.url.includes('armazemId=arm-1') && r.url.includes('zonaId=z-seca') && r.url.includes('incluirZerados=true'),
        ),
      ).toBe(true),
    )
  })
})

describe('extrato', () => {
  it('mostra o sentido de cada movimentação', async () => {
    apiDeEstoque()
    renderRoute('/estoque/extrato')

    const entrada = (await screen.findByText('Entrada')).closest('tr') as HTMLElement
    expect(within(entrada).getByText('+12')).toBeInTheDocument()
    expect(within(entrada).getByText('NF 1234')).toBeInTheDocument()
    expect(within(screen.getByText('Saída').closest('tr') as HTMLElement).getByText('−12')).toBeInTheDocument()
    const transferencia = screen.getByText('Transferência').closest('tr') as HTMLElement
    expect(within(transferencia).getByText('A-01-1-1 → A-01-2-1')).toBeInTheDocument()
    expect(within(transferencia).getByText('12')).toBeInTheDocument()
  })

  it('filtra por tipo e período, com o dia final inteiro', async () => {
    const requisicoes = apiDeEstoque()
    renderRoute('/estoque/extrato?de=2026-10-01&ate=2026-10-15')
    const user = userEvent.setup()

    await screen.findByText('Entrada')
    await user.click(screen.getByRole('combobox', { name: 'Tipo' }))
    await user.click(await screen.findByRole('option', { name: 'Saída' }))

    await waitFor(() => expect(screen.queryByText('Entrada')).not.toBeInTheDocument())
    const ultima = new URLSearchParams(requisicoes.filter((r) => r.url.startsWith('/api/v1/movimentacoes')).at(-1)?.url.split('?')[1])
    expect(ultima.get('tipo')).toBe('Saida')
    expect(ultima.get('de')).toBe(limiteDoDia('2026-10-01', false))
    expect(ultima.get('ate')).toBe(limiteDoDia('2026-10-15', true))
  })

  it('as abas mantêm o filtro do produto', async () => {
    apiDeEstoque()
    renderRoute('/estoque?produtoId=p-1')

    expect(await screen.findByText('Produto ARROZ-5KG · Arroz tipo 1 5kg')).toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'Extrato' })).toHaveAttribute('href', '/estoque/extrato?produtoId=p-1')
  })
})

describe('regras de formato', () => {
  it('o sentido vem dos endereços de origem e destino', () => {
    expect(sinal({ enderecoOrigemCodigo: null, enderecoDestinoCodigo: 'A' })).toBe('+')
    expect(sinal({ enderecoOrigemCodigo: 'A', enderecoDestinoCodigo: null })).toBe('−')
    expect(sinal({ enderecoOrigemCodigo: 'A', enderecoDestinoCodigo: 'B' })).toBe('↔')
  })

  it('o fim do período é o último milissegundo do dia local', () => {
    const fim = new Date(limiteDoDia('2026-10-15', true))
    expect([fim.getDate(), fim.getHours(), fim.getMinutes(), fim.getMilliseconds()]).toEqual([15, 23, 59, 999])
    expect(new Date(limiteDoDia('2026-10-01', false)).getHours()).toBe(0)
  })
})

describe('estoque na página do produto', () => {
  it('mostra os totais, os lotes e os atalhos', async () => {
    usarSessao(['Operador'])
    server.use(
      http.get('/api/v1/categorias', () => HttpResponse.json([])),
      http.get('/api/v1/produtos/p-1', () =>
        HttpResponse.json({
          id: 'p-1',
          sku: 'ARROZ-5KG',
          descricao: 'Arroz tipo 1 5kg',
          unidadeBase: 'UN',
          classeArmazenagem: 'Normal',
          controlaLote: true,
          controlaValidade: true,
          ncm: null,
          cest: null,
          categoriaId: null,
          ativo: true,
          versao: 1,
          embalagens: [],
        }),
      ),
      http.get('/api/v1/saldos/produtos/p-1', () =>
        HttpResponse.json({
          produtoId: 'p-1',
          sku: 'ARROZ-5KG',
          descricao: 'Arroz tipo 1 5kg',
          unidadeBase: 'UN',
          quantidade: 40,
          quantidadeReservada: 5,
          quantidadeDisponivel: 35,
          enderecos: 2,
          lotes: [{ loteId: 'l1', numero: 'L1', validade: '2027-03-31', quantidade: 30, quantidadeReservada: 5 }],
        }),
      ),
    )
    renderRoute('/catalogo/p-1')

    const estoque = await screen.findByRole('region', { name: 'Estoque' })
    expect(await within(estoque).findByText('35 UN')).toBeInTheDocument()
    expect(within(estoque).getByText('L1 · 30 · validade 31/03/2027')).toBeInTheDocument()
    expect(within(estoque).getByRole('link', { name: 'Ver extrato' })).toHaveAttribute(
      'href',
      '/estoque/extrato?produtoId=p-1',
    )
  })
})
