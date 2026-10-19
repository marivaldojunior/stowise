# 0009 — Demonstração numa só imagem (API + painel) no Render, com o banco no Neon

- **Status:** Aceito
- **Data:** 2026-10-19

## Contexto

O Marco 1 termina com uma demonstração pública: o painel, a API e o APK apontando para ela, com dados de exemplo e contas de teste. O projeto é experimental e a demonstração precisa custar zero. Restrições:

1. O painel chama a API na mesma origem (`/api`), e o cookie de refresh é `SameSite=Strict` e restrito a `/api/v1/auth` (ADR-0005). Origens separadas exigiriam CORS e cookie entre sites.
2. O banco precisa de pgvector (Marco 2 e seguintes).
3. A demonstração é pública: qualquer visitante pode entrar e mudar dados.

## Decisão

- **Uma imagem:** o `Dockerfile` da raiz constrói o painel (Vite) e a API (.NET); o painel vai para `wwwroot` e a API o serve (`PainelWeb`): arquivos estáticos antes da autenticação e o `index.html` nas rotas do painel. Prefixos da API (`/api`, `/health`, `/hubs`, `/openapi`, `/scalar`) nunca recebem o painel. Sem `wwwroot/index.html`, nada muda (desenvolvimento, testes e docker compose).
- **Hospedagem:** Render (web service gratuito, Blueprint em `render.yaml`) e Neon (PostgreSQL 17 com pgvector, conexão direta, sem pooler).
- **Contas públicas:** com `Demonstracao:Senha`, o seed cria um Gestor e um Operador de demonstração, sem bloqueio por senha errada. O Admin continua privado (`AdminBootstrap`).
- **Segredos:** só no painel do Render (`sync: false`); a chave do JWT é gerada pelo Render.

## Consequências

- Um deploy, uma URL e nenhuma configuração de CORS; o painel e a API sobem juntos e na mesma versão.
- O plano gratuito dorme sem uso: a primeira visita depois de 15 minutos demora cerca de 30 segundos, e o Neon também acorda na primeira consulta (timeout de 30 s na conexão).
- Qualquer visitante pode mudar os dados de exemplo; o reset é recriar o banco no Neon.
- O CI constrói a imagem e confere o painel, a API e a conta de demonstração (job `imagem-demonstracao` do workflow `e2e`).

## Alternativas consideradas

- **Painel em hospedagem estática (Vercel, Cloudflare Pages) e API separada** — exigiria CORS e cookie entre origens, contra o ADR-0005.
- **Fly.io** — não dorme, mas pede cartão de crédito mesmo no uso gratuito.
- **Admin com senha pública** — um visitante poderia trocar a senha dos outros ou desativar contas e derrubar a demonstração.
