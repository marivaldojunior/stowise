import { Pencil, Plus, Trash2 } from 'lucide-react'
import { type FormEvent, useState } from 'react'
import { toast } from 'sonner'
import { erroDoCampo, type Falha, falhaDe } from '@/api/falha'
import { useAdicionarEmbalagem, useAtualizarEmbalagem, useRemoverEmbalagem } from '@/api/gerado/stowise'
import type { EmbalagemDetalhe, ProdutoDetalhe, TipoEmbalagem } from '@/api/gerado/modelos'
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
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { CamposMedidas } from './CamposMedidas'
import { ehFalha, MEDIDAS_VAZIAS, type MedidasTexto, medidasDe, medidasParaApi } from './medidas'
import { ROTULO_EMBALAGEM } from './rotulos'
import { lerNumero } from '@/lib/numeros'
import { Painel } from '@/components/Painel'
import { Situacao } from '@/components/Situacao'

interface Props {
  produto: ProdutoDetalhe
  somenteLeitura: boolean
  /** Toda alteração de embalagem devolve o produto atualizado (com a versão nova). */
  onProduto: (produto: ProdutoDetalhe) => void
}

function numero(valor: number | null, sufixo: string): string {
  return valor === null ? '—' : `${valor.toLocaleString('pt-BR')} ${sufixo}`
}

function dimensoes(e: EmbalagemDetalhe): string {
  const medidas = [e.alturaCm, e.larguraCm, e.comprimentoCm]
  return medidas.every((m) => m === null)
    ? '—'
    : `${medidas.map((m) => (m === null ? '?' : m.toLocaleString('pt-BR'))).join(' × ')} cm`
}

type Dialogo = { tipo: 'nova' } | { tipo: 'editar'; embalagem: EmbalagemDetalhe } | null

/** Embalagens do produto: a da unidade base (fator 1, criada com o produto) e as caixas e paletes. */
export function Embalagens({ produto, somenteLeitura, onProduto }: Props) {
  const [dialogo, setDialogo] = useState<Dialogo>(null)
  const remover = useRemoverEmbalagem()

  async function removerEmbalagem(embalagem: EmbalagemDetalhe) {
    try {
      onProduto(await remover.mutateAsync({ id: produto.id, embalagemId: embalagem.id }))
      toast.success(`${ROTULO_EMBALAGEM[embalagem.tipo]} removida.`)
    } catch (erro) {
      toast.error(falhaDe(erro).mensagem)
    }
  }

  return (
    <Painel
      titulo="Embalagens"
      descricao="Unidade base e as caixas e paletes, com fator, código de barras e medidas."
      acoes={
        !somenteLeitura && (
          <Button variant="outline" size="sm" onClick={() => setDialogo({ tipo: 'nova' })}>
            <Plus /> Nova embalagem
          </Button>
        )
      }
    >
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Tipo</TableHead>
              <TableHead>Fator</TableHead>
              <TableHead>GTIN</TableHead>
              <TableHead>Peso</TableHead>
              <TableHead>Dimensões (A × L × C)</TableHead>
              {!somenteLeitura && (
                <TableHead className="w-24">
                  <span className="sr-only">Ações</span>
                </TableHead>
              )}
            </TableRow>
          </TableHeader>
          <TableBody>
            {produto.embalagens.map((embalagem) => (
              <TableRow key={embalagem.id}>
                <TableCell>
                  <span className="flex items-center gap-2">
                    {ROTULO_EMBALAGEM[embalagem.tipo]}
                    {embalagem.unidadeBase && <Situacao tom="marca">base</Situacao>}
                  </span>
                </TableCell>
                <TableCell>
                  {embalagem.fatorConversao.toLocaleString('pt-BR')} {produto.unidadeBase}
                </TableCell>
                <TableCell className="font-mono text-xs">{embalagem.gtin ?? '—'}</TableCell>
                <TableCell>{numero(embalagem.pesoKg, 'kg')}</TableCell>
                <TableCell>{dimensoes(embalagem)}</TableCell>
                {!somenteLeitura && (
                  <TableCell>
                    <span className="flex gap-1">
                      <Button
                        variant="ghost"
                        size="icon"
                        aria-label={`Editar ${ROTULO_EMBALAGEM[embalagem.tipo]} (fator ${embalagem.fatorConversao})`}
                        onClick={() => setDialogo({ tipo: 'editar', embalagem })}
                      >
                        <Pencil />
                      </Button>
                      {!embalagem.unidadeBase && (
                        <Button
                          variant="ghost"
                          size="icon"
                          aria-label={`Remover ${ROTULO_EMBALAGEM[embalagem.tipo]} (fator ${embalagem.fatorConversao})`}
                          disabled={remover.isPending}
                          onClick={() => void removerEmbalagem(embalagem)}
                        >
                          <Trash2 />
                        </Button>
                      )}
                    </span>
                  </TableCell>
                )}
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
      {dialogo && (
        <DialogoEmbalagem
          produto={produto}
          embalagem={dialogo.tipo === 'editar' ? dialogo.embalagem : undefined}
          onFechar={() => setDialogo(null)}
          onProduto={onProduto}
        />
      )}
    </Painel>
  )
}

interface PropsDialogo {
  produto: ProdutoDetalhe
  /** Sem embalagem, adiciona uma caixa ou palete; com embalagem, edita só as medidas (tipo e fator não mudam). */
  embalagem?: EmbalagemDetalhe
  onFechar: () => void
  onProduto: (produto: ProdutoDetalhe) => void
}

function DialogoEmbalagem({ produto, embalagem, onFechar, onProduto }: PropsDialogo) {
  const adicionar = useAdicionarEmbalagem()
  const atualizar = useAtualizarEmbalagem()
  const [tipo, setTipo] = useState<TipoEmbalagem>('Caixa')
  const [fator, setFator] = useState('')
  const [medidas, setMedidas] = useState<MedidasTexto>(embalagem ? medidasDe(embalagem) : MEDIDAS_VAZIAS)
  const [falha, setFalha] = useState<Falha | null>(null)

  async function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault()
    setFalha(null)
    const convertidas = medidasParaApi(medidas)
    if (ehFalha(convertidas)) {
      setFalha(convertidas)
      return
    }

    try {
      if (embalagem) {
        onProduto(await atualizar.mutateAsync({ id: produto.id, embalagemId: embalagem.id, data: convertidas }))
        toast.success('Medidas atualizadas.')
      } else {
        const fatorConversao = lerNumero(fator)
        onProduto(
          await adicionar.mutateAsync({
            id: produto.id,
            data: { tipo, fatorConversao: Number.isNaN(fatorConversao) ? null : fatorConversao, ...convertidas },
          }),
        )
        toast.success(`${ROTULO_EMBALAGEM[tipo]} adicionada.`)
      }

      onFechar()
    } catch (erro) {
      setFalha(falhaDe(erro))
    }
  }

  return (
    <Dialog open onOpenChange={(aberto) => !aberto && onFechar()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>{embalagem ? 'Editar embalagem' : 'Nova embalagem'}</DialogTitle>
          <DialogDescription>
            {embalagem
              ? `${ROTULO_EMBALAGEM[embalagem.tipo]} com ${embalagem.fatorConversao} ${produto.unidadeBase}.`
              : `Caixa ou palete de ${produto.descricao}.`}
          </DialogDescription>
        </DialogHeader>
        <form id="formulario-embalagem" className="flex flex-col gap-4" noValidate onSubmit={(e) => void enviar(e)}>
          {!embalagem && (
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="flex flex-col gap-2">
                <Label htmlFor="embalagem-tipo">Tipo</Label>
                <Select value={tipo} onValueChange={(valor) => setTipo(valor as TipoEmbalagem)}>
                  <SelectTrigger id="embalagem-tipo" className="w-full">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Caixa">Caixa</SelectItem>
                    <SelectItem value="Palete">Palete</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <Campo
                id="embalagem-fator"
                rotulo={`Quantidade de ${produto.unidadeBase}`}
                inputMode="decimal"
                value={fator}
                onChange={(e) => setFator(e.target.value)}
                erro={erroDoCampo(falha, 'fatorConversao')}
              />
            </div>
          )}
          <CamposMedidas idBase="embalagem" medidas={medidas} onMudar={setMedidas} falha={falha} />
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
          <Button type="submit" form="formulario-embalagem" disabled={adicionar.isPending || atualizar.isPending}>
            Salvar
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
