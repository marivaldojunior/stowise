# 0006 — Idempotência por chave do cliente e concorrência otimista com nova tentativa

- **Status:** Aceito
- **Data:** 2026-10-18

## Contexto

O [ADR-0001](0001-livro-razao-saldo-projetado.md) define que toda mudança de estoque grava uma Movimentacao e atualiza o Saldo na mesma transação. Dois problemas aparecem quando isso encontra o uso real:

1. **Reenvio.** O app Flutter trabalha offline e sincroniza uma fila de operações. A resposta pode se perder no caminho (conexão caiu depois do servidor gravar), e o app reenvia. Sem proteção, a mesma entrada vira duas.
2. **Simultaneidade.** Vários operadores e coletores movimentam o mesmo endereço ao mesmo tempo. Duas transações que leem o saldo 10 e gravam 10 + 1 terminam com 11, e não com 12 (atualização perdida). A ocupação do endereço (Livre/Ocupado) tem o mesmo risco.

O SPEC já previa as duas decisões (3: idempotência em tudo que vem do celular; 4: concorrência otimista no Saldo). Este ADR registra como elas foram implementadas.

## Decisão

### Idempotência

- O cliente gera uma `idempotencyKey` (UUID) por operação e a reenvia sem alteração em toda nova tentativa. A chave é opcional para o painel web e obrigatória por convenção para o app.
- A coluna `movimentacoes.idempotency_key` tem índice único. Antes de aplicar qualquer regra, o serviço procura a chave:
  - **Mesma operação** (tipo, produto, endereços e quantidade na unidade base): devolve a movimentação original com **200** e o cabeçalho `Idempotent-Replayed: true`. Nada é gravado de novo — inclusive quando o saldo já foi consumido depois, o que faria a operação falhar se fosse reaplicada.
  - **Operação diferente com a mesma chave:** **409**. É erro do cliente, que reaproveitou a chave.
- **Duas requisições simultâneas com a mesma chave:** as duas passam pela verificação, e o índice único barra a segunda no `INSERT`. A transação dela é desfeita inteira (o saldo não é aplicado duas vezes), e a resposta é a movimentação da vencedora.

### Concorrência otimista

- `Saldo` e `Endereco` têm `Versao` mapeada na coluna de sistema `xmin` do PostgreSQL. O `UPDATE` inclui a versão lida no `WHERE`; se outra transação gravou antes, o EF lança `DbUpdateConcurrencyException`.
- O serviço de movimentação **repete a operação inteira com dados frescos** quando isso acontece, e também quando duas operações criam o mesmo saldo ou o mesmo lote ao mesmo tempo (violação dos índices únicos de `saldos` e `lotes`). Cada repetição limpa o `ChangeTracker`, espera alguns milissegundos aleatórios e reavalia todas as regras: uma saída repetida pode, com razão, falhar por saldo insuficiente.
- O limite é de **5 tentativas**. Em cada rodada pelo menos uma operação vence, então até 5 operações simultâneas no mesmo saldo terminam sem erro. Acima disso, a última tentativa vira **409** pelo handler global, e o cliente reenvia com a mesma chave.

## Consequências

- O app pode reenviar a fila de sincronização quantas vezes precisar, sem duplicar estoque.
- Nenhuma atualização de saldo se perde, sem bloquear linhas (`SELECT ... FOR UPDATE`) nem elevar o isolamento da transação.
- Picos de concorrência no mesmo saldo custam algumas repetições; acima de 5 operações simultâneas no mesmo item, parte delas recebe 409 e precisa ser reenviada.
- A comparação da operação repetida não inclui o lote nem o documento de referência: chaves iguais com esses campos diferentes são tratadas como a mesma operação.
- Testes de integração cobrem 5 entradas simultâneas no mesmo saldo e 5 envios simultâneos com a mesma chave.

## Alternativas consideradas

- **Bloqueio pessimista (`SELECT ... FOR UPDATE`) no saldo:** elimina as repetições, mas segura locks durante toda a operação e serializa os coletores no mesmo endereço; o SPEC já tinha escolhido a concorrência otimista.
- **Isolamento `SERIALIZABLE`:** cobre também anomalias de leitura, mas aumenta as falhas de serialização em todo o sistema; o `xmin` no Saldo e no Endereco cobre os pontos de escrita que importam.
- **Cabeçalho HTTP `Idempotency-Key` com cache de respostas:** genérico, mas exige guardar respostas por um tempo e não funciona dentro do lote de sincronização offline, em que cada operação precisa da própria chave. A chave no corpo e no livro-razão é auditável para sempre.
