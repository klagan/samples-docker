param( 
    [switch] 
    $Init,
    
    [parameter(ParameterSetName="init")]
    [switch] 
    $Plan,
    
    [parameter(ParameterSetName="init")]
    [switch] 
    $Apply,
    
    [parameter(ParameterSetName="destroy")]
    [switch] 
    $PlanDestroy, 
    
    [parameter(ParameterSetName="destroy")]
    [switch] 
    $Destroy
)


$terraformInstalled = $null -ne (which terraform)
$terraformInstalled ? (terraform version) : (Write-Host "Terraform not installed")
$planFolder="plans"
$createPlanFileName = "$planFolder/plan.tfplan"
$destroyPlanFileName = "$planFolder/destroy.tfplan"

function Show-Configuration {

    $config = New-Object System.Collections.Generic.List[PSObject]

    $switches = 'Init','Plan','Apply','PlanDestroy','Destroy'

    foreach ($switch in $switches) {
        $var=Get-Variable($switch)
        $config += New-Object PSObject –Property @{Action=($var.Value ? 'Yes' : 'No');Name=$var.Name}
    }

    $config | Format-Table Name, Action
}

function Init() {

    terraform init -migrate-state -backend-config storage_account_name=$env:BACKEND_STORAGE_ACCOUNT_NAME -backend-config container_name=$env:BACKEND_CONTAINER_NAME -backend-config key=$env:BACKEND_STATE_FILE
}

function Plan() {
    
    terraform plan -out="$createPlanFileName"
}

function Apply() {
    
    terraform apply "$createPlanFileName"
}

function PlanDestroy() {

    terraform plan -destroy -out="$destroyPlanFileName"
}

function Destroy() {

    terraform apply "$destroyPlanFileName"
}

if (-Not $terraformInstalled) {
    Exit
}


Set-Location $PWD
mkdir -p $planFolder

Show-Configuration

$userResponse = (Read-Host -Prompt "Happy with configuration? (Y/N)") -eq 'y' ? $true : $false

if ($userResponse -eq $true) {
    $Init ? (Init) : ($null)
    $Plan ? (Plan) : ($null)
    $Apply ? (Apply) : ($null)
    $PlanDestroy ? (PlanDestroy) : ($null)
    $Destroy ? (Destroy) : ($null)
} else {
    Write-Output "User cancelled"
}