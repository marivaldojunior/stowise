import { createContext, useContext } from 'react'

export type Tema = 'light' | 'dark' | 'system'

/** Chave da escolha no localStorage. O script do index.html lê a mesma chave antes do React, para a tela não piscar. */
export const CHAVE_TEMA = 'stowise-tema'

export interface ContextoTema {
  /** O que a pessoa escolheu. */
  tema: Tema
  /** O que está na tela (o sistema já resolvido em claro ou escuro). */
  temaAplicado: 'light' | 'dark'
  setTema: (tema: Tema) => void
}

export const ContextoDoTema = createContext<ContextoTema | null>(null)

export function useTema(): ContextoTema {
  const contexto = useContext(ContextoDoTema)
  if (!contexto) {
    throw new Error('useTema precisa do TemaProvider.')
  }

  return contexto
}
