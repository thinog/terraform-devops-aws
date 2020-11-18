variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default     = "ami-00ddb0e5626798373"
  description = "Amazon Linux 2 AMI"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Free instance type"
}