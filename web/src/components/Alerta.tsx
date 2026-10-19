import { CircleAlert, Info, Sparkles, TriangleAlert } from 'lucide-react'
import type { ReactNode } from 'react'
import { cn } from '@/lib/utils'

type TomAlerta = 'erro' | 'aviso' | 'info' | 'ia'

const ESTILO: Record<TomAlerta, { classe: string; Icone: typeof Info }> = {
  erro: { classe: 'border-destructive/40 bg-destructive/5 [&>svg]:text-destructive', Icone: CircleAlert },
  aviso: { classe: 'border-warning/40 bg-warning/5 [&>svg]:text-warning', Icone: TriangleAlert },
  info: { classe: 'border-info/30 bg-info/5 [&>svg]:text-info', Icone: Info },
  ia: { classe: 'border-primary/30 bg-primary/5 [&>svg]:text-primary', Icone: Sparkles },
}

interface Props {
  tom: TomAlerta
  children: ReactNode
  /** Botão ou link à direita (ex.: "Carregar a versão atual"). */
  acao?: ReactNode
  className?: string
}

/**
 * Mensagem em destaque. Erro e aviso usam role="alert" (o leitor de tela anuncia); info e IA são texto comum.
 * Mensagens de erro curtas de campo ficam no próprio campo, não aqui.
 */
export function Alerta({ tom, children, acao, className }: Props) {
  const { classe, Icone } = ESTILO[tom]
  return (
    <div
      role={tom === 'erro' || tom === 'aviso' ? 'alert' : undefined}
      className={cn('flex items-start gap-3 rounded-lg border p-3 text-sm', classe, className)}
    >
      <Icone className="mt-0.5 size-4 shrink-0" aria-hidden />
      <div className="flex-1">{children}</div>
      {acao && <div className="shrink-0">{acao}</div>}
    </div>
  )
}

/** Erro curto embaixo de um formulário ou de uma ação. */
export function MensagemErro({ children }: { children: ReactNode }) {
  return (
    <p role="alert" className="flex items-center gap-1.5 text-sm text-destructive">
      <CircleAlert className="size-3.5 shrink-0" aria-hidden />
      {children}
    </p>
  )
}
