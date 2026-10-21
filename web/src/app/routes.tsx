import type { RouteObject } from 'react-router'
import { PERFIS_GESTAO, Perfis } from '../features/auth/contexto'
import { ExigePerfil, RotaProtegida } from '../features/auth/RotaProtegida'
import { InicioPage } from '../pages/InicioPage'
import { LoginPage } from '../pages/LoginPage'
import { NaoEncontradaPage } from '../pages/NaoEncontradaPage'
import { AppLayout, ErroDaRota } from './AppLayout'
import {
  CadastrosIncompletosPage,
  CatalogoPage,
  EnderecosPage,
  ExtratoPage,
  ImportacaoPage,
  ImportacoesPage,
  NovoProdutoPage,
  ProdutoPage,
  SaldosPage,
  UsuariosPage,
} from './paginas'

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
      { path: 'catalogo/incompletos', element: <CadastrosIncompletosPage /> },
      { path: 'catalogo/:id', element: <ProdutoPage /> },
      { path: 'enderecos', element: <EnderecosPage /> },
      { path: 'estoque', element: <SaldosPage /> },
      { path: 'estoque/extrato', element: <ExtratoPage /> },
      {
        path: 'importacoes',
        element: (
          <ExigePerfil perfis={PERFIS_GESTAO}>
            <ImportacoesPage />
          </ExigePerfil>
        ),
      },
      {
        path: 'importacoes/:id',
        element: (
          <ExigePerfil perfis={PERFIS_GESTAO}>
            <ImportacaoPage />
          </ExigePerfil>
        ),
      },
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
