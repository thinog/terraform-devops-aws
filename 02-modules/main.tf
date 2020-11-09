provider "aws" {
  region = var.region
}

resource "random_id" "bucket" {
  byte_length = 8
}

resource "random_id" "bucket_2" {
  byte_length = 4
}

module "s3_bucket" {
  source      = "./s3"
  bucket_name = "my-tf-test-bucket-${random_id.bucket.hex}"
  versioning  = true
  bucket_tags = {
    Env = "Dev"
  }
}

module "s3_bucket_2" {
  source        = "./s3"
  bucket_name   = "my-tf-test-bucket-2-${random_id.bucket_2.hex}"
  create_object = true
  object_key    = "test-file.txt"
  object_source = "./files/test-file.txt"
}
