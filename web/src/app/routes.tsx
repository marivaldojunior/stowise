import type { RouteObject } from 'react-router'
import { Perfis } from '../features/auth/contexto'
import { ExigePerfil, RotaProtegida } from '../features/auth/RotaProtegida'
import { InicioPage } from '../pages/InicioPage'
import { LoginPage } from '../pages/LoginPage'
import { NaoEncontradaPage } from '../pages/NaoEncontradaPage'
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
