import { createContext, useContext } from 'react'
import type { UsuarioResumo } from '@/api/gerado/modelos'

/** Perfis de acesso (ADR-0005). Os nomes são os mesmos da API. */
export const Perfis = {
  Admin: 'Admin',
  Gestor: 'Gestor',
  Operador: 'Operador',
} as const

export type Perfil = (typeof Perfis)[keyof typeof Perfis]

/** Política "Gestao" da API: escritas de cadastro e importação. */
export const PERFIS_GESTAO: readonly Perfil[] = [Perfis.Admin, Perfis.Gestor]

export interface ContextoAuth {
  /** `verificando`: o painel acabou de abrir e tenta retomar a sessão pelo cookie. */
  status: 'verificando' | 'autenticado' | 'anonimo'
  usuario: UsuarioResumo | null
  entrar: (email: string, senha: string) => Promise<void>
  sair: () => Promise<void>
  /** Verdadeiro se o usuário tem pelo menos um dos perfis. */
  temPerfil: (...perfis: readonly string[]) => boolean
}

export const ContextoDaAuth = createContext<ContextoAuth | null>(null)

export function useAuth(): ContextoAuth {
  const contexto = useContext(ContextoDaAuth)
  if (!contexto) {
    throw new Error('useAuth precisa do AuthProvider.')
  }

  return contexto
}
