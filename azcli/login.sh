#!/bin/bash

# load environment file
if [ -f /var/tmp/${K_az}.env ]
then
  export $(cat /var/tmp/$K_az.env | sed 's/#.*//g' | xargs)
fi

# prompt
export PS1="$K_certFileName >"

# https://stackoverflow.com/questions/36388465/how-to-set-bash-aliases-for-docker-containers-in-dockerfile
# shopt -s expand_aliases
# echo "alias loginaz='az login --service-principal --username ${K_spId} --tenant ${K_tenantId} --password ${K_certPath}'" >> ~/.bashrc
echo "az login --service-principal --username $K_spId --tenant $K_tenantId --password /var/tmp/${K_az}.pem" > /usr/bin/loginaz && \
    chmod +x /usr/bin/loginaz

loginaz 
accounts=$(az account list -o json)

# set up terraform variables
export ARM_SUBSCRIPTION_ID=$(echo $accounts | jq -r '.[] | .id')
export ARM_TENANT_ID=$(echo $accounts | jq -r '.[] | .tenantId')
export ARM_CLIENT_ID=$(echo $accounts | jq -r '.[] | .user.name')
export ARM_CLIENT_CERTIFICATE_PATH=/var/tmp/$K_az.pfx

/bin/bash
