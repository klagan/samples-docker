$ErrorActionPreference = "Continue"
# $DebugPreference = "Continue"
# $InformationPreference = "Continue"

# two environment variables: ARM_SUBSCRIPTION_ID and MY_VAULT_NAME must be populated manually.  
# These are used to pull the values from to keep the secrets on the host
# $env:ARM_SUBSCRIPTION_ID=''
# $env:MY_VAULT_NAME=''

$subscriptionId = $env:ARM_SUBSCRIPTION_ID
$certName = 'kamtest'
$vaultName = $env:MY_VAULT_NAME

$servicePrincipalName = 'http://{0}' -f $certName
$certFileName='{0}.pem' -f $certName
$certPfxFileName='{0}.pfx' -f $certName
$scope = '/subscriptions/{0}' -f $subscriptionId
# example of setting scope to resource group: ResourceGroup1
# $scope = '/subscriptions/{0}/resourceGroups/ResourceGroup1' -f $subscriptionId

Set-Item -Path Env:\SuppressAzurePowerShellBreakingChangeWarnings -Value $true
Set-Item -Path Env:\SuppressAzureRmModulesRetiringWarning -Value $true
[System.Environment]::SetEnvironmentVariable('SuppressAzurePowerShellBreakingChangeWarnings', 'true', [System.EnvironmentVariableTarget]::User)

# if output certificate exists, then bounce!
if (Test-Path $certFileName -PathType Leaf) {
    Write-Output "$certFileName already exists"
    Exit
}

# create service principal
$sp = az ad sp create-for-rbac --name $servicePrincipalName --create-cert  --role Contributor --scopes=$scope -o json | ConvertFrom-Json 
Write-Debug $sp

# import service principal certificate into key vault
$tempCertFileName=$sp.fileWithCertAndPrivateKey
az keyvault certificate import --vault-name $vaultName -n $certName -f $tempCertFileName | Out-Null

# download the certificate from the remote vault to a new name - this tests the certificate was uploaded
az keyvault secret download --name $certName --vault-name $vaultName --file $certFileName | Out-Null

# create .pfx file so we can login to terraform with certificates
if (-not(Test-Path $sp.fileWithCertAndPrivateKey  -PathType Leaf)) {
    openssl pkcs12 -export -out $certPfxFileName -inkey $certFileName -in $certFileName -passout pass:
}

# delete temporary certificate
rm $tempCertFileName

$out = "az login --service-principal -u {0} -p {1} -t {2}" -f $sp.appId, $certFileName, $sp.tenant

Write-Output $out