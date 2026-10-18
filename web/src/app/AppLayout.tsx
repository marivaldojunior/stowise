import { isRouteErrorResponse, NavLink, Outlet, useRouteError } from 'react-router'

export function AppLayout() {
  return (
    <div className="layout">
      <header className="layout__topo">
        <span className="layout__marca">Stowise</span>
        <nav aria-label="Principal">
          <NavLink to="/" end>
            Início
          </NavLink>
        </nav>
      </header>
      <main className="layout__conteudo">
        <Outlet />
      </main>
    </div>
  )
}

/** Erro inesperado numa rota: mostra uma mensagem simples em vez de uma tela em branco. */
export function ErroDaRota() {
  const erro = useRouteError()
  const mensagem = isRouteErrorResponse(erro) ? `${erro.status} ${erro.statusText}` : 'Erro inesperado no painel.'

  return (
    <main className="layout__conteudo">
      <h1>Algo deu errado</h1>
      <p>{mensagem}</p>
      <a href="/">Recarregar o painel</a>
    </main>
  )
}
