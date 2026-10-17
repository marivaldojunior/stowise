# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY .editorconfig global.json Directory.Build.props Directory.Packages.props Stowise.slnx ./
COPY src/Stowise.Domain/*.csproj src/Stowise.Domain/packages.lock.json src/Stowise.Domain/
COPY src/Stowise.Application/*.csproj src/Stowise.Application/packages.lock.json src/Stowise.Application/
COPY src/Stowise.Infrastructure/*.csproj src/Stowise.Infrastructure/packages.lock.json src/Stowise.Infrastructure/
COPY src/Stowise.Api/*.csproj src/Stowise.Api/packages.lock.json src/Stowise.Api/
RUN dotnet restore src/Stowise.Api/Stowise.Api.csproj --locked-mode

COPY src/ src/
RUN dotnet publish src/Stowise.Api/Stowise.Api.csproj -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
COPY --from=build /app .
USER $APP_UID
ENTRYPOINT ["dotnet", "Stowise.Api.dll"]
