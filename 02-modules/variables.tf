variable "region" {
  default     = "us-east-1"
  description = "Main region"
}

variable "s3_tags" {
  type = map
  default = {
    Name        = "My test bucket"
    Environment = "Dev"
  }
}
