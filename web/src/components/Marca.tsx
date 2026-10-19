import { Boxes } from 'lucide-react'
import { cn } from '@/lib/utils'

/**
 * Logotipo: o símbolo em degradê da marca e o nome com "wise" (inteligente) na cor da IA. O nome junta "stow"
 * (armazenar) e "wise", que dividem o mesmo "w".
 */
export function Marca({ className }: { className?: string }) {
  return (
    <span className={cn('flex items-center gap-2', className)}>
      <span
        className="relative flex size-8 items-center justify-center rounded-xl bg-grade-marca text-primary-foreground brilho-marca"
        aria-hidden
      >
        <Boxes className="size-4" />
        <span className="absolute -right-0.5 -bottom-0.5 size-2.5 rounded-full border-2 border-[color:var(--sidebar,var(--background))] bg-sinal" />
      </span>
      <span className="text-lg font-semibold tracking-tight">
        Sto<span className="texto-grade-ia">wise</span>
      </span>
    </span>
  )
}
