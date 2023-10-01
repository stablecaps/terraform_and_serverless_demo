output "bucket_source_name" {
  description = "exif-ripper s3 source bucket name"
  value       = local.bucket_source_name
}

output "bucket_dest_name" {
  description = "exif-ripper s3 destination bucket name"
  value       = local.bucket_dest_name
}