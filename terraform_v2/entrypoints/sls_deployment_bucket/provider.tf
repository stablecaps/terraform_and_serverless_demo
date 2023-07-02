terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
  required_version = "= 1.0.6"

  backend "s3" {
    key     = "exifripper/sls_deployment_bucket/terraform.tfstate"
    encrypt = "true"
  }
}

provider "aws" {
  region = "eu-west-1"
}
