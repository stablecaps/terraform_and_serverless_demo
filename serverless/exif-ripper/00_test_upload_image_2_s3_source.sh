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
    echo "USAGE: ./00_test_upload_image_2_s3_source.sh \${YOUR_AWS_PROFILE_NAME}"
    echo "./00_test_upload_image_2_s3_source.sh default"
    exit 0
fi


AWS_PROFILE=$1
SOURCE_BUCKET=$2

if ! command -v jq &> /dev/null
then
    echo "!!! Please ensure you have jq installed & on your path !!!"
    exit 42
fi

#
if ! command -v eog &> /dev/null
then
    echo "!!! Please ensure you have eog or eom installed & on your path !!!"
    exit 42
fi

rm -fv ./sls_test_img1_sanitised.jpg
cp -v test_images/OG_IMG_20220423_124829.jpg test_images/sls_test_img1.jpg

### Get source bucket name
SOURCE_BUCKET=$(aws --profile $AWS_PROFILE \
    --region eu-west-1 \
    ssm get-parameter \
    --name /genomics/exifripper/dev/bucketsource \
    | jq '.Parameter.Value' \
    | sed 's|"||g')

### Get destination bucket name
DEST_BUCKET=$(aws --profile $AWS_PROFILE \
    --region eu-west-1 \
    ssm get-parameter \
    --name /genomics/exifripper/dev/bucketdest \
    | jq '.Parameter.Value' \
    | sed 's|"||g')

### rm any existing test image
aws --profile $AWS_PROFILE \
    --region eu-west-1 \
    s3 rm \
    s3://${DEST_BUCKET}/incoming/sls_test_img1.jpg

### rm any existing dest sanitised image

### Trigger lambda via s3 copy
aws --profile $AWS_PROFILE \
    --region eu-west-1 \
    s3 cp \
    test_images/sls_test_img1.jpg \
    s3://${SOURCE_BUCKET}/incoming/sls_test_img1.jpg

sleep 10
aws --profile $AWS_PROFILE \
    --region eu-west-1 \
    s3 cp \
    s3://${DEST_BUCKET}/incoming/sls_test_img1.jpg \
    ./sls_test_img1_sanitised.jpg \

eog ./sls_test_img1_sanitised.jpg

echo -e "script finished"
