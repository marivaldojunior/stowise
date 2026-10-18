/**
 * Ponto único de rede do painel. O cliente gerado pelo orval (src/api/gerado) chama esta função em todas as
 * operações da API. Em desenvolvimento, as chamadas vão para a mesma origem e o proxy do Vite repassa para a API
 * (a API não libera CORS).
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

type TokenProvider = () => string | null | undefined

let tokenProvider: TokenProvider = () => null

/** A autenticação registra aqui como obter o token de acesso atual. */
export function setTokenProvider(provider: TokenProvider) {
  tokenProvider = provider
}

/**
 * Faz a requisição e devolve o corpo já lido (JSON) ou `undefined` sem corpo (204). Erro HTTP vira `HttpError`
 * com o ProblemDetails, para as telas mostrarem a mensagem e os erros por campo.
 */
export async function apiFetch<T>(url: string, init: RequestInit = {}): Promise<T> {
  const headers = new Headers(init.headers)
  headers.set('Accept', 'application/json')
  const token = tokenProvider()
  if (token && !headers.has('Authorization')) {
    headers.set('Authorization', `Bearer ${token}`)
  }

  let response: Response
  try {
    response = await fetch(url, { ...init, headers })
  } catch (error) {
    if (error instanceof DOMException && error.name === 'AbortError') {
      throw error
    }

    throw new HttpError(0, 'A API não respondeu. Confira se ela está rodando.', { detail: String(error) })
  }

  const texto = await response.text()
  const corpo: unknown = texto.length > 0 && isJson(response) ? JSON.parse(texto) : undefined
  if (!response.ok) {
    const problem = corpo as ProblemDetails | undefined
    throw new HttpError(response.status, problem?.title ?? `A API respondeu ${response.status}.`, problem)
  }

  return corpo as T
}

function isJson(response: Response) {
  const tipo = response.headers.get('Content-Type') ?? ''
  return tipo.includes('json')
}

/** Tipo de erro dos hooks gerados pelo orval: toda falha da API chega como `HttpError`. */
export type ErrorType<_Error> = HttpError

/** Tipo do corpo das requisições nos hooks gerados (sem transformação). */
export type BodyType<Body> = Body

export default apiFetch
