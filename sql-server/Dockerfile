FROM mcr.microsoft.com/mssql/server:2017-GA-ubuntu AS final 

LABEL author="kam lagan" \
      email="github@lagan.me"

ENV ACCEPT_EULA='' \
    SA_PASSWORD='' \
    DB_USERNAME='' \
    DB_PASSWORD='' \
    DB_NAME='' \
    MSSQL_PID= \
    STARTUP_DELAY=10s

COPY entrypoint.sh /
COPY initialise.sh /
COPY dotnet-install.sh /

RUN chmod +x /entrypoint.sh /initialise.sh /dotnet-install.sh

WORKDIR /

CMD [ "/bin/sh", "entrypoint.sh" ]
