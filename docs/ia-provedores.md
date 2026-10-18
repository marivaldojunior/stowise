# Provedores de IA

A API chama a IA por uma camada única ([ADR-0004](adr/0004-camada-de-ia.md)), com `Microsoft.Extensions.AI`. As funcionalidades não conhecem o provedor. Trocar de modelo ou de provedor é só configuração, na seção `Ia` do `appsettings.json` ou por variáveis de ambiente.

> **Aviso:** nunca coloque chaves no `appsettings.json` versionado. Use variáveis de ambiente (`Ia__Provedores__0__ApiKey`), o arquivo `.env` (não versionado) ou um cofre de segredos. Uma chave no repositório fica exposta para sempre no histórico do Git.

## Tipos de provedor

| `Tipo` | Atende | Chave |
| --- | --- | --- |
| `Anthropic` | Claude, pelo SDK oficial | `ApiKey` ou `ANTHROPIC_API_KEY` |
| `OpenAICompativel` | OpenAI e toda API no formato da OpenAI: Azure OpenAI, DeepSeek, Qwen, Kimi, GLM, Groq, Together, OpenRouter | `ApiKey` ou `OPENAI_API_KEY` |
| `Gemini` | Gemini, pelo SDK oficial do Google | `ApiKey` ou `GOOGLE_API_KEY` |
| `Ollama` | Modelos abertos locais: Llama (Meta), Qwen, DeepSeek, Gemma (Google) e outros | Sem chave |

Um provedor fora desta lista precisa de uma classe nova que implemente `IFabricaProvedorIa`, em `api/src/Stowise.Infrastructure/Ia/FabricasProvedorIa.cs`, registrada no `DependencyInjection.cs`.

## Como a API escolhe o provedor

1. `Ia:Provedores` é uma lista em ordem de preferência. O primeiro é o principal; os seguintes são o fallback.
2. Cada tentativa tem o tempo máximo `TimeoutSegundos`.
3. Uma falha transitória (timeout, HTTP 408, 429 ou 5xx, erro de rede) tenta de novo no mesmo provedor, até `TentativasPorProvedor` vezes. A espera começa em `EsperaInicialMs` e dobra a cada tentativa, com variação aleatória.
4. Outra falha (chave inválida, modelo inexistente) passa direto para o próximo provedor.
5. Se todos falharem, a funcionalidade responde "sem sugestão" e o fluxo segue manual.
6. Cada pedido gera um registro em `ChamadaIa`, com o provedor que respondeu, as tentativas e se usou o fallback. Consulte em `GET /api/v1/ia/chamadas` (Admin).

`Ia:Funcionalidades:<Funcionalidade>` muda a lista, o tempo máximo ou as tentativas de uma funcionalidade. Os nomes válidos são os de `FuncionalidadeIa` (`Mapeamento`, `Consulta`, `Embeddings` e outros).

## Exemplos

Os nomes de modelo e os endereços mudam com o tempo. Confira na documentação de cada provedor antes de usar, e preencha os preços para o custo estimado sair certo.

### Claude como principal e Ollama como reserva (padrão do projeto)

```json
"Ia": {
  "Habilitada": true,
  "Provedores": [
    { "Nome": "anthropic", "Tipo": "Anthropic", "Modelo": "claude-opus-5-5", "PrecoEntradaPorMilhao": 4.00, "PrecoSaidaPorMilhao": 20.00 },
    { "Nome": "ollama-local", "Tipo": "Ollama", "Modelo": "llama3.2", "Endpoint": "http://localhost:11434" }
  ]
}
```

### Um modelo mais barato só para o mapeamento de colunas

Dois modelos do mesmo provedor são duas entradas com nomes diferentes.

```json
"Ia": {
  "Habilitada": true,
  "Provedores": [
    { "Nome": "opus", "Tipo": "Anthropic", "Modelo": "claude-opus-5-5", "PrecoEntradaPorMilhao": 4.00, "PrecoSaidaPorMilhao": 20.00 },
    { "Nome": "haiku", "Tipo": "Anthropic", "Modelo": "claude-haiku-5-5", "PrecoEntradaPorMilhao": 0.10, "PrecoSaidaPorMilhao": 0.50 },
    { "Nome": "ollama-local", "Tipo": "Ollama", "Modelo": "llama3.2" }
  ],
  "Funcionalidades": {
    "Mapeamento": { "Provedores": [ "haiku", "ollama-local" ], "TimeoutSegundos": 30 }
  }
}
```

### Outros provedores

| Provedor | Entrada |
| --- | --- |
| OpenAI | `{ "Nome": "openai", "Tipo": "OpenAICompativel", "Modelo": "<modelo>" }` |
| DeepSeek | `{ "Nome": "deepseek", "Tipo": "OpenAICompativel", "Modelo": "deepseek-chat", "Endpoint": "https://api.deepseek.com/v1" }` |
| Qwen (Alibaba Cloud) | `{ "Nome": "qwen", "Tipo": "OpenAICompativel", "Modelo": "<modelo>", "Endpoint": "https://dashscope-intl.aliyuncs.com/compatible-mode/v1" }` |
| Kimi (Moonshot) | `{ "Nome": "kimi", "Tipo": "OpenAICompativel", "Modelo": "<modelo>", "Endpoint": "https://api.moonshot.ai/v1" }` |
| GLM (Zhipu) | `{ "Nome": "glm", "Tipo": "OpenAICompativel", "Modelo": "<modelo>", "Endpoint": "https://open.bigmodel.cn/api/paas/v4" }` |
| Llama (Meta) na Groq | `{ "Nome": "groq-llama", "Tipo": "OpenAICompativel", "Modelo": "<modelo>", "Endpoint": "https://api.groq.com/openai/v1" }` |
| Gemini | `{ "Nome": "gemini", "Tipo": "Gemini", "Modelo": "<modelo>" }` |
| Modelo aberto local | `{ "Nome": "qwen-local", "Tipo": "Ollama", "Modelo": "qwen3" }` |

## Parâmetros próprios do provedor

`ParametrosAdicionais` repassa pares chave-valor em `ChatOptions.AdditionalProperties`. Cada adaptador decide o que aceita, então confira antes no SDK do provedor. As funcionalidades não dependem desses parâmetros.

## Saída estruturada

Cada funcionalidade tem um contrato (`ContratoSaidaIa<T>`): um JSON Schema versionado junto do prompt e o tipo C# que ela recebe. A API valida toda resposta contra o schema no próprio código (ADR-0004, item 3), então o resultado não depende do suporte de cada provedor.

- A resposta inteira tem de ser um JSON válido pelo schema. Texto antes ou depois, bloco de código em Markdown e campo a mais são recusados. A API não corrige a resposta.
- Uma resposta recusada conta como falha do provedor: a API passa para o próximo da lista e grava o motivo em `ChamadaIa.Erro`, com o prefixo `SaidaInvalida`. Os tokens da resposta recusada entram no custo.
- `ModoJson` diz como pedir JSON a cada provedor:

| `ModoJson` | O que a API envia | Use quando |
| --- | --- | --- |
| `JsonSchema` (padrão) | O schema na saída estruturada nativa do provedor | Anthropic, OpenAI, Gemini, Ollama |
| `Json` | Só "responda em JSON", com o schema numa mensagem de sistema | O provedor aceita modo JSON, mas não schema (alguns compatíveis com OpenAI) |
| `Prompt` | O schema só numa mensagem de sistema | O provedor não tem modo JSON |
