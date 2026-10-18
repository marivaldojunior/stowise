import { Link } from 'react-router'
import { Button } from '@/components/ui/button'

export function NaoEncontradaPage() {
  return (
    <section className="flex flex-col items-start gap-4">
      <h1 className="text-2xl font-semibold tracking-tight">Página não encontrada</h1>
      <p className="text-muted-foreground">O endereço não existe no painel.</p>
      <Button asChild variant="outline">
        <Link to="/">Voltar para o início</Link>
      </Button>
    </section>
  )
}
