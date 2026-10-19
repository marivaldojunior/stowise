import { ArrowRight, Boxes, FileUp, Layers, type LucideIcon, Package, Plus, Warehouse } from 'lucide-react'
import type { ReactNode } from 'react'
import { Link } from 'react-router'
import {
  useListarArmazens,
  useListarEnderecos,
  useListarImportacoes,
  useListarProdutos,
  useListarSaldos,
  useObterExtrato,
} from '@/api/gerado/stowise'
import { CabecalhoPagina } from '@/components/CabecalhoPagina'
import { Painel } from '@/components/Painel'
import { Situacao } from '@/components/Situacao'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { PERFIS_GESTAO, useAuth } from '@/features/auth/contexto'
import { formatarDataHora, ROTULO_MOVIMENTACAO, sinal } from '@/features/estoque/formato'
import { formatarNumero } from '@/lib/numeros'
import { cn } from '@/lib/utils'
import { useStatusApi } from '../features/status/useStatusApi'

/** Situação da API e do banco (health check), num selo pequeno. */
function StatusApi() {
  const { data, isPending, isError, error } = useStatusApi()

  if (isPending) {
    return (
      <div role="status" aria-label="Verificando a API" className="flex items-center gap-2">
        <Skeleton className="h-5 w-24" />
        <span className="sr-only">Verificando a API…</span>
      </div>
    )
  }

  if (isError) {
    return (
      <p role="status" className="flex flex-wrap items-center gap-2 text-sm">
        <Situacao tom="perigo">Indisponível</Situacao>
        <span>API indisponível: {error.message}</span>
      </p>
    )
  }

  const disponivel = data.status === 'Healthy'
  return (
    <p role="status" className="flex flex-wrap items-center gap-2 text-sm text-muted-foreground">
      <Situacao tom={disponivel ? 'sucesso' : 'aviso'}>{disponivel ? 'Disponível' : data.status}</Situacao>
      <span>{disponivel ? 'API e banco disponíveis.' : `API com problema (${data.status}).`}</span>
    </p>
  )
}

interface PropsIndicador {
  rotulo: string
  valor: number | undefined
  formato?: (valor: number) => string
  detalhe?: ReactNode
  icone: LucideIcon
  para: string
  destaque?: boolean
}

/** Número principal com atalho para a tela de detalhe. */
function Indicador({ rotulo, valor, formato = (v) => formatarNumero(v), detalhe, icone: Icone, para, destaque }: PropsIndicador) {
  return (
    <Link
      to={para}
      className={cn(
        'group flex flex-col gap-2 rounded-xl border bg-card p-3 transition-colors sm:gap-3 sm:p-4 hover:border-primary/40 hover:bg-primary/5',
        destaque && 'border-warning/40 bg-warning/5',
      )}
    >
      <span className="flex items-start justify-between gap-2 text-sm text-muted-foreground">
        {rotulo}
        <Icone className="size-4" aria-hidden />
      </span>
      {valor === undefined ? (
        <Skeleton className="h-8 w-20" />
      ) : (
        <span className="text-2xl font-semibold tracking-tight tabular-nums sm:text-3xl">{formato(valor)}</span>
      )}
      <span className="flex items-center justify-between text-xs text-muted-foreground">
        {detalhe ?? <span />}
        <ArrowRight className="size-3.5 opacity-0 transition-opacity group-hover:opacity-100" aria-hidden />
      </span>
    </Link>
  )
}

function UltimasMovimentacoes() {
  const extrato = useObterExtrato({ pagina: 1, tamanhoPagina: 6 })

  return (
    <Painel
      titulo="Últimas movimentações"
      acoes={
        <Button variant="ghost" size="sm" asChild>
          <Link to="/estoque/extrato">
            Ver extrato <ArrowRight />
          </Link>
        </Button>
      }
    >
      {extrato.isPending ? (
        <Skeleton className="h-24 w-full" />
      ) : extrato.isError || extrato.data.itens.length === 0 ? (
        <p className="text-sm text-muted-foreground">Nenhuma movimentação registrada.</p>
      ) : (
        <ul className="flex flex-col divide-y">
          {extrato.data.itens.map((item) => {
            const sentido = sinal(item)
            return (
              <li key={item.id} className="flex items-center gap-3 py-2 text-sm">
                <span className="w-20 shrink-0 truncate text-muted-foreground sm:w-24">{ROTULO_MOVIMENTACAO[item.tipo]}</span>
                <span className="min-w-0 flex-1 truncate">
                  <span className="font-mono text-xs">{item.sku}</span>
                  <span className="text-muted-foreground">
                    {' '}
                    · {item.enderecoOrigemCodigo ?? '—'} → {item.enderecoDestinoCodigo ?? '—'}
                  </span>
                </span>
                <span
                  className={cn(
                    'font-medium tabular-nums',
                    sentido === '+' && 'text-success',
                    sentido === '−' && 'text-destructive',
                  )}
                >
                  {sentido === '↔' ? '' : sentido}
                  {formatarNumero(item.quantidade)}
                </span>
                <span className="hidden w-32 shrink-0 text-right text-xs text-muted-foreground sm:inline">
                  {formatarDataHora(item.ocorridoEm)}
                </span>
              </li>
            )
          })}
        </ul>
      )}
    </Painel>
  )
}

function AtalhosGestao() {
  const atalhos = [
    ['/catalogo/novo', 'Novo produto', Plus],
    ['/importacoes', 'Importar produtos de um arquivo', FileUp],
    ['/enderecos', 'Gerar endereços em lote', Layers],
  ] as const

  return (
    <Painel titulo="Atalhos">
      <ul className="flex flex-col gap-1">
        {atalhos.map(([para, rotulo, Icone]) => (
          <li key={para}>
            <Link to={para} className="flex items-center gap-3 rounded-md px-2 py-2 text-sm hover:bg-muted">
              <span className="flex size-8 items-center justify-center rounded-md bg-primary/10 text-primary">
                <Icone className="size-4" aria-hidden />
              </span>
              {rotulo}
            </Link>
          </li>
        ))}
      </ul>
    </Painel>
  )
}

/** Página inicial: indicadores da operação, últimas movimentações e atalhos. */
export function InicioPage() {
  const { usuario, temPerfil } = useAuth()
  const gestao = temPerfil(...PERFIS_GESTAO)
  const produtos = useListarProdutos({ ativo: true, pagina: 1, tamanhoPagina: 1 })
  const armazens = useListarArmazens()
  const ocupados = useListarEnderecos({ status: 'Ocupado', pagina: 1, tamanhoPagina: 1 })
  const saldos = useListarSaldos({ pagina: 1, tamanhoPagina: 1 })
  const confirmar = useListarImportacoes(
    { status: 'AguardandoConfirmacao', pagina: 1, tamanhoPagina: 1 },
    { query: { enabled: gestao } },
  )
  const revisar = useListarImportacoes(
    { status: 'AguardandoRevisao', pagina: 1, tamanhoPagina: 1 },
    { query: { enabled: gestao } },
  )
  const totalEnderecos = armazens.data?.reduce((soma, a) => soma + a.enderecos, 0)
  const ocupacao =
    totalEnderecos === undefined || ocupados.data === undefined
      ? undefined
      : totalEnderecos === 0
        ? 0
        : Math.round((ocupados.data.total / totalEnderecos) * 100)
  const pendentes =
    confirmar.data && revisar.data ? confirmar.data.total + revisar.data.total : undefined
  const primeiroNome = usuario?.nome.split(' ')[0]

  return (
    <section className="flex flex-col gap-6">
      <CabecalhoPagina
        titulo={primeiroNome ? `Olá, ${primeiroNome}` : 'Stowise'}
        tituloAba="Início"
        descricao="Inventário e armazenagem com IA. Resumo da operação."
        acoes={<StatusApi />}
      />

      <div className="grid grid-cols-2 gap-3 lg:grid-cols-4 lg:gap-4">
        <Indicador rotulo="Produtos ativos" valor={produtos.data?.total} icone={Package} para="/catalogo" />
        <Indicador
          rotulo="Ocupação dos endereços"
          valor={ocupacao}
          formato={(v) => `${v}%`}
          detalhe={
            totalEnderecos !== undefined && ocupados.data
              ? `${formatarNumero(ocupados.data.total)} de ${formatarNumero(totalEnderecos)}`
              : undefined
          }
          icone={Warehouse}
          para="/enderecos"
        />
        <Indicador
          rotulo="Posições com saldo"
          valor={saldos.data?.total}
          detalhe="endereço, produto e lote"
          icone={Boxes}
          para="/estoque"
        />
        {gestao && (
          <Indicador
            rotulo="Importações aguardando você"
            valor={pendentes}
            detalhe="confirmar o mapeamento ou revisar"
            icone={FileUp}
            para="/importacoes"
            destaque={(pendentes ?? 0) > 0}
          />
        )}
      </div>

      <div className={cn('grid gap-4', gestao && 'lg:grid-cols-[2fr_1fr]')}>
        <UltimasMovimentacoes />
        {gestao && <AtalhosGestao />}
      </div>
    </section>
  )
}
