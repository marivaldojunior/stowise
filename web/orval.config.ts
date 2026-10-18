import { defineConfig } from 'orval'

/**
 * Cliente da API gerado a partir do contrato versionado (api/openapi/v1.json). Regere com `npm run api:gerar`
 * depois de mudar o contrato; o CI falha se o código gerado ficar diferente do contrato.
 */
export default defineConfig({
  stowise: {
    input: {
      target: '../api/openapi/v1.json',
    },
    output: {
      mode: 'split',
      target: 'src/api/gerado/stowise.ts',
      schemas: 'src/api/gerado/modelos',
      client: 'react-query',
      httpClient: 'fetch',
      clean: true,
      override: {
        mutator: {
          path: 'src/api/mutator.ts',
          name: 'apiFetch',
        },
        // Os erros viram HttpError no mutator: as funções devolvem só o corpo da resposta de sucesso.
        fetch: {
          includeHttpResponseReturnType: false,
        },
        query: {
          signal: true,
        },
      },
    },
  },
})
