import '@testing-library/jest-dom/vitest'
import { limparSessao } from '@/features/auth/sessao'
import { server } from './msw/api'

// O jsdom não implementa estas APIs do navegador. O tema do painel usa matchMedia (tema do sistema) e os componentes
// do Radix usam ResizeObserver, captura de ponteiro e scrollIntoView.
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: (query: string) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: () => {},
    removeListener: () => {},
    addEventListener: () => {},
    removeEventListener: () => {},
    dispatchEvent: () => false,
  }),
})

// O Node 25 traz um localStorage global experimental que, sem --localstorage-file, não funciona e esconde o do
// jsdom. Nesse caso, um Storage em memória ocupa o lugar (o tema do painel fica guardado nele).
if (typeof globalThis.localStorage?.clear !== 'function') {
  const dados = new Map<string, string>()
  const armazenamento: Storage = {
    get length() {
      return dados.size
    },
    clear: () => dados.clear(),
    getItem: (chave) => dados.get(chave) ?? null,
    key: (indice) => [...dados.keys()][indice] ?? null,
    removeItem: (chave) => {
      dados.delete(chave)
    },
    setItem: (chave, valor) => {
      dados.set(chave, String(valor))
    },
  }
  Object.defineProperty(globalThis, 'localStorage', { configurable: true, value: armazenamento })
}

globalThis.ResizeObserver ??= class {
  observe() {}
  unobserve() {}
  disconnect() {}
}

Element.prototype.hasPointerCapture ??= () => false
Element.prototype.releasePointerCapture ??= () => {}
Element.prototype.scrollIntoView ??= () => {}

// A rede dos testes é o MSW: requisição sem handler falha o teste, e cada teste começa só com os handlers padrão.
beforeAll(() => server.listen({ onUnhandledRequest: 'error' }))
afterEach(() => {
  server.resetHandlers()
  server.events.removeAllListeners()
  // A sessão fica num módulo (memória do navegador). Cada teste começa sem sessão.
  limparSessao()
})
afterAll(() => server.close())
