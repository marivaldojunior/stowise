import { useQueryClient } from '@tanstack/react-query'
import { Check, Loader2, Sparkles } from 'lucide-react'
import { useState } from 'react'
import { useParams } from 'react-router'
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
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { formatarNumero } from '@/lib/numeros'
import { Amostra } from '@/features/importacoes/Amostra'
import { Previa } from '@/features/importacoes/Previa'
import { useProgressoImportacao } from '@/features/importacoes/progresso'
import { RevisaoMapeamento } from '@/features/importacoes/RevisaoMapeamento'
import { emAndamento, ETAPAS, ROTULO_STATUS_IMPORTACAO, TOM_STATUS_IMPORTACAO } from '@/features/importacoes/rotulos'
import { cn } from '@/lib/utils'
import { Situacao } from '@/components/Situacao'
import { CabecalhoPagina } from '@/components/CabecalhoPagina'
import { Alerta } from '@/components/Alerta'
import { formatarDataHora } from '@/features/estoque/formato'

const VOLTAR = { para: '/importacoes', rotulo: 'Importações' }

/** Consulta periódica enquanto um job trabalha, quando o tempo real (SignalR) não está conectado. */
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
              ativa && 'border-transparent bg-grade-marca font-medium text-primary-foreground brilho-marca',
              feita && 'border-success/40 text-success',
              !ativa && !feita && 'text-muted-foreground',
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

function Aguardando({ texto, importacao }: { texto: string; importacao?: ImportacaoDetalhe }) {
  const total = importacao?.totalLinhas ?? 0
  const feitas = Math.min(importacao?.linhasProcessadas ?? 0, total)
  const percentual = total === 0 ? 0 : Math.round((feitas / total) * 100)

  return (
    <div role="status" className="flex flex-col gap-3 rounded-xl border border-info/30 bg-info/5 p-4 text-sm">
      <p className="flex items-center gap-2">
        <Loader2 className="size-4 animate-spin text-info" aria-hidden />
        {texto}
      </p>
      {importacao && (
        <>
          <div
            role="progressbar"
            aria-label="Progresso"
            aria-valuemin={0}
            aria-valuemax={100}
            aria-valuenow={percentual}
            className="h-2 overflow-hidden rounded-full bg-muted"
          >
            <div className="h-full bg-primary transition-[width]" style={{ width: `${percentual}%` }} />
          </div>
          <p className="text-muted-foreground tabular-nums">
            {formatarNumero(feitas)} de {formatarNumero(total)} linha(s) · {percentual}%
          </p>
        </>
      )}
    </div>
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
        <Alerta
          tom="info"
          acao={
            <Button variant="ia" size="sm" disabled={sugerir.isPending} onClick={() => void pedirSugestao()}>
              <Sparkles /> Pedir sugestão à IA
            </Button>
          }
        >
          {importacao.motivoSemSugestao ?? 'Faça o mapeamento abaixo ou peça uma sugestão à IA.'}
        </Alerta>
      )}
      {conflito && (
        <Alerta
          tom="aviso"
          acao={
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
          }
        >
          Outra pessoa alterou esta importação. Carregue a versão atual.
        </Alerta>
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
  const [acompanhar, setAcompanhar] = useState(false)
  const tempoReal = useProgressoImportacao(id, acompanhar)
  const importacao = useObterImportacao(id, {
    query: {
      // Sem tempo real (hub fora do ar), a tela consulta a API de tempos em tempos enquanto o job trabalha.
      refetchInterval: (query) =>
        query.state.data && emAndamento(query.state.data.status) && !tempoReal ? INTERVALO_CONSULTA_MS : false,
    },
  })
  const andamento = importacao.data ? emAndamento(importacao.data.status) : false
  if (andamento !== acompanhar) {
    setAcompanhar(andamento)
  }

  if (importacao.isPending) {
    return <Skeleton className="h-8 w-64" role="status" aria-label="Carregando a importação" />
  }

  if (importacao.isError) {
    return (
      <section className="flex flex-col gap-4">
        <CabecalhoPagina titulo="Importação" voltar={VOLTAR} />
        <Alerta tom="erro">{falhaDe(importacao.error).mensagem}</Alerta>
      </section>
    )
  }

  const atual = importacao.data
  return (
    <section className="flex flex-col gap-6">
      <CabecalhoPagina
        voltar={VOLTAR}
        titulo={atual.nomeArquivo}
        descricao={
          <span className="flex flex-wrap items-center gap-2">
            <Situacao tom={TOM_STATUS_IMPORTACAO[atual.status]}>{ROTULO_STATUS_IMPORTACAO[atual.status]}</Situacao>
            <span>Enviado em {formatarDataHora(atual.iniciadoEm)}</span>
          </span>
        }
      />
      {atual.status !== 'Falhou' && <Etapas status={atual.status} />}

      {atual.status === 'Falhou' && (
        <Alerta tom="erro">A importação falhou: {atual.motivoFalha ?? 'motivo não informado.'}</Alerta>
      )}
      {atual.status === 'Mapeando' && <Aguardando texto="A IA está sugerindo o mapeamento das colunas…" />}
      {(atual.status === 'Recebido' || atual.status === 'AguardandoConfirmacao') && (
        <EtapaMapeamento importacao={atual} />
      )}
      {atual.status === 'Validando' && <Aguardando texto="Validando as linhas do arquivo…" importacao={atual} />}
      {atual.status === 'Efetivando' && (
        <Aguardando texto="Gravando os produtos no catálogo…" importacao={atual} />
      )}
      {(atual.status === 'AguardandoRevisao' || atual.status === 'Concluido') && <Previa importacao={atual} />}
    </section>
  )
}
