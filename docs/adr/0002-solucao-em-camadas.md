# 0002 — API .NET em camadas

- **Status:** Aceito
- **Data:** 2026-10-10

## Contexto

O SPEC deixa em aberto organizar a API em camadas ou em vertical slices. O domínio tem regras centrais compartilhadas por vários fluxos (movimentação de estoque, conversão de unidades, motor de armazenagem) e uma camada de IA que precisa ficar isolada e plugável.

## Decisão

Solução `api/Stowise.slnx` com quatro projetos e dependências em um único sentido:

```
Api ──► Application ──► Domain
 └────► Infrastructure ──► Application
```

- **Domain** — entidades, value objects e regras de negócio puras; não depende de nenhum outro projeto nem de EF Core.
- **Application** — casos de uso, interfaces de portas (repositórios, provedor de IA, armazenamento de arquivos) e validações; depende só de Domain.
- **Infrastructure** — EF Core/Npgsql/pgvector, implementação dos provedores de IA, jobs, armazenamento; implementa as portas de Application.
- **Api** — endpoints (minimal APIs), autenticação, OpenAPI, composição de dependências.

Dentro de Application, os casos de uso ficam agrupados por módulo do SPEC (Catalogo, Estrutura, Estoque, Recebimento, Importacao, Inventario), o que preserva a coesão de um vertical slice sem abrir mão da regra de dependência.

A regra de dependência é verificada por testes em `tests/Stowise.UnitTests/ArchitectureTests.cs`.

## Consequências

- Regras de domínio testáveis sem banco; a camada de IA troca de provedor sem tocar no domínio.
- Mais projetos e mais cerimônia para funcionalidades simples (CRUDs).
- Gerenciamento central de pacotes (`Directory.Packages.props`) e lock files mantêm as versões consistentes entre projetos.

## Alternativas consideradas

- **Vertical slices em um único projeto** — menos cerimônia, mas facilita vazar EF Core e IA para dentro das regras de estoque, que são o núcleo do sistema.
