import { QueryClientProvider } from '@tanstack/react-query'
import { useState } from 'react'
import { createBrowserRouter, RouterProvider } from 'react-router'
import { Toaster } from '@/components/ui/sonner'
import { TooltipProvider } from '@/components/ui/tooltip'
import { createQueryClient } from './app/queryClient'
import { routes } from './app/routes'
import { TemaProvider } from './app/tema/TemaProvider'

/** Raiz do painel: tema (claro, escuro, sistema), cache de dados (TanStack Query), rotas e avisos. */
function App() {
  const [queryClient] = useState(createQueryClient)
  const [router] = useState(() => createBrowserRouter(routes))

  return (
    <TemaProvider>
      <QueryClientProvider client={queryClient}>
        <TooltipProvider>
          <RouterProvider router={router} />
          <Toaster richColors closeButton />
        </TooltipProvider>
      </QueryClientProvider>
    </TemaProvider>
  )
}

export default App
