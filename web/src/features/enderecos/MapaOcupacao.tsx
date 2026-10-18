import type { EnderecoDetalhe, StatusEndereco } from '@/api/gerado/modelos'
import { Skeleton } from '@/components/ui/skeleton'
import { Tooltip, TooltipContent, TooltipTrigger } from '@/components/ui/tooltip'
import { cn } from '@/lib/utils'
import { agruparPorRua, COR_STATUS, resumir, ROTULO_STATUS } from './mapa'

interface Props {
  enderecos: EnderecoDetalhe[] | undefined
  carregando: boolean
  onSelecionar: (endereco: EnderecoDetalhe) => void
}

function Legenda({ enderecos }: { enderecos: EnderecoDetalhe[] }) {
  const resumo = resumir(enderecos)
  return (
    <div className="flex flex-wrap items-center gap-4 text-sm" aria-label="Resumo da ocupação">
      <span className="font-medium">{resumo.ocupacao}% ocupado</span>
      {(Object.keys(ROTULO_STATUS) as StatusEndereco[]).map((status) => (
        <span key={status} className="flex items-center gap-1.5">
          <span className={cn('size-3 rounded-sm', COR_STATUS[status])} aria-hidden />
          {ROTULO_STATUS[status]}: {resumo.porStatus[status]}
        </span>
      ))}
      <span className="text-muted-foreground">Total: {resumo.total}</span>
    </div>
  )
}

/**
 * Mapa de ocupação da zona: cada rua é um bloco; as linhas são os níveis (o mais alto em cima) e, em cada nível,
 * os módulos com as suas posições. A cor mostra a situação do endereço.
 */
export function MapaOcupacao({ enderecos, carregando, onSelecionar }: Props) {
  if (carregando || !enderecos) {
    return <Skeleton className="h-40 w-full" role="status" aria-label="Carregando o mapa" />
  }

  if (enderecos.length === 0) {
    return <p className="text-sm text-muted-foreground">Esta zona ainda não tem endereços.</p>
  }

  return (
    <div className="flex flex-col gap-4">
      <Legenda enderecos={enderecos} />
      <div className="flex flex-col gap-6">
        {agruparPorRua(enderecos).map(({ rua, niveis }) => (
          <figure key={rua} className="flex flex-col gap-2" aria-label={`Rua ${rua}`}>
            <figcaption className="text-sm font-medium">Rua {rua}</figcaption>
            <div className="overflow-x-auto pb-2">
              <div className="flex w-max flex-col gap-1">
                {niveis.map(({ nivel, modulos }) => (
                  <div key={nivel} className="flex items-center gap-2">
                    <span className="w-8 text-right text-xs text-muted-foreground">N{nivel}</span>
                    {modulos.map(({ modulo, enderecos: posicoes }) => (
                      <div key={modulo} className="flex gap-0.5 rounded-sm border p-0.5" title={`Módulo ${modulo}`}>
                        {posicoes.map((endereco) => (
                          <Tooltip key={endereco.id}>
                            <TooltipTrigger asChild>
                              <button
                                type="button"
                                aria-label={`${endereco.codigo}: ${ROTULO_STATUS[endereco.status]}`}
                                className={cn(
                                  'size-5 rounded-[3px] transition-colors focus-visible:ring-2 focus-visible:ring-ring focus-visible:outline-none',
                                  COR_STATUS[endereco.status],
                                )}
                                onClick={() => onSelecionar(endereco)}
                              />
                            </TooltipTrigger>
                            <TooltipContent>
                              {endereco.codigo} · {ROTULO_STATUS[endereco.status]}
                            </TooltipContent>
                          </Tooltip>
                        ))}
                      </div>
                    ))}
                  </div>
                ))}
              </div>
            </div>
          </figure>
        ))}
      </div>
    </div>
  )
}
