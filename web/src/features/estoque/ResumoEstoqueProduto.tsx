import { Link } from 'react-router'
import { useObterResumoSaldoProduto } from '@/api/gerado/stowise'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { formatarNumero } from '@/lib/numeros'
import { formatarData } from './formato'
import { Painel } from '@/components/Painel'

/** Totais do produto em estoque e os lotes, com atalhos para o saldo e o extrato. */
export function ResumoEstoqueProduto({ produtoId }: { produtoId: string }) {
  const resumo = useObterResumoSaldoProduto(produtoId)

  return (
    <Painel
      titulo="Estoque"
      acoes={
        <>
          <Button variant="outline" size="sm" asChild>
            <Link to={`/estoque?produtoId=${produtoId}`}>Ver saldo por endereço</Link>
          </Button>
          <Button variant="outline" size="sm" asChild>
            <Link to={`/estoque/extrato?produtoId=${produtoId}`}>Ver extrato</Link>
          </Button>
        </>
      }
    >
      {resumo.isPending ? (
        <Skeleton className="h-16 w-full" role="status" aria-label="Carregando o estoque" />
      ) : resumo.isError ? (
        <p className="text-sm text-muted-foreground">Não foi possível carregar o estoque deste produto.</p>
      ) : (
        <>
          <dl className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            {(
              [
                ['Em estoque', formatarNumero(resumo.data.quantidade, resumo.data.unidadeBase)],
                ['Reservado', formatarNumero(resumo.data.quantidadeReservada, resumo.data.unidadeBase)],
                ['Disponível', formatarNumero(resumo.data.quantidadeDisponivel, resumo.data.unidadeBase)],
                ['Endereços', formatarNumero(resumo.data.enderecos)],
              ] as const
            ).map(([rotulo, valor]) => (
              <div key={rotulo} className="rounded-lg bg-muted/50 p-3">
                <dt className="text-xs text-muted-foreground">{rotulo}</dt>
                <dd className="text-lg font-semibold tabular-nums">{valor}</dd>
              </div>
            ))}
          </dl>
          {resumo.data.lotes.some((lote) => lote.numero) && (
            <ul className="flex flex-wrap gap-2 text-sm" aria-label="Lotes em estoque">
              {resumo.data.lotes.map((lote) => (
                <li key={lote.loteId ?? 'sem-lote'} className="rounded-md border px-2 py-1">
                  {lote.numero ?? 'Sem lote'} · {formatarNumero(lote.quantidade)}
                  {lote.validade && ` · validade ${formatarData(lote.validade)}`}
                </li>
              ))}
            </ul>
          )}
        </>
      )}
    </Painel>
  )
}
