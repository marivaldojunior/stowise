import { screen, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { http, HttpResponse } from 'msw'
import type { CadastroIncompleto, ProdutoDetalhe } from '@/api/gerado/modelos'
import { problema, server, usarSessao } from '@/test/msw/api'
import { renderRoute } from '@/test/renderRoute'

const FILA: CadastroIncompleto[] = [
  {
    id: 'prod-1',
    sku: 'COLA-2L',
    descricao: 'Refrigerante Cola 2L',
    unidadeBase: 'UN',
    categoriaId: null,
    pendencias: [
      { embalagemId: 'emb-un', tipo: 'Unidade', fatorConversao: 1, gtin: '7891000315507', faltando: ['pesoKg'] },
      { embalagemId: 'emb-cx', tipo: 'Caixa', fatorConversao: 12, gtin: null, faltando: ['alturaCm', 'larguraCm'] },
    ],
  },
]

function apiDaFila(itens: CadastroIncompleto[] = FILA) {
  const buscas: (string | null)[] = []
  usarSessao(['Operador'])
  server.use(
    http.get('/api/v1/categorias', () => HttpResponse.json([])),
    http.get('/api/v1/produtos/cadastros-incompletos', ({ request }) => {
      const busca = new URL(request.url).searchParams.get('busca')
      buscas.push(busca)
      const filtrados = itens.filter((p) => !busca || p.sku.toLowerCase().includes(busca.toLowerCase()))
      return HttpResponse.json({ itens: filtrados, pagina: 1, tamanhoPagina: 20, total: filtrados.length })
    }),
  )
  return buscas
}

describe('CadastrosIncompletosPage', () => {
  it('lista o que falta em cada embalagem', async () => {
    apiDaFila()

    renderRoute('/catalogo/incompletos')

    const sku = await screen.findByRole('link', { name: 'COLA-2L' })
    expect(sku).toHaveAttribute('href', '/catalogo/prod-1')
    const linha = sku.closest('tr')!
    expect(within(linha).getAllByText('Refrigerante Cola 2L')).not.toHaveLength(0)
    expect(within(linha).getByText('peso')).toBeInTheDocument()
    expect(within(linha).getByText(/Caixa de 12 UN/)).toBeInTheDocument()
    expect(within(linha).getByText('altura')).toBeInTheDocument()
    expect(within(linha).getByText('largura')).toBeInTheDocument()
  })

  it('busca pela URL e mostra a fila vazia', async () => {
    const buscas = apiDaFila()

    const { router } = renderRoute('/catalogo/incompletos')
    await screen.findByRole('link', { name: 'COLA-2L' })
    await userEvent.type(screen.getByRole('searchbox', { name: 'Buscar por SKU ou descrição' }), 'xyz')

    expect(await screen.findByText(/Nenhum cadastro incompleto/)).toBeInTheDocument()
    expect(router.state.location.search).toContain('busca=xyz')
    expect(buscas).toContain('xyz')
  })

  it('o catálogo leva à fila', async () => {
    apiDaFila()
    server.use(
      http.get('/api/v1/produtos', () => HttpResponse.json({ itens: [] as ProdutoDetalhe[], pagina: 1, tamanhoPagina: 20, total: 0 })),
    )

    const { router } = renderRoute('/catalogo')
    await userEvent.click(await screen.findByRole('link', { name: /Cadastros incompletos/ }))

    expect(router.state.location.pathname).toBe('/catalogo/incompletos')
    expect(await screen.findByRole('heading', { name: 'Cadastros incompletos' })).toBeInTheDocument()
  })

  it('mostra o erro da API', async () => {
    usarSessao(['Operador'])
    server.use(
      http.get('/api/v1/categorias', () => HttpResponse.json([])),
      http.get('/api/v1/produtos/cadastros-incompletos', () => problema(500, 'Falha inesperada')),
    )

    renderRoute('/catalogo/incompletos')

    expect(await screen.findByText(/Não foi possível carregar a fila/)).toBeInTheDocument()
  })
})
