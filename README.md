# Stowise

[![api](https://github.com/marivaldojunior/stowise/actions/workflows/api.yml/badge.svg)](https://github.com/marivaldojunior/stowise/actions/workflows/api.yml)
[![web](https://github.com/marivaldojunior/stowise/actions/workflows/web.yml/badge.svg)](https://github.com/marivaldojunior/stowise/actions/workflows/web.yml)
[![mobile](https://github.com/marivaldojunior/stowise/actions/workflows/mobile.yml/badge.svg)](https://github.com/marivaldojunior/stowise/actions/workflows/mobile.yml)

Sistema de inventário e armazenagem em que **a IA sugere e uma pessoa sempre confirma**. O nome junta *stow* (armazenar) e *wise* (inteligente).

| Parte | Pasta | Stack |
| --- | --- | --- |
| API | [`api/`](api) | .NET 10, EF Core, PostgreSQL + pgvector |
| Painel de gestão | [`web/`](web) | React + TypeScript (Vite), Vitest |
| App de campo | [`mobile/`](mobile) | Flutter, plugin Kotlin para coletores |

- **Importação inteligente** de CSV, TXT, Excel e XML de NF-e, com staging e revisão.
- **Armazenagem inteligente** por motor de pontuação com regras configuráveis e explicáveis.
- **Contagem assistida por câmera**, com nível de confiança e aprovação antes do ajuste.

Especificação, modelo de dados e plano: [`docs/SPEC.md`](docs/SPEC.md). Decisões de arquitetura: [`docs/adr/`](docs/adr).

## Pré-requisitos

- .NET SDK 10.0.400+
- Node.js 24
- Flutter 3.44
- Docker (para o banco)

## Rodando localmente

```bash
cp .env.example .env
docker compose up -d --build
```

- API: http://localhost:8080/health/live (processo) e http://localhost:8080/health/ready (banco)
- Aspire Dashboard (traces, métricas e logs): http://localhost:18888
- PostgreSQL: `localhost:5432` (usuário, senha e banco `stowise`)

Rodando cada parte fora do Docker:

```bash
docker compose up -d db
dotnet run --project api/src/Stowise.Api        # http://localhost:5073
npm --prefix web install && npm --prefix web run dev   # http://localhost:5173
cd mobile && flutter run
```

## Contribuindo

Veja [`CONTRIBUTING.md`](CONTRIBUTING.md): uma tarefa do plano por PR, testes obrigatórios e Conventional Commits.

## Licença

Distribuído sob a licença Apache 2.0. Veja [`LICENSE`](LICENSE).
