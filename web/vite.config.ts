import path from 'node:path'
import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'
import { loadEnv } from 'vite'
import { defineConfig } from 'vitest/config'

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  // A API não libera CORS: em desenvolvimento, o painel chama a mesma origem e o Vite repassa para a API.
  // Padrão: `dotnet run` (porta 5073). Com o docker compose, use STOWISE_API_URL=http://localhost:8080.
  const api = loadEnv(mode, process.cwd(), '').STOWISE_API_URL ?? 'http://localhost:5073'

  return {
    plugins: [react(), tailwindcss()],
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
      css: false,
    },
  }
})
