import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { apiFetch } from '@/api/mutator'
import {
  comSessao,
  jsonResponse,
  problemResponse,
  renderRoute,
  type Responder,
  sessaoResponse,
  stubFetch,
} from '@/test/renderRoute'
import { type ContextoAuth, ContextoDaAuth, Perfis } from './contexto'
import { ExigePerfil } from './RotaProtegida'
import { esperaAteRenovar, getSessao, renovar, setSessao } from './sessao'

const saudavel = () => jsonResponse({ status: 'Healthy', totalDurationMs: 1, checks: [] })

/** API sem sessão: o refresh do cookie é recusado e o login segue o `login`. */
function semSessao(login: Responder = () => sessaoResponse()): Responder {
  return (url, init) => {
    if (url === '/api/v1/auth/refresh') {
      return problemResponse(401, 'Sessão inválida')
    }

    return url === '/api/v1/auth/login' ? login(url, init) : saudavel()
  }
}

function autorizacao(init: RequestInit | undefined): string | null {
  return new Headers(init?.headers).get('Authorization')
}

async function preencherLogin(email: string, senha: string) {
  const user = userEvent.setup()
  await user.type(await screen.findByLabelText('E-mail'), email)
  await user.type(screen.getByLabelText('Senha'), senha)
  await user.click(screen.getByRole('button', { name: 'Entrar' }))
}

afterEach(() => {
  vi.unstubAllGlobals()
})

describe('rotas protegidas', () => {
  it('sem sessão, leva ao login e volta para a página pedida depois de entrar', async () => {
    const fetchMock = stubFetch(semSessao())
    const { router } = renderRoute('/catalogo?pagina=2')

    await waitFor(() => expect(router.state.location.pathname).toBe('/login'))
    await preencherLogin(' ana@stowise.dev ', 'senha-forte')

    await waitFor(() => expect(router.state.location.pathname).toBe('/catalogo'))
    expect(router.state.location.search).toBe('?pagina=2')
    const chamada = fetchMock.mock.calls.find(([url]) => url === '/api/v1/auth/login')
    expect(JSON.parse(String(chamada?.[1]?.body))).toEqual({
      email: 'ana@stowise.dev',
      senha: 'senha-forte',
      useCookie: true,
    })
    expect(getSessao()?.accessToken).toBe('token-1')
  })

  it('retoma a sessão pelo cookie de refresh, sem pedir a senha', async () => {
    const fetchMock = stubFetch(comSessao(saudavel))
    renderRoute('/')

    expect(await screen.findByRole('heading', { name: 'Stowise' })).toBeInTheDocument()
    const refresh = fetchMock.mock.calls.find(([url]) => url === '/api/v1/auth/refresh')
    expect(JSON.parse(String(refresh?.[1]?.body))).toEqual({ refreshToken: null, useCookie: true })
    expect(refresh?.[1]?.credentials).toBe('same-origin')
    const health = fetchMock.mock.calls.find(([url]) => url === '/health/ready')
    expect(autorizacao(health?.[1])).toBe('Bearer token-1')
  })

  it('com sessão, a página de login leva ao início', async () => {
    stubFetch(comSessao(saudavel))
    const { router } = renderRoute('/login')

    await waitFor(() => expect(router.state.location.pathname).toBe('/'))
  })
})

describe('login', () => {
  it('mostra o motivo quando a API recusa as credenciais', async () => {
    stubFetch(
      semSessao(() =>
        problemResponse(401, 'Credenciais inválidas', 'E-mail ou senha incorretos, ou usuário bloqueado.'),
      ),
    )
    renderRoute('/login')

    await preencherLogin('ana@stowise.dev', 'errada')

    expect(await screen.findByRole('alert')).toHaveTextContent('E-mail ou senha incorretos, ou usuário bloqueado.')
    expect(screen.getByRole('button', { name: 'Entrar' })).toBeEnabled()
    expect(getSessao()).toBeNull()
  })

  it('mostra os erros de cada campo', async () => {
    stubFetch(
      semSessao(() =>
        problemResponse(400, 'One or more validation errors occurred.', undefined, {
          email: ['Informe um e-mail válido.'],
        }),
      ),
    )
    renderRoute('/login')

    await preencherLogin('ana', 'x')

    expect(await screen.findByText('Informe um e-mail válido.')).toBeInTheDocument()
    expect(screen.getByLabelText('E-mail')).toHaveAttribute('aria-invalid', 'true')
    expect(screen.getByRole('alert')).toHaveTextContent('Confira os campos destacados.')
  })

  it('avisa quando a API não responde', async () => {
    stubFetch(semSessao(() => Promise.reject(new TypeError('Failed to fetch'))))
    renderRoute('/login')

    await preencherLogin('ana@stowise.dev', 'senha')

    expect(await screen.findByRole('alert')).toHaveTextContent('A API não respondeu')
  })
})

describe('renovação do token', () => {
  it('renova depois de um 401 e repete a chamada com o token novo', async () => {
    setSessao(await sessaoResponse(['Gestor'], 'token-vencido').json())
    const fetchMock = stubFetch((url, init) => {
      if (url === '/api/v1/auth/refresh') {
        return sessaoResponse(['Gestor'], 'token-novo')
      }

      return autorizacao(init) === 'Bearer token-novo' ? jsonResponse({ ok: true }) : problemResponse(401, 'x')
    })

    await expect(apiFetch('/api/v1/produtos')).resolves.toEqual({ ok: true })

    const produtos = fetchMock.mock.calls.filter(([url]) => url === '/api/v1/produtos')
    expect(produtos.map(([, init]) => autorizacao(init))).toEqual(['Bearer token-vencido', 'Bearer token-novo'])
  })

  it('vários 401 ao mesmo tempo usam um só refresh (a API gira o refresh token)', async () => {
    setSessao(await sessaoResponse(['Gestor'], 'token-vencido').json())
    const fetchMock = stubFetch((url, init) => {
      if (url === '/api/v1/auth/refresh') {
        return sessaoResponse(['Gestor'], 'token-novo')
      }

      return autorizacao(init) === 'Bearer token-novo' ? jsonResponse({ url }) : problemResponse(401, 'x')
    })

    await Promise.all([apiFetch('/api/v1/a'), apiFetch('/api/v1/b'), apiFetch('/api/v1/c')])

    expect(fetchMock.mock.calls.filter(([url]) => url === '/api/v1/auth/refresh')).toHaveLength(1)
  })

  it('não tenta renovar quando a própria rota de autenticação responde 401', async () => {
    const fetchMock = stubFetch(() => problemResponse(401, 'Credenciais inválidas'))

    await expect(apiFetch('/api/v1/auth/login', { method: 'POST' })).rejects.toMatchObject({ status: 401 })
    expect(fetchMock).toHaveBeenCalledTimes(1)
  })

  it('refresh recusado encerra a sessão e leva ao login', async () => {
    let refreshes = 0
    stubFetch((url) => {
      if (url === '/api/v1/auth/refresh') {
        refreshes += 1
        return refreshes === 1 ? sessaoResponse() : problemResponse(401, 'Sessão inválida')
      }

      return problemResponse(401, 'Unauthorized')
    })
    const { router } = renderRoute('/')

    await waitFor(() => expect(router.state.location.pathname).toBe('/login'))
    expect(refreshes).toBe(2)
    expect(getSessao()).toBeNull()
  })

  it.each([
    ['falha de rede', () => Promise.reject(new TypeError('Failed to fetch'))],
    ['502 do proxy', () => new Response('Bad Gateway', { status: 502 })],
    ['503 da API', () => problemResponse(503, 'Service Unavailable')],
  ])('%s no refresh mantém a sessão para tentar de novo', async (_, resposta) => {
    setSessao(await sessaoResponse().json())
    stubFetch(resposta)

    await expect(renovar()).resolves.toBe(false)
    expect(getSessao()?.accessToken).toBe('token-1')
  })

  it('agenda a renovação um minuto antes do vencimento, com espera mínima', () => {
    const agora = Date.parse('2026-10-18T12:00:00Z')
    const usuario = { id: '', nome: '', email: '', perfis: [] }
    const sessao = { accessToken: 't', expiraEm: agora + 15 * 60_000, usuario }

    expect(esperaAteRenovar(sessao, agora)).toBe(14 * 60_000)
    expect(esperaAteRenovar({ ...sessao, expiraEm: agora + 30_000 }, agora)).toBe(5_000)
  })
})

describe('sair', () => {
  it('encerra a sessão na API e volta ao login', async () => {
    const fetchMock = stubFetch(
      comSessao((url) => (url === '/api/v1/auth/logout' ? new Response(null, { status: 204 }) : saudavel())),
    )
    const { router } = renderRoute('/')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'Menu do usuário' }))
    const menu = await screen.findByRole('menu')
    expect(within(menu).getByText('Ana Souza')).toBeInTheDocument()
    expect(within(menu).getByText('ana@stowise.dev')).toBeInTheDocument()
    await user.click(within(menu).getByRole('menuitem', { name: 'Sair' }))

    await waitFor(() => expect(router.state.location.pathname).toBe('/login'))
    const logout = fetchMock.mock.calls.find(([url]) => url === '/api/v1/auth/logout')
    expect(JSON.parse(String(logout?.[1]?.body))).toEqual({ refreshToken: null, useCookie: true })
    expect(getSessao()).toBeNull()
  })
})

describe('perfis', () => {
  it.each([
    [['Operador'], ['Início', 'Catálogo', 'Endereços', 'Estoque']],
    [['Gestor'], ['Início', 'Catálogo', 'Endereços', 'Estoque', 'Importações']],
    [['Admin'], ['Início', 'Catálogo', 'Endereços', 'Estoque', 'Importações', 'Uso de IA', 'Usuários']],
  ])('o menu de %j mostra só as seções permitidas', async (perfis, esperado) => {
    stubFetch(comSessao(saudavel, perfis))
    renderRoute('/')

    const menu = await screen.findByRole('navigation', { name: 'Principal' })
    const itens = [...menu.children].map((item) => item.textContent?.replace('em breve', '').trim())
    expect(itens).toEqual(esperado)
  })

  function comPerfis(perfis: string[]): ContextoAuth {
    return {
      status: 'autenticado',
      usuario: { id: '1', nome: 'Ana', email: 'ana@stowise.dev', perfis },
      entrar: vi.fn(),
      sair: vi.fn(),
      temPerfil: (...pedidos) => pedidos.some((perfil) => perfis.includes(perfil)),
    }
  }

  it('ExigePerfil mostra a área para o perfil certo e "Acesso negado" para os outros', () => {
    const { rerender } = render(
      <ContextoDaAuth.Provider value={comPerfis([Perfis.Admin])}>
        <ExigePerfil perfis={[Perfis.Admin]}>Área do Admin</ExigePerfil>
      </ContextoDaAuth.Provider>,
    )
    expect(screen.getByText('Área do Admin')).toBeInTheDocument()

    rerender(
      <ContextoDaAuth.Provider value={comPerfis([Perfis.Operador])}>
        <ExigePerfil perfis={[Perfis.Admin]}>Área do Admin</ExigePerfil>
      </ContextoDaAuth.Provider>,
    )
    expect(screen.queryByText('Área do Admin')).not.toBeInTheDocument()
    expect(screen.getByRole('heading', { name: 'Acesso negado' })).toBeInTheDocument()
  })
})
