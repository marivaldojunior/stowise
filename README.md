# Stowise

[![api](https://github.com/marivaldojunior/stowise/actions/workflows/api.yml/badge.svg)](https://github.com/marivaldojunior/stowise/actions/workflows/api.yml)
[![web](https://github.com/marivaldojunior/stowise/actions/workflows/web.yml/badge.svg)](https://github.com/marivaldojunior/stowise/actions/workflows/web.yml)
[![mobile](https://github.com/marivaldojunior/stowise/actions/workflows/mobile.yml/badge.svg)](https://github.com/marivaldojunior/stowise/actions/workflows/mobile.yml)

> [!NOTE]
> **Projeto experimental.** O Stowise é um laboratório de recursos de IA na API, no painel web e no app mobile. O código está em desenvolvimento ativo e não está pronto para produção. As APIs, o modelo de dados e as telas podem mudar sem aviso.

O Stowise testa recursos de IA sobre um caso real: um sistema de inventário e armazenagem. A regra de todo o projeto é simples: **a IA sugere e uma pessoa sempre confirma**. O nome junta *stow* (armazenar) e *wise* (inteligente).

| Parte | Pasta | Stack |
| --- | --- | --- |
| API | [`api/`](api) | .NET 10, EF Core, PostgreSQL + pgvector |
| Painel de gestão | [`web/`](web) | React + TypeScript (Vite), Vitest |
| App de campo | [`mobile/`](mobile) | Flutter, plugin Kotlin para coletores |

## Recursos de IA em teste

| Frente | Recursos |
| --- | --- |
| API | Camada de IA plugável, com JSON Schema em cada resposta, timeout, nova tentativa, provedor reserva, cota por usuário e registro de cada chamada. Mapeamento de colunas na importação, casamento de itens da NF-e com o catálogo, busca semântica com pgvector, consulta em linguagem natural e perguntas sobre documentos (RAG) |
| Web | Revisão das sugestões da IA na importação, chat de consulta em linguagem natural, busca semântica no catálogo e painel de uso de IA (chamadas, custo e latência) |
| Mobile | Contagem assistida por câmera, com nível de confiança, cadastro de produto por foto e busca semântica na consulta de saldo |

Regras que valem para todos os recursos:

- A chave do provedor de IA fica só na API. O painel web e o app nunca chamam o provedor.
- Nenhum resultado de IA é gravado sem a confirmação de uma pessoa.
- As decisões de armazenagem usam um motor de pontuação com regras explicáveis, sem LLM.
- Sem IA, todos os fluxos continuam a funcionar de forma manual.

Especificação, modelo de dados e plano (com o que já está pronto e o que está em aberto): [`docs/SPEC.md`](docs/SPEC.md). Decisões de arquitetura: [`docs/adr/`](docs/adr).

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
- Referência da API (Scalar): http://localhost:8080/scalar · contrato OpenAPI: http://localhost:8080/openapi/v1.json
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
