FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

COPY . /build

WORKDIR /build

ARG NUGET_UID
ARG NUGET_PWD

RUN sed -i -e "s/\${NUGET_UID}/$NUGET_UID/" -e "s/\${NUGET_PWD}/$NUGET_PWD/" nuget.config

RUN find . -name "appsettings.*.json" -type f -delete

RUN dotnet restore --configfile nuget.config CoreDb/CoreDb.csproj \
&& dotnet build --configuration Release --no-restore CoreDb/CoreDb.csproj \
# && dotnet test --configuration Release --logger "console;verbosity=detailed" --logger trx \ # TODO:: specification test / authorisation
&& dotnet publish --configuration Release --no-build CoreDb/CoreDb.csproj

FROM mcr.microsoft.com/mssql/server:2017-GA-ubuntu AS final 

COPY --from=build /build/CoreDb/bin/Release/netcoreapp3.1/publish/ /app

LABEL author="kam lagan" \
      email="github@lagan.me"

WORKDIR /app

ENV ConnectionStrings__Database='' \
    DbupProfile__Name=''\
    ACCEPT_EULA='' \
    SA_PASSWORD='' \
    DB_USERNAME='' \
    DB_PASSWORD='' \
    DB_NAME='' \
    STARTUP_DELAY=10s

COPY entrypoint.sh /
COPY initialise.sh /
COPY dotnet-install.sh /

RUN chmod +x /entrypoint.sh /initialise.sh /dotnet-install.sh

WORKDIR /

CMD [ "/bin/sh", "entrypoint.sh" ]
