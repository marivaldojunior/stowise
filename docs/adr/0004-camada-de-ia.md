# 0004 — Camada de IA atrás da API

- **Status:** Aceito
- **Data:** 2026-10-17

## Contexto

O Stowise usa IA em vários fluxos:

- Mapeamento de colunas na importação
- Casamento de itens de NF-e
- Contagem e cadastro por foto
- Busca semântica
- Consulta em linguagem natural
- RAG sobre documentos
- OCR de plaquetas no patrimônio

Os clientes são um app Flutter e um painel React. Sem uma regra comum, cada fluxo trataria de forma diferente a chave do provedor, o formato da resposta, as falhas e o custo. O [ADR-0001](0001-livro-razao-saldo-projetado.md) e a regra "IA só sugere" já impedem que a IA altere dados sozinha. Este ADR define como a IA é chamada.

## Decisão

1. **Só a API chama o provedor de IA.** A chave fica no servidor, em variável de ambiente ou cofre de segredos. Flutter e React chamam endpoints da API e nunca recebem a chave.
2. **Abstração única** com `Microsoft.Extensions.AI` (`IChatClient` e `IEmbeddingGenerator`) na Infrastructure. Application conhece só as portas por funcionalidade (por exemplo, `ISugestaoMapeamento`), nunca o provedor.
3. **Saída estruturada e validada.**
   - Cada funcionalidade tem um JSON Schema versionado junto do prompt (`PromptVersao`).
   - A resposta é desserializada e validada contra o schema.
   - Uma resposta inválida conta como falha: a API não a corrige "no melhor esforço".
4. **Resiliência.**
   - Cada chamada tem timeout próprio por funcionalidade.
   - Erros transitórios recebem retry com backoff exponencial e jitter.
   - Um provedor ou modelo secundário serve de fallback.
   - Se tudo falhar, a API devolve "sem sugestão", e o fluxo segue manual: nenhum fluxo depende da IA para funcionar.
5. **Custo sob controle.**
   - Toda chamada é registrada em `ChamadaIa`, com funcionalidade, usuário, modelo, tokens, custo estimado, latência, tentativas e uso de fallback.
   - A `CotaIa` limita o uso por perfil e por usuário. Acima do limite, a API responde HTTP 429.
6. **Entrada mínima.** A IA recebe só o necessário: na importação, o cabeçalho e uma amostra de cerca de 10 linhas, e não o arquivo inteiro. A normalização dos dados é aplicada por código determinístico a partir das regras sugeridas e confirmadas.
7. **IA só sugere** (reforço do ADR 7 do SPEC): toda saída de IA passa por confirmação humana antes de gravar dados de negócio.

## Consequências

- Trocar de provedor ou de modelo não afeta Domain, Application nem os clientes.
- O custo por funcionalidade e por usuário fica visível desde a primeira funcionalidade com IA.
- Os testes usam um `IChatClient` falso, com respostas gravadas. O conjunto de avaliação roda contra o provedor real em um job separado do CI.
- Fluxos com IA ficam um pouco mais lentos e mais complexos, por causa da validação, das tentativas e do registro.
- Os clientes precisam tratar "sem sugestão" e HTTP 429 como casos normais, e não como erro.

## Alternativas consideradas

- **Clientes chamam o provedor direto:** expõe a chave no app e no navegador e impede o controle de cota e de custo.
- **Resposta em texto livre, interpretada por expressão regular:** é frágil, difícil de testar e falha em silêncio quando o modelo muda o formato.
- **A IA normaliza todas as linhas do arquivo:** o custo cresce com o tamanho do arquivo, o resultado não é reprodutível e um erro de interpretação chega aos dados sem rastreio.
- **SDK de um único provedor sem abstração:** é mais simples no início, mas prende o projeto a um fornecedor e dificulta o fallback.
