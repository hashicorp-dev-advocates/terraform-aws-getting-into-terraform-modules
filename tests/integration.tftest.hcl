variables {
  name            = "bar"
  security_groups = []
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "module" {

  command = apply

  variables {
    vpc_id = run.setup.vpc_id
  }

}

run "integration" {
  module {
    source = "./tests/integration"
  }
  variables {
    asg_id = run.module.asg_id
  }

  assert {
    condition = length(data.aws_instances.test.ids) == 1
    error_message = "We should have 1 AWS instance"
  }

}