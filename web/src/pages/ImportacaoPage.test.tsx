import { screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { http, HttpResponse } from 'msw'
import type { ConfirmarMapeamento, ImportacaoDetalhe } from '@/api/gerado/modelos'
import { aplicarProgresso, type ProgressoImportacao } from '@/features/importacoes/progresso'
import { gravarRequisicoes, problema, requisicoesPara, server, usarSessao } from '@/test/msw/api'
import { renderRoute } from '@/test/renderRoute'

/**
 * Substituto do cliente SignalR: guarda as conexões abertas pela tela para o teste enviar eventos `progresso`.
 * `falharAoConectar` simula o hub fora do ar.
 */
const hub = vi.hoisted(() => {
  const estado = {
    falharAoConectar: false,
    conexoes: [] as { handlers: Map<string, (dados: unknown) => void>; invocacoes: unknown[][]; parada: boolean }[],
  }

  class ConexaoFalsa {
    handlers = new Map<string, (dados: unknown) => void>()
    invocacoes: unknown[][] = []
    parada = false
    state = 'Disconnected'
    on(evento: string, handler: (dados: unknown) => void) {
      this.handlers.set(evento, handler)
    }
    onreconnecting() {}
    onreconnected() {}
    onclose() {}
    start() {
      if (estado.falharAoConectar) {
        return Promise.reject(new Error('hub fora do ar'))
      }

      this.state = 'Connected'
      estado.conexoes.push(this)
      return Promise.resolve()
    }
    invoke(...argumentos: unknown[]) {
      this.invocacoes.push(argumentos)
      return Promise.resolve()
    }
    stop() {
      this.parada = true
      this.state = 'Disconnected'
      return Promise.resolve()
    }
  }

  class Construtor {
    withUrl() {
      return this
    }
    withAutomaticReconnect() {
      return this
    }
    configureLogging() {
      return this
    }
    build() {
      return new ConexaoFalsa()
    }
  }

  return { estado, Construtor }
})

vi.mock('@microsoft/signalr', () => ({
  HubConnectionBuilder: hub.Construtor,
  HubConnectionState: { Connected: 'Connected' },
  LogLevel: { Warning: 3 },
}))

afterEach(() => {
  hub.estado.conexoes = []
  hub.estado.falharAoConectar = false
})

function emitir(progresso: Partial<ProgressoImportacao>) {
  const conexao = hub.estado.conexoes.at(-1)
  conexao?.handlers.get('progresso')?.({
    id: 'imp-1',
    status: 'Validando',
    totalLinhas: 200,
    linhasProcessadas: 0,
    linhasValidas: 0,
    linhasComErro: 0,
    linhasPossivelDuplicata: 0,
    motivoFalha: null,
    ...progresso,
  })
}

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

const LINHAS = [
  {
    id: 'l2',
    numeroLinha: 2,
    dadosBrutos: ['A1', 'Arroz 5kg', 'UND', '5,1'],
    dadosNormalizados: { sku: 'A1', descricao: 'Arroz 5kg' },
    status: 'Valida',
    acao: 'Criar',
    produtoCorrespondenteId: null,
    similaridade: null,
    erros: [],
    efetivadaEm: null,
  },
  {
    id: 'l3',
    numeroLinha: 3,
    dadosBrutos: ['F1', 'Feijão', 'CX?', 'abc'],
    dadosNormalizados: { sku: 'F1', descricao: 'Feijão' },
    status: 'Erro',
    acao: 'Ignorar',
    produtoCorrespondenteId: null,
    similaridade: null,
    erros: [
      { campo: 'pesoKg', mensagem: 'Peso inválido: abc.' },
      { campo: 'unidade', mensagem: 'Unidade CX? desconhecida.' },
    ],
    efetivadaEm: null,
  },
]

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
    http.get('/api/v1/importacoes/imp-1/relatorio', () =>
      HttpResponse.json({
        id: 'imp-1',
        nomeArquivo: atual.nomeArquivo,
        status: atual.status,
        totalLinhas: atual.totalLinhas,
        linhasValidas: atual.linhasValidas,
        linhasComErro: atual.linhasComErro,
        linhasPossivelDuplicata: atual.linhasPossivelDuplicata,
        produtosCriados: atual.produtosCriados,
        produtosAtualizados: atual.produtosAtualizados,
        errosPorCampo: atual.linhasComErro > 0 ? { pesoKg: 2, unidade: 1 } : {},
        iniciadoEm: atual.iniciadoEm,
        concluidoEm: atual.concluidoEm,
        motivoFalha: atual.motivoFalha,
      }),
    ),
    http.get('/api/v1/importacoes/imp-1/linhas', ({ request }) => {
      const status = new URL(request.url).searchParams.get('status')
      const itens = LINHAS.filter((l) => !status || l.status === status)
      return HttpResponse.json({ itens, pagina: 1, tamanhoPagina: 50, total: itens.length })
    }),
    http.post('/api/v1/importacoes/imp-1/efetivar', async ({ request }) => {
      const { versao } = (await request.json()) as { versao: number }
      atual = { ...atual, status: 'Efetivando', linhasProcessadas: 0, versao: versao + 1 }
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
    expect(screen.getByText('Falta escolher a coluna de: SKU, Descrição.')).toBeInTheDocument()
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

  it('pede a sugestão à IA e mostra a sugestão quando o hub avisa que o job terminou', async () => {
    const api = apiDeImportacao(importacao())
    renderRoute('/importacoes/imp-1')
    const user = userEvent.setup()

    await user.click(await screen.findByRole('button', { name: 'Pedir sugestão à IA' }))
    expect(await screen.findByText('A IA está sugerindo o mapeamento das colunas…')).toBeInTheDocument()
    await waitFor(() => expect(hub.estado.conexoes.at(-1)?.invocacoes).toContainEqual(['Acompanhar', 'imp-1']))

    api.mudar({ status: 'AguardandoConfirmacao', sugestaoIa: SUGESTAO, mapeamentoSugeridoPorIa: true, versao: 3 })
    emitir({ status: 'AguardandoConfirmacao', totalLinhas: 2 })

    expect(await screen.findByText(/A IA sugeriu este mapeamento/)).toBeInTheDocument()
    expect(screen.getByText(/A coluna Peso parece estar em gramas/)).toBeInTheDocument()
    expect(screen.getByText('97%')).toBeInTheDocument()
    expect(screen.getByText('40%')).toBeInTheDocument()
    expect(screen.getByRole('textbox', { name: 'Unidade no arquivo 1' })).toHaveValue('UND')
    // Fora das etapas com job, a conexão fecha.
    await waitFor(() => expect(hub.estado.conexoes.at(-1)?.parada).toBe(true))
  })

  it('sem o hub, consulta a API de tempos em tempos até o job terminar', async () => {
    hub.estado.falharAoConectar = true
    const api = apiDeImportacao(importacao({ status: 'Mapeando' }))
    renderRoute('/importacoes/imp-1')

    expect(await screen.findByText('A IA está sugerindo o mapeamento das colunas…')).toBeInTheDocument()
    api.mudar({ status: 'AguardandoConfirmacao', sugestaoIa: SUGESTAO, mapeamentoSugeridoPorIa: true, versao: 3 })

    expect(await screen.findByText(/A IA sugeriu este mapeamento/, {}, { timeout: 5_000 })).toBeInTheDocument()
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

describe('validação, prévia e efetivação', () => {
  const validada = {
    status: 'AguardandoRevisao' as const,
    totalLinhas: 200,
    linhasProcessadas: 200,
    linhasValidas: 197,
    linhasComErro: 3,
    linhasPossivelDuplicata: 1,
    mapeamento: [{ campo: 'sku', coluna: 0 }],
    versao: 5,
  }

  it('o evento do hub atualiza o progresso e, no fim, abre a prévia', async () => {
    const api = apiDeImportacao(importacao({ status: 'Validando', totalLinhas: 200, versao: 4 }))
    renderRoute('/importacoes/imp-1')

    expect(await screen.findByText('Validando as linhas do arquivo…')).toBeInTheDocument()
    await waitFor(() => expect(hub.estado.conexoes).toHaveLength(1))

    emitir({ linhasProcessadas: 50 })
    expect(await screen.findByText('50 de 200 linha(s) · 25%')).toBeInTheDocument()
    expect(screen.getByRole('progressbar', { name: 'Progresso' })).toHaveAttribute('aria-valuenow', '25')

    api.mudar(validada)
    emitir({ status: 'AguardandoRevisao', linhasProcessadas: 200, linhasValidas: 197, linhasComErro: 3 })

    expect(await screen.findByRole('heading', { name: 'Prévia' })).toBeInTheDocument()
    expect(screen.getByText('197')).toBeInTheDocument()
  })

  it('mostra os erros por campo e as linhas com erro primeiro', async () => {
    apiDeImportacao(importacao(validada))
    renderRoute('/importacoes/imp-1')
    const user = userEvent.setup()

    expect(await screen.findByText('Peso (kg): 2')).toBeInTheDocument()
    expect(screen.getByText('unidade: 1')).toBeInTheDocument()
    const linha = (await screen.findByText('Peso inválido: abc.')).closest('tr') as HTMLElement
    expect(within(linha).getByText('Com erro')).toBeInTheDocument()
    expect(screen.queryByRole('cell', { name: 'Arroz 5kg' })).not.toBeInTheDocument()

    await user.click(screen.getByRole('combobox', { name: 'Filtrar as linhas' }))
    await user.click(await screen.findByRole('option', { name: 'Todas as linhas' }))
    expect(await screen.findByRole('cell', { name: 'Arroz 5kg' })).toBeInTheDocument()
  })

  it('efetiva com a versão lida e acompanha a gravação até o resultado', async () => {
    const api = apiDeImportacao(importacao(validada))
    const { requisicoes } = api
    renderRoute('/importacoes/imp-1')
    const user = userEvent.setup()

    expect(
      await screen.findByText(/A efetivação grava as 197 linha\(s\) válida\(s\) no catálogo/),
    ).toBeInTheDocument()
    await user.click(screen.getByRole('button', { name: 'Efetivar a importação' }))

    expect(await screen.findByText('Gravando os produtos no catálogo…')).toBeInTheDocument()
    expect(requisicoesPara(requisicoes, '/api/v1/importacoes/imp-1/efetivar')[0].corpo).toEqual({ versao: 5 })

    await waitFor(() => expect(hub.estado.conexoes.length).toBeGreaterThan(0))
    api.mudar({ status: 'Concluido', produtosCriados: 190, produtosAtualizados: 7, concluidoEm: '2026-10-18T12:05:00Z' })
    emitir({ status: 'Concluido', linhasProcessadas: 197, linhasValidas: 197, linhasComErro: 3 })

    expect(await screen.findByRole('heading', { name: 'Resultado' })).toBeInTheDocument()
    expect(screen.getByText('190')).toBeInTheDocument()
    expect(screen.getByRole('link', { name: 'Ver o catálogo' })).toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Efetivar a importação' })).not.toBeInTheDocument()
  })

  it('não deixa efetivar sem linhas válidas', async () => {
    apiDeImportacao(importacao({ ...validada, linhasValidas: 0, linhasComErro: 200 }))
    renderRoute('/importacoes/imp-1')

    expect(await screen.findByText('Nenhuma linha válida para gravar. Corrija o arquivo e envie de novo.')).toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'Efetivar a importação' })).toBeDisabled()
  })

  it('aplicarProgresso junta os contadores e diz se o status mudou', () => {
    const atual = importacao({ status: 'Validando', linhasProcessadas: 10 })
    const progresso: ProgressoImportacao = {
      id: 'imp-1',
      status: 'Validando',
      totalLinhas: 2,
      linhasProcessadas: 20,
      linhasValidas: 18,
      linhasComErro: 2,
      linhasPossivelDuplicata: 0,
      motivoFalha: null,
    }

    expect(aplicarProgresso(atual, progresso)).toMatchObject({
      importacao: { linhasProcessadas: 20, linhasValidas: 18, nomeArquivo: 'produtos.csv' },
      mudouStatus: false,
    })
    expect(aplicarProgresso(atual, { ...progresso, status: 'AguardandoRevisao' }).mudouStatus).toBe(true)
  })
})
