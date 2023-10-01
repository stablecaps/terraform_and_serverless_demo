terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "eu-west-1"
    bucket         = "tf-backend-prod-stablecaps-bhuna"
    key            = "terraform.tfstate"
    dynamodb_table = "tf-backend-prod-stablecaps-bhuna"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
