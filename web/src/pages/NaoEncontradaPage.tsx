import { MapPinOff } from 'lucide-react'
import { Link } from 'react-router'
import { EstadoPagina } from '@/components/EstadoPagina'
import { Button } from '@/components/ui/button'

export function NaoEncontradaPage() {
  return (
    <EstadoPagina
      icone={MapPinOff}
      titulo="Página não encontrada"
      descricao="O endereço não existe no painel."
      acao={
        <Button asChild variant="outline">
          <Link to="/">Voltar para o início</Link>
        </Button>
      }
    />
  )
}
