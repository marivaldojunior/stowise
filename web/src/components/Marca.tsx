import { Boxes } from 'lucide-react'
import { cn } from '@/lib/utils'

/** Logotipo: símbolo na cor da marca e o nome. */
export function Marca({ className }: { className?: string }) {
  return (
    <span className={cn('flex items-center gap-2', className)}>
      <span className="flex size-7 items-center justify-center rounded-lg bg-primary text-primary-foreground" aria-hidden>
        <Boxes className="size-4" />
      </span>
      <span className="text-base font-semibold tracking-tight">Stowise</span>
    </span>
  )
}
