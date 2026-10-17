# Stowise

Inventário e armazenagem com IA: API .NET 10 (`api/`), painel React + TypeScript (`web/`) e app Flutter (`mobile/`), sobre PostgreSQL + pgvector. A especificação completa, o modelo de dados e o **plano de tarefas** estão em [`docs/SPEC.md`](docs/SPEC.md) — leia antes de começar qualquer tarefa.

## Regras

- Trabalhe **uma tarefa do plano por vez**, na ordem dos marcos, e marque-a (`- [x]`) no `SPEC.md` ao concluir.
- Toda tarefa entra com testes; regra de negócio sem teste não está concluída.
- **Nunca altere Saldo diretamente**: toda mudança de estoque passa pelo serviço de movimentação ([ADR-0001](docs/adr/0001-livro-razao-saldo-projetado.md)).
- **IA só sugere**: nenhum fluxo grava resultado de IA sem confirmação humana. Decisões de armazenagem são algorítmicas, sem LLM.
- **IA só pela API** ([ADR-0004](docs/adr/0004-camada-de-ia.md)): a chave do provedor fica no servidor; Flutter e React nunca chamam o provedor. Toda saída de IA tem JSON Schema e é validada, e toda chamada tem timeout, retry, fallback e registro em `ChamadaIa`.
- Decisão de arquitetura nova vira um ADR em `docs/adr/` (use o modelo `0000-modelo.md`).
- Nomes de domínio em português (`Produto`, `Endereco`, `Movimentacao`); código e infraestrutura em inglês (`ProdutoRepository`, `MovimentacaoService`).
- Commits em Conventional Commits, um por tarefa — veja [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Fluxo por tarefa

1. Apresente um plano curto antes de codar.
2. Implemente com testes.
3. Rode build, testes e lint da pasta afetada (abaixo).
4. Faça o commit direto na `main`, um por tarefa. Por enquanto, o projeto não usa branches por tarefa nem PR. Não faça `git push` sem pedido do usuário.

## Comandos

```bash
# API (em api/)
dotnet build
dotnet test
dotnet format --verify-no-changes

# Migrations (em api/; rode dotnet tool restore uma vez)
dotnet ef migrations add <Nome> -p src/Stowise.Infrastructure -s src/Stowise.Infrastructure -o Persistence/Migrations

# Web (em web/)
npm run lint && npm run typecheck && npm test && npm run build

# Mobile (em mobile/)
flutter analyze && flutter test

# Banco + API (na raiz)
docker compose up -d --build
```

## Estrutura da API

Camadas com dependência em um só sentido ([ADR-0002](docs/adr/0002-solucao-em-camadas.md)): `Domain` ← `Application` ← `Infrastructure` / `Api`. `Domain` não referencia EF Core nem outros projetos. Versões de pacotes NuGet ficam em `api/Directory.Packages.props` (gerenciamento central); após adicionar um pacote, rode `dotnet restore` para atualizar os `packages.lock.json`.

- **Nomes:** substantivos e estados do domínio em português (`Endereco`, `StatusEndereco.Livre`); verbos e termos técnicos em inglês (`Endereco.Create`, `Armazem.AddZona`, `SampleDataSeeder`). Mensagens de `DomainException` em português, porque chegam ao usuário; logs e erros de infraestrutura em inglês.
- **Entidades:** construtor privado para o EF, criação por `Create(...)` com validação, setters privados. Ids em `Guid.CreateVersion7()`.
- **Banco:** tabelas e colunas em `snake_case`, enums gravados como texto e `decimal(18,4)` por convenção do `StowiseDbContext`. Migrations e seed rodam na inicialização só com `Database:MigrateOnStartup` e `Database:SeedSampleData` (ligados em Development e no docker-compose).
- **Testes de integração:** testes com PostgreSQL usam `[DockerFact]` e a coleção `PostgresTestGroup` (Testcontainers, imagem `pgvector/pgvector:pg17`, um banco novo por teste). Sem Docker, eles são pulados localmente; no CI, `STOWISE_REQUIRE_DOCKER=true` faz o teste falhar em vez de ser pulado. Testes HTTP usam `StowiseApiFactory` (ambiente `Testing`).
- **Autorização:** todo endpoint exige usuário autenticado (política de fallback, [ADR-0005](docs/adr/0005-autenticacao.md)). Restrinja por perfil com `.RequireAuthorization(Perfis.Gestor)`; use `.AllowAnonymous()` só com motivo explícito. O id do usuário está na claim `sub`.
- **Erros de caso de uso:** serviços da Application devolvem `Result`/`Result<T>` com `AppError` (Validation 400, NotFound 404, Conflict 409, BusinessRule 422), e não lançam exceção para falhas esperadas. Nos endpoints, use `ToHttpResult`/`ToNoContent` de `Stowise.Api.Common.ErrorResults`. Listas paginadas usam `PagedResult<T>` e `Paging.Normalize`.
- **Observabilidade:** use `ILogger` com `[LoggerMessage]` (Serilog por baixo; JSON com `@tr`/`@sp` fora de Development). Traces e métricas do OpenTelemetry só são exportados quando `OTEL_EXPORTER_OTLP_ENDPOINT` existe (no docker-compose, o Aspire Dashboard em http://localhost:18888). Exceções inesperadas viram 500 sem detalhes; regras do domínio (`DomainException`) viram 422. Dependências novas ganham um health check com a tag `ready`.
- **Rotas e contrato:** módulos mapeiam rotas relativas dentro do grupo versionado (`var v1 = app.MapApiV1(); v1.MapXxxEndpoints();` → `/api/v1/...`). Toda operação tem `.WithName("VerboRecurso")` em português (vira o `operationId` e o nome no cliente gerado) e declara as respostas (`.Produces<T>()`, `.ProducesProblem(status)`, `.ProducesValidationProblem()`). O contrato fica em `/openapi/v1.json` e a referência em `/scalar`.
