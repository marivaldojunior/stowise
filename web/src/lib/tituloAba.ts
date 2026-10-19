import { useEffect } from 'react'

/** Título da aba: "Página · Stowise". */
export function useTituloAba(titulo: string | undefined) {
  useEffect(() => {
    document.title = titulo ? `${titulo} · Stowise` : 'Stowise'
  }, [titulo])
}
