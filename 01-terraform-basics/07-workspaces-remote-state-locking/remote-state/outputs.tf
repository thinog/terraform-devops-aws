output "remote_state_bucket_name" {
  value = aws_s3_bucket.state.bucket
}

output "remote_state_table-name" {
  value = aws_dynamodb_table.locking.name
}

output "region" {
  value = data.aws_region.current.name
}