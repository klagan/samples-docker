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

function Lint-Tf {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        docker-compose up tf-lint
    }
}

function Initialize-Tf {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="init -migrate-state -backend-config storage_account_name=$env:BACKEND_STORAGE_ACCOUNT_NAME -backend-config container_name=$env:BACKEND_CONTAINER_NAME -backend-config key=$env:BACKEND_STATE_FILE"
        docker-compose up terraform
    }
}

function Plan-Tf {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION='plan -out=plans/kam.tfplan'
        docker-compose up terraform
        # docker run --rm -v "$pwd"/tf:/tf hashicorp/terraform:1.0.8 "plan -out=plans/kam.tfplan"
    }
}

function ShowPlan-Tf {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="show plans/kam.tfplan"
        docker-compose up terraform
    }
}

function PlanDestroy-Tf {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="plan -destroy -out=plans/destroy.tfplan"
        docker-compose up terraform
    }
}

function ShowDestroy-Tf {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="show plans/destroy.tfplan"
        docker-compose up terraform
    }
}

function Apply-Tf {

    $environmentCheck=Confirm-EnvironmentVariables

    if ($environmentCheck -eq $true) {
        $env:TF_ACTION="apply plans/plan.tfplan"
        docker-compose up terraform
    }
}


Export-ModuleMember -Function Initialize-Tf
Export-ModuleMember -Function Lint-Tf
Export-ModuleMember -Function Plan-Tf
Export-ModuleMember -Function ShowPlan-Tf
Export-ModuleMember -Function PlanDestroy-Tf
Export-ModuleMember -Function ShowDestroy-Tf
Export-ModuleMember -Function Apply-Tf

