locals {
  tags = {
    environment = var.env
    project     = "stablecaps"
    owner       = "DevOps"
    created_by  = "terraform"
  }

  bucket_source = module.exif_buckets.bucket_source_name
  bucket_dest   = module.exif_buckets.bucket_dest_name
}
