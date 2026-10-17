# 0005 — Autenticação com ASP.NET Core Identity e JWT próprio

- **Status:** Aceito
- **Data:** 2026-10-17

## Contexto

A API atende dois clientes: o painel React e o app Flutter, que também funciona offline. Os dois precisam de:

- Login com e-mail e senha
- Perfis de acesso: Admin, Gestor e Operador
- Sessões longas no app de campo, sem pedir login a cada turno
- Revogação de sessão, por exemplo quando um coletor é perdido

O SPEC deixava duas opções em aberto: ASP.NET Core Identity ou Keycloak. O projeto também precisa de um deploy de demonstração barato desde o Marco 1.

## Decisão

1. **ASP.NET Core Identity** guarda os usuários e os perfis no mesmo PostgreSQL, nas tabelas `usuarios`, `perfis` e relacionadas. Ele faz o hash de senha, o bloqueio após tentativas erradas e a política de senha. Os três perfis são dados de referência, criados pela migration.
2. **A própria API emite os tokens.** Não há servidor de identidade separado.
   - **Access token:** JWT assinado (HS256), com validade de 15 minutos. Leva `sub`, `email`, `name` e `role`.
   - **Refresh token:** valor aleatório e opaco, com 256 bits e validade de 14 dias. O banco guarda só o hash SHA-256.
3. **Rotação com detecção de reuso.**
   - Cada refresh consome o token atual e emite um novo da mesma família.
   - O consumo é atômico: um `UPDATE ... WHERE consumed_at IS NULL` decide qual de duas chamadas simultâneas ganha.
   - Se um token já consumido ou revogado for usado de novo, a API revoga a família inteira, e o usuário precisa entrar de novo.
   - O logout revoga a família da sessão.
4. **Como cada cliente transporta o refresh token:**
   - O app Flutter recebe o refresh token no corpo da resposta e o guarda no armazenamento seguro do aparelho.
   - O painel React pede `useCookie: true` e recebe o refresh token em cookie `HttpOnly`, `Secure`, `SameSite=Strict` e restrito a `/api/v1/auth`. O access token fica só em memória.
5. **Seguro por padrão.** A política de fallback exige um usuário autenticado em todo endpoint. Só o login, o refresh, o health check e o OpenAPI usam `AllowAnonymous`.
6. **Primeiro administrador.** As configurações `AdminBootstrap:Email` e `AdminBootstrap:Password` criam um Admin quando nenhum existe. Em Development, os valores ficam no `appsettings.Development.json`. Em produção, eles vêm de variáveis de ambiente.

## Consequências

- Não há um contêiner a mais no `docker-compose` nem no deploy de demonstração.
- Os testes de integração cobrem o fluxo completo de autenticação contra o PostgreSQL real (Testcontainers).
- A chave de assinatura é simétrica e precisa ficar fora do repositório em produção. Para trocar a chave sem derrubar sessões, a validação precisa aceitar mais de uma chave. Isso fica para quando for necessário.
- Login social, SSO corporativo (OIDC/SAML) e MFA não estão no escopo. Se forem necessários, o caminho é migrar para um provedor OIDC (Keycloak ou Entra ID). Os clientes já usam JWT com `Bearer`, então a troca afeta só a emissão.

## Alternativas consideradas

- **Keycloak:** traz SSO, MFA e um console de administração prontos, e passa uma imagem mais "enterprise". Mas adiciona um serviço com banco próprio, configuração de realm e um deploy de demonstração mais caro. Também tira do código a parte de autenticação, que é justamente o que o portfólio quer mostrar.
- **Endpoints prontos do Identity (`MapIdentityApi`):** emitem tokens proprietários, não JWT, e não permitem controlar a rotação, a família de tokens nem o transporte por cookie.
- **Refresh token sem rotação:** é mais simples, mas um token vazado vale por 14 dias sem que ninguém perceba.
