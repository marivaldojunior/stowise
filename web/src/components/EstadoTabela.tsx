import { Inbox } from 'lucide-react'
import { Skeleton } from '@/components/ui/skeleton'
import { TableCell, TableRow } from '@/components/ui/table'

const LINHAS_ESQUELETO = 3

/** Linhas de carregamento de uma tabela, no formato das linhas reais. */
export function LinhasCarregando({ colunas, rotulo }: { colunas: number; rotulo: string }) {
  return (
    <>
      {Array.from({ length: LINHAS_ESQUELETO }, (_, indice) => (
        <TableRow key={indice} className="hover:bg-transparent">
          <TableCell colSpan={colunas}>
            <Skeleton
              className="h-5 w-full"
              {...(indice === 0 ? { role: 'status', 'aria-label': rotulo } : { 'aria-hidden': true })}
            />
          </TableCell>
        </TableRow>
      ))}
    </>
  )
}

/** Tabela sem itens: ícone e texto curto, com uma dica do que fazer. */
export function LinhaVazia({ colunas, texto, dica }: { colunas: number; texto: string; dica?: string }) {
  return (
    <TableRow className="hover:bg-transparent">
      <TableCell colSpan={colunas} className="py-10">
        <div className="flex flex-col items-center gap-1 text-center text-muted-foreground">
          <Inbox className="mb-1 size-6" aria-hidden />
          <span className="text-sm font-medium text-foreground">{texto}</span>
          {dica && <span className="text-xs">{dica}</span>}
        </div>
      </TableCell>
    </TableRow>
  )
}
