# Stowise — app de campo (Flutter)

App do operador: movimentação de estoque, consulta de saldo e leitura de código de barras. Arquitetura em [ADR-0008](../docs/adr/0008-arquitetura-do-app.md).

## Rodar

```bash
flutter pub get
flutter run --flavor dev -t lib/main_dev.dart
```

O flavor `dev` usa a API local em `http://10.0.2.2:5073` (o computador, visto do emulador Android). Para outra URL:

```bash
flutter run --flavor dev -t lib/main_dev.dart --dart-define=STOWISE_API_URL=http://192.168.0.10:5073
```

APK de demonstração:

```bash
flutter build apk --flavor prod -t lib/main_prod.dart --dart-define=STOWISE_API_URL=https://sua-api
```

## APK de demonstração no CI

O workflow `mobile` gera o APK `prod` (um por arquitetura) a cada push na `main` e o publica como artefato `stowise-apk` (30 dias). A URL da API vem da variável do repositório `STOWISE_API_URL`. Instale o `stowise-<commit>-arm64-v8a.apk` na maioria dos celulares atuais.

## Verificar

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Goldens: `flutter test --update-goldens` regrava as imagens em `test/goldens` depois de uma mudança visual intencional.

## Estrutura

- `lib/app`: app, tema (cor da marca e `CoresStowise`) e rotas (go_router).
- `lib/core`: configuração do ambiente e serviços comuns.
- `lib/features/<area>/{data,domain,presentation}`: cada funcionalidade em camadas.
