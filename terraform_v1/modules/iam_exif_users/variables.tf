variable "env" {
  description = "Deployment environment. e.g. dev, uat, prod"
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

variable "tags" {
  description = "A map that is used to apply tags to resources created by terraform"
  type        = map(string)
}