import { screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { usarSessao } from '../test/msw/api'
import { renderRoute } from '../test/renderRoute'

beforeEach(() => {
  usarSessao(['Admin'])
})

afterEach(() => {
  localStorage.clear()
  document.documentElement.className = ''
})

describe('layout base', () => {
  it('mostra as seções futuras desabilitadas, com "em breve"', async () => {
    renderRoute('/')

    const menu = await screen.findByRole('navigation', { name: 'Principal' })
    expect(within(menu).getByRole('link', { name: 'Início' })).toHaveAttribute('aria-current', 'page')
    const enderecos = within(menu).getByText('Estoque').closest('[aria-disabled]')
    expect(enderecos).toHaveAttribute('aria-disabled', 'true')
    expect(within(menu).getAllByText('em breve')).toHaveLength(3)
  })

  it('troca o tema e guarda a escolha no navegador', async () => {
    const user = userEvent.setup()
    renderRoute('/')

    await user.click(await screen.findByRole('button', { name: 'Mudar o tema' }))
    await user.click(await screen.findByRole('menuitemradio', { name: 'Escuro' }))

    await waitFor(() => expect(document.documentElement).toHaveClass('dark'))
    expect(localStorage.getItem('stowise-tema')).toBe('dark')
  })

  it('abre o menu no celular e fecha depois de navegar', async () => {
    const user = userEvent.setup()
    renderRoute('/')

    await user.click(await screen.findByRole('button', { name: 'Abrir o menu' }))
    const painel = await screen.findByRole('dialog')
    await user.click(within(painel).getByRole('link', { name: 'Início' }))

    await waitFor(() => expect(screen.queryByRole('dialog')).not.toBeInTheDocument())
  })
})
