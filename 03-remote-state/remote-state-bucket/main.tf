provider "aws" {
  region = var.region
}

module "s3_bucket" {
  source        = "../../02-modules/s3"
  bucket_name   = var.bucket_name
  versioning    = true
  force_destroy = true
  bucket_tags = {
    Env  = var.env
    Name = "Terraform remote state bucket"
  }
}