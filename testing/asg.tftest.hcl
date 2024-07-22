variables {}

run "valid_autoscaling_group" {

  command = plan

  assert {
    condition     = aws_autoscaling_group.bar.name == "test"
    error_message = "Autoscaling group name did not match expected"
  }

}