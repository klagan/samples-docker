#!/bin/bash
# (old and unused) manual docker run. docker-compose is preferred
# assumes .pem certificate and .env files in pwd and named as service principal name
# eg: service principal name = my_sp
# expects: my_sp.env and my_sp.pem

if [[ $# -lt 1 ]]; then
    echo -e "\nIncorrect arguments provided"
    echo -e "\nusage: \t${0}\n\t{service principal name}"
    echo -e "\neg: \t${0} myrandomname \n"
    exit 1
fi

# docker build --tag local/azcli .
docker run -it --rm -v $(pwd):/var/tmp --env K_az=$1 local/azcli