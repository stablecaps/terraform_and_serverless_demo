locals {
  tags = {
    environment = var.env
    project     = "stablecaps"
    owner       = "DevOps"
    created_by  = "terraform"
  }
}
