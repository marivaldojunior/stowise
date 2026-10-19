import { useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useNavigate, useParams } from 'react-router'
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
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { PERFIS_GESTAO, useAuth } from '@/features/auth/contexto'
import { Embalagens } from '@/features/catalogo/Embalagens'
import { FormularioProduto } from '@/features/catalogo/FormularioProduto'
import { ResumoEstoqueProduto } from '@/features/estoque/ResumoEstoqueProduto'
import { CabecalhoPagina } from '@/components/CabecalhoPagina'
import { Painel } from '@/components/Painel'
import { Alerta } from '@/components/Alerta'
import { Situacao } from '@/components/Situacao'

const VOLTAR = { para: '/catalogo', rotulo: 'Catálogo' }

/** /catalogo/novo: cadastro de produto (Admin e Gestor). */
export function NovoProdutoPage() {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const criar = useCriarProduto()

  return (
    <section className="flex flex-col gap-6">
      <CabecalhoPagina titulo="Novo produto" voltar={VOLTAR} />
      <Painel titulo="Dados do produto" descricao="O SKU não muda depois de criado.">
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
      </Painel>
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
        <CabecalhoPagina titulo="Produto" voltar={VOLTAR} />
        <Alerta tom="erro">{falhaDe(produto.error).mensagem}</Alerta>
      </section>
    )
  }

  const atual = produto.data
  return (
    <section className="flex flex-col gap-6">
      <CabecalhoPagina
        voltar={VOLTAR}
        titulo={atual.descricao}
        descricao={
          <span className="flex items-center gap-2">
            <span className="font-mono">{atual.sku}</span>
            {atual.ativo ? <Situacao tom="sucesso">Ativo</Situacao> : <Situacao tom="neutro">Inativo</Situacao>}
          </span>
        }
        acoes={
          !somenteLeitura && (
            <Button
              variant={atual.ativo ? 'outline' : 'default'}
              disabled={desativar.isPending || reativar.isPending}
              onClick={() => void mudarSituacao(atual)}
            >
              {atual.ativo ? 'Desativar produto' : 'Reativar produto'}
            </Button>
          )
        }
      />

      {conflito && (
        <Alerta
          tom="aviso"
          acao={
            <Button size="sm" variant="outline" onClick={() => void carregarVersaoAtual()}>
              Carregar a versão atual
            </Button>
          }
        >
          Outra pessoa alterou este produto. Carregue a versão atual e faça a alteração de novo.
        </Alerta>
      )}

      <ResumoEstoqueProduto produtoId={atual.id} />

      <Painel titulo="Dados do produto" descricao={somenteLeitura ? 'Só Admin e Gestor alteram o produto.' : undefined}>
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
      </Painel>

      <Embalagens produto={atual} somenteLeitura={somenteLeitura} onProduto={guardar} />
    </section>
  )
}
