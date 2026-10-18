import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { render } from '@testing-library/react'
import { createMemoryRouter, RouterProvider } from 'react-router'
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
