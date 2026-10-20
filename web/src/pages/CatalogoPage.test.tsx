import { screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { http, HttpResponse } from 'msw'
import type { CriarProduto, EmbalagemDetalhe, ProdutoDetalhe } from '@/api/gerado/modelos'
import { gravarRequisicoes, problema, requisicoesPara, server, usarSessao } from '@/test/msw/api'
import { renderRoute } from '@/test/renderRoute'

const CATEGORIAS = [
  { id: 'cat-1', nome: 'Grãos', parentId: null, caminho: 'Alimentos > Grãos' },
  { id: 'cat-2', nome: 'Bebidas', parentId: null, caminho: 'Bebidas' },
]

function embalagemBase(extra: Partial<EmbalagemDetalhe> = {}): EmbalagemDetalhe {
  return {
    id: 'emb-base',
    tipo: 'Unidade',
    fatorConversao: 1,
    unidadeBase: true,
    gtin: null,
    pesoKg: null,
    alturaCm: null,
    larguraCm: null,
    comprimentoCm: null,
    ...extra,
  }
}

function produto(id: string, sku: string, descricao: string, extra: Partial<ProdutoDetalhe> = {}): ProdutoDetalhe {
  return {
    id,
    sku,
    descricao,
    unidadeBase: 'UN',
    classeArmazenagem: 'Normal',
    controlaLote: false,
    controlaValidade: false,
    ncm: null,
    cest: null,
    categoriaId: null,
    ativo: true,
    statusCadastro: 'Incompleto',
    versao: 1,
    embalagens: [embalagemBase()],
    ...extra,
  }
}

/** API do catálogo em memória (handlers do MSW), com versão (xmin) e as regras de embalagem do domínio. */
function apiDoCatalogo(iniciais: ProdutoDetalhe[], perfis = ['Gestor']) {
  const produtos = [...iniciais]
  const buscar = (id: unknown) => produtos.find((p) => p.id === id)
  const salvo = (p: ProdutoDetalhe) => {
    p.versao += 1
    return HttpResponse.json(p)
  }
  usarSessao(perfis)
  server.use(
    http.get('/api/v1/categorias', () => HttpResponse.json(CATEGORIAS)),
    http.get('/api/v1/produtos', ({ request }) => {
      const params = new URL(request.url).searchParams
      const busca = params.get('busca')?.toLowerCase()
      const categoriaId = params.get('categoriaId')
      const ativo = params.get('ativo')
      const itens = produtos.filter(
        (p) =>
          (!busca || p.sku.toLowerCase().includes(busca) || p.descricao.toLowerCase().includes(busca)) &&
          (!categoriaId || p.categoriaId === categoriaId) &&
          (ativo === null || String(p.ativo) === ativo),
      )
      return HttpResponse.json({ itens, pagina: 1, tamanhoPagina: 20, total: itens.length })
    }),
    http.get('/api/v1/saldos/produtos/:id', ({ params }) => {
      const alvo = buscar(params.id)
      return HttpResponse.json({
        produtoId: params.id,
        sku: alvo?.sku ?? '',
        descricao: alvo?.descricao ?? '',
        unidadeBase: alvo?.unidadeBase ?? 'UN',
        quantidade: 0,
        quantidadeReservada: 0,
        quantidadeDisponivel: 0,
        enderecos: 0,
        lotes: [],
      })
    }),
    http.get('/api/v1/produtos/:id', ({ params }) => {
      const alvo = buscar(params.id)
      return alvo ? HttpResponse.json(alvo) : problema(404, 'Produto não encontrado.')
    }),
    http.post('/api/v1/produtos', async ({ request }) => {
      const corpo = (await request.json()) as CriarProduto
      if (produtos.some((p) => p.sku === corpo.sku)) {
        return problema(409, `Já existe um produto com o SKU ${corpo.sku}.`)
      }

      if (!corpo.descricao) {
        return problema(400, 'Dados inválidos.', undefined, { descricao: ['Informe a descrição (até 200 caracteres).'] })
      }

      const novo = produto('p-novo', corpo.sku ?? '', corpo.descricao, {
        unidadeBase: corpo.unidadeBase ?? 'UN',
        classeArmazenagem: corpo.classeArmazenagem ?? 'Normal',
        categoriaId: corpo.categoriaId,
        embalagens: [embalagemBase({ ...corpo.embalagemBase })],
      })
      produtos.push(novo)
      return HttpResponse.json(novo, { status: 201 })
    }),
    http.put('/api/v1/produtos/:id', async ({ params, request }) => {
      const alvo = buscar(params.id)
      if (!alvo) {
        return problema(404, 'Produto não encontrado.')
      }

      const corpo = (await request.json()) as Partial<ProdutoDetalhe>
      if (corpo.versao !== alvo.versao) {
        return problema(409, 'O produto foi alterado por outra pessoa depois que você o abriu. Recarregue e tente de novo.')
      }

      Object.assign(alvo, { ...corpo, versao: alvo.versao })
      return salvo(alvo)
    }),
    http.post('/api/v1/produtos/:id/desativar', ({ params }) => {
      const alvo = buscar(params.id)
      if (alvo) {
        alvo.ativo = false
        alvo.versao += 1
      }

      return new HttpResponse(null, { status: 204 })
    }),
    http.post('/api/v1/produtos/:id/embalagens', async ({ params, request }) => {
      const alvo = buscar(params.id)
      if (!alvo) {
        return problema(404, 'Produto não encontrado.')
      }

      const corpo = (await request.json()) as Omit<EmbalagemDetalhe, 'id' | 'unidadeBase'>
      if ((corpo.fatorConversao ?? 0) <= 1) {
        return problema(422, 'O fator de conversão de caixa ou palete deve ser maior que 1.')
      }

      alvo.embalagens.push({ ...corpo, id: `emb-${alvo.embalagens.length}`, unidadeBase: false })
      return salvo(alvo)
    }),
    http.put('/api/v1/produtos/:id/embalagens/:embalagemId', async ({ params, request }) => {
      const alvo = buscar(params.id)
      const embalagem = alvo?.embalagens.find((e) => e.id === params.embalagemId)
      if (!alvo || !embalagem) {
        return problema(404, 'Embalagem não encontrada neste produto.')
      }

      Object.assign(embalagem, await request.json())
      return salvo(alvo)
    }),
    http.delete('/api/v1/produtos/:id/embalagens/:embalagemId', ({ params }) => {
      const alvo = buscar(params.id)
      if (!alvo) {
        return problema(404, 'Produto não encontrado.')
      }

      alvo.embalagens = alvo.embalagens.filter((e) => e.id !== params.embalagemId)
      return salvo(alvo)
    }),
  )

  return { produtos, requisicoes: gravarRequisicoes() }
}

async function linhaDe(texto: string) {
  const celula = await screen.findByRole('cell', { name: texto })
  return celula.closest('tr') as HTMLElement
}

describe('lista do catálogo', () => {
  it('mostra os produtos com o caminho da categoria e filtra pela categoria', async () => {
    apiDoCatalogo([
      produto('1', 'ARROZ-5KG', 'Arroz tipo 1 5kg', { categoriaId: 'cat-1' }),
      produto('2', 'SUCO-1L', 'Suco de uva 1L', { categoriaId: 'cat-2', classeArmazenagem: 'Refrigerado' }),
    ])
    const { router } = renderRoute('/catalogo')
    const user = userEvent.setup()

    expect(within(await linhaDe('Arroz tipo 1 5kg')).getByText('Alimentos > Grãos')).toBeInTheDocument()
    expect(within(await linhaDe('Suco de uva 1L')).getByText('Refrigerado')).toBeInTheDocument()

    await user.click(screen.getByRole('combobox', { name: 'Filtrar por categoria' }))
    await user.click(await screen.findByRole('option', { name: 'Bebidas' }))

    await waitFor(() => expect(screen.queryByRole('cell', { name: 'Arroz tipo 1 5kg' })).not.toBeInTheDocument())
    expect(router.state.location.search).toBe('?categoriaId=cat-2')
  })

  it('busca por SKU ou descrição', async () => {
    const { requisicoes } = apiDoCatalogo([produto('1', 'ARROZ-5KG', 'Arroz'), produto('2', 'SUCO-1L', 'Suco')])
    renderRoute('/catalogo')
    const user = userEvent.setup()

    await linhaDe('Arroz')
    await user.type(screen.getByRole('searchbox', { name: 'Buscar por SKU ou descrição' }), 'suco')

    await waitFor(() => expect(screen.queryByRole('cell', { name: 'Arroz' })).not.toBeInTheDocument())
    expect(requisicoes.some((r) => r.url.includes('busca=suco'))).toBe(true)
  })

  it('o Operador consulta, mas não vê "Novo produto"', async () => {
    apiDoCatalogo([produto('1', 'ARROZ-5KG', 'Arroz')], ['Operador'])
    renderRoute('/catalogo')

    await linhaDe('Arroz')
    expect(screen.queryByRole('link', { name: 'Novo produto' })).not.toBeInTheDocument()
  })

  it('abre o produto ao clicar no SKU', async () => {
    apiDoCatalogo([produto('1', 'ARROZ-5KG', 'Arroz tipo 1')])
    const { router } = renderRoute('/catalogo')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('link', { name: 'ARROZ-5KG' }))

    await waitFor(() => expect(router.state.location.pathname).toBe('/catalogo/1'))
    expect(await screen.findByRole('heading', { name: 'Arroz tipo 1' })).toBeInTheDocument()
  })
})

describe('cadastro de produto', () => {
  it('cria o produto com a embalagem base e abre a página dele', async () => {
    const { requisicoes } = apiDoCatalogo([])
    const { router } = renderRoute('/catalogo/novo')
    const user = userEvent.setup()

    await user.type(await screen.findByLabelText('SKU'), 'FEIJAO-1KG')
    await user.type(screen.getByLabelText('Descrição'), 'Feijão carioca 1kg')
    await user.click(screen.getByRole('combobox', { name: 'Categoria' }))
    await user.click(await screen.findByRole('option', { name: 'Alimentos > Grãos' }))
    await user.type(screen.getByLabelText('Peso (kg)'), '1,02')
    await user.type(screen.getByLabelText('GTIN (código de barras)'), '7891234567895')
    await user.click(screen.getByRole('button', { name: 'Criar produto' }))

    await waitFor(() => expect(router.state.location.pathname).toBe('/catalogo/p-novo'))
    expect(await screen.findByRole('heading', { name: 'Feijão carioca 1kg' })).toBeInTheDocument()
    expect(requisicoesPara(requisicoes, '/api/v1/produtos').find((r) => r.metodo === 'POST')?.corpo).toEqual({
      sku: 'FEIJAO-1KG',
      descricao: 'Feijão carioca 1kg',
      unidadeBase: 'UN',
      classeArmazenagem: 'Normal',
      controlaLote: false,
      controlaValidade: false,
      ncm: null,
      cest: null,
      categoriaId: 'cat-1',
      embalagemBase: { gtin: '7891234567895', pesoKg: 1.02, alturaCm: null, larguraCm: null, comprimentoCm: null },
    })
  })

  it('recusa medida que não é número sem chamar a API', async () => {
    const { requisicoes } = apiDoCatalogo([])
    renderRoute('/catalogo/novo')
    const user = userEvent.setup()

    await user.type(await screen.findByLabelText('SKU'), 'X')
    await user.type(screen.getByLabelText('Descrição'), 'Produto X')
    await user.type(screen.getByLabelText('Altura (cm)'), 'dez')
    await user.click(screen.getByRole('button', { name: 'Criar produto' }))

    expect(await screen.findByText('Informe um número maior que zero.')).toBeInTheDocument()
    expect(screen.getByLabelText('Altura (cm)')).toHaveAttribute('aria-invalid', 'true')
    expect(requisicoesPara(requisicoes, '/api/v1/produtos').filter((r) => r.metodo === 'POST')).toHaveLength(0)
  })

  it('mostra o erro de campo e o SKU repetido', async () => {
    apiDoCatalogo([produto('1', 'ARROZ-5KG', 'Arroz')])
    renderRoute('/catalogo/novo')
    const user = userEvent.setup()

    await user.type(await screen.findByLabelText('SKU'), 'NOVO')
    await user.click(screen.getByRole('button', { name: 'Criar produto' }))
    expect(await screen.findByText('Informe a descrição (até 200 caracteres).')).toBeInTheDocument()

    await user.clear(screen.getByLabelText('SKU'))
    await user.type(screen.getByLabelText('SKU'), 'ARROZ-5KG')
    await user.type(screen.getByLabelText('Descrição'), 'Outro arroz')
    await user.click(screen.getByRole('button', { name: 'Criar produto' }))
    expect(await screen.findByRole('alert')).toHaveTextContent('Já existe um produto com o SKU ARROZ-5KG.')
  })

  it('o Operador recebe "Acesso negado" no cadastro', async () => {
    apiDoCatalogo([], ['Operador'])
    renderRoute('/catalogo/novo')

    expect(await screen.findByRole('heading', { name: 'Acesso negado' })).toBeInTheDocument()
  })
})

describe('edição de produto', () => {
  it('salva com a versão lida', async () => {
    const { produtos, requisicoes } = apiDoCatalogo([produto('1', 'ARROZ-5KG', 'Arroz', { versao: 7 })])
    renderRoute('/catalogo/1')
    const user = userEvent.setup()

    const descricao = await screen.findByLabelText('Descrição')
    expect(screen.getByLabelText('SKU')).toHaveAttribute('readonly')
    await user.clear(descricao)
    await user.type(descricao, 'Arroz agulhinha 5kg')
    await user.click(screen.getByRole('button', { name: 'Salvar alterações' }))

    expect(await screen.findByRole('heading', { name: 'Arroz agulhinha 5kg' })).toBeInTheDocument()
    expect(requisicoesPara(requisicoes, '/api/v1/produtos/1').find((r) => r.metodo === 'PUT')?.corpo).toMatchObject({
      descricao: 'Arroz agulhinha 5kg',
      versao: 7,
    })
    expect(produtos[0].versao).toBe(8)
  })

  it('avisa do conflito de versão e carrega a versão atual', async () => {
    const { produtos } = apiDoCatalogo([produto('1', 'ARROZ-5KG', 'Arroz')])
    renderRoute('/catalogo/1')
    const user = userEvent.setup()

    const descricao = await screen.findByLabelText('Descrição')
    // Outra pessoa salva antes.
    Object.assign(produtos[0], { descricao: 'Arroz (alterado por outra pessoa)', versao: 2 })
    await user.clear(descricao)
    await user.type(descricao, 'Minha versão')
    await user.click(screen.getByRole('button', { name: 'Salvar alterações' }))

    expect(await screen.findByText(/Outra pessoa alterou este produto/)).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: 'Carregar a versão atual' }))

    await waitFor(() => expect(screen.getByLabelText('Descrição')).toHaveValue('Arroz (alterado por outra pessoa)'))
    expect(screen.queryByText(/Outra pessoa alterou este produto/)).not.toBeInTheDocument()
  })

  it('o Operador vê o produto só para leitura', async () => {
    apiDoCatalogo([produto('1', 'ARROZ-5KG', 'Arroz')], ['Operador'])
    renderRoute('/catalogo/1')

    expect(await screen.findByLabelText('Descrição')).toBeDisabled()
    expect(screen.queryByRole('button', { name: 'Salvar alterações' })).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Nova embalagem' })).not.toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Desativar produto' })).not.toBeInTheDocument()
  })

  it('desativa o produto', async () => {
    apiDoCatalogo([produto('1', 'ARROZ-5KG', 'Arroz')])
    renderRoute('/catalogo/1')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'Desativar produto' }))

    expect(await screen.findByRole('button', { name: 'Reativar produto' })).toBeInTheDocument()
    expect(screen.getByText('Inativo')).toBeInTheDocument()
  })

  it('mostra o produto não encontrado', async () => {
    apiDoCatalogo([])
    renderRoute('/catalogo/nao-existe')

    expect(await screen.findByRole('alert')).toHaveTextContent('Produto não encontrado.')
  })
})

describe('embalagens', () => {
  it('adiciona uma caixa e mostra a regra do fator', async () => {
    apiDoCatalogo([produto('1', 'ARROZ-5KG', 'Arroz')])
    renderRoute('/catalogo/1')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'Nova embalagem' }))
    const dialogo = await screen.findByRole('dialog', { name: 'Nova embalagem' })
    await user.type(within(dialogo).getByLabelText('Quantidade de UN'), '1')
    await user.click(within(dialogo).getByRole('button', { name: 'Salvar' }))
    expect(await within(dialogo).findByRole('alert')).toHaveTextContent('deve ser maior que 1')

    await user.clear(within(dialogo).getByLabelText('Quantidade de UN'))
    await user.type(within(dialogo).getByLabelText('Quantidade de UN'), '12')
    await user.type(within(dialogo).getByLabelText('Peso (kg)'), '61,5')
    await user.click(within(dialogo).getByRole('button', { name: 'Salvar' }))

    await waitFor(() => expect(screen.queryByRole('dialog')).not.toBeInTheDocument())
    const caixa = await linhaDe('Caixa')
    expect(within(caixa).getByText('12 UN')).toBeInTheDocument()
    expect(within(caixa).getByText('61,5 kg')).toBeInTheDocument()

    // A embalagem base não tem botão de remover.
    expect(screen.queryByRole('button', { name: 'Remover Unidade (fator 1)' })).not.toBeInTheDocument()
  })

  it('edita as medidas e remove uma caixa', async () => {
    apiDoCatalogo([
      produto('1', 'ARROZ-5KG', 'Arroz', {
        embalagens: [
          embalagemBase(),
          { ...embalagemBase(), id: 'cx', tipo: 'Caixa', fatorConversao: 6, unidadeBase: false, pesoKg: 30 },
        ],
      }),
    ])
    renderRoute('/catalogo/1')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'Editar Caixa (fator 6)' }))
    const dialogo = await screen.findByRole('dialog', { name: 'Editar embalagem' })
    expect(within(dialogo).getByLabelText('Peso (kg)')).toHaveValue('30')
    await user.type(within(dialogo).getByLabelText('Altura (cm)'), '25')
    await user.click(within(dialogo).getByRole('button', { name: 'Salvar' }))
    expect(await within(await linhaDe('Caixa')).findByText('25 × ? × ? cm')).toBeInTheDocument()

    await user.click(screen.getByRole('button', { name: 'Remover Caixa (fator 6)' }))
    await waitFor(() => expect(screen.queryByRole('cell', { name: 'Caixa' })).not.toBeInTheDocument())
  })
})
