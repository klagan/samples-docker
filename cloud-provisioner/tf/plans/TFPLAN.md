# Getting started

Terraform plan files should be generated/placed here for tidiness.  Below area couple of examples of how to make this happen using a `docker-compose` mount to the `tf` folder:

```terraform
export TF_ACTION='plan -out=./plans/plan.tfplan' && docker-compose up
export TF_ACTION='show ./plans/plan.tfplan' && docker-compose up

export TF_ACTION='plan -destroy -out=./plans/destroy.tfplan' && docker-compose up
export TF_ACTION='show ./plans/destroy.tfplan' && docker-compose up
```
