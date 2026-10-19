import { Link } from 'react-router'
import { falhaDe } from '@/api/falha'
import { useObterExtrato } from '@/api/gerado/stowise'
import type { ObterExtratoParams, TipoMovimentacao } from '@/api/gerado/modelos'
import { Paginacao } from '@/components/Paginacao'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { CabecalhoEstoque } from '@/features/estoque/CabecalhoEstoque'
import { formatarDataHora, limiteDoDia, ROTULO_MOVIMENTACAO, sinal } from '@/features/estoque/formato'
import { TODOS, useFiltrosDaUrl } from '@/lib/filtrosDaUrl'
import { formatarNumero } from '@/lib/numeros'
import { cn } from '@/lib/utils'

const TAMANHO_PAGINA = 50

/** /estoque/extrato: movimentações, da mais recente para a mais antiga, com filtros de tipo e período. */
export function ExtratoPage() {
  const url = useFiltrosDaUrl()
  const de = url.texto('de')
  const ate = url.texto('ate')
  const filtros: ObterExtratoParams = {
    produtoId: url.texto('produtoId'),
    enderecoId: url.texto('enderecoId'),
    tipo: url.texto('tipo') as TipoMovimentacao | undefined,
    de: de ? limiteDoDia(de, false) : undefined,
    ate: ate ? limiteDoDia(ate, true) : undefined,
    pagina: url.pagina(),
    tamanhoPagina: TAMANHO_PAGINA,
  }
  const extrato = useObterExtrato(filtros, { query: { placeholderData: (anterior) => anterior } })

  return (
    <section className="flex flex-col gap-6">
      <CabecalhoEstoque />

      <div className="flex flex-wrap items-end gap-3">
        <div className="flex flex-col gap-2">
          <Label htmlFor="extrato-tipo">Tipo</Label>
          <Select value={filtros.tipo ?? TODOS} onValueChange={(valor) => url.mudar('tipo', valor)}>
            <SelectTrigger id="extrato-tipo" className="w-44">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={TODOS}>Todos os tipos</SelectItem>
              {(Object.keys(ROTULO_MOVIMENTACAO) as TipoMovimentacao[]).map((tipo) => (
                <SelectItem key={tipo} value={tipo}>
                  {ROTULO_MOVIMENTACAO[tipo]}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="flex flex-col gap-2">
          <Label htmlFor="extrato-de">De</Label>
          <Input
            id="extrato-de"
            type="date"
            className="w-40"
            value={de ?? ''}
            max={ate}
            onChange={(e) => url.mudar('de', e.target.value)}
          />
        </div>
        <div className="flex flex-col gap-2">
          <Label htmlFor="extrato-ate">Até</Label>
          <Input
            id="extrato-ate"
            type="date"
            className="w-40"
            value={ate ?? ''}
            min={de}
            onChange={(e) => url.mudar('ate', e.target.value)}
          />
        </div>
      </div>

      {extrato.isError ? (
        <p role="alert" className="text-sm text-destructive">
          Não foi possível carregar o extrato: {falhaDe(extrato.error).mensagem}
        </p>
      ) : (
        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Data</TableHead>
                <TableHead>Tipo</TableHead>
                <TableHead>Produto</TableHead>
                <TableHead>Lote</TableHead>
                <TableHead>Origem → destino</TableHead>
                <TableHead className="text-right">Quantidade</TableHead>
                <TableHead>Documento</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {extrato.isPending ? (
                <TableRow>
                  <TableCell colSpan={7}>
                    <Skeleton className="h-5 w-full" role="status" aria-label="Carregando o extrato" />
                  </TableCell>
                </TableRow>
              ) : extrato.data.itens.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="text-center text-muted-foreground">
                    Nenhuma movimentação no período.
                  </TableCell>
                </TableRow>
              ) : (
                extrato.data.itens.map((item) => {
                  const sentido = sinal(item)
                  return (
                    <TableRow key={item.id}>
                      <TableCell className="whitespace-nowrap">{formatarDataHora(item.ocorridoEm)}</TableCell>
                      <TableCell>{ROTULO_MOVIMENTACAO[item.tipo]}</TableCell>
                      <TableCell>
                        <Link to={`/catalogo/${item.produtoId}`} className="font-mono text-xs hover:underline">
                          {item.sku}
                        </Link>
                      </TableCell>
                      <TableCell>{item.loteNumero ?? '—'}</TableCell>
                      <TableCell className="font-mono text-xs">
                        {item.enderecoOrigemCodigo ?? '—'} → {item.enderecoDestinoCodigo ?? '—'}
                      </TableCell>
                      <TableCell
                        className={cn(
                          'text-right font-medium tabular-nums',
                          sentido === '+' && 'text-emerald-600 dark:text-emerald-400',
                          sentido === '−' && 'text-destructive',
                        )}
                      >
                        {sentido === '↔' ? '' : sentido}
                        {formatarNumero(item.quantidade)}
                      </TableCell>
                      <TableCell className="text-muted-foreground">
                        {item.documentoReferencia ?? item.observacao ?? '—'}
                      </TableCell>
                    </TableRow>
                  )
                })
              )}
            </TableBody>
          </Table>
        </div>
      )}

      <Paginacao lista={extrato.data} rotulo="movimentação(ões)" onPagina={(p) => url.mudar('pagina', String(p))} />
    </section>
  )
}
