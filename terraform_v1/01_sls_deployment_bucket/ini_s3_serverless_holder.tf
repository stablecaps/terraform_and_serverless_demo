module "s3_serverless_deployment_bucket" {

  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = local.bucket_name
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  object_ownership = "BucketOwnerEnforced"

  force_destroy = true

  versioning = {
    enabled = true
  }

  tags = local.tags
}
