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

type UnauthorizedHandler = () => Promise<boolean>

let unauthorizedHandler: UnauthorizedHandler = () => Promise.resolve(false)

/**
 * A autenticação registra aqui como renovar a sessão quando a API responde 401. Devolve `true` se renovou: a
 * requisição é repetida uma vez com o token novo. As rotas de autenticação nunca passam por aqui.
 */
export function setUnauthorizedHandler(handler: UnauthorizedHandler) {
  unauthorizedHandler = handler
}

const ROTAS_DE_AUTENTICACAO = '/api/v1/auth/'
const MENSAGEM_SEM_RESPOSTA = 'A API não respondeu. Confira se ela está rodando.'

/**
 * Faz a requisição e devolve o corpo já lido (JSON) ou `undefined` sem corpo (204). Erro HTTP vira `HttpError`
 * com o ProblemDetails, para as telas mostrarem a mensagem e os erros por campo.
 */
export async function apiFetch<T>(url: string, init: RequestInit = {}): Promise<T> {
  let response = await send(url, init)
  if (response.status === 401 && !url.startsWith(ROTAS_DE_AUTENTICACAO) && (await unauthorizedHandler())) {
    response = await send(url, init)
  }

  const texto = await response.text()
  const corpo: unknown = texto.length > 0 && isJson(response) ? JSON.parse(texto) : undefined
  if (!response.ok) {
    const problem = corpo as ProblemDetails | undefined
    throw new HttpError(response.status, problem?.title ?? mensagemSemProblema(response.status), problem)
  }

  return corpo as T
}

/** Uma ida à API, com o token atual (que muda depois de uma renovação). */
async function send(url: string, init: RequestInit): Promise<Response> {
  const headers = new Headers(init.headers)
  headers.set('Accept', 'application/json')
  const token = tokenProvider()
  if (token && !headers.has('Authorization')) {
    headers.set('Authorization', `Bearer ${token}`)
  }

  try {
    return await fetch(url, { ...init, headers, credentials: 'same-origin' })
  } catch (error) {
    // Cancelamento (TanStack Query, troca de página) não é falha de rede. O sinal diz isso melhor que o tipo do
    // erro, que muda entre ambientes (DOMException do navegador ou do Node).
    if (init.signal?.aborted) {
      throw error
    }

    throw new HttpError(0, MENSAGEM_SEM_RESPOSTA, { detail: String(error) })
  }
}

/** 502 e 504 sem ProblemDetails vêm do proxy (Vite, nginx) quando a API está fora do ar, não da própria API. */
function mensagemSemProblema(status: number): string {
  return status === 502 || status === 504 ? MENSAGEM_SEM_RESPOSTA : `A API respondeu ${status}.`
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
