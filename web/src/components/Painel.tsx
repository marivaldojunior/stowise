import { type ReactNode, useId } from 'react'
import { cn } from '@/lib/utils'

interface Props {
  titulo: string
  descricao?: ReactNode
  /** Botões à direita do título. */
  acoes?: ReactNode
  children: ReactNode
  className?: string
}

/** Seção em card, com título (h2) que também dá o nome da região para o leitor de tela. */
export function Painel({ titulo, descricao, acoes, children, className }: Props) {
  const id = useId()
  return (
    <section aria-labelledby={id} className={cn('flex min-w-0 flex-col gap-4 rounded-2xl border border-border/70 bg-card p-4 sombra-cartao sm:p-5', className)}>
      <div className="flex flex-wrap items-start justify-between gap-2">
        <div className="flex flex-col gap-0.5">
          <h2 id={id} className="flex items-center gap-2 text-base font-semibold">
            <span className="h-4 w-1 rounded-full bg-grade-marca" aria-hidden />
            {titulo}
          </h2>
          {descricao && <p className="text-sm text-muted-foreground">{descricao}</p>}
        </div>
        {acoes && <div className="flex flex-wrap gap-2">{acoes}</div>}
      </div>
      {children}
    </section>
  )
}
