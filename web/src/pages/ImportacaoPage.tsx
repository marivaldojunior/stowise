import { useQueryClient } from '@tanstack/react-query'
import { ArrowLeft, Check, Loader2, Sparkles } from 'lucide-react'
import { useState } from 'react'
import { Link, useParams } from 'react-router'
import { toast } from 'sonner'
import { type Falha, falhaDe } from '@/api/falha'
import {
  getListarImportacoesQueryKey,
  getObterImportacaoQueryKey,
  useConfirmarMapeamentoImportacao,
  useListarCamposImportacaoProdutos,
  useObterImportacao,
  useSugerirMapeamentoImportacao,
} from '@/api/gerado/stowise'
import type { ImportacaoDetalhe, StatusImportacao } from '@/api/gerado/modelos'
import { HttpError } from '@/api/mutator'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { Amostra } from '@/features/importacoes/Amostra'
import { RevisaoMapeamento } from '@/features/importacoes/RevisaoMapeamento'
import { emAndamento, ETAPAS, ROTULO_STATUS_IMPORTACAO } from '@/features/importacoes/rotulos'
import { cn } from '@/lib/utils'

/** Consulta periódica enquanto um job trabalha (reserva do tempo real). */
const INTERVALO_CONSULTA_MS = 3_000

function Etapas({ status }: { status: StatusImportacao }) {
  const atual = ETAPAS.findIndex((etapa) => (etapa.status as readonly StatusImportacao[]).includes(status))
  const concluida = status === 'Concluido'

  return (
    <ol className="flex flex-wrap gap-2 text-sm" aria-label="Etapas da importação">
      {ETAPAS.map((etapa, indice) => {
        const feita = indice < atual || concluida
        const ativa = indice === atual && !concluida
        return (
          <li
            key={etapa.rotulo}
            aria-current={ativa ? 'step' : undefined}
            className={cn(
              'flex items-center gap-1.5 rounded-full border px-3 py-1',
              ativa && 'border-primary font-medium',
              feita && 'text-muted-foreground',
            )}
          >
            {feita && <Check className="size-3.5" aria-hidden />}
            {indice + 1}. {etapa.rotulo}
          </li>
        )
      })}
    </ol>
  )
}

function Aguardando({ texto }: { texto: string }) {
  return (
    <p role="status" className="flex items-center gap-2 rounded-md border p-4 text-sm">
      <Loader2 className="size-4 animate-spin" aria-hidden />
      {texto}
    </p>
  )
}

/** Mapeamento: pedir a sugestão da IA (se ainda não veio) e revisar campo a campo antes de confirmar. */
function EtapaMapeamento({ importacao }: { importacao: ImportacaoDetalhe }) {
  const queryClient = useQueryClient()
  const campos = useListarCamposImportacaoProdutos()
  const sugerir = useSugerirMapeamentoImportacao()
  const confirmar = useConfirmarMapeamentoImportacao()
  const [falha, setFalha] = useState<Falha | null>(null)
  const [conflito, setConflito] = useState(false)

  function guardar(atualizada: ImportacaoDetalhe) {
    queryClient.setQueryData(getObterImportacaoQueryKey(atualizada.id), atualizada)
    void queryClient.invalidateQueries({ queryKey: getListarImportacoesQueryKey() })
  }

  function tratarErro(erro: unknown) {
    setFalha(falhaDe(erro))
    setConflito(erro instanceof HttpError && erro.status === 409)
  }

  async function pedirSugestao() {
    setFalha(null)
    try {
      guardar(await sugerir.mutateAsync({ id: importacao.id, data: { versao: importacao.versao } }))
    } catch (erro) {
      tratarErro(erro)
    }
  }

  if (campos.isPending) {
    return <Skeleton className="h-40 w-full" role="status" aria-label="Carregando os campos" />
  }

  return (
    <div className="flex flex-col gap-6">
      {importacao.status === 'Recebido' && (
        <div className="flex flex-wrap items-center gap-3 rounded-md border p-3 text-sm">
          <span className="flex-1">
            {importacao.motivoSemSugestao ?? 'Faça o mapeamento abaixo ou peça uma sugestão à IA.'}
          </span>
          <Button variant="outline" size="sm" disabled={sugerir.isPending} onClick={() => void pedirSugestao()}>
            <Sparkles /> Pedir sugestão à IA
          </Button>
        </div>
      )}
      {conflito && (
        <div role="alert" className="flex flex-wrap items-center gap-3 rounded-md border border-destructive p-3 text-sm">
          <span>Outra pessoa alterou esta importação. Carregue a versão atual.</span>
          <Button
            size="sm"
            variant="outline"
            onClick={() => {
              setConflito(false)
              setFalha(null)
              void queryClient.invalidateQueries({ queryKey: getObterImportacaoQueryKey(importacao.id) })
            }}
          >
            Carregar a versão atual
          </Button>
        </div>
      )}
      <Amostra importacao={importacao} />
      <RevisaoMapeamento
        // Recria o formulário quando chega uma versão nova (ex.: a sugestão da IA).
        key={importacao.versao}
        importacao={importacao}
        campos={campos.data ?? []}
        falha={conflito ? null : falha}
        enviando={confirmar.isPending}
        onConfirmar={(comando) => {
          setFalha(null)
          confirmar
            .mutateAsync({ id: importacao.id, data: { ...comando, versao: importacao.versao } })
            .then((atualizada) => {
              guardar(atualizada)
              toast.success('Mapeamento confirmado. A validação das linhas começou.')
            })
            .catch(tratarErro)
        }}
      />
    </div>
  )
}

/** /importacoes/:id: o fluxo da importação, etapa por etapa. */
export function ImportacaoPage() {
  const { id = '' } = useParams()
  const importacao = useObterImportacao(id, {
    query: { refetchInterval: (query) => (query.state.data && emAndamento(query.state.data.status) ? INTERVALO_CONSULTA_MS : false) },
  })

  if (importacao.isPending) {
    return <Skeleton className="h-8 w-64" role="status" aria-label="Carregando a importação" />
  }

  if (importacao.isError) {
    return (
      <p role="alert" className="text-destructive">
        {falhaDe(importacao.error).mensagem}
      </p>
    )
  }

  const atual = importacao.data
  return (
    <section className="flex flex-col gap-6">
      <Button variant="ghost" size="sm" asChild className="self-start">
        <Link to="/importacoes">
          <ArrowLeft /> Importações
        </Link>
      </Button>
      <div className="flex flex-col gap-3">
        <div className="flex flex-wrap items-center gap-3">
          <h1 className="text-2xl font-semibold tracking-tight">{atual.nomeArquivo}</h1>
          <Badge variant={atual.status === 'Falhou' ? 'destructive' : 'secondary'}>
            {ROTULO_STATUS_IMPORTACAO[atual.status]}
          </Badge>
        </div>
        {atual.status !== 'Falhou' && <Etapas status={atual.status} />}
      </div>

      {atual.status === 'Falhou' && (
        <p role="alert" className="rounded-md border border-destructive p-4 text-sm">
          A importação falhou: {atual.motivoFalha ?? 'motivo não informado.'}
        </p>
      )}
      {atual.status === 'Mapeando' && <Aguardando texto="A IA está sugerindo o mapeamento das colunas…" />}
      {(atual.status === 'Recebido' || atual.status === 'AguardandoConfirmacao') && (
        <EtapaMapeamento importacao={atual} />
      )}
      {atual.status === 'Validando' && <Aguardando texto="Validando as linhas do arquivo…" />}
    </section>
  )
}
