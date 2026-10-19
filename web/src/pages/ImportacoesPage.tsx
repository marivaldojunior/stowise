import { Link } from 'react-router'
import { falhaDe } from '@/api/falha'
import { useListarImportacoes } from '@/api/gerado/stowise'
import { Paginacao } from '@/components/Paginacao'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { formatarDataHora } from '@/features/estoque/formato'
import { EnvioArquivo } from '@/features/importacoes/EnvioArquivo'
import { ROTULO_STATUS_IMPORTACAO, TOM_STATUS_IMPORTACAO } from '@/features/importacoes/rotulos'
import { useFiltrosDaUrl } from '@/lib/filtrosDaUrl'
import { formatarNumero } from '@/lib/numeros'
import { LinhaVazia, LinhasCarregando } from '@/components/EstadoTabela'
import { Alerta } from '@/components/Alerta'
import { CabecalhoPagina } from '@/components/CabecalhoPagina'
import { Situacao } from '@/components/Situacao'

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
      <CabecalhoPagina
        titulo="Importações"
        descricao="Cadastro de produtos em massa. A IA sugere o mapeamento das colunas; você confere antes de importar."
      />

      <EnvioArquivo />

      {lista.isError ? (
        <Alerta tom="erro">Não foi possível carregar as importações: {falhaDe(lista.error).mensagem}</Alerta>
      ) : (
        <div className="overflow-hidden rounded-2xl border border-border/70 bg-card sombra-cartao">
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
                <LinhasCarregando colunas={5} rotulo="Carregando as importações" />
              ) : lista.data.itens.length === 0 ? (
                <LinhaVazia colunas={5} texto="Nenhuma importação ainda." />
              ) : (
                lista.data.itens.map((importacao) => (
                  <TableRow key={importacao.id}>
                    <TableCell>
                      <Link to={`/importacoes/${importacao.id}`} className="font-medium hover:underline">
                        {importacao.nomeArquivo}
                      </Link>
                    </TableCell>
                    <TableCell>
                      <Situacao tom={TOM_STATUS_IMPORTACAO[importacao.status]}>{ROTULO_STATUS_IMPORTACAO[importacao.status]}</Situacao>
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
