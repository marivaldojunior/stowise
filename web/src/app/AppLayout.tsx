import { Menu } from 'lucide-react'
import { useState } from 'react'
import { isRouteErrorResponse, NavLink, Outlet, useRouteError } from 'react-router'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Sheet, SheetContent, SheetDescription, SheetHeader, SheetTitle, SheetTrigger } from '@/components/ui/sheet'
import { useAuth } from '@/features/auth/contexto'
import { cn } from '@/lib/utils'
import { MenuUsuario } from './MenuUsuario'
import { navegacao } from './navegacao'
import { SeletorTema } from './SeletorTema'

function Marca() {
  return <span className="text-base font-semibold tracking-tight">Stowise</span>
}

/**
 * Links do menu principal, só os que os perfis do usuário podem usar. Na tela pequena, fechar o menu depois do
 * clique (onNavegar).
 */
function MenuPrincipal({ onNavegar }: { onNavegar?: () => void }) {
  const { temPerfil } = useAuth()
  const itens = navegacao.filter(({ perfis }) => !perfis || temPerfil(...perfis))

  return (
    <nav aria-label="Principal" className="flex flex-col gap-1">
      {itens.map(({ rotulo, icone: Icone, para }) =>
        para ? (
          <NavLink
            key={rotulo}
            to={para}
            end={para === '/'}
            onClick={onNavegar}
            className={({ isActive }) =>
              cn(
                'flex items-center gap-2 rounded-md px-3 py-2 text-sm transition-colors hover:bg-muted',
                isActive && 'bg-muted font-medium',
              )
            }
          >
            <Icone className="size-4" />
            {rotulo}
          </NavLink>
        ) : (
          <span
            key={rotulo}
            aria-disabled="true"
            className="flex items-center gap-2 rounded-md px-3 py-2 text-sm text-muted-foreground"
          >
            <Icone className="size-4" />
            {rotulo}
            <Badge variant="outline" className="ml-auto text-[0.65rem]">
              em breve
            </Badge>
          </span>
        ),
      )}
    </nav>
  )
}

/** Layout base: barra lateral no desktop, menu em painel lateral no celular, tema e usuário no topo. */
export function AppLayout() {
  const [menuAberto, setMenuAberto] = useState(false)

  return (
    <div className="flex min-h-svh">
      <aside className="hidden w-60 shrink-0 border-r bg-sidebar p-4 md:flex md:flex-col md:gap-6">
        <Marca />
        <MenuPrincipal />
      </aside>

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="flex h-14 items-center gap-2 border-b px-4">
          <Sheet open={menuAberto} onOpenChange={setMenuAberto}>
            <SheetTrigger asChild>
              <Button variant="ghost" size="icon" className="md:hidden" aria-label="Abrir o menu">
                <Menu />
              </Button>
            </SheetTrigger>
            <SheetContent side="left" className="w-64 p-4">
              <SheetHeader className="p-0">
                <SheetTitle>
                  <Marca />
                </SheetTitle>
                <SheetDescription className="sr-only">Menu principal do painel</SheetDescription>
              </SheetHeader>
              <MenuPrincipal onNavegar={() => setMenuAberto(false)} />
            </SheetContent>
          </Sheet>
          <span className="md:hidden">
            <Marca />
          </span>
          <div className="ml-auto flex items-center gap-1">
            <SeletorTema />
            <MenuUsuario />
          </div>
        </header>

        <main className="mx-auto w-full max-w-6xl flex-1 p-4 md:p-8">
          <Outlet />
        </main>
      </div>
    </div>
  )
}

/** Erro inesperado numa rota: mostra uma mensagem simples em vez de uma tela em branco. */
export function ErroDaRota() {
  const erro = useRouteError()
  const mensagem = isRouteErrorResponse(erro) ? `${erro.status} ${erro.statusText}` : 'Erro inesperado no painel.'

  return (
    <main className="mx-auto flex max-w-xl flex-col gap-4 p-8">
      <h1 className="text-2xl font-semibold">Algo deu errado</h1>
      <p className="text-muted-foreground">{mensagem}</p>
      <Button asChild className="self-start">
        <a href="/">Recarregar o painel</a>
      </Button>
    </main>
  )
}
