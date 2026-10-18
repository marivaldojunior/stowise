import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { render } from '@testing-library/react'
import { createMemoryRouter, RouterProvider } from 'react-router'
import { TooltipProvider } from '@/components/ui/tooltip'
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
        <TooltipProvider>
          <RouterProvider router={router} />
        </TooltipProvider>
      </QueryClientProvider>
    </TemaProvider>,
  )

  return { router, queryClient }
}

/** Troca o `fetch` global por uma resposta fixa (o MSW entra numa tarefa seguinte do plano). */
export function stubFetch(responder: (url: string) => Response | Promise<Response>) {
  const fetchMock = vi.fn((input: RequestInfo | URL) => Promise.resolve(responder(String(input))))
  vi.stubGlobal('fetch', fetchMock)
  return fetchMock
}

export function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } })
}
