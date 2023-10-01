locals {

  bucket_source_name = "${var.bucket_source}-${var.env}-${var.random_string}"
  bucket_dest_name   = "${var.bucket_dest}-${var.env}-${var.random_string}"

}
