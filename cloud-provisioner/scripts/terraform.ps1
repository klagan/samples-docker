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

function Confirm-Apply {
    try {
        if ($Apply -or $Destroy) {

            $planFile = $Plan ? $createPlanFileName : $destroyPlanFileName

            $jsonPlan = "{0}.json" -f $planFile
            $(terraform show -no-color -json "$planFile") > $jsonPlan

            $planObj = Get-Content $jsonPlan | ConvertFrom-Json
            $resourceChanges = $planObj.resource_changes
            
            $add = ($resourceChanges | Where-Object {$_.change.actions -contains "create"}).length
            $change = ($resourceChanges | Where-Object {$_.change.actions -contains "update"}).length
            $remove = ($resourceChanges | Where-Object {$_.change.actions -contains "delete"}).length
            
            Write-Host "Changes: ($add to add, $change to change, $remove to remove) " -NoNewLine -ForegroundColor Yellow
            Write-Host "(Confirm the terraform plan)" -ForegroundColor Red
            $userResponse = (Read-Host -Prompt "`nHappy with configuration? (Y/N)") -eq 'y' ? $true : $false
            
            return $userResponse
        }
    }
    catch {
        Write-Error -Message "Oops, ran into an issue!"
        Exit
    }
}

function Apply() {

    try {
        if ($Apply) {

            $userResponse = $(Confirm-Apply)

            $userResponse -eq $true ? (terraform apply "$createPlanFileName") : (Write-Host "User Cancelled")
        }
    }
    catch {
        Write-Error -Message "Oops, ran into an issue!"
        Exit
    }
}

function PlanDestroy() {

    terraform plan -destroy -out="$destroyPlanFileName"
    terraform show -no-color -json "$destroyPlanFileName" > "$destroyPlanFileName".json
}

function Destroy() {

    try {
        if ($Destroy) {

            $userResponse = $(Confirm-Apply)

            $userResponse -eq $true ? (terraform apply "$destroyPlanFileName") : (Write-Host "User Cancelled")
        }
    }
    catch {
        Write-Error -Message "Oops, ran into an issue!"
        Exit
    }
}

if (-Not $terraformInstalled) {
    Exit
}


Set-Location $PWD
mkdir -p $planFolder

Show-Configuration

# $userResponse = (Read-Host -Prompt "`nHappy with configuration? (Y/N)") -eq 'y' ? $true : $false
$userResponse = $true

if ($userResponse -eq $true) {
    $Init ? (Init) : ($null)
    $Plan ? (Plan) : ($null)
    $Apply ? (Apply) : ($null)
    $PlanDestroy ? (PlanDestroy) : ($null)
    $Destroy ? (Destroy) : ($null)
} else {
    Write-Output "User cancelled"
}
