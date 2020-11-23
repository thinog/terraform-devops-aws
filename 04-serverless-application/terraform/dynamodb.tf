resource "aws_dynamodb_table" "this" {
  name           = var.dynamodb_db_name
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  hash_key       = "TodoId"
  attribute {
    name = "TodoId"
    type = "S"
  }
  tags = {
    Name        = var.dynamodb_db_name
    Environment = var.env
  }
}

resource "aws_dynamodb_table_item" "this" {
  table_name = aws_dynamodb_table.this.name
  hash_key   = aws_dynamodb_table.this.hash_key
  item       = <<ITEM
{
  "TodoId": {"S": "${uuid()}"},
  "Task": {"S": "Learn Terraform"},
  "Done": {"S": "0"}
}
ITEM
}