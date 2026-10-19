# 0008 — App Flutter com Riverpod, go_router, flavors e cliente gerado do contrato

- **Status:** Aceito
- **Data:** 2026-10-19

## Contexto

O app de campo começa no Marco 1 com login, movimentação e consulta de saldo. Nos marcos seguintes, ele ganha recebimento, inventário offline e leitura em coletores Zebra. O app precisa de:

1. Estado previsível e fácil de testar, com dependências trocáveis nos testes (API, armazenamento seguro, leitor de código de barras).
2. Rotas com proteção por sessão e por perfil, e links diretos (ex.: abrir a conferência de um recebimento).
3. Dois ambientes no mesmo código: desenvolvimento (API local, HTTP) e demonstração (API publicada, HTTPS).
4. Os mesmos tipos da API que o painel usa, sem escrever modelos à mão.

## Decisão

- **Estado e injeção:** Riverpod 3. Cada dependência é um `Provider`; os testes trocam o provider (`overrides`), sem mocks globais.
- **Rotas:** go_router, com `redirect` pela sessão (rotas protegidas) e pelo perfil.
- **Camadas por funcionalidade:** `lib/features/<area>/{data,domain,presentation}` e `lib/core` (configuração, rede, armazenamento). A apresentação não chama a API direto: ela usa um repositório da camada `data`.
- **Flavors:** `dev` (sufixo `.dev`, HTTP liberado, API em `http://10.0.2.2:5073`) e `prod` (HTTPS, URL no build por `--dart-define=STOWISE_API_URL`). Cada flavor tem o seu ponto de entrada (`main_dev.dart`, `main_prod.dart`).
- **Cliente da API:** gerado pelo openapi-generator (`dart-dio`) a partir de `api/openapi/v1.json`, no pacote local `mobile/packages/stowise_api`. O CI regera o cliente e falha se ele não bater com o contrato, como o orval no painel.
- **Tema:** Material 3 com a cor da marca do painel e cores semânticas (`CoresStowise`) com o mesmo sentido do web.

## Consequências

- Os testes de widget montam o app inteiro com providers trocados; os goldens rodam com densidade 1 e tolerância de 0,5% (CI em Linux, desenvolvimento em Windows).
- Mudança de endpoint exige regravar o contrato, regerar o cliente web (orval) e o cliente do app.
- O cliente gerado usa `built_value`, que precisa de `build_runner`; o código gerado fica no repositório, para o app compilar sem gerar nada.
- O APK de demonstração é assinado com a chave de debug: serve para instalar e testar, não para publicar na loja.

## Alternativas consideradas

- **Bloc** — mais cerimônia (eventos e estados por tela) para o tamanho do app; o Riverpod cobre injeção e estado com menos código.
- **Modelos e chamadas escritos à mão** — divergem do contrato sem aviso; o cliente gerado quebra o build quando a API muda.
- **Um só ponto de entrada com `--dart-define` para tudo** — sem flavor, as duas versões não convivem no mesmo aparelho (mesmo `applicationId`) e o HTTP ficaria liberado também na demonstração.
