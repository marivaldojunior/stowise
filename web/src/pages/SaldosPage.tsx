import { Link } from 'react-router'
import { falhaDe } from '@/api/falha'
import { useListarArmazens, useListarSaldos, useObterArmazem } from '@/api/gerado/stowise'
import type { ListarSaldosParams } from '@/api/gerado/modelos'
import { Paginacao } from '@/components/Paginacao'
import { Checkbox } from '@/components/ui/checkbox'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { CabecalhoEstoque } from '@/features/estoque/CabecalhoEstoque'
import { formatarData } from '@/features/estoque/formato'
import { TODOS, useFiltrosDaUrl } from '@/lib/filtrosDaUrl'
import { formatarNumero } from '@/lib/numeros'

const TAMANHO_PAGINA = 50

/** /estoque: saldo por endereço, produto e lote. Todos os perfis consultam. */
export function SaldosPage() {
  const url = useFiltrosDaUrl()
  const filtros: ListarSaldosParams = {
    produtoId: url.texto('produtoId'),
    enderecoId: url.texto('enderecoId'),
    armazemId: url.texto('armazemId'),
    zonaId: url.texto('zonaId'),
    incluirZerados: url.booleano('zerados'),
    pagina: url.pagina(),
    tamanhoPagina: TAMANHO_PAGINA,
  }
  const armazens = useListarArmazens()
  const armazem = useObterArmazem(filtros.armazemId ?? '', { query: { enabled: Boolean(filtros.armazemId) } })
  const lista = useListarSaldos(filtros, { query: { placeholderData: (anterior) => anterior } })

  return (
    <section className="flex flex-col gap-6">
      <CabecalhoEstoque />

      <div className="flex flex-wrap items-center gap-2">
        <Select
          value={filtros.armazemId ?? TODOS}
          onValueChange={(valor) => url.mudarVarios({ armazemId: valor, zonaId: undefined })}
        >
          <SelectTrigger aria-label="Filtrar por armazém" className="w-56">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={TODOS}>Todos os armazéns</SelectItem>
            {(armazens.data ?? []).map((a) => (
              <SelectItem key={a.id} value={a.id}>
                {a.codigo} · {a.nome}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        {filtros.armazemId && (
          <Select value={filtros.zonaId ?? TODOS} onValueChange={(valor) => url.mudar('zonaId', valor)}>
            <SelectTrigger aria-label="Filtrar por zona" className="w-44">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={TODOS}>Todas as zonas</SelectItem>
              {(armazem.data?.zonas ?? []).map((z) => (
                <SelectItem key={z.id} value={z.id}>
                  {z.codigo}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        )}
        <div className="flex items-center gap-2 pl-2">
          <Checkbox
            id="saldos-zerados"
            checked={filtros.incluirZerados === true}
            onCheckedChange={(marcado) => url.mudar('zerados', marcado === true ? 'true' : undefined)}
          />
          <Label htmlFor="saldos-zerados" className="font-normal">
            Mostrar saldos zerados
          </Label>
        </div>
      </div>

      {lista.isError ? (
        <p role="alert" className="text-sm text-destructive">
          Não foi possível carregar os saldos: {falhaDe(lista.error).mensagem}
        </p>
      ) : (
        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Endereço</TableHead>
                <TableHead>Produto</TableHead>
                <TableHead>Lote</TableHead>
                <TableHead>Validade</TableHead>
                <TableHead className="text-right">Quantidade</TableHead>
                <TableHead className="text-right">Reservada</TableHead>
                <TableHead className="text-right">Disponível</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {lista.isPending ? (
                <TableRow>
                  <TableCell colSpan={7}>
                    <Skeleton className="h-5 w-full" role="status" aria-label="Carregando os saldos" />
                  </TableCell>
                </TableRow>
              ) : lista.data.itens.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="text-center text-muted-foreground">
                    Nenhum saldo encontrado.
                  </TableCell>
                </TableRow>
              ) : (
                lista.data.itens.map((saldo) => (
                  <TableRow key={`${saldo.enderecoId}-${saldo.produtoId}-${saldo.loteId ?? ''}`}>
                    <TableCell className="font-mono text-xs">
                      <Link to={`/estoque/extrato?enderecoId=${saldo.enderecoId}`} className="hover:underline">
                        {saldo.enderecoCodigo}
                      </Link>
                    </TableCell>
                    <TableCell>
                      <Link to={`/catalogo/${saldo.produtoId}`} className="hover:underline">
                        <span className="font-mono text-xs">{saldo.sku}</span> · {saldo.descricao}
                      </Link>
                    </TableCell>
                    <TableCell>{saldo.loteNumero ?? '—'}</TableCell>
                    <TableCell>{formatarData(saldo.validade)}</TableCell>
                    <TableCell className="text-right tabular-nums">
                      {formatarNumero(saldo.quantidade, saldo.unidadeBase)}
                    </TableCell>
                    <TableCell className="text-right tabular-nums">{formatarNumero(saldo.quantidadeReservada)}</TableCell>
                    <TableCell className="text-right font-medium tabular-nums">
                      {formatarNumero(saldo.quantidadeDisponivel)}
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>
      )}

      <Paginacao lista={lista.data} rotulo="saldo(s)" onPagina={(p) => url.mudar('pagina', String(p))} />
    </section>
  )
}
