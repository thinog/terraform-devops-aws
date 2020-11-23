terraform {
  required_version = "~> 0.13.5"

  backend "remote" {}
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}