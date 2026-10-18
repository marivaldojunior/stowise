import { http, HttpResponse } from 'msw'
import { gravarRequisicoes, server } from '../test/msw/api'
import { getObterProdutoUrl, listarCategorias } from './gerado/stowise'
import { apiFetch, HttpError, setTokenProvider } from './mutator'

afterEach(() => {
  setTokenProvider(() => null)
})

describe('apiFetch', () => {
  it('envia o token de acesso e devolve o corpo da resposta', async () => {
    server.use(http.get('/api/v1/categorias', () => HttpResponse.json([{ id: '1', nome: 'Grãos' }])))
    const requisicoes = gravarRequisicoes()
    setTokenProvider(() => 'token-de-teste')

    const categorias = await listarCategorias()

    expect(categorias).toEqual([{ id: '1', nome: 'Grãos' }])
    expect(requisicoes).toMatchObject([{ metodo: 'GET', url: '/api/v1/categorias', autorizacao: 'Bearer token-de-teste' }])
  })

  it('não envia token quando não há sessão', async () => {
    server.use(http.get('/health/live', () => HttpResponse.json({ status: 'Healthy' })))
    const requisicoes = gravarRequisicoes()

    await apiFetch('/health/live')

    expect(requisicoes[0].autorizacao).toBeNull()
  })

  it('devolve undefined numa resposta sem corpo (204)', async () => {
    server.use(http.delete('/api/v1/categorias/1', () => new HttpResponse(null, { status: 204 })))

    await expect(apiFetch('/api/v1/categorias/1', { method: 'DELETE' })).resolves.toBeUndefined()
  })

  it('transforma o ProblemDetails em HttpError com os erros por campo', async () => {
    server.use(
      http.post('/api/v1/produtos', () =>
        HttpResponse.json(
          { title: 'Um ou mais campos são inválidos.', status: 400, errors: { sku: ['Informe o SKU.'] } },
          { status: 400 },
        ),
      ),
    )

    const erro = await apiFetch('/api/v1/produtos', { method: 'POST' }).catch((e: unknown) => e)

    expect(erro).toBeInstanceOf(HttpError)
    expect((erro as HttpError).status).toBe(400)
    expect((erro as HttpError).message).toBe('Um ou mais campos são inválidos.')
    expect((erro as HttpError).problem?.errors).toEqual({ sku: ['Informe o SKU.'] })
  })

  it('marca com status 0 quando a API não responde', async () => {
    server.use(http.get('/api/v1/categorias', () => HttpResponse.error()))

    await expect(apiFetch('/api/v1/categorias')).rejects.toMatchObject({ status: 0 })
  })

  it.each([502, 504])('trata o %i do proxy, sem ProblemDetails, como API fora do ar', async (status) => {
    server.use(http.get('/api/v1/categorias', () => new HttpResponse('Bad Gateway', { status })))

    await expect(apiFetch('/api/v1/categorias')).rejects.toMatchObject({
      status,
      message: 'A API não respondeu. Confira se ela está rodando.',
    })
  })

  it('repassa o cancelamento sem transformar em erro de rede', async () => {
    server.use(http.get('/api/v1/categorias', () => new Promise<never>(() => {})))
    const controle = new AbortController()

    const chamada = apiFetch('/api/v1/categorias', { signal: controle.signal })
    controle.abort()

    await expect(chamada).rejects.toMatchObject({ name: 'AbortError' })
  })

  it('monta as URLs do contrato com os parâmetros de rota', () => {
    expect(getObterProdutoUrl('0199')).toBe('/api/v1/produtos/0199')
  })
})
