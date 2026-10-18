import type { Falha } from '@/api/falha'
import type { EnderecoDetalhe } from '@/api/gerado/modelos'
import { lerNumero } from '@/lib/numeros'

/** Texto dos campos numéricos de um formulário (vazio = não informado). */
export type Textos<K extends string> = Record<K, string>

export const CAMPOS_DIMENSOES = [
  ['capacidadePesoKg', 'Capacidade (kg)'],
  ['alturaCm', 'Altura (cm)'],
  ['larguraCm', 'Largura (cm)'],
  ['profundidadeCm', 'Profundidade (cm)'],
] as const

export type CampoDimensao = (typeof CAMPOS_DIMENSOES)[number][0]

export function textosDe<K extends string>(nomes: readonly K[], origem?: Partial<Record<K, number | null>>): Textos<K> {
  return Object.fromEntries(
    nomes.map((nome) => {
      const valor = origem?.[nome]
      return [nome, valor === null || valor === undefined ? '' : String(valor).replace('.', ',')]
    }),
  ) as Textos<K>
}

export function dimensoesDe(endereco: EnderecoDetalhe) {
  return textosDe(['capacidadePesoKg', 'alturaCm', 'larguraCm', 'profundidadeCm', 'distanciaExpedicao'], endereco)
}

/**
 * Converte os textos em números para a API. Texto que não é número vira erro de campo, no formato da API, sem chamar
 * a API; vazio vai como null e a API diz se o campo é obrigatório.
 */
export function numerosDe<K extends string>(textos: Textos<K>): Record<K, number | null> | Falha {
  const campos: Record<string, string[]> = {}
  const numeros = {} as Record<K, number | null>
  for (const nome of Object.keys(textos) as K[]) {
    const numero = lerNumero(textos[nome])
    if (numero !== null && (Number.isNaN(numero) || numero < 0)) {
      campos[nome] = ['Informe um número (zero ou mais).']
    }

    numeros[nome] = numero
  }

  return Object.keys(campos).length > 0 ? { mensagem: 'Confira os campos destacados.', campos } : numeros
}

export function ehFalha(valor: object): valor is Falha {
  return 'mensagem' in valor && 'campos' in valor
}
