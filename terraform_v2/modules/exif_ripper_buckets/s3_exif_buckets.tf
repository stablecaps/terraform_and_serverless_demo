module "s3_bucket_source" {

  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = local.bucket_source_name
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  object_ownership = "BucketOwnerEnforced"

  force_destroy = true

  versioning = {
    enabled = false
  }

  tags = var.tags
}


module "s3_bucket_dest" {

  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = local.bucket_dest_name
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  object_ownership = "BucketOwnerEnforced"

  force_destroy = true

  versioning = {
    enabled = false
  }

  tags = var.tags
}

