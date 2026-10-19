import { ArrowRight, Boxes, FileUp, Layers, type LucideIcon, Package, Plus, Sparkles, Warehouse } from 'lucide-react'
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
import { useTituloAba } from '@/lib/tituloAba'
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

type CorIndicador = 'marca' | 'ciano' | 'sinal' | 'ia'

/** Cada indicador tem a sua cor: operação (verde-azulado), espaço (ciano), estoque (âmbar) e IA (violeta). */
const CORES_INDICADOR: Record<CorIndicador, { icone: string; brilho: string; barra: string }> = {
  marca: { icone: 'bg-grade-marca text-primary-foreground', brilho: 'var(--primary)', barra: 'bg-grade-marca' },
  ciano: {
    icone: 'bg-[linear-gradient(135deg,var(--marca-2),var(--info))] text-white',
    brilho: 'var(--marca-2)',
    barra: 'bg-[linear-gradient(90deg,var(--marca-2),var(--info))]',
  },
  sinal: { icone: 'bg-grade-sinal text-sinal-foreground', brilho: 'var(--sinal)', barra: 'bg-grade-sinal' },
  ia: { icone: 'bg-grade-ia text-white', brilho: 'var(--ia)', barra: 'bg-grade-ia' },
}

interface PropsIndicador {
  rotulo: string
  valor: number | undefined
  formato?: (valor: number) => string
  detalhe?: ReactNode
  icone: LucideIcon
  para: string
  cor: CorIndicador
  /** Barra de 0 a 100 embaixo do número (ex.: ocupação). */
  progresso?: number
  destaque?: boolean
}

/** Número principal com atalho para a tela de detalhe. */
function Indicador({
  rotulo,
  valor,
  formato = (v) => formatarNumero(v),
  detalhe,
  icone: Icone,
  para,
  cor,
  progresso,
  destaque,
}: PropsIndicador) {
  const estilo = CORES_INDICADOR[cor]
  return (
    <Link
      to={para}
      className={cn(
        'group relative isolate flex flex-col gap-2 overflow-hidden rounded-2xl border border-border/70 bg-card p-3 sombra-cartao transition-all duration-300 sm:gap-3 sm:p-4',
        'hover:-translate-y-0.5 hover:sombra-elevada',
        destaque && 'ring-2 ring-sinal/60',
      )}
    >
      {/* Brilho da cor do indicador no canto. */}
      <span
        className="pointer-events-none absolute -top-10 -right-10 -z-10 size-32 rounded-full opacity-25 blur-2xl transition-opacity group-hover:opacity-40"
        style={{ background: estilo.brilho }}
        aria-hidden
      />
      <span className="flex items-start justify-between gap-2 text-sm text-muted-foreground">
        {rotulo}
        <span className={cn('flex size-9 shrink-0 items-center justify-center rounded-xl shadow-md', estilo.icone)}>
          <Icone className="size-4" aria-hidden />
        </span>
      </span>
      {valor === undefined ? (
        <Skeleton className="h-8 w-20" />
      ) : (
        <span className="text-2xl font-bold tracking-tight tabular-nums sm:text-3xl">{formato(valor)}</span>
      )}
      {progresso !== undefined && (
        <span className="h-1.5 overflow-hidden rounded-full bg-muted" aria-hidden>
          <span className={cn('block h-full rounded-full', estilo.barra)} style={{ width: `${progresso}%` }} />
        </span>
      )}
      <span className="flex items-center justify-between text-xs text-muted-foreground">
        {detalhe ?? <span />}
        <ArrowRight className="size-3.5 -translate-x-1 opacity-0 transition-all group-hover:translate-x-0 group-hover:opacity-100" aria-hidden />
      </span>
    </Link>
  )
}

/** Abertura da página: saudação sobre a planta do armazém, com etiquetas de endereço ao fundo. */
function Boasvindas({ titulo, children }: { titulo: string; children: ReactNode }) {
  return (
    <header className="relative isolate overflow-hidden rounded-3xl bg-grade-tinta p-5 text-white sombra-elevada sm:p-7">
      <div className="pointer-events-none absolute inset-0 -z-10 fundo-planta-clara" aria-hidden />
      {/* Etiquetas de prateleira, decorativas. */}
      <div className="pointer-events-none absolute top-5 right-5 -z-10 hidden flex-col items-end gap-2 opacity-80 md:flex" aria-hidden>
        {['A-01-1-1', 'B-03-2-1', 'F-01-1-1'].map((codigo, indice) => (
          <span
            key={codigo}
            className="flex items-center gap-2 rounded-md border border-white/15 bg-white/10 px-2 py-1 font-mono text-xs backdrop-blur"
            style={{ transform: `translateX(${indice * -14}px) rotate(${indice % 2 ? 2 : -2}deg)` }}
          >
            <span className="h-3 w-1 rounded-sm bg-sinal" />
            {codigo}
            <span className="h-3 w-10 codigo-de-barras text-white/60" />
          </span>
        ))}
      </div>
      <span className="mb-3 inline-flex items-center gap-1.5 rounded-full bg-white/10 px-2.5 py-1 text-xs text-white/85 ring-1 ring-white/15">
        <Sparkles className="size-3.5 text-[color:var(--ia-2)]" aria-hidden />
        Inventário e armazenagem com IA
      </span>
      <h1 className="text-3xl font-bold tracking-tight sm:text-4xl">{titulo}</h1>
      <div className="mt-2 max-w-xl text-sm text-white/75">{children}</div>
    </header>
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
              <li key={item.id} className="flex items-center gap-3 py-2.5 text-sm">
                <span className="flex w-24 shrink-0 items-center gap-2 truncate text-muted-foreground sm:w-28">
                  <span
                    className={cn(
                      'size-2 shrink-0 rounded-full',
                      sentido === '+' && 'bg-success',
                      sentido === '−' && 'bg-destructive',
                      sentido === '↔' && 'bg-info',
                    )}
                    aria-hidden
                  />
                  {ROTULO_MOVIMENTACAO[item.tipo]}
                </span>
                <span className="min-w-0 flex-1 truncate">
                  <span className="etiqueta">{item.sku}</span>
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
    ['/catalogo/novo', 'Novo produto', Plus, 'bg-grade-marca text-primary-foreground'],
    ['/importacoes', 'Importar produtos de um arquivo', FileUp, 'bg-grade-ia text-white'],
    ['/enderecos', 'Gerar endereços em lote', Layers, 'bg-grade-sinal text-sinal-foreground'],
  ] as const

  return (
    <Painel titulo="Atalhos">
      <ul className="flex flex-col gap-1">
        {atalhos.map(([para, rotulo, Icone, cor]) => (
          <li key={para}>
            <Link
              to={para}
              className="group flex items-center gap-3 rounded-xl px-2 py-2 text-sm transition-colors hover:bg-muted"
            >
              <span
                className={cn(
                  'flex size-9 items-center justify-center rounded-xl shadow-md transition-transform group-hover:scale-105',
                  cor,
                )}
              >
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
  useTituloAba('Início')

  return (
    <section className="flex flex-col gap-6">
      <Boasvindas titulo={primeiroNome ? `Olá, ${primeiroNome}` : 'Stowise'}>
        <p>Resumo da operação: o que está no armazém, onde está e o que espera por você.</p>
        <div className="mt-4 [&_p]:text-white/80">
          <StatusApi />
        </div>
      </Boasvindas>

      <div className="grid grid-cols-2 gap-3 lg:grid-cols-4 lg:gap-4">
        <Indicador rotulo="Produtos ativos" valor={produtos.data?.total} icone={Package} para="/catalogo" cor="marca" />
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
          cor="ciano"
          progresso={ocupacao}
        />
        <Indicador
          rotulo="Posições com saldo"
          valor={saldos.data?.total}
          detalhe="endereço, produto e lote"
          icone={Boxes}
          para="/estoque"
          cor="sinal"
        />
        {gestao && (
          <Indicador
            rotulo="Importações aguardando você"
            valor={pendentes}
            detalhe="confirmar o mapeamento ou revisar"
            icone={FileUp}
            para="/importacoes"
            cor="ia"
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
