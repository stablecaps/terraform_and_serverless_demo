terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
  required_version = "= 1.0.6"
}

provider "aws" {
  region = "eu-west-1"
}

# TODO: Setup remote state