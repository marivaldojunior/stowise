import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { TODOS } from '@/lib/filtrosDaUrl'

/** Filtro Ativos, Inativos ou todos (sem filtro). */
export function FiltroSituacao({ valor, onMudar }: { valor: boolean | undefined; onMudar: (valor: string) => void }) {
  return (
    <Select value={valor === undefined ? TODOS : String(valor)} onValueChange={onMudar}>
      <SelectTrigger aria-label="Filtrar por situação" className="w-40">
        <SelectValue />
      </SelectTrigger>
      <SelectContent>
        <SelectItem value={TODOS}>Todas as situações</SelectItem>
        <SelectItem value="true">Ativos</SelectItem>
        <SelectItem value="false">Inativos</SelectItem>
      </SelectContent>
    </Select>
  )
}
