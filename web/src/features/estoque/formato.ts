import type { ExtratoItem, TipoMovimentacao } from '@/api/gerado/modelos'

export const ROTULO_MOVIMENTACAO: Record<TipoMovimentacao, string> = {
  Entrada: 'Entrada',
  Saida: 'Saída',
  Transferencia: 'Transferência',
  Ajuste: 'Ajuste',
}

/** Data (sem hora) no formato brasileiro. Validade e datas só de dia vêm como "AAAA-MM-DD". */
export function formatarData(valor: string | null | undefined): string {
  if (!valor) {
    return '—'
  }

  const [ano, mes, dia] = valor.slice(0, 10).split('-')
  return `${dia}/${mes}/${ano}`
}

export function formatarDataHora(valor: string): string {
  return new Date(valor).toLocaleString('pt-BR', { dateStyle: 'short', timeStyle: 'short' })
}

/**
 * Sentido da movimentação, pelos endereços: só destino é entrada no estoque (+), só origem é saída (−) e os dois
 * juntos são transferência (o total não muda).
 */
export function sinal(item: Pick<ExtratoItem, 'enderecoOrigemCodigo' | 'enderecoDestinoCodigo'>): '+' | '−' | '↔' {
  if (item.enderecoOrigemCodigo && item.enderecoDestinoCodigo) {
    return '↔'
  }

  return item.enderecoDestinoCodigo ? '+' : '−'
}

/**
 * Início ou fim de um dia (data do input "AAAA-MM-DD") no fuso do navegador, em ISO, para o filtro de período.
 * O fim é o último milissegundo do dia, para o dia final entrar inteiro.
 */
export function limiteDoDia(data: string, fim: boolean): string {
  const [ano, mes, dia] = data.split('-').map(Number)
  const limite = fim ? new Date(ano, mes - 1, dia, 23, 59, 59, 999) : new Date(ano, mes - 1, dia)
  return limite.toISOString()
}
