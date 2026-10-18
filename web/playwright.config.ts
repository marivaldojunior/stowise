import { defineConfig, devices } from '@playwright/test'

const porta = 5174
const noCi = Boolean(process.env.CI)

/**
 * Testes de ponta a ponta: o painel (Vite) com a API e o banco reais. A API vem do docker compose (porta 8080) ou
 * de STOWISE_API_URL. No CI, o workflow e2e sobe o compose antes; localmente, suba a API antes de `npm run e2e`.
 */
export default defineConfig({
  testDir: './e2e',
  testMatch: '**/*.e2e.ts',
  fullyParallel: false,
  forbidOnly: noCi,
  retries: noCi ? 1 : 0,
  reporter: noCi ? [['github'], ['html', { open: 'never' }]] : 'list',
  use: {
    baseURL: `http://localhost:${porta}`,
    locale: 'pt-BR',
    trace: 'retain-on-failure',
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
  webServer: {
    command: `npm run dev -- --port ${porta} --strictPort`,
    url: `http://localhost:${porta}`,
    reuseExistingServer: !noCi,
    env: { STOWISE_API_URL: process.env.STOWISE_API_URL ?? 'http://localhost:8080' },
  },
})
