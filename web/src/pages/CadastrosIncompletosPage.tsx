import { Link, useNavigate } from 'react-router'
import { falhaDe } from '@/api/falha'
import { useListarCadastrosIncompletos, useListarCategorias } from '@/api/gerado/stowise'
import type { ListarCadastrosIncompletosParams } from '@/api/gerado/modelos'
import { Alerta } from '@/components/Alerta'
import { CabecalhoPagina } from '@/components/CabecalhoPagina'
import { LinhaVazia, LinhasCarregando } from '@/components/EstadoTabela'
import { Paginacao } from '@/components/Paginacao'
import { Situacao } from '@/components/Situacao'
import { Input } from '@/components/ui/input'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { ROTULO_EMBALAGEM, ROTULO_MEDIDA } from '@/features/catalogo/rotulos'
import { TODOS, useBusca, useFiltrosDaUrl } from '@/lib/filtrosDaUrl'

const TAMANHO_PAGINA = 20

/**
 * Fila de cadastros incompletos (SPEC, 2.4): produtos ativos com peso ou medida faltando em alguma embalagem, dos
 * mais antigos aos mais novos. A NF-e não traz essas medidas, e sem elas o motor de armazenagem não confere a
 * capacidade. Cada linha leva ao produto, onde a Gestão completa as embalagens.
 */
export function CadastrosIncompletosPage() {
  const navigate = useNavigate()
  const url = useFiltrosDaUrl()
  const filtros: ListarCadastrosIncompletosParams = {
    busca: url.texto('busca'),
    categoriaId: url.texto('categoriaId'),
    pagina: url.pagina(),
    tamanhoPagina: TAMANHO_PAGINA,
  }
  const [busca, setBusca] = useBusca(filtros.busca, (valor) => url.mudar('busca', valor))
  const categorias = useListarCategorias()
  const lista = useListarCadastrosIncompletos(filtros, { query: { placeholderData: (anterior) => anterior } })

  return (
    <section className="flex flex-col gap-6">
      <CabecalhoPagina
        titulo="Cadastros incompletos"
        descricao="Produtos sem peso ou medidas em alguma embalagem. Sem elas, a sugestão de endereço não confere a capacidade."
        voltar={{ para: '/catalogo', rotulo: 'Catálogo' }}
      />

      <div className="flex flex-wrap gap-2">
        <Input
          type="search"
          aria-label="Buscar por SKU ou descrição"
          placeholder="Buscar por SKU ou descrição"
          className="w-full sm:w-72"
          value={busca}
          onChange={(e) => setBusca(e.target.value)}
        />
        <Select value={filtros.categoriaId ?? TODOS} onValueChange={(valor) => url.mudar('categoriaId', valor)}>
          <SelectTrigger aria-label="Filtrar por categoria" className="w-56">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={TODOS}>Todas as categorias</SelectItem>
            {(categorias.data ?? []).map((categoria) => (
              <SelectItem key={categoria.id} value={categoria.id}>
                {categoria.caminho}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {lista.isError ? (
        <Alerta tom="erro">Não foi possível carregar a fila: {falhaDe(lista.error).mensagem}</Alerta>
      ) : (
        <div className="overflow-hidden rounded-2xl border border-border/70 bg-card sombra-cartao">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>SKU</TableHead>
                <TableHead className="hidden sm:table-cell">Descrição</TableHead>
                <TableHead>O que falta</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {lista.isPending ? (
                <LinhasCarregando colunas={3} rotulo="Carregando a fila" />
              ) : lista.data.itens.length === 0 ? (
                <LinhaVazia colunas={3} texto="Nenhum cadastro incompleto. Todas as embalagens têm peso e medidas." />
              ) : (
                lista.data.itens.map((produto) => (
                  <TableRow
                    key={produto.id}
                    className="cursor-pointer"
                    onClick={() => void navigate(`/catalogo/${produto.id}`)}
                  >
                    <TableCell className="align-top">
                      <Link to={`/catalogo/${produto.id}`} className="etiqueta hover:underline">
                        {produto.sku}
                      </Link>
                      {/* No celular, a descrição fica embaixo do SKU, para a pendência caber na tela. */}
                      <p className="mt-1.5 text-sm font-medium whitespace-normal sm:hidden">{produto.descricao}</p>
                    </TableCell>
                    <TableCell className="hidden align-top font-medium sm:table-cell">{produto.descricao}</TableCell>
                    <TableCell>
                      <ul className="flex flex-col gap-1.5">
                        {produto.pendencias.map((p) => (
                          <li key={p.embalagemId} className="flex flex-wrap items-center gap-1.5 text-sm">
                            <span className="text-muted-foreground">
                              {ROTULO_EMBALAGEM[p.tipo]}
                              {p.fatorConversao !== 1 && ` de ${p.fatorConversao} ${produto.unidadeBase}`}:
                            </span>
                            {p.faltando.map((medida) => (
                              <Situacao key={medida} tom="aviso">
                                {ROTULO_MEDIDA[medida] ?? medida}
                              </Situacao>
                            ))}
                          </li>
                        ))}
                      </ul>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>
      )}

      <Paginacao lista={lista.data} rotulo="produto(s)" onPagina={(p) => url.mudar('pagina', String(p))} />
    </section>
  )
}
