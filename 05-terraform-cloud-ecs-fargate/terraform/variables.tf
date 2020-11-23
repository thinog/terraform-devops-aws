variable "region" {
  default = "us-east-1"
}

variable "env" {}

variable "app_name" {
  default = "node-app"
}

variable "app_folder" {
  default = "../app"
}

variable "az_count" {
  default = 2
}

variable "ecs_role" {
  default = "terraform-ecs-task-definition"
}

variable "ecs_auto_scale_role" {
  default = "terraform-ecs-auto-scale"
}

variable "fargate_cpu" {
  default = 512
}

variable "fargate_memory" {
  default = 1024
}

variable "app_port" {
  default = 3000
}

variable "app_count" {
  default = 2
}

variable "health_check_path" {
  default = "/"
}

variable "autoscaling_min_capacity" {
  default = 2
}

variable "autoscaling_max_capacity" {
  default = 5
}