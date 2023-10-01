variable "env" {
  description = "Deployment environment. e.g. dev, uat, prod"
  type        = string
  default     = "dev"
}

variable "random_string" {
  description = "A random string to ensure that different people can create globally unique s3 resources"
  type        = string
}
