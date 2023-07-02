"""
Lambda function that copies an image from a source bucket to a destination bucket after
remnoving all exif data for privacy.
"""

import sys
import os
import logging

from exif import Image as ExifImage
from boto3_helpers import boto_session, check_bucket_exists


LOG = logging.getLogger()
LOG.setLevel(logging.INFO)


def safeget(dct, *keys):
    """
    Recover value safely from nested dictionary

    safeget(example_dict, 'key1', 'key2')
    """
    for key in keys:
        try:
            dct = dct[key]
        except KeyError:
            return None
    return dct


def read_img_2memory(get_obj_resp):
    """
    Read image to memory as binary.
    """
    file_stream = get_obj_resp["Body"]
    img_binary = ExifImage(file_stream)
    return img_binary


def log_image_data(img, label):
    """
    LOG exif image data.
    """

    exif_data_list = img.list_all()
    LOG.info("exif_data_list - %s: %s", label, exif_data_list)
    return exif_data_list


# TODO: put this into a class
# TODO: split the logic out to seperate concerns
def exifripper(event, context):
    """
    Main lambda entrypoint & logic.
    """

    LOG.info("event: <%s> - <%s>", type(event), event)

    ### Setup boto3
    bo3_session = boto_session()
    s3_client = bo3_session.client("s3")

    ### read env vars
    bucket_env_list = (os.getenv("bucketSource"), os.getenv("bucketDest"))
    bucket_source, bucket_dest = bucket_env_list

    ### Sanity check
    if None in bucket_env_list:
        LOG.critical("env vars are unset in bucket_env_list: <%s>", bucket_env_list)
        sys.exit(42)

    for s3_buck in [bucket_source, bucket_dest]:
        check_bucket_exists(bucket_name=s3_buck)

    # TODO: sort out if record_list is None
    record_list = event.get("Records")
    object_key = safeget(record_list[0], "s3", "object", "key")
    LOG.info("object_key: <%s>", object_key)
    if object_key is None:
        LOG.critical("object_key not set. Exiting")
        sys.exit(42)

    ### Process new uploaded image file
    response = s3_client.get_object(Bucket=bucket_source, Key=object_key)

    LOG.info("response: %s", response)

    my_image = read_img_2memory(get_obj_resp=response)
    log_image_data(img=my_image, label="exif data pass0")

    ### initial exif data delete
    my_image.delete_all()

    exif_data_list = log_image_data(img=my_image, label="exif data pass1")

    ### Mop any exif data that failed to delete with delete_all
    if len(exif_data_list) > 0:
        for exif_tag in exif_data_list:
            my_image.delete(exif_tag)
        log_image_data(img=my_image, label="exif data pass2")

    ### Copy image with sanitised exif data to destination bucket
    s3_client.put_object(
        ACL="bucket-owner-full-control",
        Body=my_image.get_file(),
        Bucket=bucket_dest,
        Key=object_key,
    )

    LOG.info(
        "SUCCESS Copying s3 object <%s> from <%s> to <%s>",
        object_key,
        bucket_source,
        bucket_dest,
    )
