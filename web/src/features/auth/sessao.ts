import { renovarSessao } from '@/api/gerado/stowise'
import type { AuthResponse, UsuarioResumo } from '@/api/gerado/modelos'
import { HttpError, setTokenProvider, setUnauthorizedHandler } from '@/api/mutator'

/**
 * Sessão do painel (ADR-0005). O token de acesso fica só em memória: nunca em localStorage, onde um script injetado
 * conseguiria ler. O refresh token fica no cookie HttpOnly da API (`useCookie`), que o JavaScript não acessa.
 */
export interface Sessao {
  accessToken: string
  /** Vencimento do token de acesso, em milissegundos (Date.now). */
  expiraEm: number
  usuario: UsuarioResumo
}

let atual: Sessao | null = null
const ouvintes = new Set<() => void>()

export function getSessao(): Sessao | null {
  return atual
}

export function subscribeSessao(ouvinte: () => void): () => void {
  ouvintes.add(ouvinte)
  return () => ouvintes.delete(ouvinte)
}

export function setSessao(resposta: AuthResponse) {
  atual = {
    accessToken: resposta.accessToken,
    expiraEm: Date.parse(resposta.accessTokenExpiresAt),
    usuario: resposta.usuario,
  }
  ouvintes.forEach((ouvinte) => ouvinte())
}

export function limparSessao() {
  if (atual !== null) {
    atual = null
    ouvintes.forEach((ouvinte) => ouvinte())
  }
}

/** Renova o token de acesso este tempo antes de ele vencer, para as telas não receberem 401 no meio do uso. */
const ANTECEDENCIA_RENOVACAO_MS = 60_000
/** Espera mínima, para um relógio adiantado no computador não gerar renovações em sequência. */
const ESPERA_MINIMA_MS = 5_000

/** Tempo até a próxima renovação automática da sessão. */
export function esperaAteRenovar(sessao: Sessao, agora = Date.now()): number {
  return Math.max(sessao.expiraEm - agora - ANTECEDENCIA_RENOVACAO_MS, ESPERA_MINIMA_MS)
}

let renovacao: Promise<boolean> | null = null

/**
 * Pede um token novo com o cookie de refresh. Pedidos simultâneos (vários 401 ao mesmo tempo) dividem a mesma
 * chamada, porque a API gira o refresh token e um segundo uso derrubaria a sessão (detecção de reuso).
 * Sessão recusada (4xx) é encerrada; API fora do ar (sem resposta ou 5xx) mantém a sessão para a próxima tentativa.
 */
export function renovar(): Promise<boolean> {
  renovacao ??= renovarSessao({ refreshToken: null, useCookie: true })
    .then((resposta) => {
      setSessao(resposta)
      return true
    })
    .catch((erro: unknown) => {
      const apiForaDoAr = erro instanceof HttpError && (erro.status === 0 || erro.status >= 500)
      if (!apiForaDoAr) {
        limparSessao()
      }

      return false
    })
    .finally(() => {
      renovacao = null
    })

  return renovacao
}

setTokenProvider(() => atual?.accessToken)
setUnauthorizedHandler(renovar)
