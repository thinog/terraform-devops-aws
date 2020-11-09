variable "bucket_name" {}

variable "object_key" {
  default = ""
}

variable "object_source" {
  default = ""
}

variable "create_object" {
  default = false
}

variable "bucket_acl" {
  default = "private"
}

variable "versioning" {
  default = false
}

variable "bucket_tags" {
  type    = map
  default = {}
}
