import { useQueryClient } from '@tanstack/react-query'
import { type FormEvent, useState } from 'react'
import { toast } from 'sonner'
import { erroDoCampo, type Falha, falhaDe } from '@/api/falha'
import { getListarUsuariosQueryKey, useAtualizarUsuario, useCriarUsuario, useListarPerfis } from '@/api/gerado/stowise'
import type { UsuarioDetalhe } from '@/api/gerado/modelos'
import { Button } from '@/components/ui/button'
import { Checkbox } from '@/components/ui/checkbox'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { Label } from '@/components/ui/label'
import { Campo } from '@/components/Campo'

interface Props {
  onFechar: () => void
  /** Sem usuário, o formulário cria um novo; com usuário, edita nome e perfis (o e-mail não muda). */
  usuario?: UsuarioDetalhe
}

/** Diálogo de criar ou editar usuário. Ele é montado só quando aberto, então o estado começa limpo a cada vez. */
export function FormularioUsuario({ onFechar, usuario }: Props) {
  const queryClient = useQueryClient()
  const perfisDisponiveis = useListarPerfis()
  const criar = useCriarUsuario()
  const atualizar = useAtualizarUsuario()
  const [nome, setNome] = useState(usuario?.nome ?? '')
  const [email, setEmail] = useState('')
  const [senha, setSenha] = useState('')
  const [perfis, setPerfis] = useState<string[]>(usuario?.perfis ?? [])
  const [falha, setFalha] = useState<Falha | null>(null)
  const enviando = criar.isPending || atualizar.isPending

  function alternarPerfil(perfil: string, marcado: boolean) {
    setPerfis((atuais) => (marcado ? [...atuais, perfil] : atuais.filter((p) => p !== perfil)))
  }

  async function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault()
    setFalha(null)
    try {
      if (usuario) {
        await atualizar.mutateAsync({ id: usuario.id, data: { nome: nome.trim(), perfis } })
        toast.success(`Usuário ${nome.trim()} atualizado.`)
      } else {
        await criar.mutateAsync({ data: { nome: nome.trim(), email: email.trim(), senha, perfis } })
        toast.success(`Usuário ${nome.trim()} criado.`)
      }

      await queryClient.invalidateQueries({ queryKey: getListarUsuariosQueryKey() })
      onFechar()
    } catch (erro) {
      setFalha(falhaDe(erro))
    }
  }

  const erroPerfis = erroDoCampo(falha, 'perfis')

  return (
    <Dialog open onOpenChange={(aberto) => !aberto && onFechar()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{usuario ? 'Editar usuário' : 'Novo usuário'}</DialogTitle>
          <DialogDescription>
            {usuario ? usuario.email : 'O usuário entra com este e-mail e esta senha.'}
          </DialogDescription>
        </DialogHeader>
        <form id="formulario-usuario" className="flex flex-col gap-4" noValidate onSubmit={(e) => void enviar(e)}>
          <Campo
            id="usuario-nome"
            rotulo="Nome"
            value={nome}
            onChange={(e) => setNome(e.target.value)}
            erro={erroDoCampo(falha, 'nome')}
          />
          {!usuario && (
            <>
              <Campo
                id="usuario-email"
                rotulo="E-mail"
                type="email"
                autoComplete="off"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                erro={erroDoCampo(falha, 'email')}
              />
              <Campo
                id="usuario-senha"
                rotulo="Senha inicial"
                type="password"
                autoComplete="new-password"
                value={senha}
                onChange={(e) => setSenha(e.target.value)}
                erro={erroDoCampo(falha, 'senha')}
              />
            </>
          )}
          <fieldset className="flex flex-col gap-2" aria-describedby={erroPerfis ? 'usuario-perfis-erro' : undefined}>
            <legend className="mb-2 text-sm font-medium">Perfis</legend>
            {(perfisDisponiveis.data ?? []).map((perfil) => (
              <div key={perfil} className="flex items-center gap-2">
                <Checkbox
                  id={`perfil-${perfil}`}
                  checked={perfis.includes(perfil)}
                  onCheckedChange={(marcado) => alternarPerfil(perfil, marcado === true)}
                />
                <Label htmlFor={`perfil-${perfil}`} className="font-normal">
                  {perfil}
                </Label>
              </div>
            ))}
            {erroPerfis && (
              <p id="usuario-perfis-erro" className="text-sm text-destructive">
                {erroPerfis}
              </p>
            )}
          </fieldset>
          {falha && (
            <p role="alert" className="text-sm text-destructive">
              {falha.mensagem}
            </p>
          )}
        </form>
        <DialogFooter>
          <Button variant="outline" onClick={onFechar}>
            Cancelar
          </Button>
          <Button type="submit" form="formulario-usuario" disabled={enviando}>
            {enviando ? 'Salvando…' : 'Salvar'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
