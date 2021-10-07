FROM mcr.microsoft.com/azure-cli:2.9.1 AS base

ARG TERRAFORM_VERSION=0.14.5
ARG TERRAGRUNT_VERSION=0.25.5

RUN apk update && \
apk add unzip wget

RUN wget --progress=dot:mega https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN \
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
mv terraform /usr/local/bin/ && \
chmod +x /usr/local/bin/terraform && \
terraform --version

################################
# Install Terragrunt
################################

RUN wget --progress=dot:mega https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64

RUN \
	mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
	chmod +x /usr/local/bin/terragrunt && \
	terragrunt --version

################################
# Install checkov
################################
RUN pip3 install --upgrade pip && pip3 install --upgrade setuptools && pip3 install checkov

RUN pip install dataclasses-serialization && pip3 install -U checkov

COPY login.sh .

RUN chmod +x login.sh

CMD ["./login.sh"]
