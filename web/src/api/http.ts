/**
 * Cliente HTTP mínimo da API. Em desenvolvimento, as chamadas vão para a mesma origem e o proxy do Vite
 * repassa para a API (sem CORS). O cliente gerado a partir do OpenAPI (orval) vai substituir este arquivo.
 */

/** Corpo de erro da API (ProblemDetails, RFC 9457). */
export interface ProblemDetails {
  title?: string
  status?: number
  detail?: string
  traceId?: string
  errors?: Record<string, string[]>
}

/** Resposta HTTP fora da faixa 2xx. `status` 0 quer dizer que a API não respondeu (rede). */
export class HttpError extends Error {
  readonly status: number
  readonly problem?: ProblemDetails

  constructor(status: number, message: string, problem?: ProblemDetails) {
    super(message)
    this.name = 'HttpError'
    this.status = status
    this.problem = problem
  }
}

export async function getJson<T>(path: string, init?: RequestInit): Promise<T> {
  let response: Response
  try {
    response = await fetch(path, { ...init, headers: { Accept: 'application/json', ...init?.headers } })
  } catch (error) {
    throw new HttpError(0, 'A API não respondeu. Confira se ela está rodando.', { detail: String(error) })
  }

  const body: unknown = await response.json().catch(() => undefined)
  if (!response.ok) {
    const problem = body as ProblemDetails | undefined
    throw new HttpError(response.status, problem?.title ?? `A API respondeu ${response.status}.`, problem)
  }

  return body as T
}
