import { ShieldX } from 'lucide-react'
import type { ReactNode } from 'react'
import { Navigate, useLocation } from 'react-router'
import { Skeleton } from '@/components/ui/skeleton'
import { useAuth } from './contexto'

/** Só mostra o conteúdo com sessão. Sem sessão, leva ao login e guarda a página pedida para voltar depois. */
export function RotaProtegida({ children }: { children: ReactNode }) {
  const { status } = useAuth()
  const location = useLocation()

  if (status === 'verificando') {
    return (
      <div role="status" aria-label="Verificando a sessão" className="flex min-h-svh items-center justify-center">
        <Skeleton className="h-8 w-48" />
      </div>
    )
  }

  if (status === 'anonimo') {
    return <Navigate to="/login" replace state={{ de: location }} />
  }

  return children
}

/** Restringe uma área a perfis. A API também recusa (403): aqui é só para a tela não oferecer o que não pode. */
export function ExigePerfil({ perfis, children }: { perfis: readonly string[]; children: ReactNode }) {
  const { temPerfil } = useAuth()

  if (!temPerfil(...perfis)) {
    return (
      <section className="flex flex-col items-start gap-3">
        <ShieldX className="size-8 text-destructive" aria-hidden />
        <h1 className="text-2xl font-semibold tracking-tight">Acesso negado</h1>
        <p className="text-muted-foreground">Esta área é só para o perfil {perfis.join(' ou ')}.</p>
      </section>
    )
  }

  return children
}
