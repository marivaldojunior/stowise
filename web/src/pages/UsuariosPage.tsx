import { useQueryClient } from '@tanstack/react-query'
import { Ellipsis, Plus } from 'lucide-react'
import { useEffect, useState } from 'react'
import { useSearchParams } from 'react-router'
import { toast } from 'sonner'
import { falhaDe } from '@/api/falha'
import {
  getListarUsuariosQueryKey,
  useDesativarUsuario,
  useListarPerfis,
  useListarUsuarios,
  useReativarUsuario,
} from '@/api/gerado/stowise'
import type { ListarUsuariosParams, UsuarioDetalhe } from '@/api/gerado/modelos'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { Input } from '@/components/ui/input'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Skeleton } from '@/components/ui/skeleton'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { useAuth } from '@/features/auth/contexto'
import { FormularioUsuario } from '@/features/usuarios/FormularioUsuario'
import { RedefinirSenha } from '@/features/usuarios/RedefinirSenha'

const TAMANHO_PAGINA = 20
const TODOS = 'todos'
/** Espera depois da última tecla na busca, para não chamar a API a cada letra. */
const ESPERA_BUSCA_MS = 300

type Dialogo = { tipo: 'novo' } | { tipo: 'editar' | 'senha'; usuario: UsuarioDetalhe } | null

/** Filtros na URL: a lista volta igual ao recarregar ou ao compartilhar o endereço. */
function useFiltros() {
  const [params, setParams] = useSearchParams()
  const ativo = params.get('ativo')
  const filtros: ListarUsuariosParams = {
    busca: params.get('busca') ?? undefined,
    perfil: params.get('perfil') ?? undefined,
    ativo: ativo === null ? undefined : ativo === 'true',
    pagina: Number(params.get('pagina') ?? '1') || 1,
    tamanhoPagina: TAMANHO_PAGINA,
  }

  function mudar(nome: 'busca' | 'perfil' | 'ativo' | 'pagina', valor: string | undefined) {
    setParams(
      (atuais) => {
        const novos = new URLSearchParams(atuais)
        if (valor === undefined || valor === '' || valor === TODOS) {
          novos.delete(nome)
        } else {
          novos.set(nome, valor)
        }

        // Filtro novo volta para a primeira página.
        if (nome !== 'pagina') {
          novos.delete('pagina')
        }

        return novos
      },
      { replace: true },
    )
  }

  return { filtros, mudar }
}

function Situacao({ usuario }: { usuario: UsuarioDetalhe }) {
  if (!usuario.ativo) {
    return <Badge variant="outline">Inativo</Badge>
  }

  return usuario.bloqueado ? <Badge variant="destructive">Bloqueado</Badge> : <Badge variant="secondary">Ativo</Badge>
}

function AcoesUsuario({ usuario, onDialogo }: { usuario: UsuarioDetalhe; onDialogo: (d: Dialogo) => void }) {
  const queryClient = useQueryClient()
  const { usuario: atual } = useAuth()
  const desativar = useDesativarUsuario()
  const reativar = useReativarUsuario()

  async function mudarSituacao() {
    try {
      if (usuario.ativo) {
        await desativar.mutateAsync({ id: usuario.id })
        toast.success(`${usuario.nome} desativado. As sessões abertas terminaram.`)
      } else {
        await reativar.mutateAsync({ id: usuario.id })
        toast.success(`${usuario.nome} reativado.`)
      }

      await queryClient.invalidateQueries({ queryKey: getListarUsuariosQueryKey() })
    } catch (erro) {
      toast.error(falhaDe(erro).mensagem)
    }
  }

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="icon" aria-label={`Ações de ${usuario.nome}`}>
          <Ellipsis />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onSelect={() => onDialogo({ tipo: 'editar', usuario })}>Editar</DropdownMenuItem>
        <DropdownMenuItem onSelect={() => onDialogo({ tipo: 'senha', usuario })}>Redefinir a senha</DropdownMenuItem>
        <DropdownMenuSeparator />
        {/* A API também recusa (422); aqui o item some para a própria conta. */}
        {usuario.id !== atual?.id && (
          <DropdownMenuItem variant={usuario.ativo ? 'destructive' : 'default'} onSelect={() => void mudarSituacao()}>
            {usuario.ativo ? 'Desativar' : 'Reativar'}
          </DropdownMenuItem>
        )}
      </DropdownMenuContent>
    </DropdownMenu>
  )
}

export function UsuariosPage() {
  const { filtros, mudar } = useFiltros()
  const [busca, setBusca] = useState(filtros.busca ?? '')
  const [dialogo, setDialogo] = useState<Dialogo>(null)
  const perfis = useListarPerfis()
  const lista = useListarUsuarios(filtros, { query: { placeholderData: (anterior) => anterior } })

  useEffect(() => {
    if (busca === (filtros.busca ?? '')) {
      return
    }

    const timer = window.setTimeout(() => mudar('busca', busca.trim()), ESPERA_BUSCA_MS)
    return () => window.clearTimeout(timer)
  })

  const pagina = lista.data?.pagina ?? filtros.pagina ?? 1
  const totalPaginas = lista.data ? Math.max(Math.ceil(lista.data.total / lista.data.tamanhoPagina), 1) : 1

  return (
    <section className="flex flex-col gap-6">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight">Usuários</h1>
          <p className="text-muted-foreground">Contas de acesso ao Stowise e os perfis de cada uma.</p>
        </div>
        <Button onClick={() => setDialogo({ tipo: 'novo' })}>
          <Plus /> Novo usuário
        </Button>
      </div>

      <div className="flex flex-wrap gap-2">
        <Input
          type="search"
          aria-label="Buscar por nome ou e-mail"
          placeholder="Buscar por nome ou e-mail"
          className="w-full sm:w-72"
          value={busca}
          onChange={(e) => setBusca(e.target.value)}
        />
        <Select value={filtros.perfil ?? TODOS} onValueChange={(valor) => mudar('perfil', valor)}>
          <SelectTrigger aria-label="Filtrar por perfil" className="w-40">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={TODOS}>Todos os perfis</SelectItem>
            {(perfis.data ?? []).map((perfil) => (
              <SelectItem key={perfil} value={perfil}>
                {perfil}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select
          value={filtros.ativo === undefined ? TODOS : String(filtros.ativo)}
          onValueChange={(valor) => mudar('ativo', valor)}
        >
          <SelectTrigger aria-label="Filtrar por situação" className="w-40">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={TODOS}>Todas as situações</SelectItem>
            <SelectItem value="true">Ativos</SelectItem>
            <SelectItem value="false">Inativos</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {lista.isError ? (
        <p role="alert" className="text-sm text-destructive">
          Não foi possível carregar os usuários: {falhaDe(lista.error).mensagem}
        </p>
      ) : (
        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Nome</TableHead>
                <TableHead>E-mail</TableHead>
                <TableHead>Perfis</TableHead>
                <TableHead>Situação</TableHead>
                <TableHead className="w-12">
                  <span className="sr-only">Ações</span>
                </TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {lista.isPending ? (
                <TableRow>
                  <TableCell colSpan={5}>
                    <Skeleton className="h-5 w-full" role="status" aria-label="Carregando os usuários" />
                  </TableCell>
                </TableRow>
              ) : lista.data.itens.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={5} className="text-center text-muted-foreground">
                    Nenhum usuário encontrado.
                  </TableCell>
                </TableRow>
              ) : (
                lista.data.itens.map((usuario) => (
                  <TableRow key={usuario.id}>
                    <TableCell className="font-medium">{usuario.nome}</TableCell>
                    <TableCell>{usuario.email}</TableCell>
                    <TableCell>
                      <span className="flex flex-wrap gap-1">
                        {usuario.perfis.map((perfil) => (
                          <Badge key={perfil} variant="outline">
                            {perfil}
                          </Badge>
                        ))}
                      </span>
                    </TableCell>
                    <TableCell>
                      <Situacao usuario={usuario} />
                    </TableCell>
                    <TableCell>
                      <AcoesUsuario usuario={usuario} onDialogo={setDialogo} />
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>
      )}

      <nav aria-label="Paginação" className="flex items-center justify-between gap-2 text-sm">
        <span className="text-muted-foreground">
          {lista.data ? `${lista.data.total} usuário(s) · página ${pagina} de ${totalPaginas}` : ''}
        </span>
        <span className="flex gap-2">
          <Button variant="outline" size="sm" disabled={pagina <= 1} onClick={() => mudar('pagina', String(pagina - 1))}>
            Anterior
          </Button>
          <Button
            variant="outline"
            size="sm"
            disabled={pagina >= totalPaginas}
            onClick={() => mudar('pagina', String(pagina + 1))}
          >
            Próxima
          </Button>
        </span>
      </nav>

      {dialogo?.tipo === 'novo' && <FormularioUsuario onFechar={() => setDialogo(null)} />}
      {dialogo?.tipo === 'editar' && <FormularioUsuario usuario={dialogo.usuario} onFechar={() => setDialogo(null)} />}
      {dialogo?.tipo === 'senha' && <RedefinirSenha usuario={dialogo.usuario} onFechar={() => setDialogo(null)} />}
    </section>
  )
}
