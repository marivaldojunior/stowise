import { useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { Link } from 'react-router'
import { toast } from 'sonner'
import { falhaDe } from '@/api/falha'
import {
  getObterImportacaoQueryKey,
  useEfetivarImportacao,
  useListarLinhasImportacao,
  useObterRelatorioImportacao,
} from '@/api/gerado/stowise'
import type { ImportacaoDetalhe, StatusLinha } from '@/api/gerado/modelos'
import { Paginacao } from '@/components/Paginacao'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { TODOS } from '@/lib/filtrosDaUrl'
import { formatarNumero } from '@/lib/numeros'
import { ROTULO_ACAO_LINHA, ROTULO_STATUS_LINHA } from './rotulos'

const TAMANHO_PAGINA = 50

function Contador({ rotulo, valor, destaque }: { rotulo: string; valor: number; destaque?: 'erro' | 'aviso' }) {
  return (
    <div className="rounded-md border p-3">
      <dt className="text-xs text-muted-foreground">{rotulo}</dt>
      <dd
        className={
          destaque === 'erro' && valor > 0
            ? 'text-lg font-semibold text-destructive tabular-nums'
            : destaque === 'aviso' && valor > 0
              ? 'text-lg font-semibold text-amber-600 tabular-nums dark:text-amber-400'
              : 'text-lg font-semibold tabular-nums'
        }
      >
        {formatarNumero(valor)}
      </dd>
    </div>
  )
}

/** Erros agrupados por campo (relatório da API), do mais frequente para o menos. */
function ErrosPorCampo({ id }: { id: string }) {
  const relatorio = useObterRelatorioImportacao(id)
  const erros = Object.entries(relatorio.data?.errosPorCampo ?? {}).sort(([, a], [, b]) => b - a)

  if (erros.length === 0) {
    return null
  }

  return (
    <section aria-labelledby="titulo-erros-campo" className="flex flex-col gap-2">
      <h3 id="titulo-erros-campo" className="text-sm font-medium">
        Erros por campo
      </h3>
      <ul className="flex flex-wrap gap-2 text-sm">
        {erros.map(([campo, quantidade]) => (
          <li key={campo} className="rounded-md bg-destructive/10 px-2 py-1">
            {campo}: {formatarNumero(quantidade)}
          </li>
        ))}
      </ul>
    </section>
  )
}

/** Linhas do staging com o que cada uma vai fazer (criar, atualizar, ignorar) e os erros de validação. */
function Linhas({ importacao }: { importacao: ImportacaoDetalhe }) {
  const [status, setStatus] = useState<StatusLinha | undefined>(importacao.linhasComErro > 0 ? 'Erro' : undefined)
  const [pagina, setPagina] = useState(1)
  const linhas = useListarLinhasImportacao(
    importacao.id,
    { status, pagina, tamanhoPagina: TAMANHO_PAGINA },
    { query: { placeholderData: (anterior) => anterior } },
  )

  return (
    <section aria-labelledby="titulo-linhas" className="flex flex-col gap-3">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <h3 id="titulo-linhas" className="text-sm font-medium">
          Linhas
        </h3>
        <Select
          value={status ?? TODOS}
          onValueChange={(valor) => {
            setStatus(valor === TODOS ? undefined : (valor as StatusLinha))
            setPagina(1)
          }}
        >
          <SelectTrigger aria-label="Filtrar as linhas" className="w-48">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={TODOS}>Todas as linhas</SelectItem>
            {(Object.keys(ROTULO_STATUS_LINHA) as StatusLinha[]).map((valor) => (
              <SelectItem key={valor} value={valor}>
                {ROTULO_STATUS_LINHA[valor]}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="w-16">Linha</TableHead>
              <TableHead>SKU</TableHead>
              <TableHead>Descrição</TableHead>
              <TableHead>Situação</TableHead>
              <TableHead>Ação</TableHead>
              <TableHead>Erros</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {linhas.isPending ? (
              <TableRow>
                <TableCell colSpan={6}>
                  <Skeleton className="h-5 w-full" role="status" aria-label="Carregando as linhas" />
                </TableCell>
              </TableRow>
            ) : linhas.isError ? (
              <TableRow>
                <TableCell colSpan={6} className="text-destructive">
                  {falhaDe(linhas.error).mensagem}
                </TableCell>
              </TableRow>
            ) : linhas.data.itens.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center text-muted-foreground">
                  Nenhuma linha.
                </TableCell>
              </TableRow>
            ) : (
              linhas.data.itens.map((linha) => (
                <TableRow key={linha.id}>
                  <TableCell className="tabular-nums">{linha.numeroLinha}</TableCell>
                  <TableCell className="font-mono text-xs">{linha.dadosNormalizados.sku ?? '—'}</TableCell>
                  <TableCell>{linha.dadosNormalizados.descricao ?? '—'}</TableCell>
                  <TableCell>
                    <Badge variant={linha.status === 'Erro' ? 'destructive' : 'secondary'}>
                      {ROTULO_STATUS_LINHA[linha.status]}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    {linha.produtoCorrespondenteId ? (
                      <Link to={`/catalogo/${linha.produtoCorrespondenteId}`} className="hover:underline">
                        {ROTULO_ACAO_LINHA[linha.acao]}
                      </Link>
                    ) : (
                      ROTULO_ACAO_LINHA[linha.acao]
                    )}
                  </TableCell>
                  <TableCell>
                    {linha.erros.length === 0 ? (
                      '—'
                    ) : (
                      <ul className="flex flex-col gap-0.5 text-sm text-destructive">
                        {linha.erros.map((erro) => (
                          <li key={`${erro.campo}-${erro.mensagem}`}>
                            <span className="font-medium">{erro.campo}:</span> {erro.mensagem}
                          </li>
                        ))}
                      </ul>
                    )}
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>
      <Paginacao lista={linhas.data} rotulo="linha(s)" onPagina={setPagina} />
    </section>
  )
}

/**
 * Prévia depois da validação: totais, erros por campo e as linhas. A efetivação grava só as linhas válidas; as com
 * erro ficam de fora e aparecem no relatório.
 */
export function Previa({ importacao }: { importacao: ImportacaoDetalhe }) {
  const queryClient = useQueryClient()
  const efetivar = useEfetivarImportacao()
  const [erro, setErro] = useState<string | null>(null)
  const revisando = importacao.status === 'AguardandoRevisao'
  const concluida = importacao.status === 'Concluido'

  async function confirmar() {
    setErro(null)
    try {
      const atualizada = await efetivar.mutateAsync({ id: importacao.id, data: { versao: importacao.versao } })
      queryClient.setQueryData(getObterImportacaoQueryKey(importacao.id), atualizada)
      toast.success('Efetivação iniciada.')
    } catch (falha) {
      setErro(falhaDe(falha).mensagem)
    }
  }

  return (
    <div className="flex flex-col gap-6">
      <section aria-labelledby="titulo-previa" className="flex flex-col gap-3">
        <h2 id="titulo-previa" className="text-lg font-semibold">
          {concluida ? 'Resultado' : 'Prévia'}
        </h2>
        <dl className="grid grid-cols-2 gap-3 sm:grid-cols-4">
          <Contador rotulo="Linhas" valor={importacao.totalLinhas} />
          <Contador rotulo="Válidas" valor={importacao.linhasValidas} />
          <Contador rotulo="Com erro" valor={importacao.linhasComErro} destaque="erro" />
          <Contador rotulo="Possíveis duplicatas" valor={importacao.linhasPossivelDuplicata} destaque="aviso" />
          {concluida && (
            <>
              <Contador rotulo="Produtos criados" valor={importacao.produtosCriados} />
              <Contador rotulo="Produtos atualizados" valor={importacao.produtosAtualizados} />
            </>
          )}
        </dl>
        <ErrosPorCampo id={importacao.id} />
      </section>

      {revisando && (
        <div className="flex flex-col gap-2 rounded-md border p-4">
          <p className="text-sm">
            {importacao.linhasValidas > 0
              ? `A efetivação grava as ${formatarNumero(importacao.linhasValidas)} linha(s) válida(s) no catálogo. As linhas com erro ficam de fora.`
              : 'Nenhuma linha válida para gravar. Corrija o arquivo e envie de novo.'}
          </p>
          <Button
            className="self-start"
            disabled={efetivar.isPending || importacao.linhasValidas === 0}
            onClick={() => void confirmar()}
          >
            Efetivar a importação
          </Button>
          {erro && (
            <p role="alert" className="text-sm text-destructive">
              {erro}
            </p>
          )}
        </div>
      )}
      {concluida && (
        <Button variant="outline" asChild className="self-start">
          <Link to="/catalogo">Ver o catálogo</Link>
        </Button>
      )}

      <Linhas importacao={importacao} />
    </div>
  )
}
