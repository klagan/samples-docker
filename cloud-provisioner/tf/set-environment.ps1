# this is an example
# these values should be injected through a different method: environment variables, innjected arguments, pull from vault etc
# storing them here means they will be committed to the repository
$servicePrincipalName="<get from AAD>"
$servicePrincipalPassword="<password>"
$subscriptionName="<subscription name>"
$storageAccountResourceGroupName="<resource group name>"
$storageAccountName="<storage account name>"
$storageContainerName="<storage container name>"
$certificateFilePath="<full path to service principal certificate>"

if (Test-Path -Path $certificateFilePath) {
    # service principal application id
    $env:ARM_CLIENT_ID=$(az ad sp show --id "$servicePrincipalName" --output tsv --query "{appId:appId}")
    # service principal certificate path
    $env:ARM_CLIENT_CERTIFICATE_PATH=$certificateFilePath
    # service principal password - (if required)
    $env:ARM_CLIENT_CERTIFICATE_PASSWORD=$servicePrincipalPassword
    # subscription identifier
    $env:ARM_SUBSCRIPTION_ID=$(az account subscription list --query "[?displayName=='$subscriptionName'].{subscriptionId:subscriptionId}" --output tsv)
    # tenant identifier
    $env:ARM_TENANT_ID=$(az account list --query "[?name=='$subscriptionName'].{tenantId:tenantId}" --output tsv)
    # storage account access key (used for remote backend)
    $env:ARM_ACCESS_KEY=$(az storage account keys list --resource-group $storageAccountResourceGroupName --account-name $storageAccountName --query "[?keyName=='key1'].{value:value}" --output tsv)
    # backend path to state file
    $env:BACKEND_STATE_FILE="kaml/example.tfstate"
    # backend storage account name
    $env:BACKEND_STORAGE_ACCOUNT_NAME=$storageAccountName
    # backend container name 
    $env:BACKEND_CONTAINER_NAME=$storageContainerName

    Get-ChildItem -Path Env: | Where-Object -Property Name -like 'ARM*'
    Get-ChildItem -Path Env: | Where-Object -Property Name -like 'BACKEND*'

    Write-Information "az login --service-principal -u $env:ARM_CLIENT_ID -p $env:ARM_CLIENT_CERTIFICATE_PATH -t $env:ARM_TENANT_ID"
} else {
    Write-Error "Certificate file path: $certificateFilePath not found"
}