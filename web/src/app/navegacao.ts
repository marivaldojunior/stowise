import { Boxes, FileUp, House, type LucideIcon, Package, Sparkles, Users, Warehouse } from 'lucide-react'
import { PERFIS_GESTAO, type Perfil, Perfis } from '@/features/auth/contexto'

/** Item do menu principal. Sem rota, o item aparece desabilitado com "em breve" até a tarefa dele no plano. */
export interface ItemNavegacao {
  rotulo: string
  icone: LucideIcon
  para?: string
  /** Perfis que veem o item (os mesmos que a API exige). Sem perfis, todo usuário com sessão vê. */
  perfis?: readonly Perfil[]
}

/** Seções do painel, na ordem do plano (SPEC, bloco 1.5). */
export const navegacao: ItemNavegacao[] = [
  { rotulo: 'Início', icone: House, para: '/' },
  { rotulo: 'Catálogo', icone: Package, para: '/catalogo' },
  { rotulo: 'Endereços', icone: Warehouse, para: '/enderecos' },
  { rotulo: 'Estoque', icone: Boxes, para: '/estoque' },
  { rotulo: 'Importações', icone: FileUp, perfis: PERFIS_GESTAO },
  { rotulo: 'Uso de IA', icone: Sparkles, perfis: [Perfis.Admin] },
  { rotulo: 'Usuários', icone: Users, para: '/usuarios', perfis: [Perfis.Admin] },
]
