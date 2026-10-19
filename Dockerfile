# syntax=docker/dockerfile:1

# Imagem de demonstração: o painel React (web/) servido pela própria API (.NET), numa só origem.
# O docker compose usa api/Dockerfile (só a API); esta imagem é a do deploy (docs/deploy.md).

# 1. Painel: build estático do Vite (web/dist).
FROM node:24-alpine AS web
WORKDIR /web
COPY web/package.json web/package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY web/ ./
RUN npm run build

# 2. API: mesmo processo do api/Dockerfile (restore travado pelos packages.lock.json).
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS api
WORKDIR /src
COPY api/.editorconfig api/global.json api/Directory.Build.props api/Directory.Packages.props api/Stowise.slnx ./
COPY api/src/Stowise.Domain/*.csproj api/src/Stowise.Domain/packages.lock.json src/Stowise.Domain/
COPY api/src/Stowise.Application/*.csproj api/src/Stowise.Application/packages.lock.json src/Stowise.Application/
COPY api/src/Stowise.Infrastructure/*.csproj api/src/Stowise.Infrastructure/packages.lock.json src/Stowise.Infrastructure/
COPY api/src/Stowise.Api/*.csproj api/src/Stowise.Api/packages.lock.json src/Stowise.Api/
RUN dotnet restore src/Stowise.Api/Stowise.Api.csproj --locked-mode
COPY api/src/ src/
RUN dotnet publish src/Stowise.Api/Stowise.Api.csproj -c Release -o /app --no-restore

# 3. Execução: a API com o painel em wwwroot (PainelWeb serve os arquivos e o index.html das rotas do painel).
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
COPY --from=api /app .
COPY --from=web /web/dist ./wwwroot
USER $APP_UID
ENTRYPOINT ["dotnet", "Stowise.Api.dll"]
