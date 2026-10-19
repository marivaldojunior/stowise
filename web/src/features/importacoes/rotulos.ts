import type { AcaoLinha, StatusImportacao, StatusLinha } from '@/api/gerado/modelos'
import type { Tom } from '@/components/Situacao'

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

/** Aguardando você = aviso; job trabalhando = info. */
export const TOM_STATUS_IMPORTACAO: Record<StatusImportacao, Tom> = {
  Recebido: 'neutro',
  Mapeando: 'info',
  AguardandoConfirmacao: 'aviso',
  Validando: 'info',
  AguardandoRevisao: 'aviso',
  Efetivando: 'info',
  Concluido: 'sucesso',
  Falhou: 'perigo',
}

export const TOM_STATUS_LINHA: Record<StatusLinha, Tom> = {
  Valida: 'sucesso',
  Erro: 'perigo',
  PossivelDuplicata: 'aviso',
  Ignorada: 'neutro',
}

/** Nomes dos campos de produto para a tela (a API usa os nomes do código). */
const ROTULO_CAMPO: Record<string, string> = {
  sku: 'SKU',
  descricao: 'Descrição',
  unidadeBase: 'Unidade base',
  gtin: 'GTIN (código de barras)',
  ncm: 'NCM',
  cest: 'CEST',
  categoria: 'Categoria',
  classeArmazenagem: 'Classe de armazenagem',
  controlaLote: 'Controla lote',
  controlaValidade: 'Controla validade',
  pesoKg: 'Peso (kg)',
  alturaCm: 'Altura (cm)',
  larguraCm: 'Largura (cm)',
  comprimentoCm: 'Comprimento (cm)',
}

export function rotuloCampo(campo: string): string {
  return ROTULO_CAMPO[campo] ?? campo
}
