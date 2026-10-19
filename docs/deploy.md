# Deploy da demonstração (Neon + Render)

A demonstração pública roda numa só imagem ([`Dockerfile`](../Dockerfile) da raiz): a API .NET serve também o painel React, na mesma origem. O banco é o PostgreSQL do [Neon](https://neon.tech), com pgvector. A configuração do Render está em [`render.yaml`](../render.yaml).

| Parte | Serviço | Plano |
| --- | --- | --- |
| Banco (PostgreSQL 17 + pgvector) | Neon | Gratuito: suspende sem uso e acorda na primeira consulta |
| API + painel (container) | Render (web service) | Gratuito: dorme depois de 15 minutos sem acesso; a primeira visita seguinte demora cerca de 30 segundos |

## 1. Banco no Neon

1. Crie uma conta no Neon e um projeto chamado `stowise`, com PostgreSQL 17, na região **AWS US East 2 (Ohio)**.
2. Abra **Connection Details** e desligue a opção **Connection pooling**. As migrations e o Hangfire precisam da conexão direta (o host sem `-pooler`).
3. Copie os dados da conexão e monte a string no formato do Npgsql (não use a URI `postgresql://`):

   ```text
   Host=ep-xxxx.us-east-2.aws.neon.tech;Database=neondb;Username=neondb_owner;Password=SENHA;SSL Mode=Require;Timeout=30
   ```

   O `Timeout=30` cobre o tempo para o Neon acordar. A extensão `vector` é criada pela primeira migration.

## 2. Serviço no Render

1. Crie uma conta no Render e conecte a sua conta do GitHub.
2. Clique em **New → Blueprint** e escolha o repositório `stowise`. O Render lê o `render.yaml`.
3. Preencha as variáveis marcadas como secretas:

   | Variável | Valor |
   | --- | --- |
   | `ConnectionStrings__Stowise` | A string do passo 1.3 |
   | `AdminBootstrap__Email` | O seu e-mail de Admin (fica privado) |
   | `AdminBootstrap__Password` | Uma senha forte e só sua (a API exige 8+ caracteres, com maiúscula, minúscula e número) |
   | `Demonstracao__Senha` | A senha pública das contas de demonstração (vai no README; mesma regra de senha) |
   | `ANTHROPIC_API_KEY` | Deixe vazio para a IA desligada |

   `Jwt__SigningKey` é gerada pelo próprio Render. Não copie nenhuma dessas variáveis para o repositório.
4. Clique em **Apply**. O primeiro build demora alguns minutos (painel + API).
5. Abra a URL do serviço (ex.: `https://stowise.onrender.com`). Na primeira subida, a API aplica as migrations, cria o Admin, as contas de demonstração e os dados de exemplo.

## 3. Conferir

1. `https://SUA-URL/health/ready` responde `Healthy` (API e banco).
2. Entre no painel com `gestor@demo.stowise.dev` e a senha de demonstração.
3. A referência da API fica em `https://SUA-URL/scalar`.

## 4. App (APK)

1. No GitHub, abra **Settings → Secrets and variables → Actions → Variables** e crie `STOWISE_API_URL` com a URL do Render.
2. O próximo push na `main` gera o APK apontando para a demonstração (artefato `stowise-apk` do workflow `mobile`).

## Contas da demonstração

| Conta | Perfil | Pode |
| --- | --- | --- |
| `gestor@demo.stowise.dev` | Gestor | Catálogo, endereços, estoque e importações |
| `operador@demo.stowise.dev` | Operador | Consultar e movimentar estoque |

As duas usam a senha de `Demonstracao__Senha` e não são bloqueadas por senha errada (qualquer visitante poderia bloqueá-las). O Admin fica fora da demonstração pública: com ele, um visitante poderia trocar senhas ou desativar contas.

## Ligar a IA

1. No Render, defina `ANTHROPIC_API_KEY` e mude `Ia__Habilitada` para `true`.
2. A cota por usuário (Gestor: 200 chamadas por dia) limita o custo. O fallback Ollama da configuração não existe no Render: sem a Anthropic, a sugestão falha e o mapeamento fica manual.

## Atualizar

O Render faz um novo deploy a cada push na `main`. Para voltar os dados de exemplo ao início, apague e recrie o banco no Neon (**Branches → Reset**) e reinicie o serviço no Render.
