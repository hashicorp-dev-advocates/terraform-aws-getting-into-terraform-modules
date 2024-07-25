variable "name" {
  type        = string
  default     = "foo"
  description = "value"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "instance type"
}

variable "key_name" {
  type        = string
  default     = "test"
  description = "key_name :-)"
}

variable "security_groups" {
  type        = list(string)
  description = "list of security groups"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}