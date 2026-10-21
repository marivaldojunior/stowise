import { useId } from 'react'
import type { AlertaItemNota, ClasseArmazenagem, ItemAnalisado, OrigemCasamento, OrigemFator } from '@/api/gerado/modelos'
import { useObterProduto } from '@/api/gerado/stowise'
import { Campo } from '@/components/Campo'
import { Situacao } from '@/components/Situacao'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { ROTULO_CLASSE, ROTULO_EMBALAGEM } from '@/features/catalogo/rotulos'
import { formatarNumero } from '@/lib/numeros'
import { cn } from '@/lib/utils'
import type { Decisao } from './decisoes'

const ROTULO_ORIGEM: Record<OrigemCasamento, { texto: string; tom: 'sucesso' | 'info' | 'aviso' | 'neutro' }> = {
  DePara: { texto: 'De-para do fornecedor', tom: 'sucesso' },
  Gtin: { texto: 'GTIN do catálogo', tom: 'info' },
  Similaridade: { texto: 'Parecidos pela descrição', tom: 'aviso' },
  SemCandidato: { texto: 'Produto novo', tom: 'neutro' },
}

const ORIGEM_FATOR: Record<OrigemFator, string> = {
  Nota: 'pelas quantidades da nota',
  DePara: 'do de-para do fornecedor',
  Embalagem: 'da embalagem do catálogo',
  Desconhecido: 'desconhecido',
}

const ROTULO_ALERTA: Record<AlertaItemNota, string> = {
  FatorDivergente: 'O fator da nota é diferente do fator do catálogo.',
  LotesNaoFecham: 'A soma dos lotes não fecha com a quantidade do item.',
  LoteFaltando: 'O produto controla lote, mas a nota não traz o lote.',
  ValidadeFaltando: 'O produto controla validade, mas um lote não tem validade.',
  LoteVencido: 'Há lote vencido na data de emissão.',
}

interface Props {
  item: ItemAnalisado
  decisao: Decisao
  erro?: string
  onMudar: (decisao: Decisao) => void
}

/**
 * Um item da nota na revisão: o que veio no XML, como casou com o catálogo, a conversão, os lotes e os alertas, e a
 * decisão (confirmar o casamento, ligar a um produto escolhido ou criar um produto novo).
 */
export function RevisaoItem({ item, decisao, erro, onMudar }: Props) {
  const id = useId()
  const nota = item.item
  const origem = ROTULO_ORIGEM[item.origem]
  const mudar = (parcial: Partial<Decisao>) => onMudar({ ...decisao, ...parcial })

  return (
    <article
      aria-labelledby={`${id}-titulo`}
      className={cn('flex flex-col gap-4 rounded-2xl border bg-card p-4 sombra-cartao sm:p-5', erro ? 'border-destructive' : 'border-border/70')}
    >
      <header className="flex flex-wrap items-start justify-between gap-2">
        <div className="flex min-w-0 flex-col gap-1">
          <h3 id={`${id}-titulo`} className="font-semibold">
            Item {nota.numeroItem}: {nota.descricao}
          </h3>
          <p className="text-sm text-muted-foreground">
            Código do fornecedor <span className="etiqueta">{nota.codigoFornecedor}</span> · GTIN {nota.gtin ?? 'sem GTIN'} ·{' '}
            {formatarNumero(nota.quantidadeComercial)} {nota.unidadeComercial}
          </p>
        </div>
        <Situacao tom={origem.tom}>{origem.texto}</Situacao>
      </header>

      <dl className="grid gap-3 text-sm sm:grid-cols-3">
        <div>
          <dt className="text-muted-foreground">Conversão</dt>
          <dd>
            {item.conversao.fator === null
              ? 'Fator desconhecido: informe abaixo.'
              : `1 ${nota.unidadeComercial} = ${formatarNumero(item.conversao.fator)} ${nota.unidadeTributavel} · ${formatarNumero(item.conversao.quantidadeBase)} ${nota.unidadeTributavel}`}
          </dd>
        </div>
        <div className="sm:col-span-2">
          <dt className="text-muted-foreground">Lotes</dt>
          <dd>
            {item.lotes.length === 0
              ? 'Sem lote na nota.'
              : item.lotes
                  .map((l) => `${l.numero} (${formatarNumero(l.quantidadeBase ?? l.quantidadeNota)}${l.validade ? `, validade ${l.validade.split('-').reverse().join('/')}` : ''})`)
                  .join('; ')}
          </dd>
        </div>
      </dl>

      {item.alertas.length > 0 && (
        <ul className="flex flex-col gap-1 text-sm">
          {item.alertas.map((alerta) => (
            <li key={alerta}>
              <Situacao tom="aviso">{ROTULO_ALERTA[alerta]}</Situacao>
            </li>
          ))}
        </ul>
      )}

      <fieldset className="flex flex-col gap-3">
        <legend className="mb-2 text-sm font-medium">O que fazer com este item</legend>
        <div className="flex flex-wrap gap-2" role="radiogroup" aria-label={`Decisão do item ${nota.numeroItem}`}>
          {item.casamento && (
            <Opcao ativa={decisao.acao === 'Confirmar'} onClick={() => mudar({ acao: 'Confirmar' })}>
              {`Confirmar ${item.casamento.sku}`}
            </Opcao>
          )}
          {item.sugestoes.length > 0 && (
            <Opcao ativa={decisao.acao === 'Vincular'} onClick={() => mudar({ acao: 'Vincular' })}>
              Escolher um parecido
            </Opcao>
          )}
          <Opcao ativa={decisao.acao === 'CriarProduto'} onClick={() => mudar({ acao: 'CriarProduto' })}>
            Criar produto novo
          </Opcao>
        </div>

        {decisao.acao === 'Confirmar' && item.casamento && (
          <p className="text-sm">
            {item.casamento.sku} · {item.casamento.descricao} · {ROTULO_EMBALAGEM[item.casamento.tipoEmbalagem]} de{' '}
            {formatarNumero(item.casamento.fatorConversao)} {item.casamento.unidadeBase}
          </p>
        )}

        {decisao.acao === 'Vincular' && <EscolhaParecido item={item} decisao={decisao} onMudar={mudar} />}

        {decisao.acao === 'CriarProduto' && (
          <div className="grid gap-3 sm:grid-cols-3">
            <Campo id={`${id}-sku`} rotulo="SKU" value={decisao.sku} onChange={(e) => mudar({ sku: e.target.value })} />
            <Campo
              id={`${id}-descricao`}
              rotulo="Descrição"
              value={decisao.descricao}
              onChange={(e) => mudar({ descricao: e.target.value })}
            />
            <div className="flex flex-col gap-2">
              <Label htmlFor={`${id}-classe`}>Classe de armazenagem</Label>
              <Select value={decisao.classe} onValueChange={(valor) => mudar({ classe: valor as ClasseArmazenagem })}>
                <SelectTrigger id={`${id}-classe`}>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {Object.entries(ROTULO_CLASSE).map(([valor, rotulo]) => (
                    <SelectItem key={valor} value={valor}>
                      {rotulo}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
        )}

        <div className="flex max-w-xs flex-col gap-1.5">
          <Campo
            id={`${id}-fator`}
            rotulo="Fator de conversão"
            inputMode="decimal"
            value={decisao.fator}
            aria-describedby={`${id}-fator-ajuda`}
            onChange={(e) => mudar({ fator: e.target.value })}
          />
          <p id={`${id}-fator-ajuda`} className="text-xs text-muted-foreground">
            Unidades base do produto em 1 {nota.unidadeComercial}.{' '}
            {item.conversao.fator === null
              ? 'Obrigatório: a nota não permite inferir.'
              : `Vazio: ${formatarNumero(item.conversao.fator)}, ${ORIGEM_FATOR[item.conversao.origem]}.`}
          </p>
        </div>
      </fieldset>

      {erro && (
        <p role="alert" className="text-sm text-destructive">
          {erro}
        </p>
      )}
    </article>
  )
}

function Opcao({ ativa, onClick, children }: { ativa: boolean; onClick: () => void; children: string }) {
  return (
    <Button type="button" role="radio" aria-checked={ativa} variant={ativa ? 'default' : 'outline'} size="sm" onClick={onClick}>
      {children}
    </Button>
  )
}

/** Candidatos pela descrição (a IA ou os trigramas só sugerem) e a embalagem do produto escolhido. */
function EscolhaParecido({ item, decisao, onMudar }: { item: ItemAnalisado; decisao: Decisao; onMudar: (parcial: Partial<Decisao>) => void }) {
  const id = useId()
  const produto = useObterProduto(decisao.produtoId ?? '', { query: { enabled: Boolean(decisao.produtoId) } })

  return (
    <div className="flex flex-col gap-3">
      <ul className="flex flex-col gap-2" role="radiogroup" aria-label={`Produto parecido para o item ${item.item.numeroItem}`}>
        {item.sugestoes.map((s) => (
          <li key={s.id}>
            <button
              type="button"
              role="radio"
              aria-checked={decisao.produtoId === s.id}
              onClick={() => onMudar({ produtoId: s.id, embalagemId: undefined })}
              className={cn(
                'flex w-full flex-wrap items-center justify-between gap-2 rounded-lg border px-3 py-2 text-left text-sm transition-colors',
                decisao.produtoId === s.id ? 'border-primary bg-primary/5' : 'border-border hover:bg-muted/50',
              )}
            >
              <span>
                <span className="etiqueta">{s.sku}</span> {s.descricao}
              </span>
              <span className="text-muted-foreground">{formatarNumero(Math.round(s.pontuacao * 100))}% parecido</span>
            </button>
          </li>
        ))}
      </ul>
      {decisao.produtoId && (
        <div className="flex max-w-xs flex-col gap-2">
          <Label htmlFor={`${id}-embalagem`}>Embalagem da nota ({item.item.unidadeComercial})</Label>
          <Select value={decisao.embalagemId ?? ''} onValueChange={(valor) => onMudar({ embalagemId: valor })} disabled={!produto.data}>
            <SelectTrigger id={`${id}-embalagem`}>
              <SelectValue placeholder={produto.isPending ? 'Carregando…' : 'Escolha a embalagem'} />
            </SelectTrigger>
            <SelectContent>
              {(produto.data?.embalagens ?? []).map((e) => (
                <SelectItem key={e.id} value={e.id}>
                  {ROTULO_EMBALAGEM[e.tipo]} de {formatarNumero(e.fatorConversao)} {produto.data?.unidadeBase}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      )}
    </div>
  )
}
