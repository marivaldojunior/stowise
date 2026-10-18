import { screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { http, HttpResponse } from 'msw'
import type { EnderecoDetalhe, GerarEnderecos, StatusEndereco } from '@/api/gerado/modelos'
import { agruparPorRua, resumir } from '@/features/enderecos/mapa'
import { gravarRequisicoes, problema, requisicoesPara, server, usarSessao } from '@/test/msw/api'
import { renderRoute } from '@/test/renderRoute'

const ARMAZEM = {
  id: 'arm-1',
  codigo: 'CD1',
  nome: 'Centro de distribuição',
  zonas: [
    { id: 'z-seca', codigo: 'SECA', classeArmazenagem: 'Normal', enderecos: 4 },
    { id: 'z-fria', codigo: 'FRIA', classeArmazenagem: 'Refrigerado', enderecos: 0 },
  ],
}

function endereco(rua: string, modulo: number, nivel: number, posicao: number, status: StatusEndereco = 'Livre') {
  const codigo = `${rua}-${String(modulo).padStart(2, '0')}-${nivel}-${posicao}`
  return {
    id: codigo,
    armazemId: 'arm-1',
    zonaId: 'z-seca',
    codigo,
    rua,
    modulo,
    nivel,
    posicao,
    capacidadePesoKg: 1000,
    alturaCm: 150,
    larguraCm: 120,
    profundidadeCm: 100,
    distanciaExpedicao: 10 + modulo,
    status,
    motivoBloqueio: status === 'Bloqueado' ? 'Avaria na longarina' : null,
    bloqueadoEm: null,
    bloqueadoPor: null,
  } satisfies EnderecoDetalhe
}

/** API da estrutura em memória (handlers do MSW). */
function apiDeEnderecos(iniciais: EnderecoDetalhe[], perfis = ['Gestor']) {
  const enderecos = [...iniciais]
  const buscar = (id: unknown) => enderecos.find((e) => e.id === id)
  usarSessao(perfis)
  server.use(
    http.get('/api/v1/armazens', () =>
      HttpResponse.json([{ id: 'arm-1', codigo: 'CD1', nome: 'Centro de distribuição', zonas: 2, enderecos: 4 }]),
    ),
    http.get('/api/v1/armazens/arm-1', () => HttpResponse.json(ARMAZEM)),
    http.get('/api/v1/enderecos', ({ request }) => {
      const params = new URL(request.url).searchParams
      const codigo = params.get('codigo')?.toUpperCase()
      const status = params.get('status')
      const itens = enderecos.filter(
        (e) =>
          e.zonaId === params.get('zonaId') &&
          (!codigo || e.codigo.includes(codigo)) &&
          (!status || e.status === status),
      )
      const pagina = Number(params.get('pagina') ?? '1')
      const tamanho = Number(params.get('tamanhoPagina') ?? '20')
      return HttpResponse.json({
        itens: itens.slice((pagina - 1) * tamanho, pagina * tamanho),
        pagina,
        tamanhoPagina: tamanho,
        total: itens.length,
      })
    }),
    http.post('/api/v1/enderecos/:id/bloquear', async ({ params, request }) => {
      const alvo = buscar(params.id)
      const { motivo } = (await request.json()) as { motivo: string | null }
      if (!alvo) {
        return problema(404, 'Endereço não encontrado.')
      }

      if (!motivo) {
        return problema(400, 'Dados inválidos.', undefined, { motivo: ['Informe o motivo do bloqueio (até 200 caracteres).'] })
      }

      Object.assign(alvo, { status: 'Bloqueado', motivoBloqueio: motivo })
      return HttpResponse.json(alvo)
    }),
    http.post('/api/v1/enderecos/:id/desbloquear', ({ params }) => {
      const alvo = buscar(params.id)
      if (alvo) {
        Object.assign(alvo, { status: 'Livre', motivoBloqueio: null })
      }

      return new HttpResponse(null, { status: 204 })
    }),
    http.put('/api/v1/enderecos/:id', async ({ params, request }) => {
      const alvo = buscar(params.id)
      Object.assign(alvo ?? {}, await request.json())
      return HttpResponse.json(alvo)
    }),
    http.delete('/api/v1/enderecos/:id', ({ params }) => {
      const alvo = buscar(params.id)
      if (alvo?.status === 'Ocupado') {
        return problema(422, 'Endereço com saldo não pode ser excluído.')
      }

      enderecos.splice(enderecos.indexOf(alvo as EnderecoDetalhe), 1)
      return new HttpResponse(null, { status: 204 })
    }),
    http.post('/api/v1/enderecos/lote', async ({ request }) => {
      const corpo = (await request.json()) as GerarEnderecos
      const novos: EnderecoDetalhe[] = []
      for (const rua of corpo.ruas ?? []) {
        for (let m = corpo.moduloInicial ?? 1; m <= (corpo.moduloFinal ?? 1); m += 1) {
          for (let n = corpo.nivelInicial ?? 1; n <= (corpo.nivelFinal ?? 1); n += 1) {
            for (let p = corpo.posicaoInicial ?? 1; p <= (corpo.posicaoFinal ?? 1); p += 1) {
              novos.push(endereco(rua, m, n, p))
            }
          }
        }
      }

      const existentes = novos.filter((n) => buscar(n.id)).map((n) => n.codigo)
      if (!corpo.simular) {
        enderecos.push(...novos.filter((n) => !buscar(n.id)))
      }

      return HttpResponse.json({
        total: novos.length,
        criados: corpo.simular ? 0 : novos.length - existentes.length,
        ignorados: existentes.length,
        simulado: corpo.simular ?? false,
        codigosExistentes: existentes,
        amostra: novos.slice(0, 5).map((n) => n.codigo),
      })
    }),
  )

  return { enderecos, requisicoes: gravarRequisicoes() }
}

const INICIAIS = () => [
  endereco('A', 1, 1, 1, 'Ocupado'),
  endereco('A', 1, 2, 1),
  endereco('A', 2, 1, 1, 'Bloqueado'),
  endereco('B', 1, 1, 1, 'Ocupado'),
]

describe('mapa de ocupação', () => {
  it('agrupa por rua com o nível mais alto em cima e calcula a ocupação sem os bloqueados', () => {
    const ruas = agruparPorRua(INICIAIS())

    expect(ruas.map((r) => r.rua)).toEqual(['A', 'B'])
    expect(ruas[0].niveis.map((n) => n.nivel)).toEqual([2, 1])
    expect(ruas[0].niveis[1].modulos.map((m) => m.modulo)).toEqual([1, 2])
    expect(resumir(INICIAIS())).toEqual({ total: 4, porStatus: { Livre: 1, Ocupado: 2, Bloqueado: 1 }, ocupacao: 67 })
  })

  it('mostra o mapa da primeira zona do primeiro armazém, com a legenda', async () => {
    apiDeEnderecos(INICIAIS())
    renderRoute('/enderecos')

    expect(await screen.findByRole('figure', { name: 'Rua A' })).toBeInTheDocument()
    expect(screen.getByRole('figure', { name: 'Rua B' })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'A-01-1-1: Ocupado' })).toBeInTheDocument()
    expect(screen.getByText('67% ocupado')).toBeInTheDocument()
    expect(screen.getByText('Bloqueado: 1')).toBeInTheDocument()
  })

  it('lê todas as páginas da zona para montar o mapa', async () => {
    const muitos = Array.from({ length: 130 }, (_, i) => endereco('C', i + 1, 1, 1))
    const { requisicoes } = apiDeEnderecos(muitos)
    renderRoute('/enderecos')

    expect(await screen.findByText('Total: 130')).toBeInTheDocument()
    const paginas = requisicoes.filter((r) => r.url.startsWith('/api/v1/enderecos?'))
    expect(paginas.map((r) => new URLSearchParams(r.url.split('?')[1]).get('pagina'))).toEqual(['1', '2'])
  })

  it('avisa quando a zona não tem endereços', async () => {
    apiDeEnderecos([])
    renderRoute('/enderecos?armazemId=arm-1&zonaId=z-fria')

    expect(await screen.findByText('Esta zona ainda não tem endereços.')).toBeInTheDocument()
  })
})

describe('detalhe do endereço', () => {
  it('o Operador bloqueia com motivo, mas não desbloqueia nem exclui', async () => {
    const { enderecos } = apiDeEnderecos(INICIAIS(), ['Operador'])
    renderRoute('/enderecos')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'A-01-2-1: Livre' }))
    const dialogo = await screen.findByRole('dialog', { name: 'A-01-2-1' })
    expect(within(dialogo).queryByRole('button', { name: 'Excluir' })).not.toBeInTheDocument()
    expect(within(dialogo).queryByRole('button', { name: 'Editar dimensões' })).not.toBeInTheDocument()

    await user.click(within(dialogo).getByRole('button', { name: 'Bloquear' }))
    await user.click(within(dialogo).getByRole('button', { name: 'Bloquear' }))
    expect(await within(dialogo).findByText('Informe o motivo do bloqueio (até 200 caracteres).')).toBeInTheDocument()

    await user.type(within(dialogo).getByLabelText('Motivo do bloqueio'), 'Palete caído')
    await user.click(within(dialogo).getByRole('button', { name: 'Bloquear' }))

    expect(await screen.findByRole('button', { name: 'A-01-2-1: Bloqueado' })).toBeInTheDocument()
    expect(enderecos[1].motivoBloqueio).toBe('Palete caído')

    await user.click(screen.getByRole('button', { name: 'A-01-2-1: Bloqueado' }))
    const bloqueado = await screen.findByRole('dialog')
    expect(within(bloqueado).getByText('Palete caído')).toBeInTheDocument()
    expect(within(bloqueado).queryByRole('button', { name: 'Desbloquear' })).not.toBeInTheDocument()
  })

  it('a gestão desbloqueia', async () => {
    apiDeEnderecos(INICIAIS())
    renderRoute('/enderecos')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'A-02-1-1: Bloqueado' }))
    const dialogo = await screen.findByRole('dialog')
    expect(within(dialogo).getByText('Avaria na longarina')).toBeInTheDocument()
    await user.click(within(dialogo).getByRole('button', { name: 'Desbloquear' }))

    expect(await screen.findByRole('button', { name: 'A-02-1-1: Livre' })).toBeInTheDocument()
  })

  it('edita as dimensões com vírgula decimal', async () => {
    const { requisicoes } = apiDeEnderecos(INICIAIS())
    renderRoute('/enderecos')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'A-01-2-1: Livre' }))
    const dialogo = await screen.findByRole('dialog')
    await user.click(within(dialogo).getByRole('button', { name: 'Editar dimensões' }))
    const capacidade = within(dialogo).getByLabelText('Capacidade (kg)')
    await user.clear(capacidade)
    await user.type(capacidade, '1250,5')
    await user.click(within(dialogo).getByRole('button', { name: 'Salvar' }))

    await waitFor(() => expect(screen.queryByRole('dialog')).not.toBeInTheDocument())
    expect(requisicoesPara(requisicoes, '/api/v1/enderecos/A-01-2-1')[0].corpo).toEqual({
      capacidadePesoKg: 1250.5,
      alturaCm: 150,
      larguraCm: 120,
      profundidadeCm: 100,
      distanciaExpedicao: 11,
    })
  })

  it('pede confirmação para excluir e mostra a regra da API', async () => {
    apiDeEnderecos(INICIAIS())
    renderRoute('/enderecos')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'A-01-1-1: Ocupado' }))
    const dialogo = await screen.findByRole('dialog')
    await user.click(within(dialogo).getByRole('button', { name: 'Excluir' }))
    await user.click(within(dialogo).getByRole('button', { name: 'Confirmar a exclusão' }))

    expect(await within(dialogo).findByRole('alert')).toHaveTextContent('Endereço com saldo não pode ser excluído.')
  })

  it('leva ao saldo e ao extrato do endereço', async () => {
    apiDeEnderecos(INICIAIS())
    renderRoute('/enderecos')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'A-01-1-1: Ocupado' }))
    const dialogo = await screen.findByRole('dialog')

    expect(within(dialogo).getByRole('link', { name: 'Ver saldo' })).toHaveAttribute('href', '/estoque?enderecoId=A-01-1-1')
    expect(within(dialogo).getByRole('link', { name: 'Ver extrato' })).toHaveAttribute(
      'href',
      '/estoque/extrato?enderecoId=A-01-1-1',
    )
  })
})

describe('lista e cadastro', () => {
  it('mostra a lista filtrada por situação', async () => {
    apiDeEnderecos(INICIAIS())
    const { router } = renderRoute('/enderecos?visao=lista')
    const user = userEvent.setup()

    expect(await screen.findByRole('button', { name: 'B-01-1-1' })).toBeInTheDocument()
    await user.click(screen.getByRole('combobox', { name: 'Filtrar por situação' }))
    await user.click(await screen.findByRole('option', { name: 'Bloqueado' }))

    await waitFor(() => expect(screen.queryByRole('button', { name: 'B-01-1-1' })).not.toBeInTheDocument())
    expect(screen.getByRole('button', { name: 'A-02-1-1' })).toBeInTheDocument()
    expect(router.state.location.search).toContain('status=Bloqueado')
  })

  it('gera em lote depois da prévia', async () => {
    const { enderecos, requisicoes } = apiDeEnderecos(INICIAIS())
    renderRoute('/enderecos')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'Gerar em lote' }))
    const dialogo = await screen.findByRole('dialog', { name: 'Gerar endereços em lote' })
    await user.type(within(dialogo).getByLabelText('Ruas (separadas por vírgula ou espaço)'), 'a, c')
    await user.type(within(dialogo).getByLabelText('Módulo inicial'), '1')
    await user.type(within(dialogo).getByLabelText('Módulo final'), '2')
    await user.type(within(dialogo).getByLabelText('Nível inicial'), '1')
    await user.type(within(dialogo).getByLabelText('Nível final'), '1')
    await user.type(within(dialogo).getByLabelText('Posição inicial'), '1')
    await user.type(within(dialogo).getByLabelText('Posição final'), '1')
    await user.click(within(dialogo).getByRole('button', { name: 'Ver a prévia' }))

    const previa = await within(dialogo).findByRole('region', { name: 'Prévia da geração' })
    expect(previa).toHaveTextContent('4 endereço(s) no lote: 2 novo(s), 2 já existem.')
    expect(enderecos).toHaveLength(4)

    await user.click(within(dialogo).getByRole('button', { name: 'Criar 2 endereço(s)' }))
    await waitFor(() => expect(screen.queryByRole('dialog')).not.toBeInTheDocument())
    expect(enderecos).toHaveLength(6)
    const pedidos = requisicoesPara(requisicoes, '/api/v1/enderecos/lote').map((r) => r.corpo as GerarEnderecos)
    expect(pedidos.map((p) => [p.ruas, p.simular])).toEqual([
      [['A', 'C'], true],
      [['A', 'C'], false],
    ])
    expect(await screen.findByRole('button', { name: 'C-02-1-1: Livre' })).toBeInTheDocument()
  })

  it('o Operador não vê os botões de cadastro', async () => {
    apiDeEnderecos(INICIAIS(), ['Operador'])
    renderRoute('/enderecos')

    await screen.findByRole('figure', { name: 'Rua A' })
    expect(screen.queryByRole('button', { name: 'Gerar em lote' })).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Novo endereço' })).not.toBeInTheDocument()
  })
})
