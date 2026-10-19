import type { RouteObject } from 'react-router'
import { PERFIS_GESTAO, Perfis } from '../features/auth/contexto'
import { ExigePerfil, RotaProtegida } from '../features/auth/RotaProtegida'
import { CatalogoPage } from '../pages/CatalogoPage'
import { EnderecosPage } from '../pages/EnderecosPage'
import { ExtratoPage } from '../pages/ExtratoPage'
import { InicioPage } from '../pages/InicioPage'
import { LoginPage } from '../pages/LoginPage'
import { NaoEncontradaPage } from '../pages/NaoEncontradaPage'
import { NovoProdutoPage, ProdutoPage } from '../pages/ProdutoPage'
import { SaldosPage } from '../pages/SaldosPage'
import { UsuariosPage } from '../pages/UsuariosPage'
import { AppLayout, ErroDaRota } from './AppLayout'

/** Rotas do painel. Só o login é público. Os testes montam as mesmas rotas num roteador em memória. */
export const routes: RouteObject[] = [
  { path: '/login', element: <LoginPage />, errorElement: <ErroDaRota /> },
  {
    path: '/',
    element: (
      <RotaProtegida>
        <AppLayout />
      </RotaProtegida>
    ),
    errorElement: <ErroDaRota />,
    children: [
      { index: true, element: <InicioPage /> },
      { path: 'catalogo', element: <CatalogoPage /> },
      {
        path: 'catalogo/novo',
        element: (
          <ExigePerfil perfis={PERFIS_GESTAO}>
            <NovoProdutoPage />
          </ExigePerfil>
        ),
      },
      { path: 'catalogo/:id', element: <ProdutoPage /> },
      { path: 'enderecos', element: <EnderecosPage /> },
      { path: 'estoque', element: <SaldosPage /> },
      { path: 'estoque/extrato', element: <ExtratoPage /> },
      {
        path: 'usuarios',
        element: (
          <ExigePerfil perfis={[Perfis.Admin]}>
            <UsuariosPage />
          </ExigePerfil>
        ),
      },
      { path: '*', element: <NaoEncontradaPage /> },
    ],
  },
]
