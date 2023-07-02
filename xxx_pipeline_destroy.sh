#!/bin/bash

######################################################
# Error Check Script
set -e
function trap_debugger () {
    # Function to output script error & slack alert via alt script
    local parent_lineno="$1"
    local message="$2"
    local code="${3:-1}"

    if [[ -n "$message" ]] ; then
        echo "Error on or near line ${parent_lineno}: ${message}; command yielded exit code ${code}"
    else
        echo "Error on or near line ${parent_lineno}; command yielded exit code ${code}"
    fi

    exit "${code}"
}

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG

trap 'trap_debugger ${LINENO}' ERR
######################################################


if [ "$#" -ne 1 ]; then
    echo "USAGE: ./xxx_pipeline_destroy.sh \${YOUR_TERRAFORM_EXEC}"
    echo "e.g > ./xxx_pipeline_destroy.sh terraform_v1.0.6"
    exit 0
fi

terraform_exec=$1

echo "Destroying dev stack now..."

### Remove serverless
cd serverless/exif-ripper
    serverless plugin install --name serverless-ssm-fetch
    serverless plugin install --name serverless-python-requirements
    serverless plugin install --name serverless-stack-output

    # TODO: think of a bbetter way to test this
    serverless remove --stage dev --region eu-west-1 || true
cd -

### Destroy terraform

## 1
cd terraform_v1/02_DEV

    rm -rf .terraform .terraform.lock.hcl
    $terraform_exec init

    $terraform_exec destroy \
        -var random_string=killmenow \
        -auto-approve \
        -input=false

cd -


## 2
cd terraform_v1/01_sls_deployment_bucket

    rm -rf .terraform .terraform.lock.hcl
    $terraform_exec init

    $terraform_exec destroy \
        -var random_string=killmenow \
        -auto-approve \
        -input=false

cd -

