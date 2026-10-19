import { delay, http, HttpResponse } from 'msw'
import { setupWorker } from 'msw/browser'
import type {
  AuthResponse,
  CriarProduto,
  EnderecoDetalhe,
  ImportacaoDetalhe,
  ProdutoDetalhe,
  UsuarioDetalhe,
} from '@/api/gerado/modelos'
import {
  armazem,
  categorias,
  enderecos,
  importacoes,
  linhasImportacao,
  movimentacoes,
  produtos,
  saldos,
  usuarios,
} from './dados'

/**
 * Modo demonstração (`npm run dev:demo`): uma API em memória no navegador, com os mesmos caminhos e formatos da API
 * real. Serve para ver e revisar o painel sem o banco. Qualquer senha entra; o perfil vem do e-mail
 * (admin@, gestor@ ou operador@stowise.dev). As alterações valem até recarregar a página.
 */

const CHAVE_SESSAO = 'stowise-demo-usuario'
const LATENCIA_MS = 250

const CAMPOS = [
  ['sku', 'Código interno do produto (único).', true],
  ['descricao', 'Descrição do produto.', true],
  ['unidadeBase', 'Unidade base de estoque (ex.: UN, KG, CX).', true],
  ['gtin', 'Código de barras da unidade (GTIN/EAN).', false],
  ['ncm', 'NCM com 8 dígitos.', false],
  ['categoria', 'Nome da categoria.', false],
  ['classeArmazenagem', 'Normal, Refrigerado, Inflamável ou Frágil.', false],
  ['pesoKg', 'Peso da unidade em kg.', false],
].map(([nome, descricao, obrigatorio]) => ({ nome, descricao, obrigatorio }))

function sessao(email: string): AuthResponse {
  const usuario = usuarios.find((u) => u.email === email) ?? usuarios[0]
  const agora = Date.now()
  return {
    accessToken: `demo-${usuario.id}`,
    accessTokenExpiresAt: new Date(agora + 15 * 60_000).toISOString(),
    refreshToken: null,
    refreshTokenExpiresAt: new Date(agora + 7 * 86_400_000).toISOString(),
    usuario: { id: usuario.id, nome: usuario.nome, email: usuario.email, perfis: usuario.perfis },
  }
}

function problema(status: number, title: string) {
  return HttpResponse.json({ status, title }, { status, headers: { 'Content-Type': 'application/problem+json' } })
}

function pagina<T>(itens: T[], url: URL, padrao = 20) {
  const numero = Number(url.searchParams.get('pagina') ?? '1')
  const tamanho = Number(url.searchParams.get('tamanhoPagina') ?? String(padrao))
  return HttpResponse.json({
    itens: itens.slice((numero - 1) * tamanho, numero * tamanho),
    pagina: numero,
    tamanhoPagina: tamanho,
    total: itens.length,
  })
}

function contem(texto: string, busca: string | null) {
  return !busca || texto.toLowerCase().includes(busca.toLowerCase())
}

const semConteudo = () => new HttpResponse(null, { status: 204 })

function buscarProduto(valor: unknown) {
  return produtos.find((p) => p.id === valor)
}

function buscarEndereco(valor: unknown) {
  return enderecos.find((e) => e.id === valor)
}

function buscarImportacao(valor: unknown) {
  return importacoes.find((i) => i.id === valor)
}

function salvo(produto: ProdutoDetalhe) {
  produto.versao += 1
  return HttpResponse.json(produto)
}

const handlers = [
  http.all('*', async ({ request }) => {
    if (new URL(request.url).pathname.startsWith('/api/')) {
      await delay(LATENCIA_MS)
    }
  }),

  // Autenticação: a "sessão do cookie" fica no sessionStorage.
  http.post('/api/v1/auth/login', async ({ request }) => {
    const { email } = (await request.json()) as { email: string }
    if (!usuarios.some((u) => u.email === email.trim().toLowerCase() && u.ativo && !u.bloqueado)) {
      return HttpResponse.json(
        { status: 401, title: 'Credenciais inválidas', detail: 'E-mail ou senha incorretos, ou usuário bloqueado.' },
        { status: 401 },
      )
    }

    sessionStorage.setItem(CHAVE_SESSAO, email.trim().toLowerCase())
    return HttpResponse.json(sessao(email.trim().toLowerCase()))
  }),
  http.post('/api/v1/auth/refresh', () => {
    const email = sessionStorage.getItem(CHAVE_SESSAO)
    return email ? HttpResponse.json(sessao(email)) : problema(401, 'Sessão inválida')
  }),
  http.post('/api/v1/auth/logout', () => {
    sessionStorage.removeItem(CHAVE_SESSAO)
    return semConteudo()
  }),
  http.get('/health/ready', () => HttpResponse.json({ status: 'Healthy', totalDurationMs: 4.2, checks: [] })),
  http.get('/hubs/*', () => HttpResponse.error()),
  http.post('/hubs/*', () => HttpResponse.error()),

  // Catálogo
  http.get('/api/v1/categorias', () => HttpResponse.json(categorias)),
  http.get('/api/v1/produtos', ({ request }) => {
    const url = new URL(request.url)
    const busca = url.searchParams.get('busca')
    const categoriaId = url.searchParams.get('categoriaId')
    const ativo = url.searchParams.get('ativo')
    return pagina(
      produtos.filter(
        (p) =>
          (contem(p.sku, busca) || contem(p.descricao, busca)) &&
          (!categoriaId || p.categoriaId === categoriaId) &&
          (ativo === null || String(p.ativo) === ativo),
      ),
      url,
    )
  }),
  http.get('/api/v1/produtos/:id', ({ params }) => {
    const produto = buscarProduto(params.id)
    return produto ? HttpResponse.json(produto) : problema(404, 'Produto não encontrado.')
  }),
  http.post('/api/v1/produtos', async ({ request }) => {
    const corpo = (await request.json()) as CriarProduto
    if (produtos.some((p) => p.sku === corpo.sku)) {
      return problema(409, `Já existe um produto com o SKU ${corpo.sku}.`)
    }

    const novo: ProdutoDetalhe = {
      id: `prod-novo-${produtos.length + 1}`,
      sku: corpo.sku ?? '',
      descricao: corpo.descricao ?? '',
      unidadeBase: corpo.unidadeBase ?? 'UN',
      classeArmazenagem: corpo.classeArmazenagem ?? 'Normal',
      controlaLote: corpo.controlaLote,
      controlaValidade: corpo.controlaValidade,
      ncm: corpo.ncm,
      cest: corpo.cest,
      categoriaId: corpo.categoriaId,
      ativo: true,
      versao: 1,
      embalagens: [
        {
          id: `emb-novo-${produtos.length + 1}`,
          tipo: 'Unidade',
          fatorConversao: 1,
          unidadeBase: true,
          gtin: corpo.embalagemBase?.gtin ?? null,
          pesoKg: corpo.embalagemBase?.pesoKg ?? null,
          alturaCm: corpo.embalagemBase?.alturaCm ?? null,
          larguraCm: corpo.embalagemBase?.larguraCm ?? null,
          comprimentoCm: corpo.embalagemBase?.comprimentoCm ?? null,
        },
      ],
    }
    produtos.unshift(novo)
    return HttpResponse.json(novo, { status: 201 })
  }),
  http.put('/api/v1/produtos/:id', async ({ params, request }) => {
    const produto = buscarProduto(params.id)
    if (!produto) {
      return problema(404, 'Produto não encontrado.')
    }

    const corpo = (await request.json()) as Partial<ProdutoDetalhe>
    if (corpo.versao !== produto.versao) {
      return problema(409, 'O produto foi alterado por outra pessoa depois que você o abriu. Recarregue e tente de novo.')
    }

    Object.assign(produto, { ...corpo, versao: produto.versao })
    return salvo(produto)
  }),
  http.post('/api/v1/produtos/:id/:acao', async ({ params, request }) => {
    const produto = buscarProduto(params.id)
    if (!produto) {
      return problema(404, 'Produto não encontrado.')
    }

    if (params.acao === 'embalagens') {
      const corpo = (await request.json()) as Omit<ProdutoDetalhe['embalagens'][number], 'id' | 'unidadeBase'>
      if ((corpo.fatorConversao ?? 0) <= 1) {
        return problema(422, 'O fator de conversão de caixa ou palete deve ser maior que 1.')
      }

      produto.embalagens.push({ ...corpo, id: `emb-${Date.now()}`, unidadeBase: false })
      return salvo(produto)
    }

    produto.ativo = params.acao === 'reativar'
    produto.versao += 1
    return semConteudo()
  }),
  http.put('/api/v1/produtos/:id/embalagens/:embalagemId', async ({ params, request }) => {
    const produto = buscarProduto(params.id)
    const embalagem = produto?.embalagens.find((e) => e.id === params.embalagemId)
    if (!produto || !embalagem) {
      return problema(404, 'Embalagem não encontrada neste produto.')
    }

    Object.assign(embalagem, await request.json())
    return salvo(produto)
  }),
  http.delete('/api/v1/produtos/:id/embalagens/:embalagemId', ({ params }) => {
    const produto = buscarProduto(params.id)
    if (!produto) {
      return problema(404, 'Produto não encontrado.')
    }

    produto.embalagens = produto.embalagens.filter((e) => e.id !== params.embalagemId)
    return salvo(produto)
  }),

  // Estrutura
  http.get('/api/v1/armazens', () =>
    HttpResponse.json([
      { id: armazem.id, codigo: armazem.codigo, nome: armazem.nome, zonas: armazem.zonas.length, enderecos: enderecos.length },
    ]),
  ),
  http.get('/api/v1/armazens/:id', () => HttpResponse.json(armazem)),
  http.get('/api/v1/enderecos', ({ request }) => {
    const url = new URL(request.url)
    const zonaId = url.searchParams.get('zonaId')
    const codigo = url.searchParams.get('codigo')
    const status = url.searchParams.get('status')
    return pagina(
      enderecos.filter(
        (e) => (!zonaId || e.zonaId === zonaId) && contem(e.codigo, codigo) && (!status || e.status === status),
      ),
      url,
    )
  }),
  http.get('/api/v1/enderecos/:id', ({ params }) => {
    const endereco = buscarEndereco(params.id)
    return endereco ? HttpResponse.json(endereco) : problema(404, 'Endereço não encontrado.')
  }),
  http.post('/api/v1/enderecos/lote', async ({ request }) => {
    const corpo = (await request.json()) as { ruas: string[]; moduloInicial: number; moduloFinal: number; nivelInicial: number; nivelFinal: number; posicaoInicial: number; posicaoFinal: number; simular: boolean }
    const codigos: string[] = []
    for (const rua of corpo.ruas ?? []) {
      for (let m = corpo.moduloInicial ?? 1; m <= (corpo.moduloFinal ?? 1); m += 1) {
        for (let n = corpo.nivelInicial ?? 1; n <= (corpo.nivelFinal ?? 1); n += 1) {
          for (let p = corpo.posicaoInicial ?? 1; p <= (corpo.posicaoFinal ?? 1); p += 1) {
            codigos.push(`${rua}-${String(m).padStart(2, '0')}-${n}-${p}`)
          }
        }
      }
    }

    const existentes = codigos.filter((c) => enderecos.some((e) => e.codigo === c))
    return HttpResponse.json({
      total: codigos.length,
      criados: corpo.simular ? 0 : codigos.length - existentes.length,
      ignorados: existentes.length,
      simulado: corpo.simular,
      codigosExistentes: existentes,
      amostra: codigos.slice(0, 6),
    })
  }),
  http.post('/api/v1/enderecos/:id/:acao', async ({ params, request }) => {
    const endereco = buscarEndereco(params.id)
    if (!endereco) {
      return problema(404, 'Endereço não encontrado.')
    }

    if (params.acao === 'bloquear') {
      const { motivo } = (await request.json()) as { motivo: string | null }
      Object.assign(endereco, { status: 'Bloqueado', motivoBloqueio: motivo ?? 'Sem motivo' })
      return HttpResponse.json(endereco)
    }

    const temSaldo = saldos.some((s) => s.enderecoId === endereco.id)
    Object.assign(endereco, { status: temSaldo ? 'Ocupado' : 'Livre', motivoBloqueio: null })
    return semConteudo()
  }),
  http.put('/api/v1/enderecos/:id', async ({ params, request }) => {
    const endereco = buscarEndereco(params.id) as EnderecoDetalhe
    Object.assign(endereco, await request.json())
    return HttpResponse.json(endereco)
  }),
  http.delete('/api/v1/enderecos/:id', ({ params }) => {
    const endereco = buscarEndereco(params.id)
    if (endereco && saldos.some((s) => s.enderecoId === endereco.id)) {
      return problema(422, 'O endereço tem saldo e não pode ser excluído.')
    }

    enderecos.splice(enderecos.indexOf(endereco as EnderecoDetalhe), 1)
    return semConteudo()
  }),

  // Estoque
  http.get('/api/v1/saldos', ({ request }) => {
    const url = new URL(request.url)
    const filtro = (nome: string, valor: string) => !url.searchParams.get(nome) || url.searchParams.get(nome) === valor
    return pagina(
      saldos.filter(
        (s) =>
          filtro('produtoId', s.produtoId) &&
          filtro('enderecoId', s.enderecoId) &&
          filtro('armazemId', s.armazemId) &&
          filtro('zonaId', s.zonaId),
      ),
      url,
      50,
    )
  }),
  http.get('/api/v1/saldos/produtos/:id', ({ params }) => {
    const produto = buscarProduto(params.id)
    const doProduto = saldos.filter((s) => s.produtoId === params.id)
    const soma = (campo: 'quantidade' | 'quantidadeReservada') => doProduto.reduce((total, s) => total + s[campo], 0)
    return HttpResponse.json({
      produtoId: params.id,
      sku: produto?.sku ?? '',
      descricao: produto?.descricao ?? '',
      unidadeBase: produto?.unidadeBase ?? 'UN',
      quantidade: soma('quantidade'),
      quantidadeReservada: soma('quantidadeReservada'),
      quantidadeDisponivel: soma('quantidade') - soma('quantidadeReservada'),
      enderecos: new Set(doProduto.map((s) => s.enderecoId)).size,
      lotes: doProduto
        .filter((s) => s.loteNumero)
        .map((s) => ({
          loteId: s.loteId,
          numero: s.loteNumero,
          validade: s.validade,
          quantidade: s.quantidade,
          quantidadeReservada: s.quantidadeReservada,
        })),
    })
  }),
  http.get('/api/v1/movimentacoes', ({ request }) => {
    const url = new URL(request.url)
    const produtoId = url.searchParams.get('produtoId')
    const endereco = buscarEndereco(url.searchParams.get('enderecoId'))
    const tipo = url.searchParams.get('tipo')
    const de = url.searchParams.get('de')
    const ate = url.searchParams.get('ate')
    return pagina(
      movimentacoes.filter(
        (m) =>
          (!produtoId || m.produtoId === produtoId) &&
          (!endereco || [m.enderecoOrigemCodigo, m.enderecoDestinoCodigo].includes(endereco.codigo)) &&
          (!tipo || m.tipo === tipo) &&
          (!de || m.ocorridoEm >= de) &&
          (!ate || m.ocorridoEm <= ate),
      ),
      url,
      50,
    )
  }),

  // Usuários
  http.get('/api/v1/perfis', () => HttpResponse.json(['Admin', 'Gestor', 'Operador'])),
  http.get('/api/v1/usuarios', ({ request }) => {
    const url = new URL(request.url)
    const busca = url.searchParams.get('busca')
    const perfil = url.searchParams.get('perfil')
    const ativo = url.searchParams.get('ativo')
    return pagina(
      usuarios.filter(
        (u) =>
          (contem(u.nome, busca) || contem(u.email, busca)) &&
          (!perfil || u.perfis.includes(perfil)) &&
          (ativo === null || String(u.ativo) === ativo),
      ),
      url,
    )
  }),
  http.post('/api/v1/usuarios', async ({ request }) => {
    const corpo = (await request.json()) as Pick<UsuarioDetalhe, 'nome' | 'email' | 'perfis'>
    const novo: UsuarioDetalhe = { ...corpo, id: `usr-novo-${usuarios.length + 1}`, ativo: true, bloqueado: false, criadoEm: new Date().toISOString() }
    usuarios.push(novo)
    return HttpResponse.json(novo, { status: 201 })
  }),
  http.put('/api/v1/usuarios/:id', async ({ params, request }) => {
    const usuario = usuarios.find((u) => u.id === params.id) as UsuarioDetalhe
    Object.assign(usuario, await request.json())
    return HttpResponse.json(usuario)
  }),
  http.post('/api/v1/usuarios/:id/:acao', ({ params }) => {
    const usuario = usuarios.find((u) => u.id === params.id)
    if (usuario && params.acao !== 'senha') {
      usuario.ativo = params.acao === 'reativar'
    }

    return semConteudo()
  }),

  // Importações: os jobs terminam na hora (sem tempo real; a tela usa a consulta periódica).
  http.get('/api/v1/importacoes/produtos/campos', () => HttpResponse.json(CAMPOS)),
  http.get('/api/v1/importacoes', ({ request }) => {
    const url = new URL(request.url)
    const status = url.searchParams.get('status')
    return pagina(importacoes.filter((i) => !status || i.status === status), url)
  }),
  http.post('/api/v1/importacoes/produtos', async ({ request }) => {
    const arquivo = (await request.formData()).get('arquivo') as File | null
    const nova: ImportacaoDetalhe = {
      ...importacoes[2],
      id: `imp-novo-${importacoes.length + 1}`,
      nomeArquivo: arquivo?.name ?? 'arquivo.csv',
      status: 'AguardandoConfirmacao',
      iniciadoEm: new Date().toISOString(),
      versao: 1,
    }
    importacoes.unshift(nova)
    return HttpResponse.json(nova, { status: 201 })
  }),
  http.get('/api/v1/importacoes/:id', ({ params }) => {
    const importacao = buscarImportacao(params.id)
    return importacao ? HttpResponse.json(importacao) : problema(404, 'Importação não encontrada.')
  }),
  http.get('/api/v1/importacoes/:id/relatorio', ({ params }) => {
    const importacao = buscarImportacao(params.id) as ImportacaoDetalhe
    return HttpResponse.json({
      ...importacao,
      errosPorCampo: importacao.linhasComErro > 0 ? { pesoKg: importacao.linhasComErro, unidadeBase: 3 } : {},
    })
  }),
  http.get('/api/v1/importacoes/:id/linhas', ({ request }) => {
    const url = new URL(request.url)
    const status = url.searchParams.get('status')
    return pagina(linhasImportacao.filter((l) => !status || l.status === status), url, 50)
  }),
  http.put('/api/v1/importacoes/:id/mapeamento', async ({ params, request }) => {
    const importacao = buscarImportacao(params.id) as ImportacaoDetalhe
    const corpo = (await request.json()) as Pick<ImportacaoDetalhe, 'regras'> & { colunas: ImportacaoDetalhe['mapeamento'] }
    Object.assign(importacao, {
      status: 'AguardandoRevisao',
      mapeamento: corpo.colunas,
      regras: corpo.regras,
      linhasProcessadas: importacao.totalLinhas,
      linhasValidas: importacao.totalLinhas - 6,
      linhasComErro: 5,
      linhasPossivelDuplicata: 1,
      versao: importacao.versao + 1,
    })
    return HttpResponse.json(importacao, { status: 202 })
  }),
  http.post('/api/v1/importacoes/:id/:acao', ({ params }) => {
    const importacao = buscarImportacao(params.id) as ImportacaoDetalhe
    if (params.acao === 'efetivar') {
      Object.assign(importacao, {
        status: 'Concluido',
        produtosCriados: importacao.linhasValidas - 12,
        produtosAtualizados: 12,
        concluidoEm: new Date().toISOString(),
        versao: importacao.versao + 1,
      })
    } else {
      Object.assign(importacao, { status: 'AguardandoConfirmacao', sugestaoIa: importacoes.at(-1)?.sugestaoIa, versao: importacao.versao + 1 })
    }

    return HttpResponse.json(importacao, { status: 202 })
  }),
]

export async function iniciarDemonstracao() {
  await setupWorker(...handlers).start({
    onUnhandledRequest: 'bypass',
    quiet: true,
  })
}
