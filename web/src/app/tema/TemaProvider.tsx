import { type ReactNode, useCallback, useEffect, useMemo, useState } from 'react'
import { CHAVE_TEMA, ContextoDoTema, type Tema } from './contexto'

const consultaEscuro = '(prefers-color-scheme: dark)'

function lerTema(): Tema {
  try {
    const salvo = localStorage.getItem(CHAVE_TEMA)
    return salvo === 'light' || salvo === 'dark' ? salvo : 'system'
  } catch {
    return 'system'
  }
}

function sistemaEscuro() {
  return window.matchMedia(consultaEscuro).matches
}

/** Tema claro, escuro ou do sistema, aplicado pela classe `dark` no `<html>` (o modo dark do shadcn/ui). */
export function TemaProvider({ children }: { children: ReactNode }) {
  const [tema, setTemaEstado] = useState<Tema>(lerTema)
  const [escuroNoSistema, setEscuroNoSistema] = useState(sistemaEscuro)

  useEffect(() => {
    const consulta = window.matchMedia(consultaEscuro)
    const mudou = () => setEscuroNoSistema(consulta.matches)
    consulta.addEventListener('change', mudou)
    return () => consulta.removeEventListener('change', mudou)
  }, [])

  const temaAplicado = tema === 'system' ? (escuroNoSistema ? 'dark' : 'light') : tema

  useEffect(() => {
    document.documentElement.classList.toggle('dark', temaAplicado === 'dark')
    document.documentElement.style.colorScheme = temaAplicado
  }, [temaAplicado])

  const setTema = useCallback((novo: Tema) => {
    setTemaEstado(novo)
    try {
      localStorage.setItem(CHAVE_TEMA, novo)
    } catch {
      // Sem armazenamento (modo privado): o tema vale só nesta aba.
    }
  }, [])

  const valor = useMemo(() => ({ tema, temaAplicado, setTema }), [tema, temaAplicado, setTema])
  return <ContextoDoTema.Provider value={valor}>{children}</ContextoDoTema.Provider>
}
