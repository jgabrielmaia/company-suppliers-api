#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["CompanySupplier.WebApi.csproj", ""]
RUN dotnet restore "./CompanySupplier.WebApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "CompanySupplier.WebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CompanySupplier.WebApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CompanySupplier.WebApi.dll"]