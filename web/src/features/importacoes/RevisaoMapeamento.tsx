import { Plus, Sparkles, Trash2 } from 'lucide-react'
import { type FormEvent, useState } from 'react'
import { erroDoCampo, type Falha } from '@/api/falha'
import type {
  CampoImportacao,
  ConfirmarMapeamento,
  ImportacaoDetalhe,
  RegrasNormalizacao,
  UnidadeDePara,
} from '@/api/gerado/modelos'
import { Campo } from '@/components/Campo'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Checkbox } from '@/components/ui/checkbox'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'

const NAO_IMPORTAR = 'nao-importar'

interface Props {
  importacao: ImportacaoDetalhe
  campos: CampoImportacao[]
  falha: Falha | null
  enviando: boolean
  onConfirmar: (comando: Omit<ConfirmarMapeamento, 'versao'>) => void
}

/** Mapeamento inicial: o confirmado ou do template; senão, a sugestão da IA; senão, vazio (manual). */
function mapeamentoInicial(importacao: ImportacaoDetalhe): Record<string, number> {
  const origem = importacao.mapeamento ?? importacao.sugestaoIa?.colunas ?? []
  return Object.fromEntries(origem.map((m) => [m.campo, m.coluna]))
}

function regrasIniciais(importacao: ImportacaoDetalhe): RegrasNormalizacao {
  return (
    importacao.regras ??
    importacao.sugestaoIa?.regras ?? {
      separadorDecimal: importacao.layout.separadorDecimal,
      unidades: [],
      valoresVerdadeiros: [],
      valoresFalsos: [],
    }
  )
}

function lista(texto: string): string[] {
  return texto
    .split(',')
    .map((valor) => valor.trim())
    .filter(Boolean)
}

/**
 * Revisão do mapeamento (campo do Stowise → coluna do arquivo) e das regras de normalização. A IA só sugere: nada
 * vale até a pessoa confirmar aqui (ADR-0004).
 */
export function RevisaoMapeamento({ importacao, campos, falha, enviando, onConfirmar }: Props) {
  const [mapeamento, setMapeamento] = useState(() => mapeamentoInicial(importacao))
  const [regras, setRegras] = useState(() => regrasIniciais(importacao))
  const [verdadeiros, setVerdadeiros] = useState(() => regrasIniciais(importacao).valoresVerdadeiros.join(', '))
  const [falsos, setFalsos] = useState(() => regrasIniciais(importacao).valoresFalsos.join(', '))
  const [salvarTemplate, setSalvarTemplate] = useState(false)
  const [nomeTemplate, setNomeTemplate] = useState(importacao.nomeArquivo)
  const confianca = new Map((importacao.sugestaoIa?.colunas ?? []).map((c) => [c.campo, c.confianca]))
  const usouIa = !importacao.mapeamento && Boolean(importacao.sugestaoIa)
  const exemplo = importacao.amostra[0] ?? []
  const faltando = campos.filter((c) => c.obrigatorio && mapeamento[c.nome] === undefined)

  function mudarColuna(campo: string, valor: string) {
    setMapeamento((atual) => {
      const novo = { ...atual }
      if (valor === NAO_IMPORTAR) {
        delete novo[campo]
      } else {
        novo[campo] = Number(valor)
      }

      return novo
    })
  }

  function mudarUnidade(indice: number, unidade: UnidadeDePara | null) {
    setRegras((atual) => {
      const unidades = [...atual.unidades]
      if (unidade) {
        unidades[indice] = unidade
      } else {
        unidades.splice(indice, 1)
      }

      return { ...atual, unidades }
    })
  }

  function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault()
    onConfirmar({
      colunas: Object.entries(mapeamento).map(([campo, coluna]) => ({ campo, coluna })),
      regras: {
        ...regras,
        unidades: regras.unidades.filter((u) => u.origem.trim() && u.destino.trim()),
        valoresVerdadeiros: lista(verdadeiros),
        valoresFalsos: lista(falsos),
      },
      salvarTemplate,
      nomeTemplate: salvarTemplate ? nomeTemplate.trim() : null,
    })
  }

  return (
    <form className="flex flex-col gap-6" noValidate onSubmit={enviar}>
      {usouIa && (
        <p className="flex items-start gap-2 rounded-md border bg-muted/40 p-3 text-sm">
          <Sparkles className="mt-0.5 size-4 shrink-0" aria-hidden />
          <span>
            A IA sugeriu este mapeamento. Confira cada campo antes de confirmar.
            {importacao.sugestaoIa?.observacao && ` ${importacao.sugestaoIa.observacao}`}
          </span>
        </p>
      )}
      {importacao.templateId && (
        <p className="rounded-md border bg-muted/40 p-3 text-sm">
          O arquivo tem a mesma estrutura de um template salvo. O mapeamento veio dele.
        </p>
      )}

      <section aria-labelledby="titulo-mapeamento" className="flex flex-col gap-3">
        <h2 id="titulo-mapeamento" className="text-lg font-semibold">
          Campos e colunas
        </h2>
        <div className="rounded-md border">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Campo do Stowise</TableHead>
                <TableHead>Coluna do arquivo</TableHead>
                <TableHead>Exemplo</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {campos.map((campo) => {
                const coluna = mapeamento[campo.nome]
                const nivel = confianca.get(campo.nome)
                return (
                  <TableRow key={campo.nome}>
                    <TableCell>
                      <span className="flex flex-col">
                        <span className="font-medium">
                          {campo.nome}
                          {campo.obrigatorio && <span className="text-destructive"> *</span>}
                        </span>
                        <span className="text-xs text-muted-foreground">{campo.descricao}</span>
                      </span>
                    </TableCell>
                    <TableCell>
                      <span className="flex items-center gap-2">
                        <Select
                          value={coluna === undefined ? NAO_IMPORTAR : String(coluna)}
                          onValueChange={(valor) => mudarColuna(campo.nome, valor)}
                        >
                          <SelectTrigger aria-label={`Coluna do campo ${campo.nome}`} className="w-56">
                            <SelectValue />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value={NAO_IMPORTAR}>Não importar</SelectItem>
                            {importacao.layout.colunas.map((c) => (
                              <SelectItem key={c.indice} value={String(c.indice)}>
                                {c.indice + 1}. {c.nome}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                        {usouIa && nivel !== undefined && mapeamento[campo.nome] !== undefined && (
                          <Badge variant={nivel < 0.6 ? 'destructive' : 'secondary'} title="Confiança da IA">
                            {Math.round(nivel * 100)}%
                          </Badge>
                        )}
                      </span>
                      {erroDoCampo(falha, campo.nome) && (
                        <p className="mt-1 text-sm text-destructive">{erroDoCampo(falha, campo.nome)}</p>
                      )}
                    </TableCell>
                    <TableCell className="max-w-48 truncate font-mono text-xs text-muted-foreground">
                      {coluna === undefined ? '—' : (exemplo[coluna] ?? '—')}
                    </TableCell>
                  </TableRow>
                )
              })}
            </TableBody>
          </Table>
        </div>
      </section>

      <section aria-labelledby="titulo-regras" className="flex flex-col gap-4">
        <h2 id="titulo-regras" className="text-lg font-semibold">
          Regras de normalização
        </h2>
        <div className="grid gap-4 sm:grid-cols-3">
          <div className="flex flex-col gap-2">
            <Label htmlFor="regra-decimal">Separador decimal</Label>
            <Select
              value={regras.separadorDecimal ?? ','}
              onValueChange={(valor) => setRegras({ ...regras, separadorDecimal: valor })}
            >
              <SelectTrigger id="regra-decimal" className="w-full">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value=",">Vírgula (1,5)</SelectItem>
                <SelectItem value=".">Ponto (1.5)</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <Campo
            id="regra-verdadeiros"
            rotulo="Textos de sim (separados por vírgula)"
            placeholder="S, Sim, 1"
            value={verdadeiros}
            onChange={(e) => setVerdadeiros(e.target.value)}
          />
          <Campo
            id="regra-falsos"
            rotulo="Textos de não (separados por vírgula)"
            placeholder="N, Não, 0"
            value={falsos}
            onChange={(e) => setFalsos(e.target.value)}
          />
        </div>
        <fieldset className="flex flex-col gap-2">
          <legend className="mb-2 text-sm font-medium">Unidades: do arquivo → do Stowise</legend>
          {regras.unidades.map((unidade, indice) => (
            <div key={indice} className="flex items-center gap-2">
              <Input
                aria-label={`Unidade no arquivo ${indice + 1}`}
                className="w-28"
                value={unidade.origem}
                onChange={(e) => mudarUnidade(indice, { ...unidade, origem: e.target.value })}
              />
              <span aria-hidden>→</span>
              <Input
                aria-label={`Unidade no Stowise ${indice + 1}`}
                className="w-28"
                value={unidade.destino}
                onChange={(e) => mudarUnidade(indice, { ...unidade, destino: e.target.value.toUpperCase() })}
              />
              <Button
                type="button"
                variant="ghost"
                size="icon"
                aria-label={`Remover a unidade ${unidade.origem || indice + 1}`}
                onClick={() => mudarUnidade(indice, null)}
              >
                <Trash2 />
              </Button>
            </div>
          ))}
          <Button
            type="button"
            variant="outline"
            size="sm"
            className="self-start"
            onClick={() => mudarUnidade(regras.unidades.length, { origem: '', destino: '' })}
          >
            <Plus /> Adicionar unidade
          </Button>
        </fieldset>
      </section>

      <div className="flex flex-col gap-3">
        <div className="flex items-center gap-2">
          <Checkbox
            id="salvar-template"
            checked={salvarTemplate}
            onCheckedChange={(marcado) => setSalvarTemplate(marcado === true)}
          />
          <Label htmlFor="salvar-template" className="font-normal">
            Salvar como template (arquivos com a mesma estrutura usam este mapeamento)
          </Label>
        </div>
        {salvarTemplate && (
          <Campo
            id="nome-template"
            rotulo="Nome do template"
            className="max-w-sm"
            value={nomeTemplate}
            onChange={(e) => setNomeTemplate(e.target.value)}
            erro={erroDoCampo(falha, 'nomeTemplate') ?? erroDoCampo(falha, 'salvarTemplate')}
          />
        )}
      </div>

      {faltando.length > 0 && (
        <p className="text-sm text-muted-foreground">
          Falta escolher a coluna de: {faltando.map((c) => c.nome).join(', ')}.
        </p>
      )}
      {falha && (
        <p role="alert" className="text-sm text-destructive">
          {erroDoCampo(falha, 'colunas') ?? falha.mensagem}
        </p>
      )}
      <Button type="submit" className="self-start" disabled={enviando || faltando.length > 0}>
        {enviando ? 'Confirmando…' : 'Confirmar o mapeamento e validar'}
      </Button>
    </form>
  )
}
