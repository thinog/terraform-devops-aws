provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "terraform-aws-course-546063609182-us-east-1-remote-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-aws-course-546063609182-us-east-1-remote-state"
  }
}

locals {
  env = terraform.workspace
}

resource "aws_instance" "web" {
  ami           = lookup(var.ami, local.env)
  instance_type = lookup(var.type, local.env)
  tags = {
    Name         = "My web instance ${local.env}"
    Env          = local.env
    Project_Name = "Terraform AWS Course"
    Version      = "1.0.0"
  }
}
