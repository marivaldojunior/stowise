import type { EmbalagemDetalhe, EmbalagemMedidas } from '@/api/gerado/modelos'
import type { Falha } from '@/api/falha'

/** Medidas de uma embalagem como texto dos campos (vazio = não informado). */
export interface MedidasTexto {
  gtin: string
  pesoKg: string
  alturaCm: string
  larguraCm: string
  comprimentoCm: string
}

export const MEDIDAS_VAZIAS: MedidasTexto = { gtin: '', pesoKg: '', alturaCm: '', larguraCm: '', comprimentoCm: '' }

const NUMERICOS = ['pesoKg', 'alturaCm', 'larguraCm', 'comprimentoCm'] as const

function texto(valor: number | null): string {
  return valor === null ? '' : String(valor).replace('.', ',')
}

export function medidasDe(embalagem: EmbalagemDetalhe): MedidasTexto {
  return {
    gtin: embalagem.gtin ?? '',
    pesoKg: texto(embalagem.pesoKg),
    alturaCm: texto(embalagem.alturaCm),
    larguraCm: texto(embalagem.larguraCm),
    comprimentoCm: texto(embalagem.comprimentoCm),
  }
}

/** Número digitado com vírgula ou ponto decimal. Vazio vira null; texto que não é número vira NaN. */
export function lerNumero(valor: string): number | null {
  const limpo = valor.trim().replace(',', '.')
  return limpo === '' ? null : Number(limpo)
}

/**
 * Converte as medidas para a API. Campo numérico inválido volta como erro de campo, no mesmo formato da API, para a
 * tela mostrar sem chamar a API. `prefixo` é o caminho do campo na API (ex.: "embalagemBase.").
 */
export function medidasParaApi(medidas: MedidasTexto, prefixo = ''): EmbalagemMedidas | Falha {
  const campos: Record<string, string[]> = {}
  const numeros: Partial<Record<(typeof NUMERICOS)[number], number | null>> = {}
  for (const nome of NUMERICOS) {
    const numero = lerNumero(medidas[nome])
    if (numero !== null && (Number.isNaN(numero) || numero <= 0)) {
      campos[prefixo + nome] = ['Informe um número maior que zero.']
    }

    numeros[nome] = numero
  }

  if (Object.keys(campos).length > 0) {
    return { mensagem: 'Confira os campos destacados.', campos }
  }

  return {
    gtin: medidas.gtin.trim() || null,
    pesoKg: numeros.pesoKg ?? null,
    alturaCm: numeros.alturaCm ?? null,
    larguraCm: numeros.larguraCm ?? null,
    comprimentoCm: numeros.comprimentoCm ?? null,
  }
}

export function ehFalha(valor: object): valor is Falha {
  return 'mensagem' in valor && 'campos' in valor
}
