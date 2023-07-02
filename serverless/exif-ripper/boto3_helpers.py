"""Boto3 helpers to run AWS routines."""

import os
import sys
import logging
import boto3
from botocore.exceptions import ClientError

LOG = logging.getLogger(__name__)


def boto_session():
    """Initialise boto3 session."""

    LOG.debug("Setting up Boto3 session")

    aws_region = os.environ.get("AWS_REGION")

    session = boto3.Session(region_name=aws_region)
    return session


def check_bucket_exists(bucket_name):
    """Sanity check whether s3 bucket exists."""

    s3_client = boto3.resource("s3")

    try:
        s3_client.meta.client.head_bucket(Bucket=bucket_name)
        LOG.info("Verified bucket %s exists", bucket_name)
    except ClientError:
        LOG.critical("s3 bucket %s does not exist or access denied", bucket_name)
        sys.exit(42)
