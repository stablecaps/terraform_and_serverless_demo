locals {
  tags = {
    environment = var.env
    project     = "stablecaps"
    owner       = "DevOps"
    created_by  = "terraform"
  }

  bucket_name = "serverless-deployment-holder-${var.env}-${var.random_string}"
}
