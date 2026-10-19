import { screen } from '@testing-library/react'
import { HttpError } from './api/mutator'
import { shouldRetry } from './app/queryClient'
import { http, HttpResponse } from 'msw'
import { gravarRequisicoes, server, usarSessao } from './test/msw/api'
import { renderRoute } from './test/renderRoute'

beforeEach(() => usarSessao())

function saude(status: string, codigo = 200) {
  server.use(http.get('/health/ready', () => HttpResponse.json({ status, totalDurationMs: 3, checks: [] }, { status: codigo })))
}

describe('painel', () => {
  it('mostra a página inicial com a API e o banco disponíveis', async () => {
    const requisicoes = gravarRequisicoes()

    renderRoute('/')

    expect(await screen.findByRole('heading', { name: 'Olá, Ana' })).toBeInTheDocument()
    expect(await screen.findByText('API e banco disponíveis.')).toBeInTheDocument()
    expect(requisicoes.some((r) => r.url === '/health/ready')).toBe(true)
    expect(screen.getByRole('link', { name: 'Início' })).toHaveAttribute('aria-current', 'page')
  })

  it('avisa quando o banco está fora do ar', async () => {
    saude('Unhealthy', 503)

    renderRoute('/')

    expect(await screen.findByText(/API indisponível: A API respondeu 503\./)).toBeInTheDocument()
  })

  it('avisa quando a API não responde', async () => {
    server.use(http.get('/health/ready', () => HttpResponse.error()))

    renderRoute('/')

    expect(await screen.findByText(/A API não respondeu/)).toBeInTheDocument()
  })

  it('mostra a página não encontrada para um endereço desconhecido', async () => {
    renderRoute('/endereco-que-nao-existe')

    expect(await screen.findByRole('heading', { name: 'Página não encontrada' })).toBeInTheDocument()
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
