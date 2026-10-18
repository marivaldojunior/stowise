import { Link } from 'react-router'

export function NaoEncontradaPage() {
  return (
    <section>
      <h1>Página não encontrada</h1>
      <p>O endereço não existe no painel.</p>
      <Link to="/">Voltar para o início</Link>
    </section>
  )
}
