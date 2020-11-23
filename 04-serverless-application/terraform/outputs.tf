output "cg_client_id" {
  value = aws_cognito_user_pool_client.this.id
}

output "cg_client_secret" {
  value = aws_cognito_user_pool_client.this.client_secret
}

output "cg_domain" {
  value = aws_cognito_user_pool_domain.this.domain
}

output "cg_url" {
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.region}.amazoncognito.com"
}

output "lambda_layer_name" {
  value = aws_lambda_layer_version.this.layer_name
}

output "lambda_layer_version" {
  value = aws_lambda_layer_version.this.version
}

output "lambda_layer_description" {
  value = aws_lambda_layer_version.this.description
}

output "lambda_s3_url" {
  value = aws_lambda_function.s3.invoke_arn
}

output "lambda_dynamodb_url" {
  value = aws_lambda_function.dynamodb.invoke_arn
}

output "api_gw_url" {
  value = aws_api_gateway_deployment.this.invoke_url
}

output "bucket_name" {
  value = aws_s3_bucket.todo.bucket
}