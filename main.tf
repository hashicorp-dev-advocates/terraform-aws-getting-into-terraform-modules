data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_subnets" "subnet_vpc" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_launch_template" "aws_lt_module" {
  name = var.name

  image_id = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  key_name = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = concat(var.security_groups, [aws_security_group.asg.id])
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.name
    }
  }

  # user_data = filebase64("${path.module}/example.sh")
}


resource "aws_security_group" "asg" {
  name        = "${var.name}-asg"
  description = "ASG"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.name
  }
}


resource "aws_autoscaling_group" "asg" {
  name             = "${var.name}-asg"
  max_size         = 3
  min_size         = 1
  desired_capacity = 1
  force_delete     = true
  launch_template {
    id      = aws_launch_template.aws_lt_module.id
    version = "$Latest"
  }
  vpc_zone_identifier = data.aws_subnets.subnet_vpc.ids

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}
