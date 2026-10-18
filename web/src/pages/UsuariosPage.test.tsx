import { screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import type { UsuarioDetalhe } from '@/api/gerado/modelos'
import { comSessao, jsonResponse, problemResponse, renderRoute, stubFetch } from '@/test/renderRoute'

/** Id do usuário da sessão de teste (sessaoResponse). */
const EU = '0192f5e0-0000-7000-8000-000000000001'

function usuario(id: string, nome: string, extra: Partial<UsuarioDetalhe> = {}): UsuarioDetalhe {
  return {
    id,
    nome,
    email: `${nome.split(' ')[0].toLowerCase()}@stowise.dev`,
    perfis: ['Operador'],
    ativo: true,
    bloqueado: false,
    criadoEm: '2026-10-01T12:00:00Z',
    ...extra,
  }
}

/** API de usuários em memória: lista com filtros e as escritas que a página usa. */
function apiDeUsuarios(iniciais: UsuarioDetalhe[]) {
  const usuarios = [...iniciais]
  const fetchMock = stubFetch(
    comSessao(async (url, init) => {
      const { pathname, searchParams } = new URL(url, 'http://localhost')
      const metodo = init.method ?? 'GET'
      const corpo = init.body ? (JSON.parse(String(init.body)) as Record<string, unknown>) : {}

      if (pathname === '/api/v1/perfis') {
        return jsonResponse(['Admin', 'Gestor', 'Operador'])
      }

      if (pathname === '/api/v1/usuarios' && metodo === 'GET') {
        const busca = searchParams.get('busca')?.toLowerCase()
        const perfil = searchParams.get('perfil')
        const ativo = searchParams.get('ativo')
        const itens = usuarios.filter(
          (u) =>
            (!busca || u.nome.toLowerCase().includes(busca) || u.email.includes(busca)) &&
            (!perfil || u.perfis.includes(perfil)) &&
            (ativo === null || String(u.ativo) === ativo),
        )
        const pagina = Number(searchParams.get('pagina') ?? '1')
        const tamanho = Number(searchParams.get('tamanhoPagina') ?? '20')
        return jsonResponse({
          itens: itens.slice((pagina - 1) * tamanho, pagina * tamanho),
          pagina,
          tamanhoPagina: tamanho,
          total: itens.length,
        })
      }

      if (pathname === '/api/v1/usuarios' && metodo === 'POST') {
        if (usuarios.some((u) => u.email === corpo.email)) {
          return problemResponse(409, 'Já existe um usuário com este e-mail.')
        }

        if (String(corpo.senha).length < 8) {
          return problemResponse(400, 'Dados inválidos.', undefined, { Senha: ['A senha deve ter ao menos 8 caracteres.'] })
        }

        const novo = usuario('novo', String(corpo.nome), { email: String(corpo.email), perfis: corpo.perfis as string[] })
        usuarios.push(novo)
        return jsonResponse(novo, 201)
      }

      const [, id, acao] = /^\/api\/v1\/usuarios\/([^/]+)\/?(.*)$/.exec(pathname) ?? []
      const alvo = usuarios.find((u) => u.id === id)
      if (!alvo) {
        return problemResponse(404, 'Usuário não encontrado.')
      }

      if (metodo === 'PUT') {
        Object.assign(alvo, { nome: corpo.nome, perfis: corpo.perfis })
        return jsonResponse(alvo)
      }

      if (acao === 'desativar') {
        if (alvo.perfis.includes('Admin') && usuarios.filter((u) => u.ativo && u.perfis.includes('Admin')).length === 1) {
          return problemResponse(422, 'O sistema precisa de ao menos um Admin ativo.')
        }

        alvo.ativo = false
        return new Response(null, { status: 204 })
      }

      if (acao === 'reativar') {
        alvo.ativo = true
        return new Response(null, { status: 204 })
      }

      return acao === 'senha' ? new Response(null, { status: 204 }) : problemResponse(405, 'x')
    }, ['Admin']),
  )

  return { usuarios, fetchMock }
}

async function linhaDe(nome: string) {
  const celula = await screen.findByRole('cell', { name: nome })
  return celula.closest('tr') as HTMLElement
}

async function abrirAcao(nome: string, acao: string) {
  const user = userEvent.setup()
  await user.click(within(await linhaDe(nome)).getByRole('button', { name: `Ações de ${nome}` }))
  await user.click(await screen.findByRole('menuitem', { name: acao }))
  return user
}

afterEach(() => {
  vi.unstubAllGlobals()
})

describe('gestão de usuários', () => {
  it('lista os usuários com perfis e situação', async () => {
    apiDeUsuarios([
      usuario(EU, 'Ana Souza', { perfis: ['Admin'] }),
      usuario('2', 'Bruno Lima', { ativo: false }),
      usuario('3', 'Carla Dias', { bloqueado: true }),
    ])
    renderRoute('/usuarios')

    expect(await screen.findByRole('heading', { name: 'Usuários' })).toBeInTheDocument()
    expect(within(await linhaDe('Bruno Lima')).getByText('Inativo')).toBeInTheDocument()
    expect(within(await linhaDe('Carla Dias')).getByText('Bloqueado')).toBeInTheDocument()
    expect(within(await linhaDe('Ana Souza')).getByText('Admin')).toBeInTheDocument()
    expect(screen.getByText(/3 usuário\(s\) · página 1 de 1/)).toBeInTheDocument()
  })

  it('filtra pela busca e guarda o filtro na URL', async () => {
    const { fetchMock } = apiDeUsuarios([usuario(EU, 'Ana Souza'), usuario('2', 'Bruno Lima')])
    const { router } = renderRoute('/usuarios')
    const user = userEvent.setup()

    await linhaDe('Bruno Lima')
    await user.type(screen.getByRole('searchbox', { name: 'Buscar por nome ou e-mail' }), 'bruno')

    await waitFor(() => expect(screen.queryByRole('cell', { name: 'Ana Souza' })).not.toBeInTheDocument())
    expect(router.state.location.search).toBe('?busca=bruno')
    expect(fetchMock.mock.calls.some(([url]) => String(url).includes('busca=bruno'))).toBe(true)
  })

  it('filtra por situação', async () => {
    apiDeUsuarios([usuario(EU, 'Ana Souza'), usuario('2', 'Bruno Lima', { ativo: false })])
    renderRoute('/usuarios')
    const user = userEvent.setup()

    await linhaDe('Ana Souza')
    await user.click(screen.getByRole('combobox', { name: 'Filtrar por situação' }))
    await user.click(await screen.findByRole('option', { name: 'Inativos' }))

    await waitFor(() => expect(screen.queryByRole('cell', { name: 'Ana Souza' })).not.toBeInTheDocument())
    expect(screen.getByRole('cell', { name: 'Bruno Lima' })).toBeInTheDocument()
  })

  it('cria um usuário com perfis', async () => {
    const { usuarios } = apiDeUsuarios([usuario(EU, 'Ana Souza')])
    renderRoute('/usuarios')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'Novo usuário' }))
    const dialogo = await screen.findByRole('dialog', { name: 'Novo usuário' })
    await user.type(within(dialogo).getByLabelText('Nome'), 'Diego Rocha')
    await user.type(within(dialogo).getByLabelText('E-mail'), 'diego@stowise.dev')
    await user.type(within(dialogo).getByLabelText('Senha inicial'), 'senha-forte-1')
    await user.click(within(dialogo).getByRole('checkbox', { name: 'Gestor' }))
    await user.click(within(dialogo).getByRole('button', { name: 'Salvar' }))

    await waitFor(() => expect(screen.queryByRole('dialog')).not.toBeInTheDocument())
    expect(usuarios.at(-1)).toMatchObject({ nome: 'Diego Rocha', email: 'diego@stowise.dev', perfis: ['Gestor'] })
    expect(await screen.findByRole('cell', { name: 'Diego Rocha' })).toBeInTheDocument()
  })

  it('mostra o erro do campo e o conflito de e-mail ao criar', async () => {
    apiDeUsuarios([usuario(EU, 'Ana Souza')])
    renderRoute('/usuarios')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'Novo usuário' }))
    const dialogo = await screen.findByRole('dialog')
    await user.type(within(dialogo).getByLabelText('Nome'), 'Outra Ana')
    await user.type(within(dialogo).getByLabelText('E-mail'), 'ana@stowise.dev')
    await user.type(within(dialogo).getByLabelText('Senha inicial'), 'curta')
    await user.click(within(dialogo).getByRole('button', { name: 'Salvar' }))
    expect(await within(dialogo).findByRole('alert')).toHaveTextContent('Já existe um usuário com este e-mail.')

    await user.clear(within(dialogo).getByLabelText('E-mail'))
    await user.type(within(dialogo).getByLabelText('E-mail'), 'outra@stowise.dev')
    await user.click(within(dialogo).getByRole('button', { name: 'Salvar' }))
    expect(await within(dialogo).findByText('A senha deve ter ao menos 8 caracteres.')).toBeInTheDocument()
    expect(within(dialogo).getByLabelText('Senha inicial')).toHaveAttribute('aria-invalid', 'true')
  })

  it('edita o nome e os perfis', async () => {
    const { usuarios } = apiDeUsuarios([usuario(EU, 'Ana Souza', { perfis: ['Admin'] }), usuario('2', 'Bruno Lima')])
    renderRoute('/usuarios')

    const user = await abrirAcao('Bruno Lima', 'Editar')
    const dialogo = await screen.findByRole('dialog', { name: 'Editar usuário' })
    expect(within(dialogo).getByRole('checkbox', { name: 'Operador' })).toBeChecked()
    await user.click(within(dialogo).getByRole('checkbox', { name: 'Gestor' }))
    await user.click(within(dialogo).getByRole('button', { name: 'Salvar' }))

    await waitFor(() => expect(usuarios[1].perfis).toEqual(['Operador', 'Gestor']))
    expect(await within(await linhaDe('Bruno Lima')).findByText('Gestor')).toBeInTheDocument()
  })

  it('desativa e reativa um usuário', async () => {
    const { usuarios } = apiDeUsuarios([usuario(EU, 'Ana Souza', { perfis: ['Admin'] }), usuario('2', 'Bruno Lima')])
    renderRoute('/usuarios')

    await abrirAcao('Bruno Lima', 'Desativar')
    expect(await within(await linhaDe('Bruno Lima')).findByText('Inativo')).toBeInTheDocument()
    expect(usuarios[1].ativo).toBe(false)

    await abrirAcao('Bruno Lima', 'Reativar')
    expect(await within(await linhaDe('Bruno Lima')).findByText('Ativo')).toBeInTheDocument()
  })

  it('não oferece desativar a própria conta', async () => {
    apiDeUsuarios([usuario(EU, 'Ana Souza', { perfis: ['Admin'] })])
    renderRoute('/usuarios')
    const user = userEvent.setup()

    await user.click(within(await linhaDe('Ana Souza')).getByRole('button', { name: 'Ações de Ana Souza' }))
    const menu = await screen.findByRole('menu')
    expect(within(menu).getByRole('menuitem', { name: 'Editar' })).toBeInTheDocument()
    expect(within(menu).queryByRole('menuitem', { name: 'Desativar' })).not.toBeInTheDocument()
  })

  it('redefine a senha', async () => {
    const { fetchMock } = apiDeUsuarios([usuario(EU, 'Ana Souza'), usuario('2', 'Bruno Lima')])
    renderRoute('/usuarios')

    const user = await abrirAcao('Bruno Lima', 'Redefinir a senha')
    const dialogo = await screen.findByRole('dialog', { name: 'Redefinir a senha' })
    await user.type(within(dialogo).getByLabelText('Nova senha'), 'nova-senha-1')
    await user.click(within(dialogo).getByRole('button', { name: 'Redefinir' }))

    await waitFor(() => expect(screen.queryByRole('dialog')).not.toBeInTheDocument())
    const chamada = fetchMock.mock.calls.find(([url]) => url === '/api/v1/usuarios/2/senha')
    expect(JSON.parse(String(chamada?.[1]?.body))).toEqual({ novaSenha: 'nova-senha-1' })
  })

  it('pagina a lista', async () => {
    const muitos = Array.from({ length: 25 }, (_, i) => usuario(String(i + 1), `Pessoa ${String(i + 1).padStart(2, '0')}`))
    apiDeUsuarios(muitos)
    const { router } = renderRoute('/usuarios')
    const user = userEvent.setup()

    expect(await screen.findByText(/25 usuário\(s\) · página 1 de 2/)).toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'Anterior' })).toBeDisabled()
    await user.click(screen.getByRole('button', { name: 'Próxima' }))

    expect(await screen.findByRole('cell', { name: 'Pessoa 21' })).toBeInTheDocument()
    expect(router.state.location.search).toBe('?pagina=2')
    expect(screen.getByRole('button', { name: 'Próxima' })).toBeDisabled()
  })

  it('mostra "Acesso negado" para quem não é Admin', async () => {
    stubFetch(comSessao(() => jsonResponse({}), ['Gestor']))
    renderRoute('/usuarios')

    expect(await screen.findByRole('heading', { name: 'Acesso negado' })).toBeInTheDocument()
  })
})
