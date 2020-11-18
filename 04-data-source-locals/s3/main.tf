provider "aws" {
  region = var.region
}

data "terraform_remote_state" "web" {
  backend = "s3"
  config = {
    bucket = "tf-remote-state-thinog"
    key    = "dev/ec2/ec2.tfstate"
    region = "us-east-1"
  }
}

resource "random_id" "bucket" {
  byte_length = 4
}

locals {
  ami = data.terraform_remote_state.web.outputs.ec2_ami
  arn = data.terraform_remote_state.web.outputs.ec2_arn
}

module "s3_bucket" {
  source        = "../../02-modules/s3"
  bucket_name   = "my-bucket-${random_id.bucket.hex}"
  force_destroy = true
  bucket_tags = {
    Env  = var.env
    Name = "Terraform remote state bucket"
  }
  create_object = true
  object_key    = "instances/instance-${local.arn}.txt"
  object_source = "output.txt"
}