import { useStatusApi } from '../features/status/useStatusApi'

function StatusApi() {
  const { data, isPending, isError, error } = useStatusApi()

  if (isPending) {
    return <p role="status">Verificando a API…</p>
  }

  if (isError) {
    return (
      <p role="status" className="status status--erro">
        API indisponível: {error.message}
      </p>
    )
  }

  const disponivel = data.status === 'Healthy'
  return (
    <p role="status" className={disponivel ? 'status status--ok' : 'status status--erro'}>
      {disponivel ? 'API e banco disponíveis.' : `API com problema (${data.status}).`}
    </p>
  )
}

export function InicioPage() {
  return (
    <section>
      <h1>Stowise</h1>
      <p>Inventário e armazenagem com IA. Painel de gestão (projeto experimental).</p>
      <StatusApi />
    </section>
  )
}
