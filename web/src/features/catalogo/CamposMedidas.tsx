import { erroDoCampo, type Falha } from '@/api/falha'
import { Campo } from '@/components/Campo'
import type { MedidasTexto } from './medidas'

interface Props {
  idBase: string
  medidas: MedidasTexto
  onMudar: (medidas: MedidasTexto) => void
  falha: Falha | null
  prefixo?: string
}

/** GTIN, peso e dimensões de uma embalagem. */
export function CamposMedidas({ idBase, medidas, onMudar, falha, prefixo = '' }: Props) {
  function campo(nome: keyof MedidasTexto, rotulo: string, numerico = true) {
    return (
      <Campo
        id={`${idBase}-${nome}`}
        rotulo={rotulo}
        inputMode={numerico ? 'decimal' : 'numeric'}
        value={medidas[nome]}
        onChange={(e) => onMudar({ ...medidas, [nome]: e.target.value })}
        erro={erroDoCampo(falha, prefixo + nome)}
      />
    )
  }

  return (
    <div className="grid gap-4 sm:grid-cols-2">
      {campo('gtin', 'GTIN (código de barras)', false)}
      {campo('pesoKg', 'Peso (kg)')}
      {campo('alturaCm', 'Altura (cm)')}
      {campo('larguraCm', 'Largura (cm)')}
      {campo('comprimentoCm', 'Comprimento (cm)')}
    </div>
  )
}
