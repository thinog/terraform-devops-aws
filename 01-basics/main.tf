provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket-20201107"
  acl    = "private"
  tags = var.s3_tags
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "hello-world.txt"
  source = "files/hello-world.txt"
  etag   = filemd5("files/hello-world.txt")
}

resource "aws_instance" "web" {
  ami            = var.ec2_free_tier_ami
  instance_type  = var.ec2_instance_type
  #ipv6_addresses = var.ec2_ips
  tags           = var.ec2_tags
}

output "bucket" {
  value = aws_s3_bucket.bucket.id
}

output "etag" {
  value = aws_s3_bucket_object.object.etag
}
