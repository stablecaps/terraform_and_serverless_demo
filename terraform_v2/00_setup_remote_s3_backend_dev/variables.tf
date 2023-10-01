variable "env" {
  description = "Deployment environment. e.g. dev, uat, prod"
  type        = string
}

variable "random_string" {
  description = "A random string to ensure that different people can create globally unique s3 resources"
  type        = string
  default     = "defaultNotRandom"
}

variable "terraform_backend_config_file_path" {
  description = "Path to Terraform backend config file"
  type        = string
  default     = "."
}
