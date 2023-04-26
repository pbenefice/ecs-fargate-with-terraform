locals {
  tags = {
    env     = var.env
    project = var.project
    tfStack = var.tf_stack
    owner   = "terraform"
  }
}
