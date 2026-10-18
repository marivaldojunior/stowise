import { http, HttpResponse } from 'msw'
import { setupServer } from 'msw/node'
import type { AuthResponse } from '@/api/gerado/modelos'

/** Id do usuário das sessões de teste. */
export const USUARIO_DA_SESSAO = '0192f5e0-0000-7000-8000-000000000001'

/** Corpo de login ou refresh da API, com token de 15 minutos. */
export function sessao(perfis: string[] = ['Gestor'], accessToken = 'token-1'): AuthResponse {
  const agora = Date.now()
  return {
    accessToken,
    accessTokenExpiresAt: new Date(agora + 15 * 60_000).toISOString(),
    refreshToken: null,
    refreshTokenExpiresAt: new Date(agora + 7 * 24 * 60 * 60_000).toISOString(),
    usuario: { id: USUARIO_DA_SESSAO, nome: 'Ana Souza', email: 'ana@stowise.dev', perfis },
  }
}

/** ProblemDetails como a API devolve (title com a mensagem; errors com os campos). */
export function problema(status: number, title: string, detail?: string, errors?: Record<string, string[]>) {
  return HttpResponse.json(
    { status, title, detail, errors },
    { status, headers: { 'Content-Type': 'application/problem+json' } },
  )
}

/**
 * Respostas padrão: sem sessão (o refresh do cookie é recusado) e API saudável. Cada teste acrescenta as rotas que
 * usa com `server.use(...)`; uma requisição sem handler faz o teste falhar (onUnhandledRequest: 'error').
 */
export const handlersPadrao = [
  http.post('/api/v1/auth/refresh', () => problema(401, 'Sessão inválida')),
  http.get('/health/ready', () => HttpResponse.json({ status: 'Healthy', totalDurationMs: 1, checks: [] })),
]

export const server = setupServer(...handlersPadrao)

/** Abre o painel já com sessão: o refresh feito ao abrir devolve a sessão com estes perfis. */
export function usarSessao(perfis: string[] = ['Gestor']) {
  server.use(http.post('/api/v1/auth/refresh', () => HttpResponse.json(sessao(perfis))))
}

export interface Requisicao {
  metodo: string
  /** Caminho com a query string, como o painel pediu. */
  url: string
  autorizacao: string | null
  corpo: unknown
}

/** Grava as requisições que chegam ao MSW, para o teste conferir método, token e corpo. */
export function gravarRequisicoes(): Requisicao[] {
  const requisicoes: Requisicao[] = []
  server.events.on('request:start', ({ request }) => {
    const { pathname, search } = new URL(request.url)
    const requisicao: Requisicao = {
      metodo: request.method,
      url: pathname + search,
      autorizacao: request.headers.get('Authorization'),
      corpo: undefined,
    }
    requisicoes.push(requisicao)
    void request
      .clone()
      .text()
      .then((texto) => {
        requisicao.corpo = texto ? (JSON.parse(texto) as unknown) : undefined
      })
  })
  return requisicoes
}

export function requisicoesPara(requisicoes: Requisicao[], url: string) {
  return requisicoes.filter((r) => r.url === url)
}
