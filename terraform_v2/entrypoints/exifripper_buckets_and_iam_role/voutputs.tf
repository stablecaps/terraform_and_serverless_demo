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
