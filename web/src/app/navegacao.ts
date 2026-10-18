import { Boxes, FileUp, House, type LucideIcon, Package, Sparkles, Users, Warehouse } from 'lucide-react'

/** Item do menu principal. Sem rota, o item aparece desabilitado com "em breve" até a tarefa dele no plano. */
export interface ItemNavegacao {
  rotulo: string
  icone: LucideIcon
  para?: string
}

/** Seções do painel, na ordem do plano (SPEC, bloco 1.5). */
export const navegacao: ItemNavegacao[] = [
  { rotulo: 'Início', icone: House, para: '/' },
  { rotulo: 'Catálogo', icone: Package },
  { rotulo: 'Endereços', icone: Warehouse },
  { rotulo: 'Estoque', icone: Boxes },
  { rotulo: 'Importações', icone: FileUp },
  { rotulo: 'Uso de IA', icone: Sparkles },
  { rotulo: 'Usuários', icone: Users },
]
