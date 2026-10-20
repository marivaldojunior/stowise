# 0011 — Embeddings de produtos com um só modelo, e busca de similares com fallback por trigramas

- **Status:** Aceito
- **Data:** 2026-10-20

## Contexto

O casamento dos itens da NF-e (SPEC, 2.2) usa, nesta ordem, o de-para do fornecedor, o GTIN e a similaridade da descrição. A descrição da nota (`xProd`) raramente é igual à do catálogo ("REFRIG COLA 2L CX12" × "Refrigerante Cola 2L"). O SPEC prevê embeddings no pgvector (`ProdutoEmbedding`). Restrições:

1. A camada de IA (ADR-0004) tem fallback entre provedores. Embeddings de modelos diferentes não são comparáveis: um vetor do modelo A não pode ser buscado contra vetores do modelo B.
2. O provedor principal (Anthropic) não gera embeddings. OpenAI compatível, Gemini e Ollama geram, pelo `IEmbeddingGenerator` do `Microsoft.Extensions.AI`.
3. A IA vem desligada por padrão (`Ia:Habilitada=false`), inclusive na demonstração. Sem IA, o fluxo precisa continuar (ADR-0004).
4. O índice HNSW do pgvector exige um número fixo de dimensões.

## Decisão

- **Um modelo de embeddings, sem fallback entre modelos.** Seção própria `Ia:Embeddings` (tipo, modelo, endpoint, chave), com as mesmas fábricas por tipo dos provedores de chat. O vetor tem sempre **768 dimensões** (o modelo é configurado para isso: `nomic-embed-text` no Ollama; `text-embedding-3-small` e `gemini-embedding-001` aceitam o número de dimensões).
- **Tabela `produto_embeddings`** (`ProdutoId`, `Vetor vector(768)`, `Modelo`, `Texto`, `GeradoEm`), com índice HNSW por distância de cosseno. O texto é a descrição do produto (até 200 caracteres), guardado junto do vetor. Um vetor fica desatualizado quando a descrição ou o modelo mudam.
- **Job recorrente** (Hangfire, a cada 5 minutos, fila `ia`): gera em lotes os vetores que faltam ou estão desatualizados. Cada lote tem timeout e nova tentativa só para falha transitória, e grava um `ChamadaIa` (funcionalidade `Embeddings`, sem usuário: não conta na cota de ninguém).
- **Busca de similares** (`GET /produtos/similares?texto=`): com embeddings ligados e o texto da busca vetorizado, usa a distância de cosseno contra os vetores do modelo atual. Sem embeddings (IA desligada, falha do provedor ou produto ainda sem vetor), usa a **similaridade por trigramas** (`pg_trgm`) sobre a descrição. A resposta diz qual método foi usado e a pontuação de cada produto (0 a 1).
- **IA só sugere:** a busca devolve candidatos; o casamento e a confirmação são de outra tarefa e sempre passam por uma pessoa.

## Consequências

- Trocar o modelo de embeddings obriga a gerar todos os vetores de novo (o job faz isso sozinho, pelo campo `Modelo`). Durante a troca, os produtos sem vetor novo caem nos trigramas.
- A busca funciona sem IA e na demonstração, com qualidade menor (trigramas comparam letras, não sentido).
- Embeddings custam pouco, mas são uma chamada a um provedor externo por lote; o registro em `ChamadaIa` mostra o volume.
- A extensão `pg_trgm` entra no banco (existe na imagem `pgvector/pgvector` e no Neon).

## Alternativas consideradas

- **Fallback entre modelos de embeddings** — os vetores ficariam misturados e a busca, errada.
- **Coluna `vector` sem dimensão fixa** — aceita qualquer modelo, mas não permite o índice HNSW.
- **Só trigramas, sem embeddings** — simples e sem custo, mas não entende sinônimos e abreviações ("REFRIG" × "Refrigerante" ainda funciona; "água sem gás" × "mineral natural" não).
- **Gerar o vetor na hora do cadastro** — prende o cadastro à disponibilidade do provedor; o job recorrente desacopla.
