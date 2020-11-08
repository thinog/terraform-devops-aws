variable "region" {
  default     = "us-east-1"
  description = "Main region"
}

variable "ec2_free_tier_ami" {
  default     = "ami-0947d2ba12ee1ff75"
  description = "Amazon Linux 2 AMI"
}

variable "ec2_instance_type" {}

variable "ec2_ips" {
  type = list
  default = [
    "b4e0:ba17:488d:0321:d4d4:35e0:f487:f318",
    "75ac:4866:0b80:73eb:7e84:170e:0b76:5248"
  ]
}

variable "ec2_tags" {
  type = map
  default = {
    Name = "Terraform Test Vars"
    Env  = "Dev"
  }
}

variable "s3_tags" {
  type = map
  default = {
    Name        = "My test bucket"
    Environment = "Dev"
  }
}
