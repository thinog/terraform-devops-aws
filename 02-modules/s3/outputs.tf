output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}

output "object_key" {
  value = aws_s3_bucket_object.object.*.key
}
