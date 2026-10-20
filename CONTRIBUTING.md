# Contribuindo

> **Licença:** o projeto usa a [PolyForm Strict 1.0.0](LICENSE). Ao enviar um PR, você concorda que o autor pode usar, modificar e licenciar a sua contribuição sob qualquer licença. Sugestões e relatos de bug por issue são bem-vindos.

## Fluxo por tarefa

1. Escolha a próxima tarefa aberta do plano em [`docs/SPEC.md`](docs/SPEC.md), respeitando a ordem dos marcos.
2. Crie um branch `<tipo>/<descricao-curta>` (ex.: `feat/servico-movimentacao`).
3. Escreva um plano curto, implemente **com testes** e rode build, testes e lint da pasta afetada.
4. Marque a tarefa como concluída no `SPEC.md` e abra o PR usando o template.

## Commits — Conventional Commits

Um commit por tarefa, no formato:

```
<tipo>(<escopo>): <resumo>
```

| Tipo | Uso |
| --- | --- |
| `feat` | Funcionalidade nova |
| `fix` | Correção de bug |
| `refactor` | Mudança interna sem alterar comportamento |
| `test` | Apenas testes |
| `docs` | Documentação e ADRs |
| `build` | Dependências, Docker, ferramentas de build |
| `ci` | GitHub Actions |
| `chore` | Manutenção geral |
| `perf` | Desempenho |

Escopos: `api`, `web`, `mobile`, `infra`, `docs`, `repo`.

Exemplos:

```
feat(api): grava movimentação e atualiza saldo na mesma transação
ci(web): adiciona job de testes e2e com Playwright
docs(adr): adr-003 idempotência nas operações do app
```

Para usar o modelo de mensagem local:

```bash
git config commit.template .gitmessage
```

## Comandos por pasta

| Pasta | Build | Testes | Lint |
| --- | --- | --- | --- |
| `api/` | `dotnet build` | `dotnet test` | `dotnet format --verify-no-changes` |
| `web/` | `npm run build` | `npm test` | `npm run lint` e `npm run typecheck` |
| `mobile/` | `flutter build apk --debug` | `flutter test` | `flutter analyze` e `dart format --set-exit-if-changed lib test` |
