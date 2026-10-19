import { expect, type Page, test } from '@playwright/test'

/** Admin criado pelo AdminBootstrap no ambiente Development (appsettings.Development.json e docker compose). */
const ADMIN = {
  email: process.env.E2E_ADMIN_EMAIL ?? 'admin@stowise.dev',
  senha: process.env.E2E_ADMIN_SENHA ?? 'Stowise-dev-2026',
}

async function entrar(page: Page, email: string, senha: string) {
  await page.getByLabel('E-mail').fill(email)
  await page.getByLabel('Senha').fill(senha)
  await page.getByRole('button', { name: 'Entrar' }).click()
}

test('Admin entra, mantém a sessão, cria um Operador, e o Operador só vê o permitido', async ({ page }) => {
  const operador = {
    nome: 'Operador E2E',
    email: `operador-${Date.now()}@stowise.dev`,
    senha: 'Operador-e2e-2026',
  }

  // Sem sessão, a página pedida leva ao login e volta para ela depois.
  await page.goto('/usuarios')
  await expect(page).toHaveURL(/\/login$/)
  await entrar(page, ADMIN.email, ADMIN.senha)
  await expect(page).toHaveURL(/\/usuarios$/)
  await expect(page.getByRole('heading', { name: 'Usuários' })).toBeVisible()

  // A sessão volta pelo cookie HttpOnly depois de recarregar (o token de acesso fica só em memória).
  await page.reload()
  await expect(page.getByRole('heading', { name: 'Usuários' })).toBeVisible()

  await page.getByRole('button', { name: 'Novo usuário' }).click()
  const dialogo = page.getByRole('dialog', { name: 'Novo usuário' })
  await dialogo.getByLabel('Nome').fill(operador.nome)
  await dialogo.getByLabel('E-mail').fill(operador.email)
  await dialogo.getByLabel('Senha inicial').fill(operador.senha)
  await dialogo.getByRole('checkbox', { name: 'Operador' }).check()
  await dialogo.getByRole('button', { name: 'Salvar' }).click()
  await expect(dialogo).toBeHidden()

  await page.getByRole('searchbox', { name: 'Buscar por nome ou e-mail' }).fill(operador.email)
  const linha = page.getByRole('row').filter({ hasText: operador.email })
  await expect(linha).toContainText('Operador')
  await expect(linha).toContainText('Ativo')

  await page.getByRole('button', { name: 'Menu do usuário' }).click()
  await page.getByRole('menuitem', { name: 'Sair' }).click()
  await expect(page).toHaveURL(/\/login$/)

  await entrar(page, operador.email, operador.senha)
  await expect(page.getByText('API e banco disponíveis.')).toBeVisible()
  const menu = page.getByRole('navigation', { name: 'Principal' })
  await expect(menu.getByText('Início')).toBeVisible()
  await expect(menu.getByText('Usuários')).toHaveCount(0)

  await page.goto('/usuarios')
  await expect(page.getByRole('heading', { name: 'Acesso negado' })).toBeVisible()
})

test('login com senha errada mostra o motivo', async ({ page }) => {
  await page.goto('/login')
  await entrar(page, ADMIN.email, 'senha-errada')

  await expect(page.getByRole('alert')).toContainText('E-mail ou senha incorretos')
})

test('Gestão cadastra um produto com caixa e o encontra no catálogo', async ({ page }) => {
  const sku = `E2E-${Date.now()}`

  await page.goto('/catalogo/novo')
  await entrar(page, ADMIN.email, ADMIN.senha)
  await expect(page.getByRole('heading', { name: 'Novo produto' })).toBeVisible()

  await page.getByLabel('SKU').fill(sku)
  await page.getByLabel('Descrição').fill('Produto de teste e2e')
  await page.getByLabel('Peso (kg)').fill('1,5')
  await page.getByRole('button', { name: 'Criar produto' }).click()
  await expect(page.getByRole('heading', { name: 'Produto de teste e2e' })).toBeVisible()

  await page.getByRole('button', { name: 'Nova embalagem' }).click()
  const dialogo = page.getByRole('dialog', { name: 'Nova embalagem' })
  await dialogo.getByLabel('Quantidade de UN').fill('12')
  await dialogo.getByRole('button', { name: 'Salvar' }).click()
  await expect(dialogo).toBeHidden()
  await expect(page.getByRole('row').filter({ hasText: 'Caixa' })).toContainText('12 UN')

  await page.getByRole('link', { name: 'Catálogo' }).first().click()
  await page.getByRole('searchbox', { name: 'Buscar por SKU ou descrição' }).fill(sku)
  await expect(page.getByRole('row').filter({ hasText: sku })).toContainText('Produto de teste e2e')
})

test('Gestão importa produtos de um CSV, acompanha a validação e efetiva', async ({ page }) => {
  // Os jobs (Hangfire) consultam a fila a cada 5 s: cada etapa pode levar alguns segundos.
  test.setTimeout(120_000)
  const marca = Date.now()
  const csv = ['SKU;Descricao;Unidade', `IMP-${marca}-1;Arroz importado e2e;UN`, `IMP-${marca}-2;Feijão importado e2e;KG`].join(
    '\n',
  )

  await page.goto('/importacoes')
  await entrar(page, ADMIN.email, ADMIN.senha)
  await page.getByLabel('Arquivo de produtos').setInputFiles({
    name: `produtos-${marca}.csv`,
    mimeType: 'text/csv',
    buffer: Buffer.from(csv, 'utf-8'),
  })
  await expect(page.getByRole('heading', { name: `produtos-${marca}.csv` })).toBeVisible()

  // A IA fica desligada no docker compose: o mapeamento é manual.
  for (const [campo, coluna] of [
    ['sku', '1. SKU'],
    ['descricao', '2. Descricao'],
    ['unidadeBase', '3. Unidade'],
  ] as const) {
    await page.getByRole('combobox', { name: `Coluna do campo ${campo}` }).click()
    await page.getByRole('option', { name: coluna }).click()
  }
  await page.getByRole('button', { name: 'Confirmar o mapeamento e validar' }).click()

  await expect(page.getByRole('heading', { name: 'Prévia' })).toBeVisible({ timeout: 60_000 })
  await page.getByRole('button', { name: 'Efetivar a importação' }).click()
  await expect(page.getByRole('heading', { name: 'Resultado' })).toBeVisible({ timeout: 60_000 })

  await page.getByRole('link', { name: 'Ver o catálogo' }).click()
  await page.getByRole('searchbox', { name: 'Buscar por SKU ou descrição' }).fill(`IMP-${marca}`)
  await expect(page.getByRole('row').filter({ hasText: 'importado e2e' })).toHaveCount(2)
})
