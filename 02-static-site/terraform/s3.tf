resource "aws_s3_bucket" "log" {
  bucket = "${var.domain}-logs"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "site" {
  bucket = var.domain
  acl    = "public-read"
  policy = data.template_file.policy.rendered

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  logging {
    target_bucket = aws_s3_bucket.log.bucket
    target_prefix = var.domain
  }
}

resource "aws_s3_bucket" "redirect" {
  bucket = "www.${var.domain}"
  acl = "public-read"

  website {
    redirect_all_requests_to = "http://${aws_s3_bucket.site.website_endpoint}"
  }
}

resource "null_resource" "sites_files" {
  triggers = {
    react_build = filemd5("../website/build/index.html")
  }

  provisioner "local-exec" {    
    command = "aws s3 sync ..\\website\\build\\. s3://${var.domain}"
  }

  depends_on = [ aws_s3_bucket.site ]
}