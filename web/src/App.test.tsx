import { screen } from '@testing-library/react'
import { HttpError } from './api/http'
import { shouldRetry } from './app/queryClient'
import { jsonResponse, renderRoute, stubFetch } from './test/renderRoute'

afterEach(() => {
  vi.unstubAllGlobals()
})

describe('painel', () => {
  it('mostra a página inicial com a API e o banco disponíveis', async () => {
    const fetchMock = stubFetch(() => jsonResponse({ status: 'Healthy', totalDurationMs: 3.2, checks: [] }))

    renderRoute('/')

    expect(screen.getByRole('heading', { name: 'Stowise' })).toBeInTheDocument()
    expect(await screen.findByText('API e banco disponíveis.')).toBeInTheDocument()
    expect(fetchMock).toHaveBeenCalledWith('/health/ready', expect.anything())
    expect(screen.getByRole('link', { name: 'Início' })).toHaveAttribute('aria-current', 'page')
  })

  it('avisa quando o banco está fora do ar', async () => {
    stubFetch(() => jsonResponse({ status: 'Unhealthy', totalDurationMs: 5, checks: [] }, 503))

    renderRoute('/')

    expect(await screen.findByText(/API indisponível: A API respondeu 503\./)).toBeInTheDocument()
  })

  it('avisa quando a API não responde', async () => {
    vi.stubGlobal('fetch', vi.fn(() => Promise.reject(new TypeError('Failed to fetch'))))

    renderRoute('/')

    expect(await screen.findByText(/A API não respondeu/)).toBeInTheDocument()
  })

  it('mostra a página não encontrada para um endereço desconhecido', () => {
    stubFetch(() => jsonResponse({ status: 'Healthy', totalDurationMs: 1, checks: [] }))

    renderRoute('/endereco-que-nao-existe')

    expect(screen.getByRole('heading', { name: 'Página não encontrada' })).toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'Voltar para o início' })).toHaveAttribute('href', '/')
  })
})

describe('novas tentativas das consultas', () => {
  it.each([
    [0, true],
    [408, true],
    [429, true],
    [503, true],
    [400, false],
    [401, false],
    [404, false],
  ])('status %i tenta de novo: %s', (status, esperado) => {
    expect(shouldRetry(0, new HttpError(status, 'x'))).toBe(esperado)
  })

  it('para depois de duas novas tentativas', () => {
    expect(shouldRetry(1, new HttpError(503, 'x'))).toBe(true)
    expect(shouldRetry(2, new HttpError(503, 'x'))).toBe(false)
  })
})
