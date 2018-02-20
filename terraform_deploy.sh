#!/usr/bin/env bash
set -e

# Example usage ./bin/terraform_deploy.sh dev

WORKSPACE=${1}
WORKING_DIRECTORY="terraform"
shift 1

cd ${WORKING_DIRECTORY}
ls .terraform | grep -v plugins | awk '{print ".terraform/" $1}' | xargs rm -rf
terraform init -upgrade
terraform workspace select ${WORKSPACE}
terraform apply -var-file=${SECRETS_FILE} "$@"
