import type { ComponentProps } from 'react'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

type Props = ComponentProps<typeof Input> & { id: string; rotulo: string; erro?: string }

/** Campo de texto com rótulo e erro ligado por aria-describedby. */
export function Campo({ id, rotulo, erro, ...props }: Props) {
  return (
    <div className="flex flex-col gap-2">
      <Label htmlFor={id}>{rotulo}</Label>
      <Input
        id={id}
        aria-invalid={erro ? true : undefined}
        aria-describedby={erro ? `${id}-erro` : undefined}
        {...props}
      />
      {erro && (
        <p id={`${id}-erro`} className="text-sm text-destructive">
          {erro}
        </p>
      )}
    </div>
  )
}
