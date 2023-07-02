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

### sanity check
if ! command -v jq &> /dev/null
then
    echo "!!! Plaese ensure you have jq installed & on your path !!!"
    exit 42
fi


echo -e "\n checking profiles in ~/.aws/credentials file."

grep bucketb_ro ~/.aws/credentials
grep bucketa_rw ~/.aws/credentials

### Get bucket names
# TODO: put tfstate in remote backend
outputs=$(cat terraform.tfstate | jq '.outputs')
bucket_dest_name=$(echo $outputs | jq '.bucket_dest_name.value' | sed 's|"||g')
bucket_source_name=$(echo $outputs | jq '.bucket_source_name.value' | sed 's|"||g')

echo -e "\nbucket_dest_name = $bucket_dest_name"
echo "bucket_source_name = $bucket_source_name"

#####################################################
echo "~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\nTESTING BUCKETB_RO USERS READ ONLY ACCESS TO BUCKET B - TESTS SHOULD PASS"
idx=0
for s3_path in "s3://${bucket_dest_name}/" "s3://${bucket_dest_name}/incoming/"; do
    idx=$((idx+1))
    echo -e "\n${idx}: s3 ls ${s3_path}"
    aws --profile bucketb_ro --region eu-west-1 s3 ls $s3_path || true
done

echo "~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\nTESTING BUCKETB_RO USERS READ ONLY ACCESS TO BUCKET A - TESTS SHOULD FAIL"

idx=0
for s3_path in "s3://" "s3://${bucket_source_name}/"; do
    idx=$((idx+1))
    echo -e "\n${idx}: s3 ls ${s3_path}"
    aws --profile bucketb_ro --region eu-west-1 s3 ls $s3_path || true
done

echo "~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\nTESTING BUCKETB_RO USERS WRITE ACCESS TO BUCKET A & B - TESTS SHOULD FAIL"
cp -fv ../../serverless/exif-ripper/test_images/OG_IMG_20220423_124829.jpg sls_user_img1.jpg
idx=0
for s3_path in "s3://${bucket_source_name}/" "s3://${bucket_source_name}/incoming" "s3://${bucket_dest_name}/" "s3://${bucket_dest_name}/incoming"; do
    idx=$((idx+1))
    echo -e "\n${idx}: s3 ls ${s3_path}"
    aws --profile bucketb_ro --region eu-west-1 s3 cp sls_user_img1.jpg $s3_path || true
done

#####################################################
echo "~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\nTESTING BUCKETA_RW USERS READ ONLY ACCESS TO BUCKET B - TESTS SHOULD FAIL"
idx=0
for s3_path in "s3://" "s3://${bucket_dest_name}/" "s3://${bucket_dest_name}/incoming/"; do
    idx=$((idx+1))
    echo -e "\n${idx}: s3 ls ${s3_path}"
    aws --profile bucketa_rw --region eu-west-1 s3 ls $s3_path || true
done

echo "~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\nTESTING BUCKETA_RW USERS WRITE ACCESS TO BUCKET B - TESTS SHOULD FAIL"
cp -fv ../../serverless/exif-ripper/test_images/OG_IMG_20220423_124829.jpg sls_user_img1.jpg
idx=0
for s3_path in "s3://${bucket_dest_name}/" "s3://${bucket_dest_name}/incoming"; do
    idx=$((idx+1))
    echo -e "\n${idx}: s3 ls ${s3_path}"
    aws --profile bucketa_rw --region eu-west-1 s3 cp sls_user_img1.jpg $s3_path || true
done

echo "~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\nTESTING BUCKETA_RW USERS READ ONLY ACCESS TO BUCKET A - TESTS SHOULD PASS"
idx=0
for s3_path in "s3://${bucket_source_name}/" "s3://${bucket_source_name}/incoming/"; do
    idx=$((idx+1))
    echo -e "\n${idx}: s3 ls ${s3_path}"
    aws --profile bucketa_rw --region eu-west-1 s3 ls $s3_path
done

echo "~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\nTESTING BUCKETA_RW USERS WRITE ACCESS TO BUCKET A - TESTS SHOULD PASS"
cp -fv ../../serverless/exif-ripper/test_images/OG_IMG_20220423_124829.jpg sls_user_img1.jpg
idx=0
for s3_path in "s3://${bucket_source_name}/" "s3://${bucket_source_name}/incoming"; do
    idx=$((idx+1))
    echo -e "\n${idx}: s3 ls ${s3_path}"
    aws --profile bucketa_rw --region eu-west-1 s3 cp sls_user_img1.jpg $s3_path || true
done

echo -e "\nFINISHED TESTS. CLEANING.."
rm -fv ./sls_user_img1.jpg
echo -e "\nEXITING.."
