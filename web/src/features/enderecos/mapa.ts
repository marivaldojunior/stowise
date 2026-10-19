import { useQuery } from '@tanstack/react-query'
import { listarEnderecos } from '@/api/gerado/stowise'
import type { EnderecoDetalhe, StatusEndereco } from '@/api/gerado/modelos'
import type { Tom } from '@/components/Situacao'

/** Maior página que a API aceita (Paging.MaxPageSize). */
const TAMANHO_PAGINA_MAPA = 100

export const ROTULO_STATUS: Record<StatusEndereco, string> = {
  Livre: 'Livre',
  Ocupado: 'Ocupado',
  Bloqueado: 'Bloqueado',
}

/** Cor de cada situação no mapa (tokens do tema, funcionam no claro e no escuro). */
export const COR_STATUS: Record<StatusEndereco, string> = {
  Livre: 'bg-success/20 ring-1 ring-inset ring-success/40 hover:bg-success/35',
  Ocupado: 'bg-primary hover:bg-primary/80',
  Bloqueado: 'bg-destructive/80 hover:bg-destructive',
}

export const TOM_STATUS: Record<StatusEndereco, Tom> = {
  Livre: 'sucesso',
  Ocupado: 'marca',
  Bloqueado: 'perigo',
}

export function getMapaEnderecosQueryKey(zonaId: string) {
  return ['mapa-enderecos', zonaId] as const
}

/** Todos os endereços de uma zona, lidos página a página (a API pagina em até 100). */
export function useMapaEnderecos(zonaId: string | undefined) {
  return useQuery({
    queryKey: getMapaEnderecosQueryKey(zonaId ?? ''),
    enabled: Boolean(zonaId),
    queryFn: async ({ signal }) => {
      const todos: EnderecoDetalhe[] = []
      for (let pagina = 1; ; pagina += 1) {
        const resultado = await listarEnderecos(
          { zonaId, pagina, tamanhoPagina: TAMANHO_PAGINA_MAPA },
          { signal },
        )
        todos.push(...resultado.itens)
        if (todos.length >= resultado.total || resultado.itens.length === 0) {
          return todos
        }
      }
    },
  })
}

export interface Rua {
  rua: string
  /** Níveis do mais alto para o mais baixo, como o porta-palete é visto de frente. */
  niveis: { nivel: number; modulos: { modulo: number; enderecos: EnderecoDetalhe[] }[] }[]
}

/** Agrupa os endereços por rua, nível e módulo, com as posições em ordem. */
export function agruparPorRua(enderecos: EnderecoDetalhe[]): Rua[] {
  const ruas = new Map<string, Map<number, Map<number, EnderecoDetalhe[]>>>()
  for (const endereco of enderecos) {
    const niveis = ruas.get(endereco.rua) ?? new Map<number, Map<number, EnderecoDetalhe[]>>()
    const modulos = niveis.get(endereco.nivel) ?? new Map<number, EnderecoDetalhe[]>()
    modulos.set(endereco.modulo, [...(modulos.get(endereco.modulo) ?? []), endereco])
    niveis.set(endereco.nivel, modulos)
    ruas.set(endereco.rua, niveis)
  }

  return [...ruas.entries()]
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([rua, niveis]) => ({
      rua,
      niveis: [...niveis.entries()]
        .sort(([a], [b]) => b - a)
        .map(([nivel, modulos]) => ({
          nivel,
          modulos: [...modulos.entries()]
            .sort(([a], [b]) => a - b)
            .map(([modulo, lista]) => ({ modulo, enderecos: lista.sort((a, b) => a.posicao - b.posicao) })),
        })),
    }))
}

export interface ResumoOcupacao {
  total: number
  porStatus: Record<StatusEndereco, number>
  /** Ocupados sobre os endereços que podem receber (livres + ocupados), em %. */
  ocupacao: number
}

export function resumir(enderecos: EnderecoDetalhe[]): ResumoOcupacao {
  const porStatus: Record<StatusEndereco, number> = { Livre: 0, Ocupado: 0, Bloqueado: 0 }
  for (const endereco of enderecos) {
    porStatus[endereco.status] += 1
  }

  const utilizaveis = porStatus.Livre + porStatus.Ocupado
  return {
    total: enderecos.length,
    porStatus,
    ocupacao: utilizaveis === 0 ? 0 : Math.round((porStatus.Ocupado / utilizaveis) * 100),
  }
}
