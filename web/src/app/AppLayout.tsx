import { Menu, TriangleAlert } from 'lucide-react'
import { Suspense, useState } from 'react'
import { isRouteErrorResponse, NavLink, Outlet, useRouteError } from 'react-router'
import { EstadoPagina } from '@/components/EstadoPagina'
import { Marca } from '@/components/Marca'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import { Sheet, SheetContent, SheetDescription, SheetHeader, SheetTitle, SheetTrigger } from '@/components/ui/sheet'
import { useAuth } from '@/features/auth/contexto'
import { cn } from '@/lib/utils'
import { MenuUsuario } from './MenuUsuario'
import { navegacao } from './navegacao'
import { SeletorTema } from './SeletorTema'

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
                'group/item relative flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm text-sidebar-foreground/70 transition-all hover:bg-sidebar-accent hover:text-sidebar-accent-foreground',
                isActive &&
                  'bg-sidebar-accent font-medium text-sidebar-accent-foreground shadow-[inset_0_0_0_1px_oklch(1_0_0/0.06)] before:absolute before:inset-y-2 before:left-0 before:w-1 before:rounded-full before:bg-grade-marca before:shadow-[0_0_12px_var(--marca-2)]',
              )
            }
          >
            <Icone className="size-4 transition-colors group-aria-[current=page]/item:text-sidebar-primary" />
            {rotulo}
          </NavLink>
        ) : (
          <span
            key={rotulo}
            aria-disabled="true"
            className="flex items-center gap-2.5 rounded-lg px-3 py-2 text-sm text-sidebar-foreground/40"
          >
            <Icone className="size-4" />
            {rotulo}
            <Badge variant="outline" className="ml-auto border-sidebar-foreground/15 text-[0.65rem] text-sidebar-foreground/50">
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
      <aside className="relative hidden w-64 shrink-0 overflow-hidden bg-grade-tinta p-4 text-sidebar-foreground md:sticky md:top-0 md:flex md:h-svh md:flex-col md:gap-8">
        {/* Planta do armazém ao fundo do menu. */}
        <div className="pointer-events-none absolute inset-0 fundo-planta-clara [mask-image:linear-gradient(to_bottom,black,transparent_85%)]" aria-hidden />
        <Marca className="relative px-1 pt-1 text-white" />
        <div className="relative">
          <MenuPrincipal />
        </div>
        <div className="relative mt-auto flex flex-col gap-3 rounded-xl border border-sidebar-border bg-white/5 p-3 text-xs text-sidebar-foreground/70">
          <span className="h-5 w-full codigo-de-barras text-sidebar-foreground/25" aria-hidden />
          Projeto experimental de recursos de IA.
        </div>
      </aside>

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="sticky top-0 z-10 flex h-14 items-center gap-2 bg-background/80 px-4 backdrop-blur-md after:absolute after:inset-x-0 after:bottom-0 after:h-0.5 after:faixa-stowise after:opacity-80">
          <Sheet open={menuAberto} onOpenChange={setMenuAberto}>
            <SheetTrigger asChild>
              <Button variant="ghost" size="icon" className="md:hidden" aria-label="Abrir o menu">
                <Menu />
              </Button>
            </SheetTrigger>
            <SheetContent side="left" className="w-64 border-none bg-grade-tinta p-4 text-sidebar-foreground">
              <SheetHeader className="p-0">
                <SheetTitle>
                  <Marca className="text-white" />
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

        <main className="relative isolate mx-auto w-full max-w-6xl flex-1 p-4 md:p-8">
          {/* Brilho suave e planta do armazém no topo da área de trabalho. */}
          <div
            className="pointer-events-none absolute inset-x-0 top-0 -z-10 h-72 fundo-planta [mask-image:linear-gradient(to_bottom,black,transparent)]"
            aria-hidden
          />
          <Suspense fallback={<Skeleton className="h-8 w-56" role="status" aria-label="Carregando a página" />}>
            <Outlet />
          </Suspense>
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
    <main className="p-4">
      <EstadoPagina
        icone={TriangleAlert}
        tom="perigo"
        titulo="Algo deu errado"
        descricao={mensagem}
        acao={
          <Button asChild>
            <a href="/">Recarregar o painel</a>
          </Button>
        }
      />
    </main>
  )
}
