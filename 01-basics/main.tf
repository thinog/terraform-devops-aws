provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket-20201107"
  acl    = "private"

  tags = {
    Name        = "My test bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.bucket.id}"
  key    = "hello-world.txt"
  source = "files/hello-world.txt"
}
