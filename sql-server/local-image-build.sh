#!/bin/bash

# sample calls to pull values from azure keyvault (assuming access policies are correct)
# myvault='my-vault-name'
# mysecret=$(az keyvault secret show --vault-name ${myvault} --name mySecretName --output tsv --query {value:value})

imageName=local/db
imageTag=latest

docker build \
-t ${imageName}:${imageTag} \
--no-cache \
.

docker images --filter=reference=${imageName}:${imageTag}