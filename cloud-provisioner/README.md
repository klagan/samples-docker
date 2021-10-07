# Getting started

This docker image aims to contain the cloud provisioning tool-set for portability.  The image would mount local dependencies e.g. source code, authentication certificates, etc. and use them against the tool-set

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
```

## How to convert a `.pem` certificate to `.pfx` certificate

A `.pfx` certificate is required for Terraform service principal Azure logins.  If you have a `.pem` file you will need to convert it.

```bash
openssl pkcs12 -export -in my.pem -out my.pfx
```

## Run `docker-compose`

The `docker-compose` configuration is designed to house the configuration of the provisioning environment for easy portability and low footprint.  This may not be suitable for all scenarios in which case you may run the provisioning scripts manually.

There is an environment variable `TF_ACTION` which designates which Terraform action to perform.  The `docker-compose` file mounts two folders: `./tf` and `./auth` which should contain your Terraform scripts and authentication certificates when required.

```terraform
# run a terraform (local) init (default action)
export TF_ACTION=init && docker-compose up

# run a terraform (remote) init (remember to rename the `backend.tf` file)
export TF_ACTION='init -backend-config storage_account_name=myStorageAccount -backend-config container_name=myContainer -backend-config key=tf/kam.tfstate' && docker-compose up

# run a terraform plan
export TF_ACTION='plan -out=plan.tfplan'
docker-compose up

# run a terraform show plan
export TF_ACTION='show plan.tfplan'

# run an terraform apply (with plan file)
export TF_ACTION='apply plan.tfplan' && docker-compose up

# run a terraform destroy plan
export TF_ACTION='plan -destroy -out=destroy.tfplan' && docker-compose up

# run a terraform destroy (with plan file)
export TF_ACTION='show destroy.tfplan'

# run an terraform destroy (with plan file)
export TF_ACTION='apply destroy.tfplan' && docker-compose up

```
