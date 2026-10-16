# 0003 — Patrimônio como módulo separado do estoque

- **Status:** Aceito
- **Data:** 2026-10-16

## Contexto

O Stowise vai ganhar o inventário patrimonial: a conferência de bens como computadores, móveis, equipamentos e veículos. À primeira vista ele parece o inventário de estoque, mas o problema é outro:

- Um bem é **único**, identificado por uma plaqueta (número de patrimônio). Não tem quantidade, lote, validade nem unidade de medida.
- Ele fica em **salas, setores e unidades**, sob a guarda de um **responsável**, e não em posições de armazém como `A-03-02-1`.
- A conferência não compara quantidades. Ela responde se o bem está lá, se está no local certo e em que estado está.
- As divergências não viram um Ajuste de saldo. Viram transferência de local ou de responsável, mudança de estado ou abertura de apuração para bens não localizados.

Ainda assim, o problema pede o que o [ADR-0001](0001-livro-razao-saldo-projetado.md) já garante ao estoque: histórico completo, auditoria, posição em qualquer data e idempotência para o que vem do app offline.

## Decisão

1. **Módulo próprio `Patrimonio`** em Domain e Application, com entidades próprias (`BemPatrimonial`, `LocalPatrimonial`, `CategoriaPatrimonial`, `Responsavel`, `InventarioPatrimonial` e relacionadas). Bens patrimoniais **não** são `Produto` e **não** têm `Saldo`.
2. **Livro-razão próprio**, a `MovimentacaoPatrimonial`, que segue o mesmo princípio do ADR-0001:
   - É só de acréscimos: nunca é editada nem apagada.
   - Local, responsável, estado de conservação e situação do bem são **projeção** dela e são atualizados na mesma transação.
   - Só o serviço de movimentação patrimonial escreve nesses campos.
   - Toda operação vinda do app carrega `IdempotencyKey`, e o bem usa concorrência otimista.
3. **Hierarquia de locais própria** (Unidade → Prédio → Andar → Sala), independente de Armazém/Zona/Endereço.
4. **O inventário patrimonial usa snapshot e bloqueio:**
   - Na abertura, grava os bens esperados do escopo com local, responsável e estado.
   - Enquanto o inventário estiver aberto, os bens do escopo não podem ser movimentados fora da conciliação.
5. **Toda divergência é decidida por uma pessoa** na conciliação. A IA sugere a leitura de plaqueta por OCR, o estado de conservação pela foto e o casamento de sobras por similaridade, mas nunca gera movimentação sozinha. Bem não localizado abre apuração e **nunca é baixado automaticamente**. A baixa exige motivo e aprovação de um Gestor.
6. **Infraestrutura compartilhada:**
   - Sincronização offline e `IdempotencyKey`
   - Leitura de código de barras e plugin de coletor
   - Importação com staging (`Tipo` BensPatrimoniais)
   - Camada de IA com registro em `ChamadaIa`
   - pgvector, com tabela própria de embeddings de bens
7. **Fora do escopo:** depreciação, integração contábil e termo de responsabilidade. O sistema exporta os dados (CSV) para quem faz essa gestão.

## Consequências

- As regras de estoque (saldo, lote, FEFO, curva ABC) continuam sem casos especiais para itens únicos. As do patrimônio (escopo por hierarquia, bloqueio durante o inventário, baixa com aprovação) também ficam isoladas.
- O histórico de cada bem fica completo, e a posição patrimonial em uma data é reconstruída da mesma forma que o estoque.
- Há duplicação estrutural: dois livros-razão, dois inventários e duas hierarquias de categoria. O que for de fato genérico, como idempotência, envelope de sincronização, upload de imagem e registro de IA, deve ficar em componentes compartilhados, e não ser copiado.
- O bloqueio durante o inventário simplifica a conciliação, mas impede transferências legítimas no período. Inventários com escopo grande devem ser divididos por local ou feitos em janelas curtas.
- O endpoint de sincronização offline passa a aceitar também operações de conferência patrimonial.
- Um bem comprado via NF-e não é incorporado automaticamente ao patrimônio. Essa ligação fica para uma decisão futura.

## Alternativas consideradas

- **Bem como `Produto` controlado por número de série, com saldo 1 por endereço:** reaproveitaria Saldo e Movimentacao, mas forçaria quantidade, lote e endereço de armazém sobre algo que não os tem. Responsável, estado de conservação e situação não cabem no modelo de estoque, e as regras de armazenagem passariam a precisar ignorar esses itens.
- **Reaproveitar Armazém/Zona/Endereço como locais:** salas e setores não têm capacidade, dimensões nem distância de expedição, e a hierarquia administrativa (unidade, prédio, andar) não cabe em rua × módulo × nível × posição.
- **Campos editáveis no bem com uma tabela de auditoria genérica:** é mais simples de escrever, mas a auditoria vira efeito colateral e não fonte da verdade. A posição em uma data fica difícil de reconstruir, e as operações offline repetidas ficam sem proteção natural.
- **Inventário sem bloqueio, comparando com a posição vigente no momento de cada leitura:** permite movimentar durante o inventário, mas torna a conciliação dependente da ordem entre leituras e transferências, o que é difícil de explicar e de testar.
