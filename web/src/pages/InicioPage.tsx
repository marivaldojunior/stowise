import { Badge } from '@/components/ui/badge'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
import { useStatusApi } from '../features/status/useStatusApi'

function StatusApi() {
  const { data, isPending, isError, error } = useStatusApi()

  if (isPending) {
    return (
      <div role="status" aria-label="Verificando a API" className="flex items-center gap-2">
        <Skeleton className="h-5 w-24" />
        <span className="sr-only">Verificando a API…</span>
      </div>
    )
  }

  if (isError) {
    return (
      <p role="status" className="flex flex-wrap items-center gap-2 text-sm">
        <Badge variant="destructive">Indisponível</Badge>
        <span>API indisponível: {error.message}</span>
      </p>
    )
  }

  const disponivel = data.status === 'Healthy'
  return (
    <p role="status" className="flex flex-wrap items-center gap-2 text-sm">
      <Badge variant={disponivel ? 'secondary' : 'destructive'}>{disponivel ? 'Disponível' : data.status}</Badge>
      <span>{disponivel ? 'API e banco disponíveis.' : `API com problema (${data.status}).`}</span>
    </p>
  )
}

export function InicioPage() {
  return (
    <section className="flex flex-col gap-6">
      <div>
        <h1 className="text-2xl font-semibold tracking-tight">Stowise</h1>
        <p className="text-muted-foreground">Inventário e armazenagem com IA. Painel de gestão (projeto experimental).</p>
      </div>
      <Card className="max-w-md">
        <CardHeader>
          <CardTitle>Situação da API</CardTitle>
          <CardDescription>API e banco de dados, verificados a cada minuto.</CardDescription>
        </CardHeader>
        <CardContent>
          <StatusApi />
        </CardContent>
      </Card>
    </section>
  )
}
