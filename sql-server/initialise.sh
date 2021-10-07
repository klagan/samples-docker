echo "Waiting for database to startup (${STARTUP_DELAY} seconds)..."
sleep $STARTUP_DELAY

sql_result=$(/opt/mssql-tools/bin/sqlcmd -S . -U $DB_USERNAME -P $DB_PASSWORD -Q "select database_id, name from sys.databases where name = '${DB_NAME}';")
sql_result_code=$(echo $sql_result | grep -c "0 rows affected")

if [ ${sql_result_code} -eq 1 ]
then
    echo "No database found. Creating database ${DB_NAME}..."
    /opt/mssql-tools/bin/sqlcmd -S . -U $DB_USERNAME -P $DB_PASSWORD -Q "CREATE DATABASE ${DB_NAME};"
  
    # if you need to use dotnet, then run the installer
    # /dotnet-install.sh -c 3.1 --runtime aspnetcore
  
    # you can then call dotnet from this location: /root/.dotnet/dotnet
    # eg: /root/.dotnet/dotnet myapp.dll
    
    echo "Database ${DB_NAME} created."
fi