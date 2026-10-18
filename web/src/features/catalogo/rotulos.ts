import type { ClasseArmazenagem, TipoEmbalagem } from '@/api/gerado/modelos'

/** Nomes das classes de armazenagem para a tela (a API usa os nomes sem acento). */
export const ROTULO_CLASSE: Record<ClasseArmazenagem, string> = {
  Normal: 'Normal',
  Refrigerado: 'Refrigerado',
  Inflamavel: 'Inflamável',
  Fragil: 'Frágil',
}

export const ROTULO_EMBALAGEM: Record<TipoEmbalagem, string> = {
  Unidade: 'Unidade',
  Caixa: 'Caixa',
  Palete: 'Palete',
}
