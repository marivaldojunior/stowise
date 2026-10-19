import { X } from 'lucide-react'
import { NavLink } from 'react-router'
import { useObterEndereco, useObterProduto } from '@/api/gerado/stowise'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { useFiltrosDaUrl } from '@/lib/filtrosDaUrl'
import { cn } from '@/lib/utils'

/** Saldos e Extrato como abas, mantendo os filtros de produto e endereço ao trocar. */
function Abas() {
  const url = useFiltrosDaUrl()
  const filtros = new URLSearchParams()
  for (const nome of ['produtoId', 'enderecoId']) {
    const valor = url.texto(nome)
    if (valor) {
      filtros.set(nome, valor)
    }
  }

  const sufixo = filtros.size > 0 ? `?${filtros.toString()}` : ''
  return (
    <nav aria-label="Estoque" className="flex gap-1 border-b">
      {(
        [
          ['/estoque', 'Saldos'],
          ['/estoque/extrato', 'Extrato'],
        ] as const
      ).map(([para, rotulo]) => (
        <NavLink
          key={para}
          to={para + sufixo}
          end
          className={({ isActive }) =>
            cn(
              '-mb-px border-b-2 px-3 py-2 text-sm',
              isActive ? 'border-primary font-medium' : 'border-transparent text-muted-foreground hover:text-foreground',
            )
          }
        >
          {rotulo}
        </NavLink>
      ))}
    </nav>
  )
}

function Filtro({ rotulo, onRemover }: { rotulo: string; onRemover: () => void }) {
  return (
    <Badge variant="secondary" className="gap-1 pr-1">
      {rotulo}
      <Button variant="ghost" size="icon" className="size-4" aria-label={`Remover o filtro ${rotulo}`} onClick={onRemover}>
        <X className="size-3" />
      </Button>
    </Badge>
  )
}

/** Filtros de produto e de endereço que vêm de links (catálogo, mapa de endereços). */
function FiltrosDeLink() {
  const url = useFiltrosDaUrl()
  const produtoId = url.texto('produtoId')
  const enderecoId = url.texto('enderecoId')
  const produto = useObterProduto(produtoId ?? '', { query: { enabled: Boolean(produtoId) } })
  const endereco = useObterEndereco(enderecoId ?? '', { query: { enabled: Boolean(enderecoId) } })

  if (!produtoId && !enderecoId) {
    return null
  }

  return (
    <div className="flex flex-wrap items-center gap-2 text-sm">
      <span className="text-muted-foreground">Filtrando por</span>
      {produtoId && (
        <Filtro
          rotulo={`Produto ${produto.data ? `${produto.data.sku} · ${produto.data.descricao}` : '…'}`}
          onRemover={() => url.mudar('produtoId', undefined)}
        />
      )}
      {enderecoId && (
        <Filtro
          rotulo={`Endereço ${endereco.data?.codigo ?? '…'}`}
          onRemover={() => url.mudar('enderecoId', undefined)}
        />
      )}
    </div>
  )
}

export function CabecalhoEstoque() {
  return (
    <div className="flex flex-col gap-4">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">Estoque</h1>
        <p className="text-muted-foreground">Saldo por endereço e lote, e o histórico das movimentações.</p>
      </div>
      <Abas />
      <FiltrosDeLink />
    </div>
  )
}
