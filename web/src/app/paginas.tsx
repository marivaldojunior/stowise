import { lazy } from 'react'

/**
 * Páginas carregadas sob demanda: cada área vira um arquivo JS separado, baixado na primeira visita. O início e o
 * login ficam no pacote principal, porque são a primeira tela.
 */
export const CatalogoPage = lazy(() => import('../pages/CatalogoPage').then((m) => ({ default: m.CatalogoPage })))
export const CadastrosIncompletosPage = lazy(() =>
  import('../pages/CadastrosIncompletosPage').then((m) => ({ default: m.CadastrosIncompletosPage })),
)
export const NovoProdutoPage = lazy(() => import('../pages/ProdutoPage').then((m) => ({ default: m.NovoProdutoPage })))
export const ProdutoPage = lazy(() => import('../pages/ProdutoPage').then((m) => ({ default: m.ProdutoPage })))
export const EnderecosPage = lazy(() => import('../pages/EnderecosPage').then((m) => ({ default: m.EnderecosPage })))
export const SaldosPage = lazy(() => import('../pages/SaldosPage').then((m) => ({ default: m.SaldosPage })))
export const ExtratoPage = lazy(() => import('../pages/ExtratoPage').then((m) => ({ default: m.ExtratoPage })))
export const ImportacoesPage = lazy(() => import('../pages/ImportacoesPage').then((m) => ({ default: m.ImportacoesPage })))
export const ImportacaoPage = lazy(() => import('../pages/ImportacaoPage').then((m) => ({ default: m.ImportacaoPage })))
export const UsuariosPage = lazy(() => import('../pages/UsuariosPage').then((m) => ({ default: m.UsuariosPage })))
