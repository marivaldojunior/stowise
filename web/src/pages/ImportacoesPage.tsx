import { Link } from 'react-router'
import { falhaDe } from '@/api/falha'
import { useListarImportacoes } from '@/api/gerado/stowise'
import { Paginacao } from '@/components/Paginacao'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { formatarDataHora } from '@/features/estoque/formato'
import { EnvioArquivo } from '@/features/importacoes/EnvioArquivo'
import { ROTULO_STATUS_IMPORTACAO } from '@/features/importacoes/rotulos'
import { useFiltrosDaUrl } from '@/lib/filtrosDaUrl'
import { formatarNumero } from '@/lib/numeros'

const TAMANHO_PAGINA = 20

/** /importacoes (Admin e Gestor): envio de arquivo de produtos e histórico das importações. */
export function ImportacoesPage() {
  const url = useFiltrosDaUrl()
  const lista = useListarImportacoes(
    { pagina: url.pagina(), tamanhoPagina: TAMANHO_PAGINA },
    { query: { placeholderData: (anterior) => anterior } },
  )

  return (
    <section className="flex flex-col gap-6">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">Importações</h1>
        <p className="text-muted-foreground">
          Cadastro de produtos em massa. A IA sugere o mapeamento das colunas; você confere antes de importar.
        </p>
      </div>

      <EnvioArquivo />

      {lista.isError ? (
        <p role="alert" className="text-sm text-destructive">
          Não foi possível carregar as importações: {falhaDe(lista.error).mensagem}
        </p>
      ) : (
        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Arquivo</TableHead>
                <TableHead>Situação</TableHead>
                <TableHead className="text-right">Linhas</TableHead>
                <TableHead className="text-right">Com erro</TableHead>
                <TableHead>Enviado em</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {lista.isPending ? (
                <TableRow>
                  <TableCell colSpan={5}>
                    <Skeleton className="h-5 w-full" role="status" aria-label="Carregando as importações" />
                  </TableCell>
                </TableRow>
              ) : lista.data.itens.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={5} className="text-center text-muted-foreground">
                    Nenhuma importação ainda.
                  </TableCell>
                </TableRow>
              ) : (
                lista.data.itens.map((importacao) => (
                  <TableRow key={importacao.id}>
                    <TableCell>
                      <Link to={`/importacoes/${importacao.id}`} className="font-medium hover:underline">
                        {importacao.nomeArquivo}
                      </Link>
                    </TableCell>
                    <TableCell>
                      <Badge variant={importacao.status === 'Falhou' ? 'destructive' : 'secondary'}>
                        {ROTULO_STATUS_IMPORTACAO[importacao.status]}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-right tabular-nums">{formatarNumero(importacao.totalLinhas)}</TableCell>
                    <TableCell className="text-right tabular-nums">
                      {formatarNumero(importacao.linhasComErro)}
                    </TableCell>
                    <TableCell className="whitespace-nowrap">{formatarDataHora(importacao.iniciadoEm)}</TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>
      )}

      <Paginacao lista={lista.data} rotulo="importação(ões)" onPagina={(p) => url.mudar('pagina', String(p))} />
    </section>
  )
}
