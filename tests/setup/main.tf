data "aws_vpc" "selected" {
  default = true 
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}
