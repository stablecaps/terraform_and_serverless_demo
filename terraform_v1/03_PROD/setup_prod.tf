locals {
  tags = {
    environment = var.env
    project     = "genomics"
    owner       = "gtampi/devops"
    created_by  = "terraform"
  }
}

module "exif_buckets" {
  source = "../modules/exif_ripper_buckets"

  env           = var.env
  random_string = var.random_string
  bucket_source = "genomics-source"
  bucket_dest   = "genomics-destination"

  tags = local.tags

  ssm_root_prefix = var.ssm_root_prefix

}

module "lambda_role_and_policies" {
  source = "../modules/lambda_iam_role_and_policies"

  env           = var.env
  bucket_source = module.exif_buckets.bucket_source_name
  bucket_dest   = module.exif_buckets.bucket_dest_name

  tags = local.tags

  ssm_root_prefix = var.ssm_root_prefix
}

# TODO: make this module able to assign any number of users arbitrary bucket permssions
# TODO: make this handle multiple envs

# module "iam_exif_users" {
#   source = "../modules/iam_exif_users"

#   env  = var.env
#   tags = local.tags

#   bucket_source = module.exif_buckets.bucket_source_name
#   bucket_dest   = module.exif_buckets.bucket_dest_name

# }
