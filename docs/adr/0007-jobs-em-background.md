# 0007 — Jobs em background com Hangfire e armazenamento no PostgreSQL

- **Status:** Aceito
- **Data:** 2026-10-18

## Contexto

Algumas operações demoram demais para caber numa requisição HTTP:

1. **Staging da importação.** Hoje, `PUT /importacoes/{id}/mapeamento` lê o arquivo inteiro, valida cada linha e cruza com o catálogo na mesma requisição. Com o limite de 1.000.000 de linhas, a requisição passa do timeout do proxy, e o painel não mostra progresso.
2. **Efetivação.** Gravar no catálogo as linhas revisadas (bulk insert) tem o mesmo problema.
3. **Próximas funcionalidades.** As chamadas de IA (ADR-0004), os embeddings da busca semântica e o RAG (Marco 6) também rodam fora da requisição. Há ainda tarefas periódicas, como limpar staging antigo e refresh tokens vencidos.

Os requisitos são:

- **Fila durável:** um job enfileirado sobrevive a um restart ou a um deploy da API.
- **Nova tentativa:** uma falha transitória (banco indisponível, timeout do provedor de IA) repete o job com espera crescente.
- **Agendamento:** jobs recorrentes por cron e jobs com atraso.
- **Sem infraestrutura nova:** o projeto já tem PostgreSQL. Um Redis ou um broker só para a fila aumenta o custo do deploy de demonstração.
- **Visibilidade:** ver jobs na fila, em execução e com falha, durante o desenvolvimento.

## Decisão

1. **Hangfire 1.8 com o armazenamento Hangfire.PostgreSql**, no mesmo banco da aplicação e num schema próprio (`hangfire`). As tabelas do Hangfire são criadas pelo próprio Hangfire na inicialização. Elas não entram nas migrations do EF.
2. **O servidor de jobs roda no processo da API** (`AddHangfireServer`). Um deploy só serve a API e os jobs. A configuração `Jobs:Enabled` liga e desliga o servidor; separar um worker depois é só subir o mesmo binário com a API desligada.
3. **A Application não conhece o Hangfire.** Ela usa uma porta (`IFilaTrabalhos`, com métodos por caso de uso, como `EnfileirarStaging(importacaoId)`). A Infrastructure implementa a porta com `IBackgroundJobClient`. Os argumentos dos jobs são só ids; o job carrega o estado atual do banco.
4. **Todo job é idempotente.** O Hangfire entrega cada job *pelo menos uma vez*: um restart no meio da execução repete o job. Por isso:
   - O job confere o status antes de agir. Exemplo: o staging só roda com a importação em `Validando`; se ela já está em revisão, o job termina sem fazer nada.
   - O trabalho de cada etapa fica numa transação, ou é refeito do zero (o staging apaga as linhas anteriores antes de gravar).
5. **Nova tentativa só para falha transitória.**
   - Exceções de infraestrutura (conexão, timeout) sobem e o Hangfire repete o job até 3 vezes, com espera crescente.
   - Uma regra de negócio (`DomainException`) ou um arquivo inválido não melhora com nova tentativa. O job grava a importação como `Falhou`, com o motivo, e termina sem lançar a exceção.
   - Se as tentativas acabam, um filtro do Hangfire grava `Falhou` com um motivo genérico. O usuário nunca vê uma importação parada em `Validando` para sempre.
6. **Filas por tipo de trabalho:** `importacao` para staging e efetivação, `ia` para chamadas de IA e `default` para o resto. A quantidade de workers é configurável (`Jobs:Workers`).
7. **Jobs recorrentes** são registrados na inicialização com `RecurringJob.AddOrUpdate`, por cron em UTC. O primeiro é a limpeza de staging de importações encerradas há mais de 30 dias.
8. **Dashboard em `/hangfire` só em Development**, com o filtro padrão de requisição local. A API autentica por Bearer, e uma navegação no browser não envia esse cabeçalho. Em produção, o painel React mostra o status pelos endpoints da importação e, depois, por SignalR.
9. **Observabilidade:** cada job abre uma `Activity` (`Stowise.Jobs`) com o id da entidade, e os logs passam pelo `ILogger` (Serilog). O trace do job aparece no Aspire Dashboard junto com o da requisição que o enfileirou.

## Consequências

- **Mais fácil:** staging, efetivação e chamadas de IA saem da requisição. A resposta do `PUT /mapeamento` passa a ser imediata (`202`), e o progresso fica consultável. Um restart no meio do processamento não perde trabalho.
- **Semântica pelo menos uma vez:** todo job novo precisa ser idempotente, e os testes devem cobrir a repetição.
- **Testes:** os testes de integração sobem o servidor do Hangfire contra o banco do Testcontainers e esperam o status mudar, com um limite de tempo. Os jobs são classes comuns, testáveis também sem o Hangfire.
- **Dependências:** Hangfire.Core e Hangfire.PostgreSql usam a licença LGPL-3.0. O uso como biblioteca (link dinâmico, sem alterar o código deles) é compatível com a licença do projeto (PolyForm Strict 1.0.0; Apache 2.0 até a v0.1.0). O Hangfire.PostgreSql é mantido pela comunidade, não pela equipe do Hangfire. O Hangfire traz o Newtonsoft.Json para serializar os argumentos.
- **Banco:** o schema `hangfire` cresce com o histórico de jobs. O Hangfire expira os jobs concluídos (padrão de 1 dia); o mesmo vale para os falhos depois de inspecionados.
- **Fica para depois:** health check do servidor de jobs (tag `ready`) e métricas de fila no OpenTelemetry.

## Alternativas consideradas

- **Fila própria no PostgreSQL** (`FOR UPDATE SKIP LOCKED` e um `BackgroundService`) — sem dependência e com controle total, mas a nova tentativa com espera, o agendamento por cron, a recuperação de jobs órfãos e um painel teriam de ser escritos e testados por nós.
- **Quartz.NET** — forte em agendamento, com armazenamento no PostgreSQL, mas a fila de trabalho sob demanda e a nova tentativa são menos diretas, e não há painel pronto.
- **Canais em memória (`System.Threading.Channels`)** — simples, mas não são duráveis: um restart perde a fila.
- **Broker de mensagens (RabbitMQ, Azure Service Bus) ou Redis** — robustos, mas exigem infraestrutura nova no deploy de demonstração, sem ganho para o volume do projeto.
