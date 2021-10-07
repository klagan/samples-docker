#!/bin/bash


var=`date +"%FORMAT_STRING"`
now=`date +"%m_%d_%Y"`
now=`date +"%Y-%m-%d"`
filename_prefix=${now}


docker run --rm --volumes-from ghost -v $(pwd):/backup ghost:3-alpine tar cvf /backup/ghost_${filename_prefix}.tar /var/lib/ghost/content/

docker run --rm --volumes-from ghostdb -v $(pwd):/backup mysql:5.7 tar cvf /backup/mysql_${filename_prefix}.tar /var/lib/mysql/