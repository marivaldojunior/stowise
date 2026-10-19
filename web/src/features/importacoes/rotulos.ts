import type { AcaoLinha, StatusImportacao, StatusLinha } from '@/api/gerado/modelos'

export const ROTULO_STATUS_IMPORTACAO: Record<StatusImportacao, string> = {
  Recebido: 'Recebido',
  Mapeando: 'IA sugerindo o mapeamento',
  AguardandoConfirmacao: 'Aguardando confirmação',
  Validando: 'Validando',
  AguardandoRevisao: 'Aguardando revisão',
  Efetivando: 'Efetivando',
  Concluido: 'Concluído',
  Falhou: 'Falhou',
}

export const ROTULO_STATUS_LINHA: Record<StatusLinha, string> = {
  Valida: 'Válida',
  Erro: 'Com erro',
  PossivelDuplicata: 'Possível duplicata',
  Ignorada: 'Ignorada',
}

export const ROTULO_ACAO_LINHA: Record<AcaoLinha, string> = {
  Criar: 'Criar',
  Atualizar: 'Atualizar',
  Ignorar: 'Ignorar',
}

/** Status em que um job trabalha na importação: a tela acompanha o progresso. */
export const STATUS_EM_ANDAMENTO: readonly StatusImportacao[] = ['Mapeando', 'Validando', 'Efetivando']

export function emAndamento(status: StatusImportacao): boolean {
  return STATUS_EM_ANDAMENTO.includes(status)
}

/** Etapas do fluxo, na ordem, para o indicador de passos. */
export const ETAPAS = [
  { rotulo: 'Mapeamento', status: ['Recebido', 'Mapeando', 'AguardandoConfirmacao'] },
  { rotulo: 'Validação', status: ['Validando'] },
  { rotulo: 'Revisão', status: ['AguardandoRevisao'] },
  { rotulo: 'Efetivação', status: ['Efetivando', 'Concluido'] },
] as const satisfies readonly { rotulo: string; status: readonly StatusImportacao[] }[]
