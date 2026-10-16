# 0001 — Livro-razão de movimentações + saldo projetado

- **Status:** Aceito
- **Data:** 2026-10-10

## Contexto

O estoque é alterado por várias origens — recebimento de NF-e, armazenagem, transferências, inventário (inclusive contagens sugeridas por IA) e sincronização offline do app de campo. Um campo de quantidade editável diretamente perde o histórico, dificulta auditoria, não permite saber o estoque em uma data passada e torna difícil detectar operações duplicadas vindas do celular.

## Decisão

- Toda mudança de estoque é registrada como uma **Movimentacao** (`Entrada`, `Saída`, `Transferência`, `Ajuste`). Movimentações **nunca são editadas nem apagadas**; um erro é corrigido com uma nova movimentação.
- O **Saldo** (por endereço + produto + lote) é uma **projeção** das movimentações, atualizada **na mesma transação** em que a movimentação é gravada.
- Apenas o **serviço de movimentação** escreve em Saldo. Importação, Recebimento, Armazenagem e Inventário pedem movimentações a esse serviço; nenhum outro código altera Saldo diretamente.
- Cada movimentação guarda quem (`UsuarioId`, `DispositivoId`), quando (`OcorridoEm` no aparelho, `RecebidoEm` no servidor) e por quê (`DocumentoReferencia`).

## Consequências

- Auditoria completa e possibilidade de reconstruir o saldo em qualquer data somando as movimentações até ela.
- Leitura de saldo continua barata, porque a projeção está materializada.
- A escrita fica um pouco mais cara (duas tabelas por operação) e exige transação e controle de concorrência no Saldo — tratado em ADR próprio (concorrência otimista via `xmin`).
- Precisamos de um teste de consistência que compare o Saldo com a soma das movimentações.
- A tabela de movimentações cresce indefinidamente; particionamento por data pode ser necessário no futuro.

## Alternativas consideradas

- **Campo de quantidade editável no produto/endereço** — simples, mas sem histórico, sem auditoria e propenso a perder atualizações concorrentes.
- **Event sourcing puro, saldo calculado sob demanda** — leitura cara e complexidade desproporcional para o escopo; o livro-razão com projeção síncrona entrega a mesma auditabilidade.
- **Projeção assíncrona do saldo** — introduz consistência eventual em uma operação (consultar saldo para armazenar ou separar) que precisa ser imediata.
