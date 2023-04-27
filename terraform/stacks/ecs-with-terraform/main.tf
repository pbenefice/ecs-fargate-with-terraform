module "naming" {
  source = "../../modules/naming"

  env      = var.env
  project  = "ecs-with-terraform"
  tf_stack = "main"
}

module "bastion" {
  source = "../../modules/bastion"

  name          = "${local.prefix}-bastion"
  env           = var.env
  vpc_id        = data.aws_vpc.selected.id
  subnet_id     = data.aws_subnets.private_selected.ids[0]
  allowed_cidrs = [data.aws_vpc.selected.cidr_block]
}

module "ecs" {
  source = "../../modules/ecs"

  project_prefix  = local.prefix
  env             = var.env
  vpc_id          = data.aws_vpc.selected.id
  vpc_cidr        = data.aws_vpc.selected.cidr_block
  private_subnets = data.aws_subnets.private_selected.ids
}
