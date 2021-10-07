#!/bin/bash 
# https://docs.microsoft.com/en-us/azure/app-service/tutorial-custom-container?pivots=container-linux#access-diagnostic-logs

service ssh start

/usr/sbin/apache2ctl -D FOREGROUND