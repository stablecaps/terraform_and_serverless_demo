variable "env" {
  description = "Deployment environment. e.g. dev, uat, prod"
  type        = string
}

variable "random_string" {
  description = "A random string to ensure that different people can create uniuque s3 resources"
  type        = string
}


variable "bucket_source" {
  description = "Exif-ripper source bucket that is monitored for new files"
  type        = string
}

variable "bucket_dest" {
  description = "Exif-ripper destination bucket that sanitised files are copied to"
  type        = string
}

variable "ssm_root_prefix" {
  description = "SSM root prefix used to construct the key path"
  type        = string
}

variable "tags" {
  description = "A map that is used to apply tags to resources created by terraform"
  type        = map(string)
}