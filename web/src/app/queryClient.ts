import { QueryClient } from '@tanstack/react-query'
import { HttpError } from '../api/mutator'

const MAX_TENTATIVAS = 2

/**
 * Nova tentativa só para falha que pode passar sozinha: rede (status 0), 408, 429 e 5xx. Erro 4xx (validação,
 * permissão, não encontrado) não melhora repetindo, e a tela mostra o erro na hora.
 */
export function shouldRetry(failureCount: number, error: unknown): boolean {
  if (failureCount >= MAX_TENTATIVAS) {
    return false
  }

  if (error instanceof HttpError) {
    return error.status === 0 || error.status === 408 || error.status === 429 || error.status >= 500
  }

  return true
}

export function createQueryClient(): QueryClient {
  return new QueryClient({
    defaultOptions: {
      queries: {
        retry: shouldRetry,
        staleTime: 30_000,
        refetchOnWindowFocus: false,
      },
      mutations: {
        retry: false,
      },
    },
  })
}
