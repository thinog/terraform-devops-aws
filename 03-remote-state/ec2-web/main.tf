provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 0.13.5"
  backend "s3" {
    ### provided by CLI
    ### terraform init -backend=true -backend-config='region=us-east-1' -backend-config='bucket=tf-remote-state-thinog' -backend-config='key=dev/ec2/web.tfstate'
    # bucket = var.backend_bucket_name
    # key = "${var.env}/ec2/web.tfstate"
    # region = var.region
  }
}

resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
}