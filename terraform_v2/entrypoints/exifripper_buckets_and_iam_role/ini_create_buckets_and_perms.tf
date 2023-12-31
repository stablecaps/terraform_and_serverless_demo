module "exif_buckets" {
  source = "../../modules/exif_ripper_buckets"

  env           = var.env
  random_string = var.random_string
  bucket_source = "stablecaps-source"
  bucket_dest   = "stablecaps-destination"

  tags = local.tags

  ssm_root_prefix = var.ssm_root_prefix

}

### uses a custom written remote module written by me
module "lambda_role_and_policies" {

  source = "github.com/stablecaps/terraform-aws-iam-policies-stablecaps?ref=v2.0.0"

  role_name = "exif-ripper-${var.env}-eu-west-1-lambdaRole"
  role_desc = "lambda iam role for exif-ripper - ${var.env}"
  role_path = "/lambda/${var.env}/"

  trusted_entity_principals = {
    Service = "lambda.amazonaws.com"
  }

  custom_policies  = local.custom_policies
  managed_policies = {}

  tags = local.tags
}
