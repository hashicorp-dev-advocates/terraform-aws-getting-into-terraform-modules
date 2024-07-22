resource "aws_launch_template" "foo" {
  name = "foo"


  image_id = "ami-test"

  instance_type = "t2.micro"

  key_name = "test"

  network_interfaces {
    associate_public_ip_address = true
    security_group_ids          = []
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test"
    }
  }

  user_data = filebase64("${path.module}/example.sh")
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_autoscaling_group" "bar" {
  name             = "foobar3-terraform-test"
  max_size         = 3
  min_size         = 1
  desired_capacity = 1
  force_delete     = true
  launch_template {
    id      = ""
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.example1.id, aws_subnet.example2.id]

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }
}