import { useQueryClient } from '@tanstack/react-query'
import { CheckCircle2, FileCode2 } from 'lucide-react'
import { type DragEvent, useRef, useState } from 'react'
import { type Falha, falhaDe } from '@/api/falha'
import type { AnaliseNotaFiscal, NotaFiscalEfetivada } from '@/api/gerado/modelos'
import { useAnalisarNotaFiscal, useEfetivarNotaFiscal } from '@/api/gerado/stowise'
import { Alerta } from '@/components/Alerta'
import { CabecalhoPagina } from '@/components/CabecalhoPagina'
import { Painel } from '@/components/Painel'
import { Situacao } from '@/components/Situacao'
import { Button } from '@/components/ui/button'
import { formatarDataHora } from '@/features/estoque/formato'
import { type Decisao, decisaoInicial, errosPorItem, paraEfetivacao, validarDecisoes } from '@/features/notasFiscais/decisoes'
import { RevisaoItem } from '@/features/notasFiscais/RevisaoItem'
import { cn } from '@/lib/utils'

interface NotaEmRevisao {
  xml: string
  analise: AnaliseNotaFiscal
  decisoes: Record<number, Decisao>
}

/**
 * /notas-fiscais (Admin e Gestor): envio do XML da NF-e, revisão do casamento de cada item com o catálogo e
 * efetivação (SPEC, 2.4). A análise não grava nada; só a efetivação cria fornecedor, produtos, de-para e o recebimento.
 */
export function NotaFiscalPage() {
  const queryClient = useQueryClient()
  const analisar = useAnalisarNotaFiscal()
  const efetivar = useEfetivarNotaFiscal()
  const [nota, setNota] = useState<NotaEmRevisao | null>(null)
  const [falhaEnvio, setFalhaEnvio] = useState<string | null>(null)
  const [falhaEfetivacao, setFalhaEfetivacao] = useState<Falha | null>(null)
  const [errosLocais, setErrosLocais] = useState<Record<number, string>>({})
  const [efetivada, setEfetivada] = useState<NotaFiscalEfetivada | null>(null)

  async function enviar(arquivo: File | undefined) {
    if (!arquivo) {
      return
    }

    setFalhaEnvio(null)
    try {
      const [xml, analise] = await Promise.all([arquivo.text(), analisar.mutateAsync({ data: { arquivo } })])
      const decisoes = Object.fromEntries(analise.itens.map((i) => [i.item.numeroItem, decisaoInicial(i)]))
      setNota({ xml, analise, decisoes })
    } catch (falha) {
      setFalhaEnvio(falhaDe(falha).mensagem)
    }
  }

  async function confirmar() {
    if (!nota) {
      return
    }

    const erros = validarDecisoes(nota.analise, nota.decisoes)
    setErrosLocais(erros)
    setFalhaEfetivacao(null)
    if (Object.keys(erros).length > 0) {
      return
    }

    try {
      const resultado = await efetivar.mutateAsync({ data: paraEfetivacao(nota.xml, nota.analise, nota.decisoes) })
      await queryClient.invalidateQueries({ queryKey: ['/api/v1/produtos'] })
      await queryClient.invalidateQueries({ queryKey: ['/api/v1/produtos/cadastros-incompletos'] })
      setEfetivada(resultado)
      setNota(null)
    } catch (falha) {
      setFalhaEfetivacao(falhaDe(falha))
    }
  }

  function recomecar() {
    setNota(null)
    setEfetivada(null)
    setFalhaEfetivacao(null)
    setErrosLocais({})
  }

  const errosApi = errosPorItem(falhaEfetivacao)

  return (
    <section className="flex flex-col gap-6">
      <CabecalhoPagina
        titulo="Notas fiscais"
        descricao="Envie o XML da NF-e. A API casa cada item com o catálogo; você confere antes de criar o recebimento."
      />

      {efetivada ? (
        <Painel
          titulo="Nota efetivada"
          descricao="O recebimento espera a conferência no app."
          acoes={<Button onClick={recomecar}>Enviar outra nota</Button>}
        >
          <p className="flex items-center gap-2 text-sm">
            <CheckCircle2 className="size-4 text-success" aria-hidden />
            {efetivada.itens.length} item(ns) no recebimento · {efetivada.produtosCriados} produto(s) novo(s) ·{' '}
            {efetivada.vinculosCriados} de-para novo(s){efetivada.fornecedorCriado && ' · fornecedor cadastrado'}
          </p>
          {efetivada.produtosCriados > 0 && (
            <p className="text-sm text-muted-foreground">
              Os produtos novos entram na fila de cadastros incompletos: a nota não traz peso nem medidas.
            </p>
          )}
        </Painel>
      ) : nota ? (
        <>
          <Painel
            titulo={`NF-e ${nota.analise.numero}, série ${nota.analise.serie}`}
            acoes={
              <Button variant="outline" onClick={recomecar}>
                Trocar arquivo
              </Button>
            }
          >
            <dl className="grid gap-3 text-sm sm:grid-cols-3">
              <div>
                <dt className="text-muted-foreground">Fornecedor</dt>
                <dd className="flex flex-wrap items-center gap-2">
                  {nota.analise.fornecedor.razaoSocial}
                  {nota.analise.fornecedor.fornecedorId === null && <Situacao tom="info">Novo</Situacao>}
                </dd>
              </div>
              <div>
                <dt className="text-muted-foreground">Emissão</dt>
                <dd>{formatarDataHora(nota.analise.dataEmissao)}</dd>
              </div>
              <div>
                <dt className="text-muted-foreground">Situação</dt>
                <dd>
                  {nota.analise.autorizada ? (
                    <Situacao tom="sucesso">Autorizada</Situacao>
                  ) : (
                    <Situacao tom="aviso">Sem protocolo de autorização</Situacao>
                  )}
                </dd>
              </div>
              <div className="sm:col-span-3">
                <dt className="text-muted-foreground">Chave de acesso</dt>
                <dd className="font-mono text-xs break-all">{nota.analise.chaveAcesso}</dd>
              </div>
            </dl>
          </Painel>

          <div className="flex flex-col gap-4">
            {nota.analise.itens.map((item) => (
              <RevisaoItem
                key={item.item.numeroItem}
                item={item}
                decisao={nota.decisoes[item.item.numeroItem]}
                erro={errosLocais[item.item.numeroItem] ?? errosApi[item.item.numeroItem]}
                onMudar={(decisao) => setNota({ ...nota, decisoes: { ...nota.decisoes, [item.item.numeroItem]: decisao } })}
              />
            ))}
          </div>

          {(Object.keys(errosLocais).length > 0 || falhaEfetivacao) && (
            <Alerta tom="erro">
              {Object.keys(errosLocais).length > 0 ? 'Confira os itens destacados.' : falhaEfetivacao?.mensagem}
            </Alerta>
          )}

          <div className="flex justify-end">
            <Button disabled={efetivar.isPending} onClick={() => void confirmar()}>
              {efetivar.isPending ? 'Efetivando…' : 'Efetivar a nota'}
            </Button>
          </div>
        </>
      ) : (
        <EnvioXml enviando={analisar.isPending} erro={falhaEnvio} onArquivo={(arquivo) => void enviar(arquivo)} />
      )}
    </section>
  )
}

function EnvioXml({ enviando, erro, onArquivo }: { enviando: boolean; erro: string | null; onArquivo: (arquivo: File | undefined) => void }) {
  const entrada = useRef<HTMLInputElement>(null)
  const [arrastando, setArrastando] = useState(false)

  function soltar(evento: DragEvent<HTMLDivElement>) {
    evento.preventDefault()
    setArrastando(false)
    onArquivo(evento.dataTransfer.files[0])
  }

  return (
    <div className="flex flex-col gap-2">
      <div
        onDragOver={(e) => {
          e.preventDefault()
          setArrastando(true)
        }}
        onDragLeave={() => setArrastando(false)}
        onDrop={soltar}
        className={cn(
          'flex flex-col items-center gap-3 rounded-lg border-2 border-dashed p-8 text-center transition-colors',
          arrastando && 'border-primary bg-primary/5',
        )}
      >
        <FileCode2 className="size-8 text-muted-foreground" aria-hidden />
        <p className="text-sm text-muted-foreground">Arraste o XML da NF-e (versão 4.00) para cá, ou escolha no computador.</p>
        <input
          ref={entrada}
          type="file"
          accept=".xml,text/xml,application/xml"
          className="sr-only"
          aria-label="XML da NF-e"
          onChange={(e) => {
            onArquivo(e.target.files?.[0])
            e.target.value = ''
          }}
        />
        <Button disabled={enviando} onClick={() => entrada.current?.click()}>
          {enviando ? 'Analisando…' : 'Escolher XML'}
        </Button>
      </div>
      {erro && (
        <p role="alert" className="text-sm text-destructive">
          {erro}
        </p>
      )}
    </div>
  )
}
