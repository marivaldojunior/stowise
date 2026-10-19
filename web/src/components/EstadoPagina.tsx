import type { LucideIcon } from 'lucide-react'
import type { ReactNode } from 'react'
import { useTituloAba } from '@/lib/tituloAba'
import { cn } from '@/lib/utils'

interface Props {
  icone: LucideIcon
  titulo: string
  descricao: ReactNode
  acao?: ReactNode
  tom?: 'neutro' | 'perigo'
}

/** Página inteira de exceção (não encontrada, acesso negado, erro): ícone, título, explicação e uma saída. */
export function EstadoPagina({ icone: Icone, titulo, descricao, acao, tom = 'neutro' }: Props) {
  useTituloAba(titulo)

  return (
    <section className="mx-auto flex max-w-md flex-col items-center gap-3 py-16 text-center">
      <span
        className={cn(
          'flex size-12 items-center justify-center rounded-full',
          tom === 'perigo' ? 'bg-destructive/10 text-destructive' : 'bg-muted text-muted-foreground',
        )}
        aria-hidden
      >
        <Icone className="size-6" />
      </span>
      <h1 className="text-2xl font-semibold tracking-tight">{titulo}</h1>
      <p className="text-muted-foreground">{descricao}</p>
      {acao && <div className="mt-2">{acao}</div>}
    </section>
  )
}
