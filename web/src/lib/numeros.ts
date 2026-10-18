/** Número digitado com vírgula ou ponto decimal. Vazio vira null; texto que não é número vira NaN. */
export function lerNumero(valor: string): number | null {
  const limpo = valor.trim().replace(',', '.')
  return limpo === '' ? null : Number(limpo)
}

/** Número para a tela, no formato brasileiro. Null vira travessão. */
export function formatarNumero(valor: number | null | undefined, sufixo = ''): string {
  return valor === null || valor === undefined ? '—' : `${valor.toLocaleString('pt-BR')}${sufixo ? ` ${sufixo}` : ''}`
}
