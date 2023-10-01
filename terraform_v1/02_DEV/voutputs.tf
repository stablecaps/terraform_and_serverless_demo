output "iam_role_arn" {
  description = "Lambda IAM role arn used for serverless function"
  value       = module.lambda_role_and_policies.iam_role_arn
}

output "bucket_source_name" {
  description = "exif-ripper s3 source bucket name"
  value       = module.exif_buckets.bucket_source_name
}

output "bucket_dest_name" {
  description = "exif-ripper s3 destination bucket name"
  value       = module.exif_buckets.bucket_dest_name
}
output "iam_exif_s3_rwa_id" {
  description = "user A RW IAM access id"
  sensitive   = true
  value       = module.iam_exif_users.iam_exif_s3_rwa_id
}

output "iam_exif_s3_rwa_secret" {
  description = "user A RW IAM access secret"
  sensitive   = true
  value       = module.iam_exif_users.iam_exif_s3_rwa_secret
}
#
output "iam_exif_s3_rob_id" {
  description = "user B RO IAM access id"
  sensitive   = true
  value       = module.iam_exif_users.iam_exif_s3_rob_id
}

output "iam_exif_s3_rob_secret" {
  description = "user B RO IAM access secret"
  sensitive   = true
  value       = module.iam_exif_users.iam_exif_s3_rob_secret
}