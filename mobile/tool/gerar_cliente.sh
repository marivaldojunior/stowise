#!/usr/bin/env bash
# Gera o cliente da API (pacote packages/stowise_api) a partir do contrato api/openapi/v1.json (ADR-0008).
# Uso (em mobile/): tool/gerar_cliente.sh
set -euo pipefail

VERSAO=7.14.0
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
CACHE="$RAIZ/.tool"
JAR="$CACHE/openapi-generator-cli-$VERSAO.jar"
URL="https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/$VERSAO/openapi-generator-cli-$VERSAO.jar"
DESTINO="$RAIZ/packages/stowise_api"

mkdir -p "$CACHE"
if [ ! -f "$JAR" ]; then
  echo "Baixando openapi-generator $VERSAO..."
  curl -fsSL "$URL" -o "$JAR.tmp"
  # Confere o arquivo com o SHA-1 publicado no Maven Central antes de usar.
  esperado="$(curl -fsSL "$URL.sha1" | cut -c1-40)"
  obtido="$(sha1sum "$JAR.tmp" | cut -c1-40)"
  if [ "$esperado" != "$obtido" ]; then
    echo "SHA-1 do jar não confere (esperado $esperado, obtido $obtido)." >&2
    rm -f "$JAR.tmp"
    exit 1
  fi
  mv "$JAR.tmp" "$JAR"
fi

rm -rf "$DESTINO"
java -jar "$JAR" generate \
  -i "$RAIZ/../api/openapi/v1.json" \
  -g dart-dio \
  -o "$DESTINO" \
  --global-property skipFormModel=false \
  --additional-properties=pubName=stowise_api,pubLibrary=stowise_api,pubDescription="Cliente da API do Stowise (gerado)",pubAuthor=Stowise,pubHomepage=,dateLibrary=core,serializationLibrary=built_value \
  > "$CACHE/geracao.log"

# Sem documentação nem testes de exemplo do gerador: só o código do cliente.
rm -rf "$DESTINO/doc" "$DESTINO/test" "$DESTINO/.travis.yml" "$DESTINO/git_push.sh" "$DESTINO/.openapi-generator-ignore"

cd "$DESTINO"
dart pub get > /dev/null
dart run build_runner build --delete-conflicting-outputs > "$CACHE/build_runner.log"
dart format --page-width 120 lib > /dev/null
echo "Cliente gerado em packages/stowise_api."
