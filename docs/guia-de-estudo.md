# Guia de estudo do Stowise

Este guia resume a aplicação e as decisões técnicas da versão `v0.1.0` (Marco 1). Use-o para estudar o projeto. Cada tema tem o problema, a solução, os arquivos para ler e perguntas de revisão. Os detalhes completos estão na [especificação](SPEC.md) e nos [ADRs](adr).

## 1. A aplicação em uma página

O Stowise controla inventário e armazenagem. Ele tem três partes, que usam o mesmo contrato OpenAPI:

| Parte | Tecnologia | Quem usa | O que faz |
| --- | --- | --- | --- |
| API | .NET 10, EF Core, PostgreSQL + pgvector | Os dois clientes | Regras de negócio, estoque, importação, IA e autenticação |
| Painel web | React, TypeScript, Vite, TanStack Query, shadcn/ui | Gestor e administrador | Catálogo, endereços, saldos, extrato, usuários e importação |
| App de campo | Flutter, Riverpod, go_router, ML Kit | Operador no armazém | Leitura de código de barras, movimentação e consulta de saldo |

**Conceitos do domínio:**

- **Produto:** item do catálogo, com SKU, unidade base e embalagens (ex.: caixa com 12 UN).
- **Armazém → Zona → Endereço:** a estrutura física. Um endereço é uma posição (rua, módulo, nível, posição), por exemplo `A-01-1-1`.
- **Movimentação:** um lançamento no livro-razão (entrada, saída, transferência, ajuste, saída reservada).
- **Saldo:** a quantidade de um produto, num endereço e num lote. É uma projeção das movimentações.
- **Reserva:** separa uma quantidade do saldo. Ela muda só a quantidade reservada.
- **Importação:** a carga de produtos por arquivo (CSV, texto posicional ou Excel), com mapeamento de colunas.

## 2. Arquitetura da API em camadas

**Problema:** as regras de negócio misturadas com banco e HTTP são difíceis de testar e de mudar.

**Solução ([ADR-0002](adr/0002-solucao-em-camadas.md)):** quatro projetos, com dependência num só sentido.

```
Domain  ←  Application  ←  Infrastructure
                        ←  Api
```

- **Domain:** entidades e regras. Não conhece EF Core nem HTTP. Exemplo: [Movimentacao.cs](../api/src/Stowise.Domain/Estoque/Movimentacao.cs), [Saldo.cs](../api/src/Stowise.Domain/Estoque/Saldo.cs).
- **Application:** casos de uso e portas (interfaces). Os serviços devolvem `Result`/`AppError` e não lançam exceção para falhas esperadas.
- **Infrastructure:** EF Core, Identity, Hangfire, provedores de IA. Implementa as portas.
- **Api:** endpoints mínimos, autorização e conversão de `AppError` em HTTP ([ErrorResults.cs](../api/src/Stowise.Api/Common/ErrorResults.cs)).

**Padrões das entidades:** construtor privado para o EF, criação por `Create(...)` com validação, setters privados e ids `Guid.CreateVersion7()` gerados no domínio.

**Mapa de erros:** Validation → 400, NotFound → 404, Conflict → 409, BusinessRule → 422, TooManyRequests → 429. Uma `DomainException` também vira 422.

**Perguntas de revisão:**
1. Por que o Domain não pode referenciar o EF Core?
2. Qual é a vantagem de devolver `Result` em vez de lançar exceção?
3. Por que gerar o id no domínio, e não no banco?

## 3. Estoque como livro-razão

**Problema:** se o saldo for editado direto, você perde a auditoria e não consegue saber o saldo de uma data passada.

**Solução ([ADR-0001](adr/0001-livro-razao-saldo-projetado.md)):** toda mudança de estoque grava uma `Movimentacao` e atualiza o `Saldo` na mesma transação. O saldo é uma projeção; ninguém o altera direto.

- A quantidade é sempre positiva. O sentido vem do endereço de origem e do endereço de destino.
- Uma transferência é um só lançamento, com origem e destino.
- O saldo numa data vem da soma das movimentações até essa data.

**Arquivos:** [MovimentacaoService.cs](../api/src/Stowise.Infrastructure/Estoque/MovimentacaoService.cs), [Movimentacao.cs](../api/src/Stowise.Domain/Estoque/Movimentacao.cs).

**Trade-off:** mais escrita por operação, em troca de auditoria completa.

**Perguntas de revisão:**
1. Como o sistema calcula o saldo de um produto no mês passado?
2. Por que a quantidade de uma movimentação nunca é negativa?

## 4. Idempotência e concorrência

**Problema:** no armazém, a rede falha. O operador toca em "Registrar" de novo, e a entrada pode ser gravada duas vezes. Dois operadores também podem tirar o mesmo saldo ao mesmo tempo.

**Solução ([ADR-0006](adr/0006-idempotencia-e-concorrencia.md)):**

- **Idempotência:** o cliente gera uma `idempotencyKey` (UUID v7) por operação e repete a mesma chave em cada nova tentativa.
  - Mesma chave e mesma operação: a API devolve a movimentação original (200 e o cabeçalho `Idempotent-Replayed: true`). Nada é gravado de novo.
  - Mesma chave e operação diferente: 409.
  - Um índice único na chave barra a gravação dupla em requisições simultâneas.
- **Concorrência otimista:** `Saldo` e `Endereco` têm `Versao` mapeada na coluna `xmin` do PostgreSQL. Se outra transação gravou antes, o EF lança uma exceção de concorrência, e o serviço tenta de novo com dados frescos (até 5 vezes, em [EstoqueRetry.cs](../api/src/Stowise.Infrastructure/Estoque/EstoqueRetry.cs)).

No app, a chave muda quando qualquer campo da operação muda ([movimentacao_page.dart](../mobile/lib/features/estoque/presentation/movimentacao_page.dart)).

**Perguntas de revisão:**
1. Por que a chave é gerada no cliente, e não no servidor?
2. Qual é a diferença entre concorrência otimista e um `SELECT ... FOR UPDATE`?
3. O que acontece se o saldo já foi consumido quando a mesma chave chega de novo?

## 5. Autenticação

**Problema:** dois clientes diferentes (navegador e celular) precisam de login seguro, sem um serviço externo.

**Solução ([ADR-0005](adr/0005-autenticacao.md)):** ASP.NET Core Identity para usuários e senhas, JWT de curta duração e refresh token rotativo.

- Cada refresh consome o token atual e emite um novo da mesma família. Se um token antigo for usado de novo, a família inteira é revogada (detecção de reuso).
- **Web:** o refresh token fica num cookie `HttpOnly`, `Secure`, `SameSite=Strict`, restrito a `/api/v1/auth`. O access token fica só na memória.
- **App:** o refresh token fica no armazenamento seguro do aparelho (Keystore).
- Todo endpoint exige um usuário autenticado (política de fallback). Perfis: Admin, Gestor e Operador.

**Arquivos:** [AuthService.cs](../api/src/Stowise.Infrastructure/Identity/AuthService.cs), [AuthProvider.tsx](../web/src/features/auth/AuthProvider.tsx), [sessao_controller.dart](../mobile/lib/features/auth/presentation/sessao_controller.dart).

**Perguntas de revisão:**
1. Por que o painel web não guarda o token no `localStorage`?
2. Como a rotação detecta um refresh token roubado?

## 6. Importação de produtos e jobs em background

**Problema:** um arquivo de fornecedor pode ter milhares de linhas, encoding e delimitadores diferentes. O processamento não pode prender a requisição HTTP.

**Solução ([ADR-0007](adr/0007-jobs-em-background.md)):** Hangfire no mesmo PostgreSQL (schema `hangfire`), sem fila externa.

**Fluxo da importação:**

1. Upload: a API detecta encoding, delimitador, separador decimal e layout ([DetectorLayout.cs](../api/src/Stowise.Application/Importacoes/DetectorLayout.cs)).
2. Mapeamento: um template salvo (pelo fingerprint do cabeçalho), a sugestão da IA ou a escolha manual.
3. Confirmação humana do mapeamento.
4. Staging em background: as linhas vão para `importacao_linhas` com COPY binário ([StagingProdutos.cs](../api/src/Stowise.Infrastructure/Importacoes/StagingProdutos.cs)) e passam por validações determinísticas (GTIN, NCM, unidades).
5. Revisão: a prévia mostra os erros linha a linha.
6. Efetivação em background: gravação em lote no catálogo.

**Regras dos jobs:**
- O job recebe só ids e confere o status antes de agir.
- O job é idempotente, porque a entrega é "pelo menos uma vez".
- Uma `DomainException` grava a falha sem nova tentativa.
- O progresso vai para o painel em tempo real pelo hub SignalR `/hubs/importacoes`.

**Arquivos:** [ImportacaoJobs.cs](../api/src/Stowise.Infrastructure/Importacoes/ImportacaoJobs.cs), [NormalizadorProdutos.cs](../api/src/Stowise.Application/Importacoes/NormalizadorProdutos.cs).

**Perguntas de revisão:**
1. Por que o job recebe só ids, e não os dados?
2. O que significa "entrega pelo menos uma vez", e como o código se protege?

## 7. Camada de IA

**Problema:** usar um LLM sem controle traz riscos: chave exposta, custo sem limite, resposta inválida e dependência de um só fornecedor.

**Solução ([ADR-0004](adr/0004-camada-de-ia.md), [provedores](ia-provedores.md)):**

- **IA só pela API:** a chave fica no servidor. O web e o app nunca chamam o provedor.
- **Provedores trocáveis:** `Microsoft.Extensions.AI`, com uma lista ordenada na configuração (Anthropic, OpenAI compatível, Gemini, Ollama). O primeiro é o principal; os outros são o fallback.
- **GatewayIa:** toda chamada passa por ele ([GatewayIa.cs](../api/src/Stowise.Infrastructure/Ia/GatewayIa.cs)). Ele aplica timeout, nova tentativa só para falha transitória, fallback e cota por usuário (`CotaIa`, HTTP 429). Cada pedido grava um registro `ChamadaIa`.
- **Saída validada:** cada funcionalidade tem um JSON Schema versionado ([ContratoSaidaIa.cs](../api/src/Stowise.Infrastructure/Ia/ContratoSaidaIa.cs)). Uma resposta inválida é recusada e vai para o próximo provedor.
- **IA só sugere:** a sugestão de mapeamento vira uma proposta (`AguardandoConfirmacao`). Uma pessoa confirma antes de gravar. As regras confirmadas são aplicadas por código determinístico.
- **Sem IA, o fluxo continua manual.** Decisões de armazenagem usam regras explicáveis, sem LLM.

**Testes:** `FakeChatClient` e `RegistroEmMemoria`. Nenhum teste chama o provedor real.

**Perguntas de revisão:**
1. Por que a IA sugere as regras de normalização, mas o código aplica essas regras?
2. O que acontece quando o provedor principal devolve um JSON fora do schema?
3. Por que a cota de IA é por usuário?

## 8. Contrato OpenAPI e clientes gerados

**Problema:** três bases de código podem divergir nos nomes e nos tipos da API.

**Solução:** o contrato `api/openapi/v1.json` fica no repositório.

- Um teste da API falha se o contrato mudar sem atualização.
- O painel gera o cliente com orval; o app gera o cliente com openapi-generator (dart-dio).
- O CI do web e o do mobile falham se o cliente gerado não bater com o contrato.
- Cada operação tem um nome em português (`.WithName("VerboRecurso")`), que vira o nome da função no cliente.

**Pergunta de revisão:** qual erro esse fluxo impede de chegar à produção?

## 9. Painel web

- **Dados:** TanStack Query para cache e estado do servidor; o cliente gerado faz as chamadas ([mutator.ts](../web/src/api/mutator.ts)).
- **Rotas:** páginas carregadas sob demanda (`lazy`) e protegidas por perfil ([RotaProtegida.tsx](../web/src/features/auth/RotaProtegida.tsx)). Os filtros das listas ficam na URL.
- **Interface:** componentes do shadcn/ui, tokens de cor em `index.css` e componentes padrão (`CabecalhoPagina`, `Painel`, `Situacao`, `Alerta`).
- **Testes:** Vitest e Testing Library; a rede é simulada pelo MSW. Os testes e2e usam o Playwright contra a API real.
- **Modo demonstração:** `npm run dev:demo` usa o MSW no navegador, sem a API.

## 10. App de campo

**Decisões ([ADR-0008](adr/0008-arquitetura-do-app.md)):**

- **Camadas por funcionalidade:** `data` (repositórios), `domain` (modelos) e `presentation` (telas e controllers).
- **Riverpod:** injeção de dependências trocáveis nos testes.
- **go_router:** rotas com redirecionamento pela sessão ([rotas.dart](../mobile/lib/app/rotas.dart)).
- **Flavors** dev e prod, com URLs de API diferentes.
- **Leitura de código de barras** no aparelho (ML Kit) ou pelo leitor do coletor (o campo aceita digitação).
- **Testes:** unidade, widget, golden e integração. Os goldens usam o Linux como referência, no CI.

## 11. Qualidade, CI e entrega

- **Workflows do GitHub Actions:** `api`, `web`, `e2e` e `mobile`. O `mobile` gera o APK de demonstração como artefato.
- **Testes de integração da API:** Testcontainers com `pgvector/pgvector:pg17`, um banco novo por teste.
- **Observabilidade:** Serilog, OpenTelemetry (exportado só quando há um endpoint OTLP) e health checks.
- **Deploy de demonstração ([ADR-0009](adr/0009-deploy-de-demonstracao.md)):** uma só imagem Docker (API + painel na mesma origem, sem CORS) no Render, com o banco no Neon.

## 12. Resumo das decisões

| ADR | Decisão | Ganho | Custo |
| --- | --- | --- | --- |
| [0001](adr/0001-livro-razao-saldo-projetado.md) | Livro-razão + saldo projetado | Auditoria e saldo em qualquer data | Mais escrita; saldo nunca editado direto |
| [0002](adr/0002-solucao-em-camadas.md) | API em camadas | Domínio testável sem banco | Mais projetos e mapeamentos |
| [0003](adr/0003-patrimonio-modulo-separado.md) | Patrimônio separado do estoque | Regras de ativo isoladas | Dois livros-razão |
| [0004](adr/0004-camada-de-ia.md) | IA atrás da API, validada e com cota | Chave segura, custo controlado, provedor trocável | Latência e um contrato por funcionalidade |
| [0005](adr/0005-autenticacao.md) | Identity + JWT + refresh rotativo | Sem serviço externo; detecção de reuso | Fluxo de tokens mantido no projeto |
| [0006](adr/0006-idempotencia-e-concorrencia.md) | Idempotência + concorrência otimista | Reenvio seguro; sem saldo negativo por corrida | Chave por operação e novas tentativas |
| [0007](adr/0007-jobs-em-background.md) | Hangfire no PostgreSQL | Sem fila externa para operar | Polling no banco |
| [0008](adr/0008-arquitetura-do-app.md) | Riverpod, go_router, flavors, cliente gerado | Testes com dependências trocáveis; tipos iguais aos da API | Código gerado no repositório |
| [0009](adr/0009-deploy-de-demonstracao.md) | Render + Neon numa só imagem | Custo zero, sem CORS | A primeira visita acorda o serviço |

## 13. Roteiro sugerido de estudo

1. Leia a seção 1 e rode o painel em modo demonstração (`npm run dev:demo` em `web/`).
2. Leia o ADR-0001 e siga uma entrada de estoque do endpoint até o `Saldo`.
3. Leia o ADR-0006 e encontre a verificação da `idempotencyKey` no `MovimentacaoService`.
4. Leia o ADR-0005 e siga um refresh de token no `AuthService`.
5. Leia o ADR-0007 e siga uma importação do upload até a efetivação.
6. Leia o ADR-0004 e siga uma chamada pelo `GatewayIa`, incluindo o fallback.
7. Mude um endpoint, regrave o contrato e veja o CI dos clientes falhar.
8. Responda às perguntas de revisão de cada seção sem consultar o texto.
