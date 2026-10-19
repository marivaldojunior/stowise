# Stowise — Inventário e armazenagem com IA

Oct 10, 2026 · @Marivaldo

## Visão geral

Stowise é um sistema de inventário e armazenagem com app Flutter, dashboard React e API .NET 10, em que a IA sugere e uma pessoa sempre confirma. O nome junta *stow* (armazenar) e *wise* (inteligente).

| Parte | Responsabilidade |
| --- | --- |
| Flutter (app de campo) | Contagem offline-first, leitura de código de barras on-device, conferência de recebimento, confirmação de endereço, cadastro de produto por foto; plugin Kotlin para coletores Zebra/Honeywell |
| .NET 10 (API) | Catálogo, estoque, recebimento, importação, motor de armazenagem, patrimônio, camada de IA isolada e plugável |
| React + TypeScript (gestão) | Revisão de importações, divergências, aprovação de ajustes, mapa de ocupação, configuração de regras, conciliação do inventário patrimonial, gestão de usuários, consultas em linguagem natural |

Funcionalidades centrais:

- **Importação inteligente** de CSV, TXT (delimitado ou posicional), Excel e XML de NF-e: a IA mapeia colunas e casa itens com o catálogo; a importação em si é determinística, com staging e revisão.
- **Armazenagem inteligente**: motor de pontuação com regras configuráveis (capacidade, zona, curva ABC, FEFO, consolidação) e explicação de cada sugestão. Sem LLM na decisão.
- **Contagem assistida por câmera**, com nível de confiança e aprovação antes de ajustar o saldo.
- **Cadastro por foto** no app: a IA sugere descrição, categoria e atributos; o operador revisa antes de gravar.
- **Busca semântica de produtos**: busca híbrida (texto + embeddings no pgvector), sem banco vetorial separado.
- **Perguntas sobre documentos** (extensão, Marco 6): RAG sobre manuais, notas e laudos de lote, com citação da fonte.
- **Inventário patrimonial** (extensão, Marco 5): conferência de bens por plaqueta, local, responsável e estado de conservação, com conciliação aprovada por uma pessoa.

Banco: **PostgreSQL**, com `jsonb` para o staging e **pgvector** para busca de produtos e bens similares.

## Como usar com o Claude Code

Exporte este documento em Markdown e salve na raiz do repositório como `docs/SPEC.md`. Crie um `CLAUDE.md` curto que aponte para ele e traga as regras abaixo.

**Estrutura do repositório**

```
stowise/
├── api/          # .NET 10
├── web/          # React + TypeScript (Vite)
├── mobile/       # Flutter + plugin Kotlin
├── docs/
│   ├── SPEC.md   # este documento
│   └── adr/      # um arquivo por decisão
├── infra/        # scripts de infraestrutura (init do Postgres)
└── docker-compose.yml
```

**Regras para o agente**

- Trabalhar uma tarefa do plano por vez, na ordem dos marcos, e marcar a tarefa ao concluir
- Toda tarefa entra com testes; regra de negócio sem teste não é considerada concluída
- Nunca alterar Saldo diretamente: toda mudança de estoque passa pelo serviço de movimentação
- IA só sugere: nenhum fluxo grava resultado de IA sem confirmação humana
- IA só pela API: a chave do provedor fica no servidor; Flutter e React nunca chamam o provedor ([ADR-0004](adr/0004-camada-de-ia.md))
- Decisão de arquitetura nova vira um ADR em `docs/adr/`
- Nomes de domínio em português (Produto, Endereco, Movimentacao); código e infraestrutura em inglês
- Commits no padrão Conventional Commits, um por tarefa

**Fluxo sugerido por tarefa**

1. Pedir ao Claude Code um plano curto da tarefa antes de codar
2. Implementar com testes
3. Rodar build, testes e lint localmente
4. Abrir PR com descrição e checklist

## Modelo de dados

&#91;embedded content: modelo de dados · 6 módulos\]

Importação, Recebimento e Inventário nunca alteram o saldo diretamente: tudo vira Movimentacao no Estoque, que referencia os cadastros de Catálogo e Estrutura física.

O Patrimônio (módulo 7) é separado do estoque: bens patrimoniais não têm Saldo e têm um livro-razão próprio, a MovimentacaoPatrimonial ([ADR-0003](adr/0003-patrimonio-modulo-separado.md)).

### 1. Catálogo

Peso, dimensões e GTIN ficam na embalagem, não no produto: uma caixa e um palete do mesmo SKU ocupam espaços diferentes.

| Entidade | Campos principais | Observações |
| --- | --- | --- |
| Produto | `Id`, `Sku` (único), `Descricao`, `Ncm`, `Cest`, `CategoriaId`, `UnidadeBase`, `ControlaLote`, `ControlaValidade`, `ClasseArmazenagem`, `ClasseAbc`, `StatusCadastro`, `Ativo`, `RowVersion` | `ClasseArmazenagem`: Normal, Refrigerado, Inflamável, Frágil. `ClasseAbc` recalculada por job. `StatusCadastro`: Incompleto ou Ativo |
| ProdutoEmbalagem | `Id`, `ProdutoId`, `Tipo`, `Gtin` (único), `FatorConversao`, `PesoKg`, `AlturaCm`, `LarguraCm`, `ComprimentoCm` | `Tipo`: UN, CX, PALETE. Fator em relação à unidade base |
| Categoria | `Id`, `Nome`, `ParentId` | Hierarquia |
| ProdutoEmbedding | `ProdutoId`, `Vetor`, `Modelo`, `GeradoEm` | Tabela separada para regenerar ao trocar de modelo |
| Fornecedor | `Id`, `Cnpj` (único), `RazaoSocial`, `NomeFantasia` |  |
| ProdutoFornecedor | `Id`, `FornecedorId`, `CodigoFornecedor`, `ProdutoId`, `EmbalagemId`, `UnidadeFornecedor`, `FatorConversao`, `ConfirmadoPor`, `ConfirmadoEm` | De-para. Único por fornecedor + código do fornecedor (`cProd` da NF-e) |

Produtos criados a partir de uma NF-e entram como **Incompleto**, porque a nota não traz peso nem dimensões por item. Eles vão para uma fila de "completar cadastro" no React, ou têm as medidas capturadas no recebimento pelo app.

### 2. Estrutura física

| Entidade | Campos principais | Observações |
| --- | --- | --- |
| Armazem | `Id`, `Codigo`, `Nome` |  |
| Zona | `Id`, `ArmazemId`, `Codigo`, `ClasseArmazenagem` | Define onde cada classe de produto pode ficar |
| Endereco | `Id`, `ZonaId`, `Codigo`, `Rua`, `Modulo`, `Nivel`, `Posicao`, `CapacidadePesoKg`, `AlturaCm`, `LarguraCm`, `ProfundidadeCm`, `DistanciaExpedicao`, `Status`, `MotivoBloqueio` | `Codigo` no formato A-03-02-1. `Status`: Livre, Ocupado, Bloqueado. `DistanciaExpedicao` alimenta a regra de curva ABC |

### 3. Estoque

A Movimentacao é o livro-razão: nunca é editada nem apagada. O Saldo é uma projeção atualizada na mesma transação, o que dá auditoria completa e permite reconstruir o estoque em qualquer data.

| Entidade | Campos principais | Observações |
| --- | --- | --- |
| Lote | `Id`, `ProdutoId`, `Numero`, `Fabricacao`, `Validade` | Preenchido também pelo grupo `rastro` da NF-e |
| Movimentacao | `Id`, `Tipo`, `ProdutoId`, `LoteId`, `EnderecoOrigemId`, `EnderecoDestinoId`, `Quantidade`, `DocumentoReferencia`, `UsuarioId`, `DispositivoId`, `OcorridoEm`, `RecebidoEm`, `IdempotencyKey` (única) | `Tipo`: Entrada, Saída, Transferência, Ajuste. `OcorridoEm` é a hora do celular; `RecebidoEm`, a do servidor |
| Saldo | `EnderecoId`, `ProdutoId`, `LoteId`, `Quantidade`, `QuantidadeReservada`, `RowVersion` | Único por endereço + produto + lote. Concorrência otimista |

A `IdempotencyKey` garante que uma sincronização offline repetida não duplique movimento.

### 4. Recebimento, NF-e e armazenagem

| Entidade | Campos principais | Observações |
| --- | --- | --- |
| Recebimento | `Id`, `FornecedorId`, `ChaveAcesso` (única), `Numero`, `Serie`, `DataEmissao`, `XmlOriginalUrl`, `Status`, `DataChegada` | A chave única impede importar a mesma nota duas vezes. O XML original fica guardado para auditoria |
| RecebimentoItem | `Id`, `RecebimentoId`, `NumeroItem`, `ProdutoId`, `ProdutoFornecedorId`, `EmbalagemId`, `LoteId`, `Quantidade`, `CodigoFornecedor`, `DescricaoNota`, `UnidadeNota`, `QuantidadeNota`, `Cfop`, `ValorUnitario` | Guarda o que veio na nota separado do que foi convertido, para conferir divergências |
| TarefaArmazenagem | `Id`, `RecebimentoItemId`, `Quantidade`, `EnderecoSugeridoId`, `EnderecoConfirmadoId`, `Status`, `MotivoDivergencia`, `PontuacaoJson`, `RegrasVersao`, `CriadoEm`, `ConcluidoEm` | `PontuacaoJson` é o snapshot da nota de cada regra, para explicar a sugestão mesmo após mudar os pesos |
| RegraArmazenagem | `Id`, `Codigo`, `Peso`, `Ativa`, `ParametrosJson` | `Codigo` é a chave da estratégia no código |

**Campos da NF-e e seu destino:**

| Campo do XML | Uso no modelo |
| --- | --- |
| `chNFe` | `Recebimento.ChaveAcesso` |
| `emit/CNPJ`, `xNome` | Fornecedor |
| `det/prod/cProd` | `ProdutoFornecedor.CodigoFornecedor` |
| `cEAN` / `cEANTrib` | GTIN da embalagem (pode vir "SEM GTIN") |
| `xProd`, `NCM`, `CEST` | Criar ou casar o produto |
| `uCom`/`qCom` × `uTrib`/`qTrib` | Inferir `FatorConversao` (ex.: 10 CX = 120 UN → fator 12) |
| `rastro` (`nLote`, `dFab`, `dVal`) | Lote |

**Casamento de itens da nota**, nesta ordem: de-para existente → GTIN → similaridade de descrição (pgvector). O usuário confirma os itens novos ou duvidosos, e o vínculo é salvo para as próximas notas daquele fornecedor.

**Fluxo:** XML → valida XSD e chave → identifica fornecedor → casa itens → revisão → cria Recebimento → conferência física no app → sugestão de endereço.

### 5. Importação

A IA entende o arquivo (recebe só o cabeçalho e cerca de 10 linhas de amostra); quem importa é código determinístico. Para NF-e, o layout é fixo e não há mapeamento por IA.

| Entidade | Campos principais | Observações |
| --- | --- | --- |
| TemplateImportacao | `Id`, `Nome`, `Fingerprint`, `Formato`, `Encoding`, `Delimitador`, `SeparadorDecimal`, `MapeamentoJson`, `SugeridoPorIa`, `ConfirmadoPor`, `VezesUsado` | `Fingerprint`: hash do cabeçalho normalizado; arquivo reconhecido dispensa a IA. `Formato`: Delimitado, Posicional, Excel |
| Importacao | `Id`, `Tipo`, `Formato`, `NomeArquivo`, `HashArquivo`, `TemplateId`, `Status`, `TotalLinhas`, `LinhasValidas`, `LinhasComErro`, `UsuarioId`, `IniciadoEm`, `ConcluidoEm` | `Tipo`: Produtos, NotaFiscal ou BensPatrimoniais. `Formato` inclui NFeXml. `HashArquivo` evita importar o mesmo arquivo duas vezes |
| ImportacaoLinha | `Id`, `ImportacaoId`, `NumeroLinha`, `DadosBrutos`, `DadosNormalizados`, `Status`, `Acao`, `ProdutoCorrespondenteId`, `Similaridade`, `Erros` | Staging em `jsonb`. `Status`: Válida, Erro, Possível duplicata, Ignorada. `Acao`: Criar, Atualizar, Ignorar. Na NF-e, cada `det` vira uma linha |

Estados da Importacao:

`Recebido → Mapeando → AguardandoConfirmacao → Validando → AguardandoRevisao → Efetivando → Concluido` (ou `Falhou`)

### 6. Inventário e IA

Uma contagem aprovada gera uma Movimentacao do tipo Ajuste; a IA nunca mexe no saldo diretamente.

| Entidade | Campos principais | Observações |
| --- | --- | --- |
| Inventario | `Id`, `Tipo`, `ZonaId`, `Status`, `AbertoEm`, `FechadoEm` | `Tipo`: Geral ou Rotativo |
| Contagem | `Id`, `InventarioId`, `EnderecoId`, `ProdutoId`, `LoteId`, `QuantidadeContada`, `QuantidadeSistema`, `Origem`, `ConfiancaIa`, `ImagemUrl`, `Status`, `UsuarioId`, `IdempotencyKey` | `QuantidadeSistema` é snapshot. `Origem`: Manual, Código de barras, Câmera. `Status`: Pendente, Aprovada, Rejeitada |
| ChamadaIa | `Id`, `Funcionalidade`, `UsuarioId`, `Provedor`, `Modelo`, `PromptVersao`, `TokensEntrada`, `TokensSaida`, `CustoEstimado`, `LatenciaMs`, `Tentativas`, `UsouFallback`, `Sucesso`, `Erro`, `CorrelacaoId` | `Funcionalidade`: Mapeamento, Casamento de itens, Câmera, Cadastro por foto, Consulta, Embeddings, Documentos, Leitura de plaqueta, Estado de conservação, Casamento de bens. Base para controle de custo, cota por usuário e comparação de prompts |
| CotaIa | `Id`, `Perfil`, `UsuarioId`, `Funcionalidade`, `LimiteChamadasDia`, `LimiteTokensMes` | Cota por perfil, com exceção opcional por usuário. Acima do limite, a API recusa a chamada (HTTP 429) e o fluxo segue sem IA |

### 7. Patrimônio

Bens patrimoniais (computadores, móveis, equipamentos, veículos) são itens únicos identificados por plaqueta: não têm quantidade, lote nem Saldo. Ficam em um módulo próprio, com hierarquia de locais e livro-razão separados do estoque ([ADR-0003](adr/0003-patrimonio-modulo-separado.md)). Depreciação, integração contábil e termo de responsabilidade estão fora do escopo; o sistema exporta os dados para quem faz essa gestão.

**Cadastros e movimentação**

| Entidade | Campos principais | Observações |
| --- | --- | --- |
| LocalPatrimonial | `Id`, `Codigo`, `Nome`, `Tipo`, `ParentId`, `Ativo` | Hierarquia: Unidade → Prédio → Andar → Sala. Independente de Armazém/Zona/Endereço |
| CategoriaPatrimonial | `Id`, `Nome`, `ParentId` | Hierarquia própria, separada da Categoria de produtos |
| Responsavel | `Id`, `Nome`, `Matricula` (única), `Email`, `UsuarioId`, `Ativo` | Pessoa que responde pelo bem; não precisa ter login (`UsuarioId` opcional) |
| BemPatrimonial | `Id`, `NumeroPatrimonio` (único), `Descricao`, `CategoriaId`, `NumeroSerie`, `Marca`, `Modelo`, `DataAquisicao`, `ValorAquisicao`, `DocumentoAquisicao`, `CentroCusto`, `LocalId`, `ResponsavelId`, `EstadoConservacao`, `Situacao`, `ImagemUrl`, `RowVersion` | `LocalId`, `ResponsavelId`, `EstadoConservacao` e `Situacao` são projeção do livro-razão e nunca são editados diretamente. `EstadoConservacao`: Novo, Bom, Regular, Ruim, Inservível. `Situacao`: Ativo, Em manutenção, Emprestado, Não localizado, Baixado |
| MovimentacaoPatrimonial | `Id`, `BemId`, `Tipo`, `LocalOrigemId`, `LocalDestinoId`, `ResponsavelOrigemId`, `ResponsavelDestinoId`, `EstadoAnterior`, `EstadoNovo`, `SituacaoAnterior`, `SituacaoNova`, `Motivo`, `DocumentoReferencia`, `InventarioPatrimonialId`, `UsuarioId`, `DispositivoId`, `OcorridoEm`, `RecebidoEm`, `IdempotencyKey` (única) | `Tipo`: Incorporação, Transferência, Mudança de estado, Mudança de situação, Baixa. Nunca é editada nem apagada |
| BemEmbedding | `BemId`, `Vetor`, `Modelo`, `GeradoEm` | Busca de bens similares por descrição para casar sobras sem plaqueta |

A **Baixa** exige `Motivo` (Extravio, Furto, Inservível, Doação, Venda, Outro) e aprovação de um Gestor; um bem baixado não volta a ser movimentado.

**Inventário patrimonial**

| Entidade | Campos principais | Observações |
| --- | --- | --- |
| InventarioPatrimonial | `Id`, `Descricao`, `Status`, `CriadoPor`, `AbertoEm`, `FechadoEm` | `Status`: Planejado → EmAndamento → EmConciliacao → Concluido (ou Cancelado) |
| InventarioPatrimonialLocal | `InventarioId`, `LocalId` | Escopo: os locais selecionados incluem os descendentes na hierarquia |
| InventarioPatrimonialInventariante | `InventarioId`, `UsuarioId` | Só inventariantes registram conferências |
| InventarioPatrimonialBem | `Id`, `InventarioId`, `BemId`, `LocalEsperadoId`, `ResponsavelEsperadoId`, `EstadoEsperado`, `Resultado`, `Decisao`, `DecididoPor`, `DecididoEm`, `MovimentacaoId` | Snapshot dos bens esperados na abertura. `Resultado`: Conforme, Local divergente, Estado divergente, Não localizado. `Decisao`: Aceitar, Corrigir cadastro, Manter, Abrir apuração |
| ConferenciaPatrimonial | `Id`, `InventarioId`, `PlaquetaLida`, `BemId`, `LocalEncontradoId`, `EstadoEncontrado`, `Observacao`, `Origem`, `ImagemUrl`, `ConfiancaIa`, `UsuarioId`, `DispositivoId`, `OcorridoEm`, `IdempotencyKey` (única) | `Origem`: Código de barras/QR, Manual, Câmera (OCR). `BemId` vazio indica sobra (bem sem cadastro) |

Regras do inventário patrimonial:

- Na **abertura**, o sistema grava o snapshot dos bens ativos do escopo. Enquanto o inventário estiver EmAndamento ou EmConciliacao, esses bens **não podem ser movimentados** fora da conciliação: a tentativa retorna conflito.
- **Leituras repetidas** do mesmo bem prevalecem pela mais recente; leituras em locais diferentes no mesmo inventário são sinalizadas na conciliação.
- No **encerramento da contagem**, bens do snapshot sem conferência viram Não localizado e as sobras são listadas à parte.
- Na **conciliação**, cada divergência é decidida por uma pessoa. Aceitar uma divergência de local ou estado gera a MovimentacaoPatrimonial correspondente; Não localizado vira Situacao Não localizado e abre apuração, **nunca baixa automática**; uma sobra pode ser incorporada (novo bem) ou casada com um bem existente.
- O **relatório de conciliação** (PDF e CSV) é gerado no fechamento e fica guardado com o inventário.

**IA no patrimônio** (sempre como sugestão, registrada em ChamadaIa):

- Leitura de plaqueta danificada ou ilegível por OCR na foto
- Sugestão de estado de conservação a partir da foto, com confiança
- Casamento de sobra com bens cadastrados por descrição e foto (pgvector)

### 8. Documentos (RAG)

Perguntas em linguagem natural sobre manuais, notas fiscais e laudos de lote. A resposta sempre cita a fonte (documento e página) e diz quando não encontrou a informação. Usa o mesmo pgvector do catálogo, sem banco vetorial separado.

| Entidade | Campos principais | Observações |
| --- | --- | --- |
| Documento | `Id`, `Titulo`, `Tipo`, `ArquivoUrl`, `HashArquivo`, `ProdutoId`, `LoteId`, `FornecedorId`, `RecebimentoId`, `PerfisPermitidos`, `Status`, `EnviadoPor`, `EnviadoEm` | `Tipo`: Manual, Nota fiscal, Laudo, Ficha técnica, Outro. `Status`: Recebido, Processando, Indexado, Falhou. O XML de NF-e já guardado no Recebimento entra como documento |
| DocumentoTrecho | `Id`, `DocumentoId`, `Ordem`, `Pagina`, `Texto`, `Vetor`, `Modelo`, `BuscaTexto` | `BuscaTexto` é `tsvector` para a busca híbrida. Trechos são regenerados ao trocar de modelo |

Regras: o usuário só recebe trechos de documentos permitidos ao seu perfil, e a resposta sem trecho de apoio é "não encontrei", nunca uma resposta inventada.

## Decisões de arquitetura (ADRs)

1. **Livro-razão + saldo projetado**, em vez de um campo de quantidade editável
2. **Quantidades sempre na unidade base** (`decimal(18,4)`); embalagens e unidades do fornecedor apenas convertem
3. **Idempotência em tudo que vem do celular**, por causa do modo offline
4. **Concorrência otimista** no Saldo (`xmin` do Postgres via EF Core)
5. **Relacional no núcleo, `jsonb` no staging**: rigidez onde o dado é confiável, flexibilidade onde ainda não é
6. **Snapshot das decisões automáticas** (pontuação de armazenagem, confiança da IA) para manter tudo explicável
7. **IA só sugere**: mapeamento, casamento de itens e contagem sempre passam por confirmação humana; decisões de armazenagem são algorítmicas
8. **Aprendizado por confirmação**: templates de importação e de-para de fornecedor reduzem chamadas de IA a cada uso
9. **Patrimônio separado do estoque**, com hierarquia de locais e livro-razão próprios ([ADR-0003](adr/0003-patrimonio-modulo-separado.md))
10. **Camada de IA atrás da API**: chave só no servidor, saída estruturada e validada, timeout, retry e fallback, cota por usuário ([ADR-0004](adr/0004-camada-de-ia.md))
11. **Autenticação com ASP.NET Core Identity e JWT próprio**, com refresh token rotativo e detecção de reuso ([ADR-0005](adr/0005-autenticacao.md))
12. **Idempotência e concorrência no estoque**: chave do cliente única no livro-razão e `xmin` no Saldo e no Endereco, com nova tentativa ([ADR-0006](adr/0006-idempotencia-e-concorrencia.md))
13. **Jobs em background com Hangfire** no mesmo PostgreSQL: fila durável, nova tentativa só para falha transitória e jobs idempotentes ([ADR-0007](adr/0007-jobs-em-background.md))

## Plano de tarefas

O plano é dividido em **marcos**. Cada marco é uma fatia vertical (API, Web e App) que termina com uma entrega demonstrável: deploy de demonstração atualizado, README atualizado e uma versão marcada com tag.

| Marco | Objetivo | O que a demonstração mostra | Versão |
| --- | --- | --- | --- |
| 0 | Fundação do repositório | CI por pasta e ambiente local com Docker | — |
| 1 | MVP: catálogo, endereços, estoque e importação com IA | Importar uma planilha com mapeamento sugerido pela IA, movimentar estoque pelo app e ver o saldo no painel | v0.1.0 |
| 2 | NF-e, recebimento e armazenagem inteligente | XML de NF-e → conferência no app → sugestão de endereço com explicação | v0.2.0 |
| 3 | Inventário e modo offline | Contagem offline, inclusive por câmera, sincronização e aprovação do ajuste | v0.3.0 |
| 4 | IA avançada | Cadastro por foto, busca semântica, chat de consulta e painel de custo da IA | v1.0.0 |
| 5 | Patrimônio (extensão) | Importação de bens → inventário patrimonial → conciliação | v1.1.0 |
| 6 | Perguntas sobre documentos (extensão) | Pergunta sobre um manual ou lote, com citação da fonte | v1.2.0 |

Regras de ordem:

- Os marcos seguem a ordem da tabela. Um marco só começa depois da entrega do marco anterior.
- Dentro de cada marco, a ordem é API, Web, App e Entrega; dentro de cada bloco, as tarefas seguem a ordem de dependência.
- A IA entra depois que o fluxo sem IA já funciona.

### Marco 0 — Fundação do repositório

- [x] Criar o monorepo com as pastas `api/`, `web/`, `mobile/` e `docs/adr/`
- [x] `docker-compose` com PostgreSQL + pgvector e a API
- [x] GitHub Actions separados por pasta (filtro de caminho), com build, testes e lint
- [x] README inicial, `CLAUDE.md`, `docs/SPEC.md` e ADR-001 (livro-razão + saldo projetado)
- [x] Convenção de commits e template de PR

### Marco 1 — MVP: catálogo, endereços, estoque e importação com IA

**1.1 API — Fundação**

- [x] Solução em camadas (Domain, Application, Infrastructure, Api) ou vertical slices
- [x] EF Core + Npgsql + pgvector, migrations e seed com um armazém de exemplo
- [x] ADR de autenticação (ASP.NET Core Identity × Keycloak)
- [x] Autenticação JWT com refresh token rotativo e perfis (Admin, Gestor, Operador)
- [x] Endpoints de gestão de usuários e perfis (Admin), usados pela tela do painel
- [x] Erros em ProblemDetails, logs estruturados (Serilog), OpenTelemetry (traces, métricas e logs) e health checks
- [x] OpenAPI com Scalar e versionamento de rotas
- [x] Contrato OpenAPI versionado no repositório e verificado no CI (o build falha se o contrato mudar sem atualização)
- [x] Projetos de teste: unidade e integração com Testcontainers

**1.2 API — Catálogo e estrutura física**

- [x] CRUD de Produto, ProdutoEmbalagem e Categoria
- [x] CRUD de Armazém, Zona e Endereço
- [x] Geração de endereços em lote (rua × módulo × nível × posição)
- [x] Bloqueio e desbloqueio de endereço com motivo

**1.3 API — Estoque**

- [x] Serviço de movimentação: grava Movimentacao e atualiza Saldo na mesma transação
- [x] Idempotência por `IdempotencyKey` e concorrência otimista (`xmin`)
- [x] Transferência entre endereços e reservas
- [x] Consultas: saldo por produto, endereço e lote; extrato; saldo em uma data

**1.4 API — Importação de produtos com IA**

- [x] Upload com detecção de encoding, delimitador, separador decimal e layout posicional
- [x] Leitura de Excel (`.xlsx`), com a mesma detecção de cabeçalho e colunas do texto
- [x] Fingerprint do cabeçalho e templates de importação
- [x] Staging, validações determinísticas (GTIN, NCM, unidades) e máquina de estados
- [x] ADR de jobs em background (fila durável, retry e agendamento)
- [x] Processamento em background (Hangfire): staging fora da requisição, com status e progresso consultáveis por endpoint e por SignalR e gravação em lote (COPY)
- [x] Efetivação em background: gravação no catálogo em lote (bulk insert), idempotente, e relatório final
- [x] Camada de IA plugável (Microsoft.Extensions.AI) com registro em ChamadaIa, conforme o ADR-0004
- [x] Resiliência da IA: timeout, retry com backoff e fallback de provedor; sem IA disponível, o fluxo segue manual (provedores em lista ordenada, com fábricas por tipo: Anthropic, OpenAI compatível, Gemini e Ollama)
- [x] Saídas estruturadas: JSON Schema por funcionalidade, validação e rejeição de resposta inválida
- [x] Cota de IA por perfil e por usuário (CotaIa), com HTTP 429 acima do limite
- [x] Sugestão de mapeamento de colunas e de regras de normalização (data, decimal, unidade) por IA, a partir do cabeçalho + amostra; a aplicação das regras é determinística (regras de data ficam para quando houver campo de data na importação)

**1.5 Web — Fundação, cadastros, estoque e importação**

- [x] Vite + TypeScript, React Router e TanStack Query
- [x] Cliente da API gerado a partir do OpenAPI (orval)
- [x] Biblioteca de componentes (shadcn/ui ou MUI), tema e layout base
- [x] Login, renovação de token e rotas protegidas por perfil
- [x] Gestão de usuários e perfis (Admin)
- [x] Testes: Vitest + Testing Library, MSW para mocks e Playwright para e2e
- [x] Catálogo: lista com filtros, formulário de produto e embalagens
- [x] Endereços: cadastro, geração em lote e mapa de ocupação (heatmap)
- [x] Saldos e extrato de movimentações
- [x] Upload de arquivo e revisão do mapeamento sugerido
- [x] Prévia com erros linha a linha e progresso em tempo real

**1.6 App — Fundação, movimentação e consulta**

- [ ] Projeto com flavors (dev/prod), arquitetura em camadas, Riverpod ou Bloc e go\_router
- [ ] Cliente da API gerado a partir do contrato OpenAPI (openapi-generator, dart-dio)
- [ ] Autenticação e armazenamento seguro de tokens
- [ ] Testes de unidade, widget, golden e integração
- [ ] Leitura de código de barras on-device (ML Kit)
- [ ] Movimentação online: entrada, saída e transferência, com leitura do código do produto e do endereço
- [ ] Consulta de saldo por produto e por endereço
- [ ] APK de demonstração gerado pelo CI como artefato

**1.7 Entrega**

- [ ] Deploy de demonstração da API e da Web, com dados de exemplo e usuário de teste
- [ ] README com diagrama de arquitetura, como rodar localmente, links para os ADRs e badges de CI
- [ ] Seção "Decisões técnicas" no README, com os trade-offs de cada ADR em uma linha
- [ ] GIF curto de cada cliente (Web e App) no README
- [ ] Tag `v0.1.0` com notas de release
- [ ] Repositório fixado no perfil do GitHub

### Marco 2 — NF-e, recebimento e armazenagem inteligente

**2.1 API — Fornecedores e cadastros incompletos**

- [ ] CRUD de Fornecedor e do de-para ProdutoFornecedor
- [ ] `StatusCadastro` e endpoint da fila de cadastros incompletos

**2.2 API — NF-e**

- [ ] Parser do XML 4.00 com validação de XSD e dígito da chave de acesso
- [ ] Job de embeddings de produtos e busca de similares
- [ ] Casamento de itens: de-para, depois GTIN, depois similaridade
- [ ] Inferência do fator de conversão (`uCom`/`uTrib`) e do lote (`rastro`)
- [ ] Efetivação: cria produtos, de-para, Recebimento e itens

**2.3 API — Recebimento e armazenagem**

- [ ] Fluxo de status do recebimento e conferência
- [ ] Motor de pontuação: interface de regra e regras de capacidade, zona, curva ABC, FEFO e consolidação
- [ ] Geração de TarefaArmazenagem com snapshot da pontuação; confirmação e divergência
- [ ] Job de recálculo da curva ABC

**2.4 Web — NF-e e operação**

- [ ] Fila de cadastros incompletos
- [ ] Upload de NF-e e revisão do casamento de itens com as sugestões
- [ ] Recebimentos e acompanhamento das tarefas de armazenagem
- [ ] Tela de divergências de armazenagem
- [ ] Configuração dos pesos das regras de armazenagem

**2.5 App — Recebimento e armazenagem**

- [ ] Plugin Kotlin para coletores Zebra (DataWedge) via platform channel
- [ ] Conferência de recebimento: bipagem, quantidade, lote, validade e captura de medidas
- [ ] Armazenagem: recebe a sugestão, bipa o endereço e registra divergência com motivo

**2.6 Entrega**

- [ ] Deploy de demonstração atualizado com notas fiscais de exemplo
- [ ] GIF do fluxo NF-e → recebimento → armazenagem no README
- [ ] Tag `v0.2.0` com notas de release

### Marco 3 — Inventário e modo offline

**3.1 API — Inventário**

- [ ] Abertura e fechamento de inventário; registro de contagens
- [ ] Aprovação e rejeição de contagem, gerando Ajuste
- [ ] Endpoint de sincronização offline (lote de operações idempotentes)
- [ ] Contagem por imagem: IA sugere item e quantidade com confiança

**3.2 Web — Inventário**

- [ ] Tela de divergências de inventário
- [ ] Aprovação de contagens com foto e nível de confiança

**3.3 App — Inventário e offline**

- [ ] Banco local (Drift) e fila de sincronização com `IdempotencyKey`
- [ ] Contagem de inventário manual e por código de barras
- [ ] Contagem por câmera, com confirmação da sugestão da IA
- [ ] Sincronização em background, indicador de modo offline e tratamento de conflitos
- [ ] Pipeline de release (Codemagic ou Fastlane) e publicação em teste aberto

**3.4 Entrega**

- [ ] Vídeo ou GIF de 2 minutos com o fluxo completo: NF-e → recebimento → armazenagem → contagem
- [ ] Tag `v0.3.0` com notas de release

### Marco 4 — IA avançada

**4.1 API**

- [ ] Busca semântica de produtos: busca híbrida (texto + vetor) com filtros
- [ ] Cadastro por foto: IA sugere descrição, categoria, marca, GTIN e atributos; o produto só é criado após confirmação e entra como Incompleto se faltar medida
- [ ] Consulta em linguagem natural com tool calling sobre endpoints somente leitura
- [ ] Conjunto de avaliação (arquivos e imagens de teste) rodando no CI
- [ ] Cache de respostas e relatório de custo por funcionalidade e por usuário

**4.2 Web**

- [ ] Busca semântica no catálogo
- [ ] Chat de consulta em linguagem natural
- [ ] Painel de uso de IA: chamadas, custo e latência por funcionalidade e por usuário

**4.3 App**

- [ ] Cadastro de produto por foto, com revisão da sugestão da IA antes de gravar
- [ ] Busca semântica de produto na consulta de saldo

**4.4 Entrega**

- [ ] README revisado: diagrama, decisões técnicas e GIFs atualizados
- [ ] Tag `v1.0.0` com notas de release

### Marco 5 — Patrimônio (extensão)

Reaproveita a sincronização offline, a leitura de código de barras, a importação com staging e a camada de IA dos marcos anteriores.

**5.1 API — Cadastros e movimentação patrimonial**

- [ ] Módulo `Patrimonio` em Domain e Application, conforme o ADR-0003
- [ ] CRUD de LocalPatrimonial (hierarquia), CategoriaPatrimonial e Responsavel
- [ ] CRUD de BemPatrimonial sem edição direta de local, responsável, estado e situação
- [ ] Serviço de movimentação patrimonial: incorporação, transferência, mudança de estado e de situação, com idempotência e concorrência otimista
- [ ] Baixa com motivo e aprovação de Gestor
- [ ] Consultas: bens por local (com descendentes) e por responsável, histórico do bem e posição em uma data
- [ ] Importação de bens (`Tipo` BensPatrimoniais) reaproveitando staging, templates e mapeamento por IA

**5.2 API — Inventário patrimonial**

- [ ] Planejamento: escopo de locais, inventariantes e transições de status
- [ ] Abertura com snapshot dos bens esperados e bloqueio de movimentação dos bens no escopo
- [ ] Registro de conferências, inclusive pelo endpoint de sincronização offline
- [ ] Encerramento da contagem: não localizados, sobras e leituras em locais diferentes
- [ ] Conciliação: decisões por bem, geração das movimentações patrimoniais e incorporação ou casamento de sobras
- [ ] Relatório de conciliação em PDF e CSV

**5.3 API — IA no patrimônio**

- [ ] Leitura de plaqueta por OCR na foto
- [ ] Sugestão de estado de conservação pela foto, com confiança
- [ ] Job de embeddings de bens e casamento de sobras por similaridade

**5.4 Web — Patrimônio**

- [ ] Árvore de locais, categorias e responsáveis
- [ ] Lista de bens com filtros e ficha do bem com histórico de movimentações
- [ ] Transferência, mudança de estado e baixa com aprovação
- [ ] Geração de números de patrimônio e impressão de plaquetas (PDF com código de barras/QR)
- [ ] Planejamento do inventário e acompanhamento em tempo real (percentual conferido por local)
- [ ] Tela de conciliação com fotos, sugestões da IA e decisão por bem; download do relatório

**5.5 App — Inventário patrimonial**

- [ ] Seleção do inventário e do local, bipagem de plaquetas pela câmera e pelo coletor
- [ ] Registro de estado de conservação, observação e foto por bem
- [ ] Registro de sobra (bem sem plaqueta ou sem cadastro) com foto e descrição
- [ ] OCR de plaqueta e sugestão de estado pela IA, com confirmação
- [ ] Funcionamento offline com a fila de sincronização existente

**5.6 Entrega**

- [ ] README e demonstração atualizados com o fluxo: importação de bens → inventário → conciliação
- [ ] Tag `v1.1.0` com notas de release

### Marco 6 — Perguntas sobre documentos (extensão)

Reaproveita a camada de IA, os jobs em background, o pgvector e o chat de consulta.

**6.1 API**

- [ ] ADR do pipeline de RAG (extração, tamanho dos trechos, busca híbrida e formato da citação)
- [ ] Upload de documentos com vínculo opcional a produto, lote, fornecedor ou recebimento, e perfis permitidos
- [ ] Job de ingestão: extração de texto (PDF e XML), divisão em trechos, embeddings e `tsvector`
- [ ] Busca híbrida de trechos com filtro por perfil
- [ ] Resposta com citação obrigatória (documento e página) e "não encontrei" quando não houver trecho de apoio
- [ ] Integração com o chat de consulta: a IA escolhe entre ferramentas de dados e busca em documentos
- [ ] Conjunto de avaliação de RAG (perguntas e fontes esperadas) rodando no CI

**6.2 Web**

- [ ] Biblioteca de documentos: upload, status da indexação e vínculos
- [ ] Respostas do chat com citações clicáveis, que abrem o documento na página citada

**6.3 App**

- [ ] Pergunta sobre um produto ou lote a partir da leitura do código de barras, com a citação da fonte

**6.4 Entrega**

- [ ] README e demonstração atualizados com o fluxo de perguntas sobre documentos
- [ ] Tag `v1.2.0` com notas de release
