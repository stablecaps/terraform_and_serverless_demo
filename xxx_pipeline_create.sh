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


if [ "$#" -ne 2 ]; then
    echo "USAGE: ./xxx_pipeline_destroy.sh \${YOUR_TERRAFORM_EXEC} \${YOUR_UNIQUE_RANDOM_STRING}"
    echo "e.g > ./xxx_pipeline_destroy.sh terraform_v1.0.6 z0b3ly"
    exit 0
fi

terraform_exec=$1
random_string=$2

echo "creating dev stack now..."


### Run terraform
## 1
cd terraform_v1/01_sls_deployment_bucket

    rm -rf .terraform .terraform.lock.hcl
    $terraform_exec init

    $terraform_exec validate

    $terraform_exec apply \
        -var random_string=$random_string \
        -auto-approve \
        -input=false

    terraform_v1.0.6 output | awk '{print $3}' | sed 's|"||g' \
        > ../../serverless/exif-ripper/sls_deply_buck.output
cd -

## 2
cd terraform_v1/02_DEV

    rm -rf .terraform .terraform.lock.hcl
    $terraform_exec init

    $terraform_exec validate

    $terraform_exec apply \
        -var random_string=$random_string \
        -auto-approve \
        -input=false

    terraform_v1.0.6 output | awk '{print $3}' | grep role | sed 's|"||g' \
        > ../../serverless/exif-ripper/role_arn.output

cd -


### Deploy serverless
cd serverless/exif-ripper
    tf_rolearn=$(cat role_arn.output)
    tf_deploy_bucket=$(cat sls_deply_buck.output)

    serverless plugin install --name serverless-ssm-fetch
    serverless plugin install --name serverless-python-requirements
    serverless plugin install --name serverless-stack-output

    serverless deploy \
        --stage dev \
        --region eu-west-1 \
        --param="rolearn=${tf_rolearn}" \
        --param="dbuck=${tf_deploy_bucket}"
cd -
