locals {
  layer_name = "terraform_layer.zip"
  layer_path = "${path.module}/../lambdas-layers/nodejs"
}

resource "null_resource" "build_lambda_layers" {
  triggers = {
    layer_build = filemd5("${local.layer_path}/package.json")
  }

  provisioner "local-exec" {
    working_dir = local.layer_path
    command     = "npm install --production && cd ../ && tar -a -c -f ${local.layer_name} *"
  }
}

resource "aws_lambda_layer_version" "this" {
  filename            = "${local.layer_path}/../${local.layer_name}"
  layer_name          = "terraform-layer"
  description         = "joi: ^17.3.0; uuid: ^8.3.1;"
  compatible_runtimes = ["nodejs12.x"]
  depends_on          = [null_resource.build_lambda_layers]
}

# DynamoDB Lambda

data "archive_file" "dynamodb" {
  type        = "zip"
  source_file = "${path.module}/../lambdas/dynamodb/index.js"
  output_path = "${path.module}/../lambdas/dynamodb/index.js.zip"
}

resource "aws_lambda_function" "dynamodb" {
  function_name    = "terraform-dynamodb"
  handler          = "index.handler"
  role             = aws_iam_role.dynamodb.arn
  runtime          = "nodejs12.x"
  layers           = [aws_lambda_layer_version.this.arn]
  filename         = data.archive_file.dynamodb.output_path
  source_code_hash = data.archive_file.dynamodb.output_base64sha256
  timeout          = 30
  memory_size      = 128

  environment {
    variables = {
      TABLE = aws_dynamodb_table.this.name
    }
  }
}

resource "aws_lambda_permission" "dynamodb" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dynamodb.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:*/*"
}

resource "aws_lambda_permission" "dynamodb_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dynamodb.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.this.arn
}

# S3 Lambda

data "archive_file" "s3" {
  type        = "zip"
  source_file = "${path.module}/../lambdas/s3/index.js"
  output_path = "${path.module}/../lambdas/s3/index.js.zip"
}

resource "aws_lambda_function" "s3" {
  function_name    = "terraform-s3"
  handler          = "index.handler"
  role             = aws_iam_role.s3.arn
  runtime          = "nodejs12.x"
  layers           = [aws_lambda_layer_version.this.arn]
  filename         = data.archive_file.s3.output_path
  source_code_hash = data.archive_file.s3.output_base64sha256
  timeout          = 30
  memory_size      = 128

  environment {
    variables = {
      TOPIC_ARN = aws_sns_topic.this.arn
    }
  }
}

resource "aws_lambda_permission" "s3" {
  statement_id = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3.arn
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.todo.arn
}