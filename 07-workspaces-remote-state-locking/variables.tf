variable "region" {
  default = "us-east-1"
}

variable "ami" {
  type = map
  default = {
    dev  = "ami-0947d2ba12ee1ff75"
    prod = "ami-0885b1f6bd170450c"
  }
}

variable "type" {
  type = map
  default = {
    dev  = "t2.micro"
    prod = "t2.micro"
  }
}