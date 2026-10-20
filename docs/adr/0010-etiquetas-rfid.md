# 0010 — Etiquetas RFID no padrão GS1 (SGTIN-96), com o leitor atrás de uma porta no app

- **Status:** Aceito
- **Data:** 2026-10-20

## Contexto

Clientes com coletores RFID UHF querem ler e gravar etiquetas: contar caixas sem bipar uma a uma, gravar a etiqueta de um produto no recebimento e, depois, inventariar com leitura em massa. O projeto já tem:

1. A busca de produto por GTIN de qualquer embalagem (`/produtos/codigo/{codigo}`).
2. O campo de código do app, que aceita o leitor físico em modo teclado (DataWedge, Honeywell).
3. Estoque por quantidade (produto, endereço e lote), num livro-razão (ADR-0001), sem rastrear cada unidade.

Cada fabricante de coletor RFID tem um SDK nativo diferente (Zebra, Honeywell, Chainway), e o CI não tem um leitor real.

## Decisão

- **Padrão da etiqueta:** EPC **SGTIN-96** (GS1 EPC Tag Data Standard). O EPC carrega o GTIN-14 da embalagem e um número de série de 38 bits. O filtro segue a embalagem: Unidade = 1 (item de venda), Caixa = 2 (caixa de transporte), Palete = 6 (carga unitária).
- **RFID conta, não rastreia unidade:** um EPC lido vira uma unidade da embalagem do GTIN. O livro-razão e o `Saldo` não mudam. O número de série só garante que duas etiquetas não tenham o mesmo EPC.
- **Codificação no domínio:** `Sgtin96` (`Stowise.Domain/Rfid`) codifica e decodifica o EPC em hexadecimal e gera a URI `urn:epc:id:sgtin:...`. O tamanho do prefixo da empresa GS1 (6 a 12 dígitos) não está no GTIN: o pedido informa o tamanho, ou vale `Rfid:TamanhoPrefixoEmpresaPadrao`.
- **API:**
  - `GET /produtos/codigo/{codigo}` também aceita o EPC SGTIN-96 em hexadecimal. Um coletor RFID em modo teclado funciona no app atual sem mudança.
  - `POST /rfid/leituras` resolve um lote de EPCs (até 1000, repetições ignoradas) em produtos, embalagens e quantidades.
  - `POST /rfid/etiquetas` gera EPCs para uma embalagem com GTIN, com números de série tirados da sequência `rfid_serial` do PostgreSQL (únicos, sem tabela de etiquetas).
- **App:** o leitor fica atrás da porta `LeitorRfid` (ler em massa, parar e gravar um EPC). A implementação padrão é `LeitorRfidIndisponivel`; cada SDK de fabricante entra depois como um plugin Kotlin por platform channel (o mesmo caminho do plugin do DataWedge, no Marco 2). Os testes usam um leitor falso.

## Consequências

- O nível 1 (uma etiqueta por vez, em modo teclado) funciona já, sem código nativo.
- A leitura em massa e a gravação dependem de um plugin por fabricante, testado num aparelho real; o CI cobre só a parte em Dart.
- Sem tabela de etiquetas, o sistema não sabe quais EPCs foram gravados nem onde está cada unidade. Rastrear unidade (EPC por movimentação) exige um novo ADR, porque muda o livro-razão.
- O tamanho do prefixo da empresa depende de configuração. Um GTIN de outro fornecedor pode ter outro tamanho; a tabela de tamanhos da GS1 fica para depois.
- Etiquetas NFC (HF, lidas pelo celular) e portais fixos (LLRP) ficam fora desta decisão.

## Alternativas consideradas

- **EPC proprietário (id interno no EPC)** — exige consultar a API para saber o produto e não conversa com etiquetas já gravadas pelos fornecedores.
- **Rastrear cada unidade desde já** — custo alto no domínio e no volume de dados, sem um cliente que precise disso agora.
- **SDK de um fabricante direto no app** — prende o app a um hardware; a porta permite trocar o fabricante e testar sem aparelho.
- **Série gerada no app** — dois aparelhos podem gerar o mesmo EPC; a sequência do banco evita isso.
