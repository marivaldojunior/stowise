import { useEffect, useState } from 'react'
import { useSearchParams } from 'react-router'

/** Valor dos selects para "sem filtro" (o Select do Radix não aceita valor vazio). */
export const TODOS = 'todos'

/** Espera depois da última tecla na busca, para não chamar a API a cada letra. */
const ESPERA_BUSCA_MS = 300

/**
 * Filtros de uma lista guardados na URL: a lista volta igual ao recarregar ou ao compartilhar o endereço.
 * Mudar um filtro volta para a primeira página.
 */
export function useFiltrosDaUrl() {
  const [params, setParams] = useSearchParams()

  function texto(nome: string): string | undefined {
    return params.get(nome) ?? undefined
  }

  function booleano(nome: string): boolean | undefined {
    const valor = params.get(nome)
    return valor === null ? undefined : valor === 'true'
  }

  function pagina(): number {
    return Number(params.get('pagina') ?? '1') || 1
  }

  /** Muda vários filtros numa só navegação (duas chamadas seguidas perderiam a primeira mudança). */
  function mudarVarios(valores: Record<string, string | undefined>) {
    setParams(
      (atuais) => {
        const novos = new URLSearchParams(atuais)
        for (const [nome, valor] of Object.entries(valores)) {
          if (valor === undefined || valor === '' || valor === TODOS) {
            novos.delete(nome)
          } else {
            novos.set(nome, valor)
          }
        }

        if (!('pagina' in valores)) {
          novos.delete('pagina')
        }

        return novos
      },
      { replace: true },
    )
  }

  function mudar(nome: string, valor: string | undefined) {
    mudarVarios({ [nome]: valor })
  }

  return { texto, booleano, pagina, mudar, mudarVarios }
}

/** Texto da busca na tela, aplicado ao filtro da URL depois da espera. */
export function useBusca(atual: string | undefined, aplicar: (valor: string) => void) {
  const [busca, setBusca] = useState(atual ?? '')

  useEffect(() => {
    if (busca.trim() === (atual ?? '')) {
      return
    }

    const timer = window.setTimeout(() => aplicar(busca.trim()), ESPERA_BUSCA_MS)
    return () => window.clearTimeout(timer)
  })

  return [busca, setBusca] as const
}

/** Total de páginas de uma lista paginada da API (pelo menos 1). */
export function totalDePaginas(lista: { total: number; tamanhoPagina: number } | undefined): number {
  return lista ? Math.max(Math.ceil(lista.total / lista.tamanhoPagina), 1) : 1
}
