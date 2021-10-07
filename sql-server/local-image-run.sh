docker run \
--rm \
--name local-sqlsvr \
-e ACCEPT_EULA=Y \
-e MSSQL_PID=Developer \
-e SA_PASSWORD=i4m@4dmin \
-e DB_USERNAME=sa \
-e DB_PASSWORD=i4m@4dmin \
-e DB_NAME=testdb \
-p 1433:1433 \
local/db:latest

docker ps --filter=reference='local/*:*'