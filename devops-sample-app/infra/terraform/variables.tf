variable "aws_region" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "environment" {
  default = "development"
}
