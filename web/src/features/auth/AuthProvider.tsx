import { useQueryClient } from '@tanstack/react-query'
import { type ReactNode, useCallback, useEffect, useMemo, useRef, useState, useSyncExternalStore } from 'react'
import { toast } from 'sonner'
import { login, logout } from '@/api/gerado/stowise'
import { type ContextoAuth, ContextoDaAuth } from './contexto'
import { esperaAteRenovar, getSessao, limparSessao, renovar, setSessao, subscribeSessao } from './sessao'

/**
 * Sessão do painel: retoma pelo cookie ao abrir, renova o token antes de vencer e encerra no "Sair". Quando a
 * sessão cai sozinha (refresh recusado), avisa e as rotas protegidas levam ao login.
 */
export function AuthProvider({ children }: { children: ReactNode }) {
  const queryClient = useQueryClient()
  const sessao = useSyncExternalStore(subscribeSessao, getSessao)
  const [verificando, setVerificando] = useState(() => getSessao() === null)
  const saindo = useRef(false)
  const tinhaSessao = useRef(sessao !== null)

  // Ao abrir o painel, o cookie HttpOnly de refresh (se houver) devolve a sessão sem pedir a senha de novo.
  useEffect(() => {
    if (!verificando) {
      return
    }

    let ativo = true
    void renovar().finally(() => {
      if (ativo) {
        setVerificando(false)
      }
    })
    return () => {
      ativo = false
    }
  }, [verificando])

  // Renovação antes do vencimento. Cada sessão nova (token renovado) agenda a seguinte.
  useEffect(() => {
    if (!sessao) {
      return
    }

    const timer = window.setTimeout(() => void renovar(), esperaAteRenovar(sessao))
    return () => window.clearTimeout(timer)
  }, [sessao])

  // Sessão que caiu sem o usuário pedir: avisa e limpa o cache de dados do usuário anterior.
  useEffect(() => {
    if (tinhaSessao.current && sessao === null) {
      queryClient.clear()
      if (!saindo.current) {
        toast.warning('Sua sessão expirou. Entre novamente.')
      }

      saindo.current = false
    }

    tinhaSessao.current = sessao !== null
  }, [sessao, queryClient])

  const entrar = useCallback(async (email: string, senha: string) => {
    setSessao(await login({ email, senha, useCookie: true }))
  }, [])

  const sair = useCallback(async () => {
    saindo.current = true
    try {
      await logout({ refreshToken: null, useCookie: true })
    } catch {
      // Mesmo sem resposta da API, a sessão local termina; o refresh token expira sozinho.
    }

    limparSessao()
  }, [])

  const valor = useMemo<ContextoAuth>(
    () => ({
      status: verificando ? 'verificando' : sessao ? 'autenticado' : 'anonimo',
      usuario: sessao?.usuario ?? null,
      entrar,
      sair,
      temPerfil: (...perfis) => perfis.some((perfil) => sessao?.usuario.perfis.includes(perfil) ?? false),
    }),
    [verificando, sessao, entrar, sair],
  )

  return <ContextoDaAuth.Provider value={valor}>{children}</ContextoDaAuth.Provider>
}
