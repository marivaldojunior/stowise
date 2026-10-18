import { type FormEvent, useState } from 'react'
import { erroDoCampo, type Falha, falhaDe } from '@/api/falha'
import { useListarCategorias } from '@/api/gerado/stowise'
import type { AtualizarProduto, ClasseArmazenagem, CriarProduto, ProdutoDetalhe } from '@/api/gerado/modelos'
import { Campo } from '@/components/Campo'
import { Button } from '@/components/ui/button'
import { Checkbox } from '@/components/ui/checkbox'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { CamposMedidas } from './CamposMedidas'
import { ehFalha, MEDIDAS_VAZIAS, type MedidasTexto, medidasParaApi } from './medidas'
import { ROTULO_CLASSE } from './rotulos'

const SEM_CATEGORIA = 'sem-categoria'

interface Dados {
  sku: string
  descricao: string
  unidadeBase: string
  classeArmazenagem: ClasseArmazenagem
  controlaLote: boolean
  controlaValidade: boolean
  ncm: string
  cest: string
  categoriaId: string
}

function dadosDe(produto?: ProdutoDetalhe): Dados {
  return {
    sku: produto?.sku ?? '',
    descricao: produto?.descricao ?? '',
    unidadeBase: produto?.unidadeBase ?? 'UN',
    classeArmazenagem: produto?.classeArmazenagem ?? 'Normal',
    controlaLote: produto?.controlaLote ?? false,
    controlaValidade: produto?.controlaValidade ?? false,
    ncm: produto?.ncm ?? '',
    cest: produto?.cest ?? '',
    categoriaId: produto?.categoriaId ?? SEM_CATEGORIA,
  }
}

type Props =
  | { modo: 'criar'; onCriar: (dados: CriarProduto) => Promise<unknown>; somenteLeitura?: false }
  | {
      modo: 'editar'
      produto: ProdutoDetalhe
      onAtualizar: (dados: AtualizarProduto) => Promise<unknown>
      somenteLeitura: boolean
    }

/**
 * Dados do produto. Na criação, pede também as medidas da embalagem da unidade base. O SKU não muda depois de
 * criado. A edição envia a versão lida (concorrência otimista): se outra pessoa salvou antes, a API responde 409.
 */
export function FormularioProduto(props: Props) {
  const produto = props.modo === 'editar' ? props.produto : undefined
  const categorias = useListarCategorias()
  const [dados, setDados] = useState(() => dadosDe(produto))
  const [medidas, setMedidas] = useState<MedidasTexto>(MEDIDAS_VAZIAS)
  const [falha, setFalha] = useState<Falha | null>(null)
  const [enviando, setEnviando] = useState(false)

  function mudar<K extends keyof Dados>(nome: K, valor: Dados[K]) {
    setDados((atuais) => ({ ...atuais, [nome]: valor }))
  }

  async function enviar(evento: FormEvent<HTMLFormElement>) {
    evento.preventDefault()
    setFalha(null)
    const comuns = {
      descricao: dados.descricao.trim(),
      unidadeBase: dados.unidadeBase.trim().toUpperCase(),
      classeArmazenagem: dados.classeArmazenagem,
      controlaLote: dados.controlaLote,
      controlaValidade: dados.controlaValidade,
      ncm: dados.ncm.trim() || null,
      cest: dados.cest.trim() || null,
      categoriaId: dados.categoriaId === SEM_CATEGORIA ? null : dados.categoriaId,
    }

    setEnviando(true)
    try {
      if (props.modo === 'criar') {
        const embalagemBase = medidasParaApi(medidas, 'embalagemBase.')
        if (ehFalha(embalagemBase)) {
          setFalha(embalagemBase)
          return
        }

        await props.onCriar({ ...comuns, sku: dados.sku.trim(), embalagemBase })
      } else {
        await props.onAtualizar({ ...comuns, versao: props.produto.versao })
      }
    } catch (erro) {
      setFalha(falhaDe(erro))
    } finally {
      setEnviando(false)
    }
  }

  const somenteLeitura = props.somenteLeitura === true

  return (
    <form className="flex flex-col gap-6" noValidate onSubmit={(e) => void enviar(e)}>
      <fieldset disabled={somenteLeitura} className="flex flex-col gap-4">
        <div className="grid gap-4 sm:grid-cols-[12rem_1fr]">
          <Campo
            id="produto-sku"
            rotulo="SKU"
            value={dados.sku}
            onChange={(e) => mudar('sku', e.target.value)}
            readOnly={props.modo === 'editar'}
            erro={erroDoCampo(falha, 'sku')}
          />
          <Campo
            id="produto-descricao"
            rotulo="Descrição"
            value={dados.descricao}
            onChange={(e) => mudar('descricao', e.target.value)}
            erro={erroDoCampo(falha, 'descricao')}
          />
        </div>
        <div className="grid gap-4 sm:grid-cols-3">
          <Campo
            id="produto-unidade"
            rotulo="Unidade base"
            value={dados.unidadeBase}
            onChange={(e) => mudar('unidadeBase', e.target.value)}
            erro={erroDoCampo(falha, 'unidadeBase')}
          />
          <div className="flex flex-col gap-2">
            <Label htmlFor="produto-classe">Classe de armazenagem</Label>
            <Select
              value={dados.classeArmazenagem}
              onValueChange={(valor) => mudar('classeArmazenagem', valor as ClasseArmazenagem)}
              disabled={somenteLeitura}
            >
              <SelectTrigger id="produto-classe" className="w-full">
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
          <div className="flex flex-col gap-2">
            <Label htmlFor="produto-categoria">Categoria</Label>
            <Select
              value={dados.categoriaId}
              onValueChange={(valor) => mudar('categoriaId', valor)}
              disabled={somenteLeitura}
            >
              <SelectTrigger id="produto-categoria" className="w-full">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={SEM_CATEGORIA}>Sem categoria</SelectItem>
                {(categorias.data ?? []).map((categoria) => (
                  <SelectItem key={categoria.id} value={categoria.id}>
                    {categoria.caminho}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
            {erroDoCampo(falha, 'categoriaId') && (
              <p className="text-sm text-destructive">{erroDoCampo(falha, 'categoriaId')}</p>
            )}
          </div>
        </div>
        <div className="grid gap-4 sm:grid-cols-3">
          <Campo
            id="produto-ncm"
            rotulo="NCM (8 dígitos)"
            inputMode="numeric"
            value={dados.ncm}
            onChange={(e) => mudar('ncm', e.target.value)}
            erro={erroDoCampo(falha, 'ncm')}
          />
          <Campo
            id="produto-cest"
            rotulo="CEST (7 dígitos)"
            inputMode="numeric"
            value={dados.cest}
            onChange={(e) => mudar('cest', e.target.value)}
            erro={erroDoCampo(falha, 'cest')}
          />
        </div>
        <div className="flex flex-col gap-2">
          <div className="flex items-center gap-2">
            <Checkbox
              id="produto-lote"
              checked={dados.controlaLote}
              onCheckedChange={(marcado) => mudar('controlaLote', marcado === true)}
            />
            <Label htmlFor="produto-lote" className="font-normal">
              Controla lote
            </Label>
          </div>
          <div className="flex items-center gap-2">
            <Checkbox
              id="produto-validade"
              checked={dados.controlaValidade}
              onCheckedChange={(marcado) => mudar('controlaValidade', marcado === true)}
            />
            <Label htmlFor="produto-validade" className="font-normal">
              Controla validade (exige lote)
            </Label>
          </div>
          {erroDoCampo(falha, 'controlaValidade') && (
            <p className="text-sm text-destructive">{erroDoCampo(falha, 'controlaValidade')}</p>
          )}
        </div>
        {props.modo === 'criar' && (
          <fieldset className="flex flex-col gap-4 rounded-md border p-4">
            <legend className="px-1 text-sm font-medium">Embalagem da unidade base</legend>
            <CamposMedidas
              idBase="base"
              medidas={medidas}
              onMudar={setMedidas}
              falha={falha}
              prefixo="embalagemBase."
            />
          </fieldset>
        )}
      </fieldset>
      {falha && (
        <p role="alert" className="text-sm text-destructive">
          {falha.mensagem}
        </p>
      )}
      {!somenteLeitura && (
        <Button type="submit" className="self-start" disabled={enviando}>
          {enviando ? 'Salvando…' : props.modo === 'criar' ? 'Criar produto' : 'Salvar alterações'}
        </Button>
      )}
    </form>
  )
}
