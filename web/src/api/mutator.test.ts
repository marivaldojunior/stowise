import { jsonResponse, stubFetch } from '../test/renderRoute'
import { getObterProdutoUrl, listarCategorias } from './gerado/stowise'
import { apiFetch, HttpError, setTokenProvider } from './mutator'

afterEach(() => {
  vi.unstubAllGlobals()
  setTokenProvider(() => null)
})

describe('apiFetch', () => {
  it('envia o token de acesso e devolve o corpo da resposta', async () => {
    const fetchMock = stubFetch(() => jsonResponse([{ id: '1', nome: 'Grãos' }]))
    setTokenProvider(() => 'token-de-teste')

    const categorias = await listarCategorias()

    expect(categorias).toEqual([{ id: '1', nome: 'Grãos' }])
    const [url, init] = fetchMock.mock.calls[0] as unknown as [string, RequestInit]
    expect(url).toBe('/api/v1/categorias')
    expect(new Headers(init.headers).get('Authorization')).toBe('Bearer token-de-teste')
  })

  it('não envia token quando não há sessão', async () => {
    const fetchMock = stubFetch(() => jsonResponse({ status: 'Healthy' }))

    await apiFetch('/health/live')

    const [, init] = fetchMock.mock.calls[0] as unknown as [string, RequestInit]
    expect(new Headers(init.headers).has('Authorization')).toBe(false)
  })

  it('devolve undefined numa resposta sem corpo (204)', async () => {
    stubFetch(() => new Response(null, { status: 204 }))

    await expect(apiFetch('/api/v1/categorias/1', { method: 'DELETE' })).resolves.toBeUndefined()
  })

  it('transforma o ProblemDetails em HttpError com os erros por campo', async () => {
    stubFetch(() =>
      jsonResponse({ title: 'Um ou mais campos são inválidos.', status: 400, errors: { sku: ['Informe o SKU.'] } }, 400),
    )

    const erro = await apiFetch('/api/v1/produtos', { method: 'POST' }).catch((e: unknown) => e)

    expect(erro).toBeInstanceOf(HttpError)
    expect((erro as HttpError).status).toBe(400)
    expect((erro as HttpError).message).toBe('Um ou mais campos são inválidos.')
    expect((erro as HttpError).problem?.errors).toEqual({ sku: ['Informe o SKU.'] })
  })

  it('marca com status 0 quando a API não responde', async () => {
    vi.stubGlobal('fetch', vi.fn(() => Promise.reject(new TypeError('Failed to fetch'))))

    await expect(apiFetch('/api/v1/categorias')).rejects.toMatchObject({ status: 0 })
  })

  it('repassa o cancelamento sem transformar em erro de rede', async () => {
    vi.stubGlobal('fetch', vi.fn(() => Promise.reject(new DOMException('aborted', 'AbortError'))))

    await expect(apiFetch('/api/v1/categorias')).rejects.toMatchObject({ name: 'AbortError' })
  })

  it('monta as URLs do contrato com os parâmetros de rota', () => {
    expect(getObterProdutoUrl('0199')).toBe('/api/v1/produtos/0199')
  })
})
