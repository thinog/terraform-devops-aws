resource "aws_ecr_repository" "this" {
  name = "${local.app_name}-repository"
}

resource "null_resource" "docker" {
  triggers = {
    app_md5 = filemd5("${var.app_folder}/server.js")
  }

  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  }

  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "docker build -t ${local.app_name} ."
  }

  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "docker tag ${local.app_name}:latest ${aws_ecr_repository.this.repository_url}:latest"
  }

  provisioner "local-exec" {
    working_dir = var.app_folder
    command     = "docker push ${aws_ecr_repository.this.repository_url}:latest"
  }
}