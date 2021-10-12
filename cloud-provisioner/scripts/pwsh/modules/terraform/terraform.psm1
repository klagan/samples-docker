<#
 .Synopsis
  Manages the deployment of terraform scripts in a generic workflow

 .Description
  The idea is to wrap up standard terraform methods in a "one name" call that encapsulates the scripts.  

 .Example
   # Intialise the terraform scripts
   Initialize-Tf

 .Example
   # Lint the terraform scripts
   Lint-Tf

 .Example
   # Plan the terraform scripts
   Plan-Tf

 .Example
   # Show the terraform plan
   ShowPlan-Tf

 .Example
   # Plan the terraform destroy scripts
   PlanDestroy-Tf

 .Example
   # Show the terraform destroy plan scripts
   ShowDestroy-Tf

#>

$ErrorActionPreference = "Continue"

function Confirm-EnvironmentVariables {

    $EnvironmentVariables = "BACKEND_STORAGE_ACCOUNT_NAME", "BACKEND_CONTAINER_NAME", "BACKEND_STATE_FILE"

    foreach ($var in $EnvironmentVariables) {
        if (-not [Environment]::GetEnvironmentVariable($var))
        {
            Write-Host "$($var) has not been set"
            return $false
        }
    }

    return $true
}

function Use-TfLint {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        docker-compose up tf-lint
    }
}

function Use-TfInit {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="init -migrate-state -backend-config storage_account_name=$env:BACKEND_STORAGE_ACCOUNT_NAME -backend-config container_name=$env:BACKEND_CONTAINER_NAME -backend-config key=$env:BACKEND_STATE_FILE"
        docker-compose up terraform
    }
}

function Use-TfPlan {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION='plan -out=plans/kam.tfplan'
        docker-compose up terraform
        # docker run --rm -v "$pwd"/tf:/tf hashicorp/terraform:1.0.8 "plan -out=plans/kam.tfplan"
    }
}

function Use-TfShowplan {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="show plans/kam.tfplan"
        docker-compose up terraform
    }
}

function Use-TfPlandestroy {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="plan -destroy -out=plans/destroy.tfplan"
        docker-compose up terraform
    }
}

function Use-TfShowdestroy {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="show plans/destroy.tfplan"
        docker-compose up terraform
    }
}

function Use-TfApply {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="apply plans/plan.tfplan"
        docker-compose up terraform
    }
}


Export-ModuleMember -Function USe-TfInit
Export-ModuleMember -Function Use-TfLint
Export-ModuleMember -Function Use-TfPlan
Export-ModuleMember -Function Use-TfShowplan
Export-ModuleMember -Function Use-TfPlandestroy
Export-ModuleMember -Function Use-TfShowDestroy
Export-ModuleMember -Function Use-TfApply

