# Architecture Decision Records

Uma decisão por arquivo, numerada em sequência (`NNNN-titulo-curto.md`), a partir do [modelo](0000-modelo.md). Um ADR aceito não é reescrito: se a decisão mudar, crie outro que o substitua e atualize o status do antigo.

| # | Decisão | Status |
| --- | --- | --- |
| [0001](0001-livro-razao-saldo-projetado.md) | Livro-razão de movimentações + saldo projetado | Aceito |
| [0002](0002-solucao-em-camadas.md) | API .NET em camadas (Domain, Application, Infrastructure, Api) | Aceito |
| [0003](0003-patrimonio-modulo-separado.md) | Patrimônio como módulo separado do estoque, com livro-razão próprio | Aceito |
| [0004](0004-camada-de-ia.md) | Camada de IA atrás da API: chave no servidor, saída validada, resiliência e cota | Aceito |
| [0005](0005-autenticacao.md) | Autenticação com ASP.NET Core Identity, JWT próprio e refresh token rotativo | Aceito |

Decisões já previstas no [SPEC](../SPEC.md#decisões-de-arquitetura-adrs), a registrar quando forem implementadas: quantidades na unidade base, idempotência nas operações do app, concorrência otimista no Saldo, relacional no núcleo e `jsonb` no staging, snapshot das decisões automáticas, IA só sugere, aprendizado por confirmação, jobs em background e pipeline de RAG.
