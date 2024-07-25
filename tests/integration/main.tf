variable "asg_id" {
  type = string
  description = "Autoscaling group ID"
}

data "aws_instances" "test" {
  instance_tags = {
    "aws:autoscaling:groupName" = var.asg_id
  }

  instance_state_names = ["running"]
}
