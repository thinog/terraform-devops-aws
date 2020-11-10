variable "env" {
  default = "dev"
}

variable "region" {
  default = "us-east-1"
}

variable "backend_bucket_name" {
  default = "tf-remote-state"
}

variable "ami" {
  default     = "ami-0947d2ba12ee1ff75"
  description = "Amazon Linux 2 AMI"
}

variable "instance_type" {
  default = "t2.micro"
  description = "Free instance type"
}