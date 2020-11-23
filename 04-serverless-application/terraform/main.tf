provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "random_id" "bucket" {
  byte_length = 8
}