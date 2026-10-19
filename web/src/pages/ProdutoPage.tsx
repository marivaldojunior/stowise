import { useQueryClient } from '@tanstack/react-query'
import { ArrowLeft } from 'lucide-react'
import { useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router'
import { toast } from 'sonner'
import { falhaDe } from '@/api/falha'
import {
  getListarProdutosQueryKey,
  getObterProdutoQueryKey,
  useAtualizarProduto,
  useCriarProduto,
  useDesativarProduto,
  useObterProduto,
  useReativarProduto,
} from '@/api/gerado/stowise'
import type { ProdutoDetalhe } from '@/api/gerado/modelos'
import { HttpError } from '@/api/mutator'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { PERFIS_GESTAO, useAuth } from '@/features/auth/contexto'
import { Embalagens } from '@/features/catalogo/Embalagens'
import { FormularioProduto } from '@/features/catalogo/FormularioProduto'
import { ResumoEstoqueProduto } from '@/features/estoque/ResumoEstoqueProduto'

function Voltar() {
  return (
    <Button variant="ghost" size="sm" asChild className="self-start">
      <Link to="/catalogo">
        <ArrowLeft /> Catálogo
      </Link>
    </Button>
  )
}

/** /catalogo/novo: cadastro de produto (Admin e Gestor). */
export function NovoProdutoPage() {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const criar = useCriarProduto()

  return (
    <section className="flex flex-col gap-6">
      <Voltar />
      <h1 className="text-2xl font-semibold tracking-tight">Novo produto</h1>
      <FormularioProduto
        modo="criar"
        onCriar={async (dados) => {
          const produto = await criar.mutateAsync({ data: dados })
          queryClient.setQueryData(getObterProdutoQueryKey(produto.id), produto)
          await queryClient.invalidateQueries({ queryKey: getListarProdutosQueryKey() })
          toast.success(`Produto ${produto.sku} criado.`)
          void navigate(`/catalogo/${produto.id}`, { replace: true })
        }}
      />
    </section>
  )
}

/** /catalogo/:id: dados e embalagens do produto. O Operador consulta; Admin e Gestor alteram. */
export function ProdutoPage() {
  const { id = '' } = useParams()
  const queryClient = useQueryClient()
  const { temPerfil } = useAuth()
  const produto = useObterProduto(id)
  const atualizar = useAtualizarProduto()
  const desativar = useDesativarProduto()
  const reativar = useReativarProduto()
  const [conflito, setConflito] = useState(false)
  // Muda para recriar o formulário com os dados atuais depois de um conflito de versão.
  const [chaveFormulario, setChaveFormulario] = useState(0)
  const somenteLeitura = !temPerfil(...PERFIS_GESTAO)

  function guardar(atual: ProdutoDetalhe) {
    queryClient.setQueryData(getObterProdutoQueryKey(atual.id), atual)
    void queryClient.invalidateQueries({ queryKey: getListarProdutosQueryKey() })
  }

  async function carregarVersaoAtual() {
    await produto.refetch()
    setConflito(false)
    setChaveFormulario((chave) => chave + 1)
  }

  async function mudarSituacao(atual: ProdutoDetalhe) {
    try {
      if (atual.ativo) {
        await desativar.mutateAsync({ id: atual.id })
      } else {
        await reativar.mutateAsync({ id: atual.id })
      }

      const recarregado = await produto.refetch()
      if (recarregado.data) {
        guardar(recarregado.data)
      }

      toast.success(atual.ativo ? 'Produto desativado.' : 'Produto reativado.')
    } catch (erro) {
      toast.error(falhaDe(erro).mensagem)
    }
  }

  if (produto.isPending) {
    return <Skeleton className="h-8 w-64" role="status" aria-label="Carregando o produto" />
  }

  if (produto.isError) {
    return (
      <section className="flex flex-col gap-4">
        <Voltar />
        <p role="alert" className="text-destructive">
          {falhaDe(produto.error).mensagem}
        </p>
      </section>
    )
  }

  const atual = produto.data
  return (
    <section className="flex flex-col gap-6">
      <Voltar />
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div className="flex flex-col gap-1">
          <h1 className="text-2xl font-semibold tracking-tight">{atual.descricao}</h1>
          <p className="flex items-center gap-2 text-sm text-muted-foreground">
            <span className="font-mono">{atual.sku}</span>
            {atual.ativo ? <Badge variant="secondary">Ativo</Badge> : <Badge variant="outline">Inativo</Badge>}
          </p>
        </div>
        {!somenteLeitura && (
          <Button
            variant={atual.ativo ? 'outline' : 'default'}
            disabled={desativar.isPending || reativar.isPending}
            onClick={() => void mudarSituacao(atual)}
          >
            {atual.ativo ? 'Desativar produto' : 'Reativar produto'}
          </Button>
        )}
      </div>

      {conflito && (
        <div role="alert" className="flex flex-wrap items-center gap-3 rounded-md border border-destructive p-3 text-sm">
          <span>Outra pessoa alterou este produto. Carregue a versão atual e faça a alteração de novo.</span>
          <Button size="sm" variant="outline" onClick={() => void carregarVersaoAtual()}>
            Carregar a versão atual
          </Button>
        </div>
      )}

      <FormularioProduto
        key={chaveFormulario}
        modo="editar"
        produto={atual}
        somenteLeitura={somenteLeitura}
        onAtualizar={async (dados) => {
          try {
            guardar(await atualizar.mutateAsync({ id: atual.id, data: dados }))
            toast.success('Produto salvo.')
          } catch (erro) {
            if (erro instanceof HttpError && erro.status === 409) {
              setConflito(true)
            }

            throw erro
          }
        }}
      />

      <ResumoEstoqueProduto produtoId={atual.id} />

      <Embalagens produto={atual} somenteLeitura={somenteLeitura} onProduto={guardar} />
    </section>
  )
}
