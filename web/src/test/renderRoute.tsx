import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { render } from '@testing-library/react'
import { createMemoryRouter, RouterProvider } from 'react-router'
import type { AuthResponse } from '@/api/gerado/modelos'
import { TooltipProvider } from '@/components/ui/tooltip'
import { AuthProvider } from '@/features/auth/AuthProvider'
import { routes } from '../app/routes'
import { TemaProvider } from '../app/tema/TemaProvider'

/**
 * Monta o painel numa rota, com os mesmos provedores do App, as rotas reais num roteador em memória e um cache
 * novo por teste. Sem novas tentativas, para um erro da API aparecer na hora.
 */
export function renderRoute(path: string) {
  const queryClient = new QueryClient({ defaultOptions: { queries: { retry: false } } })
  const router = createMemoryRouter(routes, { initialEntries: [path] })

  render(
    <TemaProvider>
      <QueryClientProvider client={queryClient}>
        <AuthProvider>
          <TooltipProvider>
            <RouterProvider router={router} />
          </TooltipProvider>
        </AuthProvider>
      </QueryClientProvider>
    </TemaProvider>,
  )

  return { router, queryClient }
}

export type Responder = (url: string, init: RequestInit) => Response | Promise<Response>

/** Troca o `fetch` global por respostas fixas (o MSW entra numa tarefa seguinte do plano). */
export function stubFetch(responder: Responder) {
  const fetchMock = vi.fn((input: RequestInfo | URL, init?: RequestInit) =>
    Promise.resolve(responder(String(input), init ?? {})),
  )
  vi.stubGlobal('fetch', fetchMock)
  return fetchMock
}

export function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } })
}

export function problemResponse(status: number, title: string, detail?: string, errors?: Record<string, string[]>) {
  return new Response(JSON.stringify({ status, title, detail, errors }), {
    status,
    headers: { 'Content-Type': 'application/problem+json' },
  })
}

/** Resposta de login ou refresh da API, com token de 15 minutos. */
export function sessaoResponse(perfis: string[] = ['Gestor'], accessToken = 'token-1') {
  const agora = Date.now()
  const corpo: AuthResponse = {
    accessToken,
    accessTokenExpiresAt: new Date(agora + 15 * 60_000).toISOString(),
    refreshToken: null,
    refreshTokenExpiresAt: new Date(agora + 7 * 24 * 60 * 60_000).toISOString(),
    usuario: { id: '0192f5e0-0000-7000-8000-000000000001', nome: 'Ana Souza', email: 'ana@stowise.dev', perfis },
  }
  return jsonResponse(corpo)
}

/**
 * Responde como a API com uma sessão ativa: o refresh (feito ao abrir o painel) devolve a sessão e as demais
 * rotas caem no `outras`.
 */
export function comSessao(outras: Responder, perfis: string[] = ['Gestor']): Responder {
  return (url, init) => (url === '/api/v1/auth/refresh' ? sessaoResponse(perfis) : outras(url, init))
}
