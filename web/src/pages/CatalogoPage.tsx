import { Plus } from 'lucide-react'
import { Link, useNavigate } from 'react-router'
import { falhaDe } from '@/api/falha'
import { useListarCategorias, useListarProdutos } from '@/api/gerado/stowise'
import type { ListarProdutosParams } from '@/api/gerado/modelos'
import { FiltroSituacao } from '@/components/FiltroSituacao'
import { Paginacao } from '@/components/Paginacao'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { PERFIS_GESTAO, useAuth } from '@/features/auth/contexto'
import { ROTULO_CLASSE } from '@/features/catalogo/rotulos'
import { TODOS, useBusca, useFiltrosDaUrl } from '@/lib/filtrosDaUrl'
import { LinhaVazia, LinhasCarregando } from '@/components/EstadoTabela'
import { Alerta } from '@/components/Alerta'
import { CabecalhoPagina } from '@/components/CabecalhoPagina'
import { Situacao } from '@/components/Situacao'

const TAMANHO_PAGINA = 20

/** Catálogo de produtos: todos os perfis consultam; Admin e Gestor cadastram. */
export function CatalogoPage() {
  const { temPerfil } = useAuth()
  const navigate = useNavigate()
  const url = useFiltrosDaUrl()
  const filtros: ListarProdutosParams = {
    busca: url.texto('busca'),
    categoriaId: url.texto('categoriaId'),
    ativo: url.booleano('ativo'),
    pagina: url.pagina(),
    tamanhoPagina: TAMANHO_PAGINA,
  }
  const [busca, setBusca] = useBusca(filtros.busca, (valor) => url.mudar('busca', valor))
  const categorias = useListarCategorias()
  const lista = useListarProdutos(filtros, { query: { placeholderData: (anterior) => anterior } })
  const caminhoDaCategoria = new Map((categorias.data ?? []).map((c) => [c.id, c.caminho]))

  return (
    <section className="flex flex-col gap-6">
      <CabecalhoPagina
        titulo="Catálogo"
        descricao="Produtos, unidades e embalagens."
        acoes={
          temPerfil(...PERFIS_GESTAO) && (
            <Button asChild>
              <Link to="/catalogo/novo">
                <Plus /> Novo produto
              </Link>
            </Button>
          )
        }
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
        <FiltroSituacao valor={filtros.ativo} onMudar={(valor) => url.mudar('ativo', valor)} />
      </div>

      {lista.isError ? (
        <Alerta tom="erro">Não foi possível carregar o catálogo: {falhaDe(lista.error).mensagem}</Alerta>
      ) : (
        <div className="overflow-hidden rounded-2xl border border-border/70 bg-card sombra-cartao">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>SKU</TableHead>
                <TableHead>Descrição</TableHead>
                <TableHead>Unidade</TableHead>
                <TableHead>Classe</TableHead>
                <TableHead>Categoria</TableHead>
                <TableHead>Situação</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {lista.isPending ? (
                <LinhasCarregando colunas={6} rotulo="Carregando o catálogo" />
              ) : lista.data.itens.length === 0 ? (
                <LinhaVazia colunas={6} texto="Nenhum produto encontrado." />
              ) : (
                lista.data.itens.map((produto) => (
                  <TableRow
                    key={produto.id}
                    className="cursor-pointer"
                    onClick={() => void navigate(`/catalogo/${produto.id}`)}
                  >
                    <TableCell>
                      <Link to={`/catalogo/${produto.id}`} className="etiqueta hover:underline">
                        {produto.sku}
                      </Link>
                    </TableCell>
                    <TableCell className="font-medium">{produto.descricao}</TableCell>
                    <TableCell>{produto.unidadeBase}</TableCell>
                    <TableCell>{ROTULO_CLASSE[produto.classeArmazenagem]}</TableCell>
                    <TableCell className="text-muted-foreground">
                      {produto.categoriaId ? (caminhoDaCategoria.get(produto.categoriaId) ?? '…') : '—'}
                    </TableCell>
                    <TableCell>
                      {produto.ativo ? (
                        <Situacao tom="sucesso">Ativo</Situacao>
                      ) : (
                        <Situacao tom="neutro">Inativo</Situacao>
                      )}
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
