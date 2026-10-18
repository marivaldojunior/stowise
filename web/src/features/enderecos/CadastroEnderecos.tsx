import { useQueryClient } from '@tanstack/react-query'
import { type FormEvent, useState } from 'react'
import { toast } from 'sonner'
import { erroDoCampo, type Falha, falhaDe } from '@/api/falha'
import { getListarEnderecosQueryKey, useCriarEndereco, useGerarEnderecos } from '@/api/gerado/stowise'
import type { GeracaoEnderecosResultado, GerarEnderecos, ZonaDetalhe } from '@/api/gerado/modelos'
import { Campo } from '@/components/Campo'
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
import { CAMPOS_DIMENSOES, ehFalha, numerosDe, textosDe } from './dimensoes'
import { getMapaEnderecosQueryKey } from './mapa'

interface Props {
  zona: ZonaDetalhe
  onFechar: () => void
}

function useAtualizarListas(zonaId: string) {
  const queryClient = useQueryClient()
  return () =>
    Promise.all([
      queryClient.invalidateQueries({ queryKey: getMapaEnderecosQueryKey(zonaId) }),
      queryClient.invalidateQueries({ queryKey: getListarEnderecosQueryKey() }),
    ])
}

const CAMPOS_POSICAO = [
  ['modulo', 'Módulo'],
  ['nivel', 'Nível'],
  ['posicao', 'Posição'],
] as const

/** Um endereço avulso na zona. */
export function NovoEndereco({ zona, onFechar }: Props) {
  const criar = useCriarEndereco()
  const atualizarListas = useAtualizarListas(zona.id)
  const [rua, setRua] = useState('')
  const [numeros, setNumeros] = useState(() =>
    textosDe([...CAMPOS_POSICAO.map(([n]) => n), ...CAMPOS_DIMENSOES.map(([n]) => n), 'distanciaExpedicao']),
  )
  const [falha, setFalha] = useState<Falha | null>(null)

  async function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault()
    setFalha(null)
    const convertidos = numerosDe(numeros)
    if (ehFalha(convertidos)) {
      setFalha(convertidos)
      return
    }

    try {
      const endereco = await criar.mutateAsync({
        data: { zonaId: zona.id, rua: rua.trim().toUpperCase(), ...convertidos },
      })
      await atualizarListas()
      toast.success(`Endereço ${endereco.codigo} criado.`)
      onFechar()
    } catch (erro) {
      setFalha(falhaDe(erro))
    }
  }

  const campo = (nome: keyof typeof numeros, rotulo: string) => (
    <Campo
      key={nome}
      id={`novo-${nome}`}
      rotulo={rotulo}
      inputMode="decimal"
      value={numeros[nome]}
      onChange={(e) => setNumeros({ ...numeros, [nome]: e.target.value })}
      erro={erroDoCampo(falha, nome)}
    />
  )

  return (
    <Dialog open onOpenChange={(aberto) => !aberto && onFechar()}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Novo endereço</DialogTitle>
          <DialogDescription>Zona {zona.codigo}.</DialogDescription>
        </DialogHeader>
        <form id="novo-endereco" className="flex flex-col gap-4" noValidate onSubmit={(e) => void enviar(e)}>
          <div className="grid gap-4 sm:grid-cols-4">
            <Campo
              id="novo-rua"
              rotulo="Rua"
              value={rua}
              onChange={(e) => setRua(e.target.value)}
              erro={erroDoCampo(falha, 'rua')}
            />
            {CAMPOS_POSICAO.map(([nome, rotulo]) => campo(nome, rotulo))}
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            {CAMPOS_DIMENSOES.map(([nome, rotulo]) => campo(nome, rotulo))}
            {campo('distanciaExpedicao', 'Distância da expedição (m)')}
          </div>
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
          <Button type="submit" form="novo-endereco" disabled={criar.isPending}>
            Criar
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

const CAMPOS_FAIXA = [
  ['moduloInicial', 'Módulo inicial'],
  ['moduloFinal', 'Módulo final'],
  ['nivelInicial', 'Nível inicial'],
  ['nivelFinal', 'Nível final'],
  ['posicaoInicial', 'Posição inicial'],
  ['posicaoFinal', 'Posição final'],
] as const

const CAMPOS_DISTANCIA = [
  ['distanciaBase', 'Distância base (m)'],
  ['distanciaPorModulo', 'Distância por módulo (m)'],
] as const

/**
 * Geração em lote: ruas × módulos × níveis × posições. Primeiro a API simula (total, amostra e códigos que já
 * existem); só depois da prévia o usuário confirma a criação.
 */
export function GerarEmLote({ zona, onFechar }: Props) {
  const gerar = useGerarEnderecos()
  const atualizarListas = useAtualizarListas(zona.id)
  const [ruas, setRuas] = useState('')
  const [numeros, setNumeros] = useState(() =>
    textosDe([...CAMPOS_FAIXA.map(([n]) => n), ...CAMPOS_DIMENSOES.map(([n]) => n), ...CAMPOS_DISTANCIA.map(([n]) => n)]),
  )
  const [ignorarExistentes, setIgnorarExistentes] = useState(true)
  const [previa, setPrevia] = useState<GeracaoEnderecosResultado | null>(null)
  const [falha, setFalha] = useState<Falha | null>(null)

  function comando(simular: boolean): GerarEnderecos | Falha {
    const convertidos = numerosDe(numeros)
    if (ehFalha(convertidos)) {
      return convertidos
    }

    const listaRuas = ruas
      .split(/[\s,;]+/)
      .map((rua) => rua.trim().toUpperCase())
      .filter(Boolean)
    return { zonaId: zona.id, ruas: listaRuas, ...convertidos, ignorarExistentes, simular }
  }

  async function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault()
    setFalha(null)
    const dados = comando(previa === null)
    if (ehFalha(dados)) {
      setFalha(dados)
      return
    }

    try {
      const resultado = await gerar.mutateAsync({ data: dados })
      if (resultado.simulado) {
        setPrevia(resultado)
        return
      }

      await atualizarListas()
      toast.success(`${resultado.criados} endereço(s) criado(s); ${resultado.ignorados} já existiam.`)
      onFechar()
    } catch (erro) {
      setPrevia(null)
      setFalha(falhaDe(erro))
    }
  }

  // Qualquer mudança no formulário invalida a prévia: a criação tem de corresponder ao que foi simulado.
  function mudar(acao: () => void) {
    acao()
    setPrevia(null)
  }

  const campo = (nome: keyof typeof numeros, rotulo: string) => (
    <Campo
      key={nome}
      id={`lote-${nome}`}
      rotulo={rotulo}
      inputMode="decimal"
      value={numeros[nome]}
      onChange={(e) => mudar(() => setNumeros({ ...numeros, [nome]: e.target.value }))}
      erro={erroDoCampo(falha, nome)}
    />
  )

  return (
    <Dialog open onOpenChange={(aberto) => !aberto && onFechar()}>
      <DialogContent className="max-h-[90svh] overflow-y-auto sm:max-w-2xl">
        <DialogHeader>
          <DialogTitle>Gerar endereços em lote</DialogTitle>
          <DialogDescription>Zona {zona.codigo}. Confira a prévia antes de criar.</DialogDescription>
        </DialogHeader>
        <form id="gerar-lote" className="flex flex-col gap-4" noValidate onSubmit={(e) => void enviar(e)}>
          <Campo
            id="lote-ruas"
            rotulo="Ruas (separadas por vírgula ou espaço)"
            placeholder="A, B, C"
            value={ruas}
            onChange={(e) => mudar(() => setRuas(e.target.value))}
            erro={erroDoCampo(falha, 'ruas')}
          />
          <div className="grid gap-4 sm:grid-cols-3">{CAMPOS_FAIXA.map(([nome, rotulo]) => campo(nome, rotulo))}</div>
          <div className="grid gap-4 sm:grid-cols-3">
            {CAMPOS_DIMENSOES.map(([nome, rotulo]) => campo(nome, rotulo))}
            {CAMPOS_DISTANCIA.map(([nome, rotulo]) => campo(nome, rotulo))}
          </div>
          <div className="flex items-center gap-2">
            <Checkbox
              id="lote-ignorar"
              checked={ignorarExistentes}
              onCheckedChange={(marcado) => mudar(() => setIgnorarExistentes(marcado === true))}
            />
            <Label htmlFor="lote-ignorar" className="font-normal">
              Pular os endereços que já existem
            </Label>
          </div>
          {previa && (
            <section aria-label="Prévia da geração" className="rounded-md border bg-muted/40 p-3 text-sm">
              <p className="font-medium">
                {previa.total} endereço(s) no lote: {previa.total - previa.codigosExistentes.length} novo(s),{' '}
                {previa.codigosExistentes.length} já existem.
              </p>
              <p className="mt-1 font-mono text-xs text-muted-foreground">
                {previa.amostra.join(' · ')}
                {previa.total > previa.amostra.length ? ' …' : ''}
              </p>
            </section>
          )}
          {falha && (
            <p role="alert" className="text-sm text-destructive">
              {erroDoCampo(falha, 'lote') ?? falha.mensagem}
            </p>
          )}
        </form>
        <DialogFooter>
          <Button variant="outline" onClick={onFechar}>
            Cancelar
          </Button>
          <Button type="submit" form="gerar-lote" disabled={gerar.isPending}>
            {previa ? `Criar ${previa.total - previa.codigosExistentes.length} endereço(s)` : 'Ver a prévia'}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
