provider "aws" {
  region = lookup(var.region, var.env)
}

locals {
  common_tags = {
    Project = "AWS with Terraform"
    Owner   = "Thiago Martins"
    Year    = "2019"
  }
  file_ext    = "zip"
  object_name = "my-data"
}

resource "random_id" "bucket" {
  byte_length = 4
}

data "template_file" "json" {
  template = file("file.json.tpl")
  vars = {
    id   = uuid()
    age  = 31
    name = "Thiago"
  }
}

data "archive_file" "json" {
  type        = "zip"
  output_path = "${path.module}/files/${local.object_name}.${local.file_ext}"
  source {
    content  = data.template_file.json.rendered
    filename = "${local.object_name}.json"
  }
}


module "s3_bucket" {
  depends_on    = [data.archive_file.json]
  source        = "../02-modules/s3"
  bucket_name   = "my-bucket-${random_id.bucket.hex}"
  force_destroy = true
  bucket_tags   = merge(local.common_tags, map("name", "My Bucket"), map("env", format("%s", var.env)))
  create_object = true
  object_key    = "${random_id.bucket.hex}.${local.file_ext}"
  object_source = data.archive_file.json.output_path
}
