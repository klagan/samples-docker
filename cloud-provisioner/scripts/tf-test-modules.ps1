
Write-Host "Working folder: $PWD"

Use-TfInit
Use-TfLint
Use-TfPlan
Use-TfShowplan