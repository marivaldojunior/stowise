import { screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { http, HttpResponse } from 'msw'
import type { ConfirmarMapeamento, ImportacaoDetalhe } from '@/api/gerado/modelos'
import { gravarRequisicoes, problema, requisicoesPara, server, usarSessao } from '@/test/msw/api'
import { renderRoute } from '@/test/renderRoute'

const CAMPOS = [
  { nome: 'sku', descricao: 'Código do produto', obrigatorio: true },
  { nome: 'descricao', descricao: 'Nome do produto', obrigatorio: true },
  { nome: 'unidade', descricao: 'Unidade base', obrigatorio: false },
  { nome: 'pesoKg', descricao: 'Peso da unidade', obrigatorio: false },
]

function importacao(extra: Partial<ImportacaoDetalhe> = {}): ImportacaoDetalhe {
  return {
    id: 'imp-1',
    tipo: 'Produtos',
    status: 'Recebido',
    nomeArquivo: 'produtos.csv',
    hashArquivo: 'abc',
    tamanhoBytes: 120,
    layout: {
      formato: 'Delimitado',
      encoding: 'UTF-8',
      delimitador: ';',
      separadorDecimal: ',',
      temCabecalho: true,
      colunas: [
        { indice: 0, nome: 'Codigo' },
        { indice: 1, nome: 'Nome' },
        { indice: 2, nome: 'Unid' },
        { indice: 3, nome: 'Peso' },
      ],
    },
    amostra: [
      ['A1', 'Arroz 5kg', 'UND', '5,1'],
      ['F1', 'Feijão 1kg', 'UND', '1,02'],
    ],
    totalLinhas: 2,
    usuarioId: 'u-1',
    iniciadoEm: '2026-10-18T12:00:00Z',
    concluidoEm: null,
    fingerprint: 'fp',
    templateId: null,
    mapeamento: null,
    mapeamentoConfirmadoPor: null,
    mapeamentoConfirmadoEm: null,
    linhasValidas: 0,
    linhasComErro: 0,
    linhasPossivelDuplicata: 0,
    linhasProcessadas: 0,
    produtosCriados: 0,
    produtosAtualizados: 0,
    motivoFalha: null,
    regras: null,
    sugestaoIa: null,
    mapeamentoSugeridoPorIa: false,
    motivoSemSugestao: null,
    versao: 1,
    ...extra,
  } as ImportacaoDetalhe
}

const SUGESTAO = {
  colunas: [
    { campo: 'sku', coluna: 0, confianca: 0.97 },
    { campo: 'descricao', coluna: 1, confianca: 0.95 },
    { campo: 'unidade', coluna: 2, confianca: 0.4 },
  ],
  regras: { separadorDecimal: ',', unidades: [{ origem: 'UND', destino: 'UN' }], valoresVerdadeiros: ['S'], valoresFalsos: ['N'] },
  observacao: 'A coluna Peso parece estar em gramas.',
  chamadaIaId: 'c-1',
}

/** API da importação em memória (handlers do MSW). */
function apiDeImportacao(inicial: ImportacaoDetalhe) {
  let atual = inicial
  usarSessao(['Gestor'])
  server.use(
    http.get('/api/v1/importacoes/produtos/campos', () => HttpResponse.json(CAMPOS)),
    http.get('/api/v1/importacoes/imp-1', () => HttpResponse.json(atual)),
    http.get('/api/v1/importacoes', () =>
      HttpResponse.json({ itens: [atual], pagina: 1, tamanhoPagina: 20, total: 1 }),
    ),
    http.post('/api/v1/importacoes/produtos', () => {
      atual = inicial
      return HttpResponse.json(atual, { status: 201 })
    }),
    http.post('/api/v1/importacoes/imp-1/sugestao', async ({ request }) => {
      const { versao } = (await request.json()) as { versao: number }
      if (versao !== atual.versao) {
        return problema(409, 'A importação foi alterada por outra pessoa depois que você a abriu. Recarregue e tente de novo.')
      }

      atual = { ...atual, status: 'Mapeando', versao: atual.versao + 1 }
      return HttpResponse.json(atual, { status: 202 })
    }),
    http.put('/api/v1/importacoes/imp-1/mapeamento', async ({ request }) => {
      const corpo = (await request.json()) as ConfirmarMapeamento
      atual = { ...atual, status: 'Validando', mapeamento: corpo.colunas, versao: atual.versao + 1 }
      return HttpResponse.json(atual, { status: 202 })
    }),
  )

  return {
    requisicoes: gravarRequisicoes(),
    /** Simula o job: a importação muda no servidor sem a tela pedir. */
    mudar: (dados: Partial<ImportacaoDetalhe>) => {
      atual = { ...atual, ...dados }
    },
  }
}

describe('envio do arquivo', () => {
  it('envia o arquivo e abre a importação', async () => {
    const { requisicoes } = apiDeImportacao(importacao())
    const { router } = renderRoute('/importacoes')
    const user = userEvent.setup()

    expect(await screen.findByRole('link', { name: 'produtos.csv' })).toBeInTheDocument()
    await user.upload(screen.getByLabelText('Arquivo de produtos'), new File(['Codigo;Nome'], 'produtos.csv', { type: 'text/csv' }))

    await waitFor(() => expect(router.state.location.pathname).toBe('/importacoes/imp-1'))
    expect(requisicoesPara(requisicoes, '/api/v1/importacoes/produtos').filter((r) => r.metodo === 'POST')).toHaveLength(1)
    expect(await screen.findByRole('heading', { name: 'produtos.csv' })).toBeInTheDocument()
  })

  it('mostra o arquivo repetido recusado pela API', async () => {
    apiDeImportacao(importacao())
    server.use(
      http.post('/api/v1/importacoes/produtos', () =>
        problema(409, 'Este arquivo já foi enviado como produtos.csv (importação imp-1).'),
      ),
    )
    renderRoute('/importacoes')
    const user = userEvent.setup()

    await user.upload(await screen.findByLabelText('Arquivo de produtos'), new File(['x'], 'produtos.csv'))

    expect(await screen.findByRole('alert')).toHaveTextContent('Este arquivo já foi enviado')
  })

  it('o Operador recebe "Acesso negado"', async () => {
    usarSessao(['Operador'])
    renderRoute('/importacoes')

    expect(await screen.findByRole('heading', { name: 'Acesso negado' })).toBeInTheDocument()
  })
})

describe('mapeamento', () => {
  it('mostra a amostra e faz o mapeamento manual', async () => {
    const { requisicoes } = apiDeImportacao(importacao({ motivoSemSugestao: 'A IA está desligada. Faça o mapeamento manual.' }))
    renderRoute('/importacoes/imp-1')
    const user = userEvent.setup()

    expect(await screen.findByText('A IA está desligada. Faça o mapeamento manual.')).toBeInTheDocument()
    expect(screen.getByRole('columnheader', { name: '2. Nome' })).toBeInTheDocument()
    expect(screen.getByText('Falta escolher a coluna de: sku, descricao.')).toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'Confirmar o mapeamento e validar' })).toBeDisabled()

    await user.click(screen.getByRole('combobox', { name: 'Coluna do campo sku' }))
    await user.click(await screen.findByRole('option', { name: '1. Codigo' }))
    await user.click(screen.getByRole('combobox', { name: 'Coluna do campo descricao' }))
    await user.click(await screen.findByRole('option', { name: '2. Nome' }))
    expect(screen.getAllByText('Arroz 5kg')).toHaveLength(2)

    await user.click(screen.getByRole('button', { name: 'Confirmar o mapeamento e validar' }))

    expect(await screen.findByText('Validando as linhas do arquivo…')).toBeInTheDocument()
    expect(requisicoesPara(requisicoes, '/api/v1/importacoes/imp-1/mapeamento')[0].corpo).toEqual({
      colunas: [
        { campo: 'sku', coluna: 0 },
        { campo: 'descricao', coluna: 1 },
      ],
      regras: { separadorDecimal: ',', unidades: [], valoresVerdadeiros: [], valoresFalsos: [] },
      salvarTemplate: false,
      nomeTemplate: null,
      versao: 1,
    })
  })

  it('pede a sugestão à IA, espera o job e mostra a sugestão com a confiança', async () => {
    const api = apiDeImportacao(importacao())
    renderRoute('/importacoes/imp-1')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'Pedir sugestão à IA' }))
    expect(await screen.findByText('A IA está sugerindo o mapeamento das colunas…')).toBeInTheDocument()

    // O job termina; a tela consulta de novo e mostra a sugestão.
    api.mudar({ status: 'AguardandoConfirmacao', sugestaoIa: SUGESTAO, mapeamentoSugeridoPorIa: true, versao: 3 })
    expect(await screen.findByText(/A IA sugeriu este mapeamento/, {}, { timeout: 5_000 })).toBeInTheDocument()
    expect(screen.getByText(/A coluna Peso parece estar em gramas/)).toBeInTheDocument()
    expect(screen.getByText('97%')).toBeInTheDocument()
    expect(screen.getByText('40%')).toBeInTheDocument()
    expect(screen.getByRole('textbox', { name: 'Unidade no arquivo 1' })).toHaveValue('UND')
  }, 10_000)

  it('confirma a sugestão revisada, com as regras e o template', async () => {
    const { requisicoes } = apiDeImportacao(
      importacao({ status: 'AguardandoConfirmacao', sugestaoIa: SUGESTAO, mapeamentoSugeridoPorIa: true, versao: 3 }),
    )
    renderRoute('/importacoes/imp-1')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('combobox', { name: 'Coluna do campo pesoKg' }))
    await user.click(await screen.findByRole('option', { name: '4. Peso' }))
    await user.type(screen.getByLabelText('Textos de sim (separados por vírgula)'), ', Sim')
    await user.click(screen.getByLabelText(/Salvar como template/))
    await user.click(screen.getByRole('button', { name: 'Confirmar o mapeamento e validar' }))

    await screen.findByText('Validando as linhas do arquivo…')
    const corpo = requisicoesPara(requisicoes, '/api/v1/importacoes/imp-1/mapeamento')[0].corpo as ConfirmarMapeamento
    expect(corpo.colunas).toContainEqual({ campo: 'pesoKg', coluna: 3 })
    expect(corpo.regras).toEqual({
      separadorDecimal: ',',
      unidades: [{ origem: 'UND', destino: 'UN' }],
      valoresVerdadeiros: ['S', 'Sim'],
      valoresFalsos: ['N'],
    })
    expect(corpo).toMatchObject({ salvarTemplate: true, nomeTemplate: 'produtos.csv', versao: 3 })
  })

  it('avisa do conflito de versão', async () => {
    const api = apiDeImportacao(importacao())
    renderRoute('/importacoes/imp-1')
    const user = userEvent.setup()

    const botao = await screen.findByRole('button', { name: 'Pedir sugestão à IA' })
    api.mudar({ versao: 2 })
    await user.click(botao)

    expect(await screen.findByText('Outra pessoa alterou esta importação. Carregue a versão atual.')).toBeInTheDocument()
  })

  it('mostra o motivo da falha', async () => {
    apiDeImportacao(importacao({ status: 'Falhou', motivoFalha: 'O arquivo não tem linhas.' }))
    renderRoute('/importacoes/imp-1')

    expect(await screen.findByRole('alert')).toHaveTextContent('A importação falhou: O arquivo não tem linhas.')
    expect(within(screen.getByRole('main')).queryByRole('list', { name: 'Etapas da importação' })).not.toBeInTheDocument()
  })
})
