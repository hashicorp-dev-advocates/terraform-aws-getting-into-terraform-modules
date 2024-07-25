variables {
  name            = "foo"
  security_groups = []
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "valid_autoscaling_group" {

  command = plan

  variables {
    vpc_id = run.setup.vpc_id
  }

  assert {
    condition     = aws_autoscaling_group.asg.name == "foo-asg"
    error_message = "Autoscaling group name did not match expected"
  }

  assert{
    condition = strcontains(aws_launch_template.aws_lt_module.image_id, "ami") 
    error_message = "Should pass dynamic AMI id"
  }

  assert{
    condition = strcontains(aws_security_group.asg.name, "asg")
    error_message = "Security group name did not match expected"
  }

}

