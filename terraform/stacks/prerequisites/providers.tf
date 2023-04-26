provider "aws" {
  region = local.region

  default_tags {
    tags = module.naming.tags
  }
}
