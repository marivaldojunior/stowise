import type { ReactNode } from 'react'
import { cn } from '@/lib/utils'

/**
 * Tom de uma situação, sempre com o mesmo sentido em todo o painel:
 * sucesso (ativo, livre, válida, concluído), aviso (reservado, duplicata, aguardando você), perigo (bloqueado, erro,
 * falhou), info (em andamento), marca (destaque neutro) e neutro (inativo, ignorado).
 */
export type Tom = 'sucesso' | 'aviso' | 'perigo' | 'info' | 'marca' | 'neutro'

const CORES: Record<Tom, string> = {
  sucesso: 'bg-success/12 text-success ring-success/25',
  aviso: 'bg-warning/12 text-warning ring-warning/30',
  perigo: 'bg-destructive/10 text-destructive ring-destructive/25',
  info: 'bg-info/12 text-info ring-info/25',
  marca: 'bg-primary/12 text-primary ring-primary/25',
  neutro: 'bg-muted text-muted-foreground ring-border',
}

/** Selo de situação (status) com cor pelo sentido, e não pela tela. */
export function Situacao({ tom, children, className }: { tom: Tom; children: ReactNode; className?: string }) {
  return (
    <span
      className={cn(
        'inline-flex h-5 shrink-0 items-center gap-1 rounded-full px-2 text-xs font-medium whitespace-nowrap ring-1 ring-inset',
        CORES[tom],
        className,
      )}
    >
      {children}
    </span>
  )
}
