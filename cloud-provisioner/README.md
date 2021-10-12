# Getting started

This `docker-compose` aims to contain the cloud provisioning tool-set for portability.  The image will mount local dependencies e.g. source code, authentication certificates, etc. and use them against the tool-sets defined in the `docker-compose file`.  

There are multiple `docker-compose` services to define the various stages of a standard `terraform` deployment:

- init (tf-init)
- lint (checkov)
- plan (tf-plan)
- show plan (tf-show-plan)
- apply (tf-apply)
- plan destroy (tf-plan-destroy)
- show destroy (tf-show-destroy)
- destroy (tf-destroy)

The `tf` folder is the location of Terraform files. The example used in this sample is for Azure AKS.

## Setting environment variables

The following environment variables are required to run as a service principal.  

The Terraform CLI will use these credentials to authenticate against Azure.  (These details should **not** be stored in a code repository. They could be generated dynamically at runtime for CI/CD pipelines)

> You must ensure that the `docker-compose` and the `ARM_CERTIFICATE_PATH` environment variable match locations and mounts.  The image will need to point to the same location inside the container.

```bash
# service principal application id
export ARM_CLIENT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# service principal certificate path
export ARM_CLIENT_CERTIFICATE_PATH="/home/kam/my_certificates/certificate.pfx"

# service principal password - (may not be required)
export ARM_CLIENT_CERTIFICATE_PASSWORD=""

# subscription identifier
export ARM_SUBSCRIPTION_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# tenant identifier
export ARM_TENANT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# storage account access key (used for remote backend)
export ARM_ACCESS_KEY=""

# backend storage account name
export BACKEND_STORAGE_ACCOUNT_NAME="myStorage"

# backend container name 
export BACKEND_CONTAINER_NAME="myContainer"

# backend path to state file
export BACKEND_STATE_FILE="some/example.tfstate"
```

## How to convert a `.pem` certificate to `.pfx` certificate

A `.pfx` certificate is required for Terraform service principal Azure logins.  If you have a `.pem` file you will need to convert it.

```bash
openssl pkcs12 -export -in my.pem -out my.pfx
```

## Run `docker-compose`

The `docker-compose` configuration is designed to house the configuration of the provisioning environment for easy portability and low footprint.  This may not be suitable for all scenarios in which case you may run the provisioning scripts manually.

The `docker-compose` file mounts two folders: `./tf` and `./auth` which should contain your `Terraform` scripts and authentication certificates when required.

```terraform
# run checkov on the terraform folder
docker-compose up tf-lint

# run a terraform init and backend configuration
docker-compose up tf-init

# run a terraform plan
docker-compose up tf-plan

# run a terraform show plan
docker-compose up tf-show-plan

# run an terraform apply (with plan file)
docker-compose up tf-apply

# run a terraform destroy plan
docker-compose up tf-plan-destroy

# run a terraform destroy (with plan file)
docker-compose up -tf-destroy

# run a custom terraform command
export TF_ACTION='<terraform command arguments>' && docker-compose up terraform
# eg: export TF_ACTION='plan -out=custom-filename.tfplan' && docker-compose up terraform

```

## How to switch to a local backend storage and back again

It is not always possible or preferred to use a remote backend for state storage - although it is more secure.

It is useful when developing to use a local backend.  

To do this you must rename the `backend.tf` to anything that does not end in `.tf`.  This will prevent the `Terraform` CLI from picking up the file and expecting a remote backend configuration.  

Then we must migrate the state away from the previously configured remote backend.  To accomplish this we must make use of the custom `Terraform` option of this tool-set.

```bash
# custom terraform call to migrate the remote state and revert to a local backend
export TF_ACTION='init -migrate-state' && docker-compose up terraform
```

You should be presented with a confirmation similar to the following:

```bash
Initializing the backend...
 Terraform has detected youre un-configuring your previously set "azurerm" backend.

 Successfully unset the backend "azurerm". Terraform will now operate locally.
```

To revert back to using the default state of a remote backend storage we must rename the `backend.tf` back to `backend.tf` and then run `docker-compose up tf-init` which should migrate the state and reconfigure the connection.

## Blastradius

[source](https://github.com/28mm/blast-radius)

```bash
pip3 install blastradius

blast-radius --server [tf-folder]
```

> use 127.0.0.1 rather than localhost e.g. `http://127.0.0.1:500`

## Clear Powershell modules

```powershell
@("terraform") | %{&remove-module -erroraction:silentlycontinue $_}
```
