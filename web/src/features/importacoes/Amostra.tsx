import type { ImportacaoDetalhe } from '@/api/gerado/modelos'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'

const LINHAS_AMOSTRA = 5

const FORMATO: Record<ImportacaoDetalhe['layout']['formato'], string> = {
  Delimitado: 'texto delimitado',
  Posicional: 'texto posicional',
  Excel: 'planilha do Excel',
  NFeXml: 'XML de NF-e',
}

/** Layout detectado e as primeiras linhas do arquivo, com o nome de cada coluna. */
export function Amostra({ importacao }: { importacao: ImportacaoDetalhe }) {
  const { layout } = importacao
  const detalhes = [
    FORMATO[layout.formato],
    layout.encoding,
    layout.delimitador && `delimitador "${layout.delimitador === '\t' ? 'tab' : layout.delimitador}"`,
    layout.planilha && `planilha ${layout.planilha}`,
    layout.temCabecalho ? 'com cabeçalho' : 'sem cabeçalho',
  ].filter(Boolean)

  return (
    <section aria-labelledby="titulo-amostra" className="flex flex-col gap-2">
      <h2 id="titulo-amostra" className="text-lg font-semibold">
        Amostra do arquivo
      </h2>
      <p className="text-sm text-muted-foreground">
        {importacao.totalLinhas} linha(s) · {detalhes.join(' · ')}
      </p>
      <div className="overflow-x-auto rounded-2xl border border-border/70 bg-card sombra-cartao">
        <Table>
          <TableHeader>
            <TableRow>
              {layout.colunas.map((coluna) => (
                <TableHead key={coluna.indice} className="whitespace-nowrap">
                  {coluna.indice + 1}. {coluna.nome}
                </TableHead>
              ))}
            </TableRow>
          </TableHeader>
          <TableBody>
            {importacao.amostra.slice(0, LINHAS_AMOSTRA).map((linha, indice) => (
              <TableRow key={indice}>
                {layout.colunas.map((coluna) => (
                  <TableCell key={coluna.indice} className="max-w-48 truncate font-mono text-xs">
                    {linha[coluna.indice] ?? ''}
                  </TableCell>
                ))}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </section>
  )
}
