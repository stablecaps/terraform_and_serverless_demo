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

if ! command -v jq &> /dev/null
then
    echo "!!! Plaese ensure you have jq installed & on your path !!!"
    exit 42
fi

# TODO: put tfstate in remote backend
outputs=$(cat terraform.tfstate | jq '.outputs')

bucketb_ro_keyid=$(echo $outputs | jq '.iam_exif_s3_rob_id.value' | sed 's|"||g')
bucketb_ro_secret=$(echo $outputs | jq '.iam_exif_s3_rob_secret.value' | sed 's|"||g')
#
bucketa_rw_keyid=$(echo $outputs | jq '.iam_exif_s3_rwa_id.value' | sed 's|"||g')
bucketa_rw_secret=$(echo $outputs | jq '.iam_exif_s3_rwa_secret.value' | sed 's|"||g')

cat << EOF > ./append_these_perms_to_aws_credentials_file.secrets
[bucketb_ro]
aws_access_key_id = $bucketb_ro_keyid
aws_secret_access_key = $bucketb_ro_secret

[bucketa_rw]
aws_access_key_id = $bucketa_rw_keyid
aws_secret_access_key = $bucketa_rw_secret
EOF

echo -e "\nPlease add secrets in ./append_these_perms_to_aws_credentials_file.secrets file"
echo "to your ~/.aws/credentials file."
echo "Success! exiting.."