import type { RouteObject } from 'react-router'
import { InicioPage } from '../pages/InicioPage'
import { NaoEncontradaPage } from '../pages/NaoEncontradaPage'
import { AppLayout, ErroDaRota } from './AppLayout'

/** Rotas do painel. Os testes montam as mesmas rotas num roteador em memória. */
export const routes: RouteObject[] = [
  {
    path: '/',
    element: <AppLayout />,
    errorElement: <ErroDaRota />,
    children: [
      { index: true, element: <InicioPage /> },
      { path: '*', element: <NaoEncontradaPage /> },
    ],
  },
]
