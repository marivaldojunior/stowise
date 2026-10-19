import { ArrowLeft } from 'lucide-react'
import type { ReactNode } from 'react'
import { Link } from 'react-router'
import { Button } from '@/components/ui/button'
import { useTituloAba } from '@/lib/tituloAba'

interface Props {
  titulo: ReactNode
  /** Texto do título da aba do navegador, quando o título tem elementos (ex.: com selo). */
  tituloAba?: string
  descricao?: ReactNode
  /** Botões à direita do título. */
  acoes?: ReactNode
  voltar?: { para: string; rotulo: string }
}

/** Cabeçalho padrão das páginas: voltar, título, descrição e ações. Também define o título da aba. */
export function CabecalhoPagina({ titulo, tituloAba, descricao, acoes, voltar }: Props) {
  useTituloAba(tituloAba ?? (typeof titulo === 'string' ? titulo : undefined))

  return (
    <header className="flex flex-col gap-3">
      {voltar && (
        <Button variant="ghost" size="sm" asChild className="-ml-2 self-start text-muted-foreground">
          <Link to={voltar.para}>
            <ArrowLeft /> {voltar.rotulo}
          </Link>
        </Button>
      )}
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div className="flex min-w-0 flex-col gap-1.5">
          <span className="h-1 w-10 rounded-full faixa-stowise" aria-hidden />
          <h1 className="text-2xl font-bold tracking-tight sm:text-3xl">{titulo}</h1>
          {descricao && <div className="text-sm text-muted-foreground">{descricao}</div>}
        </div>
        {acoes && <div className="flex flex-wrap gap-2">{acoes}</div>}
      </div>
    </header>
  )
}
