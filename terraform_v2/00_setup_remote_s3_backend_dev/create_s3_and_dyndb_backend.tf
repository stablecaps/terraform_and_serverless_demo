# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage

variable "env" {
  type    = string
  default = "dev"
}

variable "random_string" {
  type = string
}

variable "terraform_backend_config_file_path" {
  type    = string
  default = "."
}



module "terraform_state_backend" {

  source     = "cloudposse/tfstate-backend/aws"
  version    = "0.38.1"
  namespace  = "genomics-${var.random_string}"
  stage      = var.env
  name       = "terraform"
  attributes = ["state"]

  environment = "eu-west-1"

  dynamodb_enabled              = true
  dynamodb_table_name           = "tf-backend-${var.env}-genomics-${var.random_string}"
  billing_mode                  = "PAY_PER_REQUEST"
  enable_point_in_time_recovery = false

  s3_bucket_name             = "tf-backend-${var.env}-genomics-${var.random_string}"
  bucket_enabled             = true
  block_public_acls          = true
  block_public_policy        = true
  enable_public_access_block = true
  ignore_public_acls         = true
  restrict_public_buckets    = true
  s3_replication_enabled     = false
  force_destroy              = true

  enable_server_side_encryption = true

  terraform_backend_config_file_path = var.terraform_backend_config_file_path
  terraform_backend_config_file_name = "backend_${var.env}.tf"

}
