import { useQueryClient } from '@tanstack/react-query'
import { type FormEvent, useState } from 'react'
import { Link } from 'react-router'
import { toast } from 'sonner'
import { erroDoCampo, type Falha, falhaDe } from '@/api/falha'
import {
  getListarEnderecosQueryKey,
  useAtualizarEndereco,
  useBloquearEndereco,
  useDesbloquearEndereco,
  useExcluirEndereco,
} from '@/api/gerado/stowise'
import type { EnderecoDetalhe } from '@/api/gerado/modelos'
import { Campo } from '@/components/Campo'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { PERFIS_GESTAO, useAuth } from '@/features/auth/contexto'
import { formatarNumero } from '@/lib/numeros'
import { CAMPOS_DIMENSOES, dimensoesDe, ehFalha, numerosDe } from './dimensoes'
import { getMapaEnderecosQueryKey, ROTULO_STATUS, TOM_STATUS } from './mapa'
import { Situacao } from '@/components/Situacao'

type Modo = 'ver' | 'bloquear' | 'editar'

interface Props {
  endereco: EnderecoDetalhe
  onFechar: () => void
}

/**
 * Detalhe de um endereço. Qualquer perfil bloqueia (ex.: avaria vista na operação), com motivo. Desbloquear, mudar as
 * dimensões e excluir são da gestão (Admin e Gestor).
 */
export function DetalheEndereco({ endereco, onFechar }: Props) {
  const queryClient = useQueryClient()
  const { temPerfil } = useAuth()
  const gestao = temPerfil(...PERFIS_GESTAO)
  const [modo, setModo] = useState<Modo>('ver')
  const [motivo, setMotivo] = useState('')
  const [dimensoes, setDimensoes] = useState(() => dimensoesDe(endereco))
  const [falha, setFalha] = useState<Falha | null>(null)
  const [confirmarExclusao, setConfirmarExclusao] = useState(false)
  const bloquear = useBloquearEndereco()
  const desbloquear = useDesbloquearEndereco()
  const atualizar = useAtualizarEndereco()
  const excluir = useExcluirEndereco()
  const ocupado = bloquear.isPending || desbloquear.isPending || atualizar.isPending || excluir.isPending

  async function executar(acao: () => Promise<unknown>, sucesso: string) {
    setFalha(null)
    try {
      await acao()
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: getMapaEnderecosQueryKey(endereco.zonaId) }),
        queryClient.invalidateQueries({ queryKey: getListarEnderecosQueryKey() }),
      ])
      toast.success(sucesso)
      onFechar()
    } catch (erro) {
      setFalha(falhaDe(erro))
    }
  }

  function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault()
    if (modo === 'bloquear') {
      void executar(
        () => bloquear.mutateAsync({ id: endereco.id, data: { motivo: motivo.trim() || null } }),
        `${endereco.codigo} bloqueado.`,
      )
      return
    }

    const numeros = numerosDe(dimensoes)
    if (ehFalha(numeros)) {
      setFalha(numeros)
      return
    }

    void executar(() => atualizar.mutateAsync({ id: endereco.id, data: numeros }), `${endereco.codigo} atualizado.`)
  }

  return (
    <Dialog open onOpenChange={(aberto) => !aberto && onFechar()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle className="font-mono">{endereco.codigo}</DialogTitle>
          <DialogDescription>
            Rua {endereco.rua}, módulo {endereco.modulo}, nível {endereco.nivel}, posição {endereco.posicao}.
          </DialogDescription>
        </DialogHeader>

        {modo === 'ver' && (
          <dl className="grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
            <dt className="text-muted-foreground">Situação</dt>
            <dd>
              <Situacao tom={TOM_STATUS[endereco.status]}>{ROTULO_STATUS[endereco.status]}</Situacao>
            </dd>
            {endereco.motivoBloqueio && (
              <>
                <dt className="text-muted-foreground">Motivo do bloqueio</dt>
                <dd>{endereco.motivoBloqueio}</dd>
              </>
            )}
            <dt className="text-muted-foreground">Capacidade</dt>
            <dd>{formatarNumero(endereco.capacidadePesoKg, 'kg')}</dd>
            <dt className="text-muted-foreground">Dimensões (A × L × P)</dt>
            <dd>
              {formatarNumero(endereco.alturaCm)} × {formatarNumero(endereco.larguraCm)} ×{' '}
              {formatarNumero(endereco.profundidadeCm, 'cm')}
            </dd>
            <dt className="text-muted-foreground">Distância da expedição</dt>
            <dd>{formatarNumero(endereco.distanciaExpedicao, 'm')}</dd>
          </dl>
        )}

        {modo !== 'ver' && (
          <form id="formulario-endereco" className="flex flex-col gap-4" noValidate onSubmit={enviar}>
            {modo === 'bloquear' ? (
              <Campo
                id="motivo-bloqueio"
                rotulo="Motivo do bloqueio"
                value={motivo}
                onChange={(e) => setMotivo(e.target.value)}
                erro={erroDoCampo(falha, 'motivo')}
              />
            ) : (
              <div className="grid gap-4 sm:grid-cols-2">
                {[...CAMPOS_DIMENSOES, ['distanciaExpedicao', 'Distância da expedição (m)'] as const].map(
                  ([nome, rotulo]) => (
                    <Campo
                      key={nome}
                      id={`endereco-${nome}`}
                      rotulo={rotulo}
                      inputMode="decimal"
                      value={dimensoes[nome]}
                      onChange={(e) => setDimensoes({ ...dimensoes, [nome]: e.target.value })}
                      erro={erroDoCampo(falha, nome)}
                    />
                  ),
                )}
              </div>
            )}
          </form>
        )}

        {falha && (
          <p role="alert" className="text-sm text-destructive">
            {falha.mensagem}
          </p>
        )}

        <DialogFooter className="flex-wrap gap-2 sm:justify-between">
          {modo === 'ver' ? (
            <>
              <span className="flex gap-2">
                <Button variant="outline" size="sm" asChild>
                  <Link to={`/estoque?enderecoId=${endereco.id}`}>Ver saldo</Link>
                </Button>
                <Button variant="outline" size="sm" asChild>
                  <Link to={`/estoque/extrato?enderecoId=${endereco.id}`}>Ver extrato</Link>
                </Button>
              </span>
              <span className="flex flex-wrap gap-2">
                {endereco.status === 'Bloqueado'
                  ? gestao && (
                      <Button
                        size="sm"
                        disabled={ocupado}
                        onClick={() =>
                          void executar(
                            () => desbloquear.mutateAsync({ id: endereco.id }),
                            `${endereco.codigo} desbloqueado.`,
                          )
                        }
                      >
                        Desbloquear
                      </Button>
                    )
                  : (
                      <Button size="sm" variant="outline" onClick={() => setModo('bloquear')}>
                        Bloquear
                      </Button>
                    )}
                {gestao && (
                  <>
                    <Button size="sm" variant="outline" onClick={() => setModo('editar')}>
                      Editar dimensões
                    </Button>
                    <Button
                      size="sm"
                      variant="destructive"
                      disabled={ocupado}
                      onClick={() =>
                        confirmarExclusao
                          ? void executar(() => excluir.mutateAsync({ id: endereco.id }), `${endereco.codigo} excluído.`)
                          : setConfirmarExclusao(true)
                      }
                    >
                      {confirmarExclusao ? 'Confirmar a exclusão' : 'Excluir'}
                    </Button>
                  </>
                )}
              </span>
            </>
          ) : (
            <>
              <Button variant="outline" onClick={() => setModo('ver')}>
                Voltar
              </Button>
              <Button type="submit" form="formulario-endereco" disabled={ocupado}>
                {modo === 'bloquear' ? 'Bloquear' : 'Salvar'}
              </Button>
            </>
          )}
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
