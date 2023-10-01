resource "aws_ssm_parameter" "bucket_source" {
  name      = "${var.ssm_root_prefix}/${var.env}/bucketsource"
  type      = "String"
  value     = local.bucket_source_name
  overwrite = true

  tags = var.tags
}

resource "aws_ssm_parameter" "bucket_dest" {
  name      = "${var.ssm_root_prefix}/${var.env}/bucketdest"
  type      = "String"
  value     = local.bucket_dest_name
  overwrite = true

  tags = var.tags
}
