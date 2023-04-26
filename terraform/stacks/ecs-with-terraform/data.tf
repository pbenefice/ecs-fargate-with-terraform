data "aws_vpc" "selected" {
  filter {
    name   = "tag:project"
    values = ["ecs-with-terraform"]
  }

  filter {
    name   = "tag:env"
    values = [var.env]
  }
}

data "aws_subnets" "private_selected" {
  filter {
    name   = "tag:project"
    values = ["ecs-with-terraform"]
  }

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }

  filter {
    name   = "tag:env"
    values = [var.env]
  }
}
