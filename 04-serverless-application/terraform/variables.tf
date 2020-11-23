variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "cg_pools" {
  default = "Todos"
}

variable "cg_client" {
  default = "todos-app-client"
}

variable "cg_domain" {
  default = "todos-api"
}

variable "dynamodb_db_name" {
  default = "todos"
}

variable "dynamodb_read_capacity" {
  default = 5
}

variable "dynamodb_write_capacity" {
  default = 5
}

variable "api_name" {
  default = "Terraform"
}

variable "api_description" {
  default = "API built with Terraform"
}

variable "sns_topic_name" {
  default = "terraform-s3-events"
}