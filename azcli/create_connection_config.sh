#!/bin/bash
# START HERE!
# creates a service principal with certificate (.pem)
# backs up certificate to key vault
# creates associated environment (.env) file
# displays sample (working) docker-compose file for new service principal

if [[ $# -lt 3 ]]; then
    echo -e "\nIncorrect arguments provided"
    echo -e "\nusage: \t${0}\n\t{identifying name}\n\t{subscription id}\n\t{vault name to store certificate}"
    echo -e "\neg: \t${0} myrandomname xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx myvaultname\n"
    exit 1
fi

certName=$1
subscriptionId=$2
vaultName=$3
certFileName=$(echo $certName | tr -d ' ').pem
certPfxFileName=$(echo $certName | tr -d ' ').pfx

if [ -f "$certFileName" ]; then
    echo "$certFileName already exists"
    exit 1
fi

# create a service principal called "certName" and local certifcate in correct format (read documentation)
sp=$(az ad sp create-for-rbac --name $certName --create-cert --scopes="/subscriptions/$subscriptionId" -o json)

# upload the local certificate into the remote vault with the name "certName"
tempCertFileName=$(echo $sp | jq -r ".fileWithCertAndPrivateKey")
az keyvault certificate import \
--vault-name $vaultName \
-n $certName \
-f $tempCertFileName &> /dev/null

# example of how to login manually
# echo az login --service-principal --username $(echo $sp | jq -r ".appId") --tenant $(echo $sp | jq -r ".tenant") --password $(echo $sp | jq -r ".fileWithCertAndPrivateKey")

# download the certificate from the remote vault to a new name - this tests the certificate was uploaded
az keyvault secret download \
--name $certName \
--vault-name $vaultName \
--file $certFileName &> /dev/null

# create .pfx file so we can login to terraform with certificates
if [ ! -f "$certPfxFileName" ]; then
    openssl pkcs12 -export -out $certPfxFileName -inkey $certFileName -in $certFileName -passout pass:
fi


# delete temporary certificate
rm $tempCertFileName

# display guidance messages
spId=$(echo $sp | jq -r ".appId")
tenantId=$(echo $sp | jq -r ".tenant")


cat << EOF > $certName.env
K_spId=$spId
K_tenantId=$tenantId
K_certFileName=$certFileName
K_certPfxFileName=$certPfxFileName
K_subscriptionId=$subscriptionId
EOF

echo "Sample docker-compose.yml:"
cat << EOF
version: '3.2'

services:
  $certName:
    build:
      context: .
    image: local/azcli
    container_name: $certName
    volumes:
       - type: bind
         source: .
         target: /var/tmp
    environment:
      - TERM=xterm
      - K_az=$certName
    stdin_open: true 
    tty: true        
EOF
