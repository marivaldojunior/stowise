import { useQueryClient } from '@tanstack/react-query'
import { Ellipsis, Plus } from 'lucide-react'
import { useState } from 'react'
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
import { FiltroSituacao } from '@/components/FiltroSituacao'
import { Paginacao } from '@/components/Paginacao'
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
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { useAuth } from '@/features/auth/contexto'
import { FormularioUsuario } from '@/features/usuarios/FormularioUsuario'
import { RedefinirSenha } from '@/features/usuarios/RedefinirSenha'
import { TODOS, useBusca, useFiltrosDaUrl } from '@/lib/filtrosDaUrl'
import { LinhaVazia, LinhasCarregando } from '@/components/EstadoTabela'
import { Alerta } from '@/components/Alerta'
import { CabecalhoPagina } from '@/components/CabecalhoPagina'
import { Situacao } from '@/components/Situacao'

const TAMANHO_PAGINA = 20

type Dialogo = { tipo: 'novo' } | { tipo: 'editar' | 'senha'; usuario: UsuarioDetalhe } | null

function SituacaoUsuario({ usuario }: { usuario: UsuarioDetalhe }) {
  if (!usuario.ativo) {
    return <Situacao tom="neutro">Inativo</Situacao>
  }

  return usuario.bloqueado ? <Situacao tom="perigo">Bloqueado</Situacao> : <Situacao tom="sucesso">Ativo</Situacao>
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
  const url = useFiltrosDaUrl()
  const filtros: ListarUsuariosParams = {
    busca: url.texto('busca'),
    perfil: url.texto('perfil'),
    ativo: url.booleano('ativo'),
    pagina: url.pagina(),
    tamanhoPagina: TAMANHO_PAGINA,
  }
  const [busca, setBusca] = useBusca(filtros.busca, (valor) => url.mudar('busca', valor))
  const [dialogo, setDialogo] = useState<Dialogo>(null)
  const perfis = useListarPerfis()
  const lista = useListarUsuarios(filtros, { query: { placeholderData: (anterior) => anterior } })

  return (
    <section className="flex flex-col gap-6">
      <CabecalhoPagina
        titulo="Usuários"
        descricao="Contas de acesso ao Stowise e os perfis de cada uma."
        acoes={
          <Button onClick={() => setDialogo({ tipo: 'novo' })}>
            <Plus /> Novo usuário
          </Button>
        }
      />

      <div className="flex flex-wrap gap-2">
        <Input
          type="search"
          aria-label="Buscar por nome ou e-mail"
          placeholder="Buscar por nome ou e-mail"
          className="w-full sm:w-72"
          value={busca}
          onChange={(e) => setBusca(e.target.value)}
        />
        <Select value={filtros.perfil ?? TODOS} onValueChange={(valor) => url.mudar('perfil', valor)}>
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
        <FiltroSituacao valor={filtros.ativo} onMudar={(valor) => url.mudar('ativo', valor)} />
      </div>

      {lista.isError ? (
        <Alerta tom="erro">Não foi possível carregar os usuários: {falhaDe(lista.error).mensagem}</Alerta>
      ) : (
        <div className="overflow-hidden rounded-2xl border border-border/70 bg-card sombra-cartao">
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
                <LinhasCarregando colunas={5} rotulo="Carregando os usuários" />
              ) : lista.data.itens.length === 0 ? (
                <LinhaVazia colunas={5} texto="Nenhum usuário encontrado." />
              ) : (
                lista.data.itens.map((usuario) => (
                  <TableRow key={usuario.id}>
                    <TableCell className="font-medium">{usuario.nome}</TableCell>
                    <TableCell>{usuario.email}</TableCell>
                    <TableCell>
                      <span className="flex flex-wrap gap-1">
                        {usuario.perfis.map((perfil) => (
                          <Situacao key={perfil} tom="marca">
                            {perfil}
                          </Situacao>
                        ))}
                      </span>
                    </TableCell>
                    <TableCell>
                      <SituacaoUsuario usuario={usuario} />
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

      <Paginacao lista={lista.data} rotulo="usuário(s)" onPagina={(p) => url.mudar('pagina', String(p))} />

      {dialogo?.tipo === 'novo' && <FormularioUsuario onFechar={() => setDialogo(null)} />}
      {dialogo?.tipo === 'editar' && <FormularioUsuario usuario={dialogo.usuario} onFechar={() => setDialogo(null)} />}
      {dialogo?.tipo === 'senha' && <RedefinirSenha usuario={dialogo.usuario} onFechar={() => setDialogo(null)} />}
    </section>
  )
}
