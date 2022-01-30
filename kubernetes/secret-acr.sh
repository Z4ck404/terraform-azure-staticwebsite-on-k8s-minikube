#!/bin/bash
# This script requires Azure CLI version 2.25.0 or later. Check version with `az --version`.

ACR_NAME=elbaziblog
SERVICE_PRINCIPAL_NAME=acr-service-principal

ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query "id" --output tsv)

PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --query "password" --output tsv)
USER_NAME=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query "[].appId" --output tsv)


#echo '{"docker-username":$USER_NAME, "docker-password":$PASSWORD}'| jq .

jq --arg key0 'docker_username' \
   --arg value0 "$USER_NAME" \
   --arg key1 'docker_password' \
   --arg value1 "$PASSWORD" \
   '. | .[$key0]=$value0 | .[$key1]=$value1' \
   <<<'{}'