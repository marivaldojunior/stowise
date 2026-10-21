# Architecture Decision Records

Uma decisão por arquivo, numerada em sequência (`NNNN-titulo-curto.md`), a partir do [modelo](0000-modelo.md). Um ADR aceito não é reescrito: se a decisão mudar, crie outro que o substitua e atualize o status do antigo.

| # | Decisão | Status |
| --- | --- | --- |
| [0001](0001-livro-razao-saldo-projetado.md) | Livro-razão de movimentações + saldo projetado | Aceito |
| [0002](0002-solucao-em-camadas.md) | API .NET em camadas (Domain, Application, Infrastructure, Api) | Aceito |
| [0003](0003-patrimonio-modulo-separado.md) | Patrimônio como módulo separado do estoque, com livro-razão próprio | Aceito |
| [0004](0004-camada-de-ia.md) | Camada de IA atrás da API: chave no servidor, saída validada, resiliência e cota | Aceito |
| [0005](0005-autenticacao.md) | Autenticação com ASP.NET Core Identity, JWT próprio e refresh token rotativo | Aceito |
| [0006](0006-idempotencia-e-concorrencia.md) | Idempotência por chave do cliente e concorrência otimista (xmin) com nova tentativa | Aceito |
| [0007](0007-jobs-em-background.md) | Jobs em background com Hangfire e armazenamento no PostgreSQL | Aceito |
| [0008](0008-arquitetura-do-app.md) | App Flutter com Riverpod, go_router, flavors e cliente gerado do contrato | Aceito |
| [0009](0009-deploy-de-demonstracao.md) | Demonstração numa só imagem (API + painel) no Render, com o banco no Neon | Aceito |
| [0010](0010-etiquetas-rfid.md) | Etiquetas RFID em SGTIN-96 (GS1), contando unidades, com o leitor atrás de uma porta no app | Aceito |
| [0011](0011-embeddings-e-similares.md) | Embeddings dos produtos com um só modelo e busca de similares com fallback por trigramas | Aceito |
| [0012](0012-motor-de-armazenagem.md) | Motor de armazenagem por pontuação de regras, sem LLM, com restrições que não se desligam | Aceito |

Decisões já previstas no [SPEC](../SPEC.md#decisões-de-arquitetura-adrs), a registrar quando forem implementadas: quantidades na unidade base, relacional no núcleo e `jsonb` no staging, snapshot das decisões automáticas, IA só sugere, aprendizado por confirmação e pipeline de RAG.
