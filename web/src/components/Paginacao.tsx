import { Button } from '@/components/ui/button'
import { totalDePaginas } from '@/lib/filtrosDaUrl'

interface Props {
  lista: { total: number; pagina: number; tamanhoPagina: number } | undefined
  /** Nome do item no plural, para o resumo (ex.: "usuário(s)"). */
  rotulo: string
  onPagina: (pagina: number) => void
}

/** Resumo da lista e botões Anterior e Próxima. */
export function Paginacao({ lista, rotulo, onPagina }: Props) {
  const pagina = lista?.pagina ?? 1
  const total = totalDePaginas(lista)

  return (
    <nav aria-label="Paginação" className="flex items-center justify-between gap-2 text-sm">
      <span className="text-muted-foreground">
        {lista ? `${lista.total} ${rotulo} · página ${pagina} de ${total}` : ''}
      </span>
      <span className="flex gap-2">
        <Button variant="outline" size="sm" disabled={pagina <= 1} onClick={() => onPagina(pagina - 1)}>
          Anterior
        </Button>
        <Button variant="outline" size="sm" disabled={pagina >= total} onClick={() => onPagina(pagina + 1)}>
          Próxima
        </Button>
      </span>
    </nav>
  )
}
