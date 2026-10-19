import { readFileSync } from 'node:fs'
import path from 'node:path'
import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { loadEnv, type Plugin } from 'vite'
import { defineConfig } from 'vitest/config'

/**
 * Modo demonstração (`npm run dev:demo`): o MSW responde no navegador, sem a API. O service worker do MSW vem do
 * pacote instalado e só é servido aqui, no servidor de desenvolvimento: ele nunca entra no build de produção.
 */
function demonstracao(): Plugin {
  const worker = path.resolve(import.meta.dirname, 'node_modules/msw/lib/mockServiceWorker.js')
  return {
    name: 'stowise-demonstracao',
    apply: 'serve',
    configureServer(server) {
      server.middlewares.use('/mockServiceWorker.js', (_req, res) => {
        res.setHeader('Content-Type', 'text/javascript')
        res.end(readFileSync(worker))
      })
    },
  }
}

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  // A API não libera CORS: em desenvolvimento, o painel chama a mesma origem e o Vite repassa para a API.
  // Padrão: `dotnet run` (porta 5073). Com o docker compose, use STOWISE_API_URL=http://localhost:8080.
  const api = loadEnv(mode, process.cwd(), '').STOWISE_API_URL ?? 'http://localhost:5073'

  return {
    plugins: [react(), tailwindcss(), ...(mode === 'demo' ? [demonstracao()] : [])],
    resolve: {
      alias: { '@': path.resolve(import.meta.dirname, './src') },
    },
    server: {
      proxy: {
        '/api': { target: api, changeOrigin: true },
        '/health': { target: api, changeOrigin: true },
        '/hubs': { target: api, changeOrigin: true, ws: true },
      },
    },
    test: {
      environment: 'jsdom',
      globals: true,
      setupFiles: ['./src/test/setup.ts'],
      // Só os testes de unidade e de componente; os de ponta a ponta (e2e/) rodam no Playwright.
      include: ['src/**/*.test.{ts,tsx}'],
      css: false,
    },
  }
})
