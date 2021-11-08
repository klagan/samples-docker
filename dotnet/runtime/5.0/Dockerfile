#==========================================================================================================================
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
RUN groupadd -r basic && useradd --no-log-init -r -g basic apprunner
USER apprunner

ENV ASPNETCORE_URLS=http://+:5000 \
DOTNET_USE_POLLING_FILE_WATCHER=true \
ASPNETCORE_ENVIRONMENT=Development 

EXPOSE 5001
EXPOSE 5000
#==========================================================================================================================
FROM ghcr.io/klagan/dotnet/sdk:5.0 AS builder
ARG DOTNET_SOLUTION
ARG BUILD_OUTPUT="/build"
RUN  sudo mkdir -p /output

COPY [".", "/mysource"]
RUN if [ -f "$DOTNET_SOLUTION" ]; then sudo dotnet restore "$DOTNET_SOLUTION"; else echo "Solution not found" ; fi

COPY [".", "/mysource"]
RUN if [ -f "$DOTNET_SOLUTION" ]; then sudo dotnet build --configuration Release --output "$BUILD_OUTPUT" "$DOTNET_SOLUTION"; else echo "Solution not found" ; fi
#==========================================================================================================================
FROM builder AS publisher
ARG DOTNET_SOLUTION
ARG PUBLISH_OUTPUT="/output"
RUN  sudo mkdir -p /output
WORKDIR /mysource

RUN if [ -f "$DOTNET_SOLUTION" ]; then sudo dotnet publish --configuration Release --output "$PUBLISH_OUTPUT" "$DOTNET_SOLUTION"; else echo "Solution not found" ; fi
#==========================================================================================================================
FROM base AS final
COPY --chown=apprunner:basic --from=PUBLISHER /output /app

ENTRYPOINT ["dotnet", "/app/Samples.WebApi.dll"]
#==========================================================================================================================

# 20211108 - have not created the base docker images reference above yet, so this is theoretical for now