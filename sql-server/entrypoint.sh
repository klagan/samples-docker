 # calling two commands like this makes them run in parallel
 # the beginning of initialise.sh is a wait command, to give sql server enough time to start up before the script continues to use the database
 # this is all works on timing
 
 /initialise.sh & /opt/mssql/bin/sqlservr
