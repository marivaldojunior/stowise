import { type FormEvent, useState } from 'react'
import { toast } from 'sonner'
import { erroDoCampo, type Falha, falhaDe } from '@/api/falha'
import { useRedefinirSenhaUsuario } from '@/api/gerado/stowise'
import type { UsuarioDetalhe } from '@/api/gerado/modelos'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { Campo } from './Campo'

/** O Admin define uma senha nova para o usuário. A API encerra as sessões abertas dele. */
export function RedefinirSenha({ usuario, onFechar }: { usuario: UsuarioDetalhe; onFechar: () => void }) {
  const redefinir = useRedefinirSenhaUsuario()
  const [novaSenha, setNovaSenha] = useState('')
  const [falha, setFalha] = useState<Falha | null>(null)

  async function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault()
    setFalha(null)
    try {
      await redefinir.mutateAsync({ id: usuario.id, data: { novaSenha } })
      toast.success(`Senha de ${usuario.nome} redefinida.`)
      onFechar()
    } catch (erro) {
      setFalha(falhaDe(erro))
    }
  }

  return (
    <Dialog open onOpenChange={(aberto) => !aberto && onFechar()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Redefinir a senha</DialogTitle>
          <DialogDescription>
            {usuario.nome} ({usuario.email}) vai entrar com a senha nova. As sessões abertas terminam.
          </DialogDescription>
        </DialogHeader>
        <form id="formulario-senha" className="flex flex-col gap-4" noValidate onSubmit={(e) => void enviar(e)}>
          <Campo
            id="nova-senha"
            rotulo="Nova senha"
            type="password"
            autoComplete="new-password"
            value={novaSenha}
            onChange={(e) => setNovaSenha(e.target.value)}
            erro={erroDoCampo(falha, 'novaSenha')}
          />
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
          <Button type="submit" form="formulario-senha" disabled={redefinir.isPending}>
            Redefinir
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
